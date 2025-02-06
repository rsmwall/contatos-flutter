import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/contato.dart';
import '../controllers/database_helper.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng _currentPosition = const LatLng(-5.088979, -42.811194); // Posição inicial (Teresina)
  final Set<Marker> _markers = {}; 

  @override
  void initState() {
    super.initState();
    _loadMarkers(); 
    _determinePosition(); 
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Serviço de localização desativado.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permissão de localização negada.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permissão permanentemente negada.');
    }

    Position position = await Geolocator.getCurrentPosition();
    LatLng newPosition = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentPosition = newPosition;
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentPosition,
          infoWindow: const InfoWindow(title: "Minha Localização"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(_currentPosition, 14));
  }

  void _loadMarkers() async {
  List<Contato> contatos = await DatabaseHelper.instance.readAll();
  Set<Marker> newMarkers = {};

  for (var contato in contatos) {
    final marker = Marker(
      markerId: MarkerId(contato.id.toString()),
      position: LatLng(
        double.parse(contato.coordx),
        double.parse(contato.coordy),
      ),
      infoWindow: InfoWindow(
        title: contato.nome, 
        snippet: contato.telefone, 
      ),
    );
    newMarkers.add(marker);
  }

  setState(() {
    _markers.addAll(newMarkers);
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mapa"), backgroundColor: Colors.amber),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 14),
        markers: _markers, 
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _determinePosition,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
