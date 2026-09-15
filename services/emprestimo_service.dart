import '../models/Emprestimo.dart';

  class EmprestimoService{
    List<Emprestimo> emprestimos = [];

    void adicionarEmprestimo(Emprestimo emprestimo){
      emprestimos.add(emprestimo);

      print("Empréstimo com ID ${emprestimo.id} adicionado com sucesso!");
    }

    void ListarEmprestimos(){
      if(emprestimos.isEmpty){
        print("Nenhum empréstimo cadastrado.");
      } else {
        print("Lista de empréstimos:");
        for(var emprestimo in emprestimos){
          print(
             'ID: ${emprestimo.id} | ' 
             'Usuário ID: ${emprestimo.usuarioId} | ' 
             'Exemplar ID: ${emprestimo.exemplarId} | ' 
             'Data Empréstimo: ${emprestimo.dataEmprestimo} | ' 
             'Data Devolução: ${emprestimo.dataDevolucao}',
          );
        }
      }
    }

    Emprestimo? buscarPorId(int id){
      for(var emprestimo in emprestimos){
        if(emprestimo.id == id){
          return emprestimo;
        }
      }
      return null;
    }

    Emprestimo? buscarPorUsuarioId(int usuarioId){
      for(var emprestimo in emprestimos){
        if(emprestimo.usuarioId == usuarioId){
          return emprestimo;
        }
      }
      return null;
    }

    void devolverEmprestimo(int id, DateTime dataDevolucao){
      Emprestimo? emprestimo = buscarPorId(id);
      if(emprestimo == null){
        print("Empréstimo com ID $id não encontrado.");
      } else {
        emprestimo.dataDevolucao = dataDevolucao;
        print("Empréstimo com ID $id devolvido com sucesso!");
      }
    }

    void removerEmprestimo(int id){
      Emprestimo? emprestimo = buscarPorId(id);
      if(emprestimo == null){
        print("Empréstimo com ID $id não encontrado.");
      } else {
        emprestimos.remove(emprestimo);
        print("Empréstimo com ID $id removido com sucesso!");
      }
    }
  }
