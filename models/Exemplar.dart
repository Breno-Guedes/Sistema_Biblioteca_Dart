class Exemplar{
  int id;
  int livroId;
  bool disponivel;

  Exemplar(this.id, this.livroId, this.disponivel);

  Map<String, dynamic> toJson() => {
    'id': id,
    'livroId': livroId,
    'disponivel': disponivel,
  };

  factory Exemplar.fromJson(Map<String, dynamic> json) => Exemplar(
     json['id'],
     json['livroId'],
     json['disponivel'],
  );
}