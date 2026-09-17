import '../models/Emprestimo.dart';
import 'storage_service.dart';

  class EmprestimoService{
    static const _caminhoDados = 'dados/emprestimos.json';
    List<Emprestimo> emprestimos = [];

    Future<void> carregarDados() async {
      emprestimos = await StorageService.carregarDados(_caminhoDados, Emprestimo.fromJson);
    }

    Future<void> salvarDados() => StorageService.salvarDados(_caminhoDados, emprestimos);

    Future<void> adicionarEmprestimo(Emprestimo emprestimo) async {
      emprestimos.add(emprestimo);
      await salvarDados();
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

    Future<void> devolverEmprestimo(int id, DateTime dataDevolucao) async {
      Emprestimo? emprestimo = buscarPorId(id);
      if(emprestimo == null){
        print("Empréstimo com ID $id não encontrado.");
      } else {
        emprestimo.dataDevolucao = dataDevolucao;
        await salvarDados();
        print("Empréstimo com ID $id devolvido com sucesso!");
      }
    }

    Future<void> removerEmprestimo(int id) async {
      Emprestimo? emprestimo = buscarPorId(id);
      if(emprestimo == null){
        print("Empréstimo com ID $id não encontrado.");
      } else {
        emprestimos.remove(emprestimo);
        await salvarDados();
        print("Empréstimo com ID $id removido com sucesso!");
      }
    }
  }
