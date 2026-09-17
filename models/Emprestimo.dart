class Emprestimo {
  int id;
  int usuarioId;
  int exemplarId;
  DateTime dataEmprestimo;
  DateTime dataPrevistaDevolucao;
  DateTime? dataDevolucao;

  Emprestimo(this.id, this.usuarioId, this.exemplarId, 
  this.dataEmprestimo, this.dataPrevistaDevolucao, 
  [this.dataDevolucao]);

  Map<String, dynamic> toJson() => {
    'id': id,
    'usuarioId': usuarioId,
    'exemplarId': exemplarId,
    'dataEmprestimo': dataEmprestimo.toIso8601String(),
    'dataPrevistaDevolucao': dataPrevistaDevolucao.toIso8601String(),
    'dataDevolucao': dataDevolucao?.toIso8601String(),
  };

  factory Emprestimo.fromJson(Map<String, dynamic> json) => Emprestimo(
    json['id'],
    json['usuarioId'],
    json['exemplarId'],
    DateTime.parse(json['dataEmprestimo']),
    DateTime.parse(json['dataPrevistaDevolucao']),
    json['dataDevolucao'] != null ? DateTime.parse(json['dataDevolucao']) : null
  );
}