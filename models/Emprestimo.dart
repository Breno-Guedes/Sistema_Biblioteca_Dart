class Emprestimo {
  int id;
  int usuarioId;
  int exemplarId;
  DateTime dataEmprestimo;
  DateTime dataPrevistaDevolucao;
  DateTime? dataDevolucao;
  double multa;
  double ressarcimento;
  String? ocorrencia;

  Emprestimo(this.id, this.usuarioId, this.exemplarId, 
  this.dataEmprestimo, this.dataPrevistaDevolucao, 
  [this.dataDevolucao, this.multa = 0, this.ressarcimento = 0, this.ocorrencia]);

  bool get ativo => dataDevolucao == null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'usuarioId': usuarioId,
    'exemplarId': exemplarId,
    'dataEmprestimo': dataEmprestimo.toIso8601String(),
    'dataPrevistaDevolucao': dataPrevistaDevolucao.toIso8601String(),
    'dataDevolucao': dataDevolucao?.toIso8601String(),
    'multa': multa,
    'ressarcimento': ressarcimento,
    'ocorrencia': ocorrencia,
  };

  factory Emprestimo.fromJson(Map<String, dynamic> json) => Emprestimo(
    json['id'],
    json['usuarioId'],
    json['exemplarId'],
    DateTime.parse(json['dataEmprestimo']),
    DateTime.parse(json['dataPrevistaDevolucao']),
    json['dataDevolucao'] != null ? DateTime.parse(json['dataDevolucao']) : null,
    (json['multa'] ?? 0).toDouble(),
    (json['ressarcimento'] ?? 0).toDouble(),
    json['ocorrencia'],
  );
}
