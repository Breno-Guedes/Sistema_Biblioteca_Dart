class Usuario{
  int id;
  String nome;
  String tipo;

  Usuario(this.id, this.nome, this.tipo);

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'tipo': tipo,
  };

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    json['id'],
    json['nome'],
    json['tipo'],
  );
}
