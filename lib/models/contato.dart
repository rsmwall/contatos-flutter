class Contato {
  int? id;
  String nome;
  String telefone;
  String email;
  String coordx;
  String coordy;

  Contato({this.id, required this.nome, required this.telefone, required this.email, required this.coordx, required this.coordy});

  factory Contato.fromMap(Map<String, dynamic> map) {
    return Contato(
      id: map['id'],
      nome: map['nome'],
      telefone: map['telefone'],
      email: map['email'],
      coordx: map['coordx'],
      coordy: map['coordy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'coordx': coordx,
      'coordy': coordy,
    };
  }
}
