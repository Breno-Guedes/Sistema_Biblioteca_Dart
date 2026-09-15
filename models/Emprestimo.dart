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
}