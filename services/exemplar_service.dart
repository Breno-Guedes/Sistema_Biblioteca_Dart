import '../models/Exemplar.dart';
import 'storage_service.dart';

class ExemplarService{
  static const _caminhoDados = 'dados/exemplares.json';
  List<Exemplar> exemplares = [];

  Future<void> carregarDados() async {
    exemplares = await StorageService.carregarDados(_caminhoDados, Exemplar.fromJson);
  }

  Future<void> salvarDados() => StorageService.salvarDados(_caminhoDados, exemplares);
  
  Future<void> adicionarExemplar(Exemplar exemplar) async {
    exemplares.add(exemplar);
    await salvarDados();
    print("Exemplar com ID ${exemplar.id} adicionado com sucesso!");
  }

  void ListarExemplares(){
    if(exemplares.isEmpty){
      print("Nenhum exemplar cadastrado.");
    } else {
      print("Lista de exemplares:");
      for(var exemplar in exemplares){
        print(
           'ID: ${exemplar.id} | ' 
           'Livro ID: ${exemplar.livroId} | ' 
           'Disponível: ${exemplar.disponivel}',
        );
      }
    }
  }

  Exemplar? buscarPorId(int id){
    for(var exemplar in exemplares){
      if(exemplar.id == id){
        return exemplar;
      }
    }
    return null;
  }

  Exemplar? buscarDisponivel(int livroId){
    for(var exemplar in exemplares){
      if(exemplar.livroId == livroId && exemplar.disponivel){
        return exemplar;
      }
    }
    return null;
  }

  Future<void> alterarExemplar(int id, int livroId, bool disponivel) async {
    Exemplar? exemplar = buscarPorId(id);
    if(exemplar == null){
      print("Exemplar com ID $id não encontrado.");
    } else {
      exemplar.livroId = livroId;
      exemplar.disponivel = disponivel;
      await salvarDados();
      print("Exemplar com ID $id alterado com sucesso!");
    }
  }

  Future<void> removerExemplar(int id) async {
    Exemplar? exemplar = buscarPorId(id);
    if(exemplar == null){
      print("Exemplar com ID $id não encontrado.");
    } else {
      exemplares.remove(exemplar);
      await salvarDados();
      print("Exemplar com ID $id removido com sucesso!");
    }
  }
}
