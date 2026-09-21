class Livro{
  int id;
  String titulo;
  String autor;
  String categoria;
  String natureza;

  Livro(this.id, this.titulo, this.autor, this.categoria, [this.natureza = 'Livro']);

  bool get ehConsultaLocal => ['referência', 'referencia', 'consulta']
      .contains(natureza.toLowerCase());
  bool get ehPeriodico => ['periódico', 'periodico'].contains(natureza.toLowerCase());

  Map<String, dynamic> toJson() => {
      'id': id,
      'titulo': titulo,
      'autor': autor,
      'categoria': categoria,
      'natureza': natureza,
  };

  factory Livro.fromJson(Map<String, dynamic> json) => Livro(
    json['id'],
    json['titulo'],
    json['autor'],
    json['categoria'],
    json['natureza'] ?? 'Livro',
  );
}
