import '../models/Livro.dart';
import '../services/storage_service.dart';

class LivroService{
  static const _caminhoDados = 'dados/livros.json';
  List<Livro> livros = [];

  Future<void> carregarDados() async {
    livros = await StorageService.carregarDados(_caminhoDados, Livro.fromJson);
  }

  Future<void> salvarDados() => StorageService.salvarDados(_caminhoDados, livros);

  Future<void> adicionarLivro(Livro livro) async {
    livros.add(livro);
    await salvarDados();
    print("Livro ${livro.titulo} adicionado com sucesso!");
  }

  void ListarLivros(){
    if(livros.isEmpty){
      print("Nenhum livro cadastrado.");
    } else {
      print("Lista de livros:");
      for(var livro in livros){
        print(
           'ID: ${livro.id} | ' 
           'Título: ${livro.titulo} | ' 
           'Autor: ${livro.autor} | ' 
           'Categoria: ${livro.categoria}',
        );
      }
    }
  }

  Livro? buscarPorId(int id){
    for(var livro in livros){
      if(livro.id == id){
        return livro;
      }
    }
    return null;
  }

  Future<void> alterarLivro(int id, String titulo, String autor, String categoria) async {
    Livro? livro = buscarPorId(id);

    if(livro == null){
      print("Livro com ID $id não encontrado.");
    } else {
      livro.titulo = titulo;
      livro.autor = autor;
      livro.categoria = categoria;
      await salvarDados();
      print("Livro com ID $id alterado com sucesso!");
    }
  }

  Future<void> removerLivro(int id) async {
    Livro? livro = buscarPorId(id);

    if(livro == null){
      print("Livro com ID $id não encontrado.");
    } else {
      livros.remove(livro);
      await salvarDados();
      print("Livro com ID $id removido com sucesso!");
    }
  }
}
