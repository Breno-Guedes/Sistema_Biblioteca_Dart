class Usuario{
  int id;
  String nome;
  String tipo;
  double pendenciaFinanceira;

  Usuario(this.id, this.nome, this.tipo, [this.pendenciaFinanceira = 0]);

  bool get bloqueado => pendenciaFinanceira > 0;

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome': nome,
    'tipo': tipo,
    'pendenciaFinanceira': pendenciaFinanceira,
  };

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    json['id'],
    json['nome'],
    json['tipo'],
    (json['pendenciaFinanceira'] ?? 0).toDouble(),
  );
}
