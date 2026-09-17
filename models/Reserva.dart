class Reserva {
  int id;
  int usuarioId;
  int livroId;
  DateTime dataReserva;

  Reserva(this.id, this.usuarioId, this.livroId, this.dataReserva);

  Map<String, dynamic> toJson() => {
    'id': id,
    'usuarioId': usuarioId,
    'livroId': livroId,
    'dataReserva': dataReserva.toIso8601String(),
  };

  factory Reserva.fromJson(Map<String, dynamic> json) => Reserva(
    json['id'],
    json['usuarioId'],
    json['livroId'],
    DateTime.parse(json['dataReserva']),
  );
}