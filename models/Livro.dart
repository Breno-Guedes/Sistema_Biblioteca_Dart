class Livro{
  int id;
  String titulo;
  String autor;
  String categoria;

  Livro(this.id, this.titulo, this.autor, this.categoria);

  Map<String, dynamic> toJson() => {
      'id': id,
      'titulo': titulo,
      'autor': autor,
      'categoria': categoria,
  };

  factory Livro.fromJson(Map<String, dynamic> json) => Livro(
    json['id'],
    json['titulo'],
    json['autor'],
    json['categoria'],
  );
}
