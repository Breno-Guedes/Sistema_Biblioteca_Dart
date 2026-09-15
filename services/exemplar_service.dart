import '../models/Exemplar.dart';

class ExemplarService{
  List<Exemplar> exemplares = [];
  
  void adicionarExemplar(Exemplar exemplar){
    exemplares.add(exemplar);

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

  void alterarExemplar(int id, int livroId, bool disponivel){
    Exemplar? exemplar = buscarPorId(id);
    if(exemplar == null){
      print("Exemplar com ID $id não encontrado.");
    } else {
      exemplar.livroId = livroId;
      exemplar.disponivel = disponivel;
      print("Exemplar com ID $id alterado com sucesso!");
    }
  }

  void removerExemplar(int id){
    Exemplar? exemplar = buscarPorId(id);
    if(exemplar == null){
      print("Exemplar com ID $id não encontrado.");
    } else {
      exemplares.remove(exemplar);
      print("Exemplar com ID $id removido com sucesso!");
    }
  }
}