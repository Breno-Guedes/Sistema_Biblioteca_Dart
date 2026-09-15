import '../models/Livro.dart';

class LivroService{
  List<Livro> livros = [];

  void adicionarLivro(Livro livro){
    livros.add(livro);

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

  void alterarLivro(int id, String titulo, String autor, String categoria){
    Livro? livro = buscarPorId(id);

    if(livro == null){
      print("Livro com ID $id não encontrado.");
    } else {
      livro.titulo = titulo;
      livro.autor = autor;
      livro.categoria = categoria;
      print("Livro com ID $id alterado com sucesso!");
    }
  }

  void removerLivro(int id){
    Livro? livro = buscarPorId(id);

    if(livro == null){
      print("Livro com ID $id não encontrado.");
    } else {
      livros.remove(livro);
      print("Livro com ID $id removido com sucesso!");
    }
  }
}