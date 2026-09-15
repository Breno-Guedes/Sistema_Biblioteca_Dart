import '../models/Usuario.dart';

class UsuarioService{
  List<Usuario> usuarios = [];

  void adicionarUsuario(Usuario usuario){
    usuarios.add(usuario);

    print("Usuário ${usuario.nome} adicionado com sucesso!");
  }

  void ListarUsuarios(){
    if(usuarios.isEmpty){
      print("Nenhum usuário cadastrado.");
    } else {
      print("Lista de usuários:");
      for(var usuario in usuarios){
        print(
           'ID: ${usuario.id} | ' 
           'Nome: ${usuario.nome} | ' 
           'Tipo: ${usuario.tipo}',
        );
      }
    }
  }

  Usuario? buscarPorId(int id){
    for(var usuario in usuarios){
      if(usuario.id == id){
        return usuario;
      }
    }
    return null;
  }

  void alterarUsuario(int id, String nome, String tipo){
    Usuario? usuario = buscarPorId(id);
    if(usuario == null){
      print("Usuário com ID $id não encontrado.");
    } else {
      usuario.nome = nome;
      usuario.tipo = tipo;
      print("Usuário com ID $id alterado com sucesso!");
    }
  }

  void removerUsuario(int id){
    Usuario? usuario = buscarPorId(id);
    if(usuario == null){
      print("Usuário com ID $id não encontrado.");
    } else {
      usuarios.remove(usuario);
      print("Usuário com ID $id removido com sucesso!");
    }
  }
}