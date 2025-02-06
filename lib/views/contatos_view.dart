import 'package:flutter/material.dart';
import '../models/contato.dart';
import '../controllers/database_helper.dart';

class ContatosView extends StatefulWidget {
  const ContatosView({super.key});

  @override
  ContatosViewState createState() => ContatosViewState();
}

class ContatosViewState extends State<ContatosView> {
  late Future<List<Contato>> contatos;

  @override
  void initState() {
    super.initState();
    contatos = DatabaseHelper.instance.readAll();
  }

  void _showForm({Contato? contato}) {
    final nomeController = TextEditingController(text: contato?.nome ?? '');
    final telefoneController = TextEditingController(text: contato?.telefone ?? '');
    final emailController = TextEditingController(text: contato?.email ?? '');
    final coordxController = TextEditingController(text: contato?.coordx ?? '');
    final coordyController = TextEditingController(text: contato?.coordy ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(contato == null ? 'Cadastrar Contato' : 'Alterar Contato'),
          content: Column(
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: telefoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
              ),
              TextField(
                controller: coordxController,
                decoration: InputDecoration(labelText: 'Coordenada X'),
              ),
              TextField(
                controller: coordyController,
                decoration: InputDecoration(labelText: 'Coordenada Y'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final nome = nomeController.text;
                final telefone = telefoneController.text;
                final email = emailController.text;
                final coordx = coordxController.text;
                final coordy = coordyController.text;

                if (contato == null) {
                  final newContato = Contato(
                    nome: nome,
                    telefone: telefone,
                    email: email,
                    coordx: coordx,
                    coordy: coordy,
                  );
                  DatabaseHelper.instance.create(newContato);
                } else {
                  final updatedContato = Contato(
                    id: contato.id,
                    nome: nome,
                    telefone: telefone,
                    email: email,
                    coordx: coordx,
                    coordy: coordy,
                  );
                  DatabaseHelper.instance.update(updatedContato);
                }

                setState(() {
                  contatos = DatabaseHelper.instance.readAll();
                });

                Navigator.of(context).pop();
              },
              child: Text(contato == null ? 'Cadastrar' : 'Alterar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteContato(int id) {
    DatabaseHelper.instance.delete(id);
    setState(() {
      contatos = DatabaseHelper.instance.readAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<List<Contato>>(
        future: contatos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar contatos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum contato cadastrado'));
          } else {
            final contatosList = snapshot.data!;
            return ListView.builder(
              itemCount: contatosList.length,
              itemBuilder: (context, index) {
                final contato = contatosList[index];
                return ListTile(
                  title: Text(contato.nome),
                  subtitle: Text(contato.telefone),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteContato(contato.id!),
                  ),
                  onTap: () => _showForm(contato: contato),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
