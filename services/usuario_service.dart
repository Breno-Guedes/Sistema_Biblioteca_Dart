import '../models/Usuario.dart';
import 'storage_service.dart';

class UsuarioService{
  static const _caminhoDados = 'dados/usuarios.json';
  List<Usuario> usuarios = [];

  Future<void> carregarDados() async {
    usuarios = await StorageService.carregarDados(_caminhoDados, Usuario.fromJson);
  }

  Future<void> salvarDados() => StorageService.salvarDados(_caminhoDados, usuarios);

  Future<void> adicionarUsuario(Usuario usuario) async {
    usuarios.add(usuario);
    await salvarDados();
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

  Future<void> alterarUsuario(int id, String nome, String tipo) async {
    Usuario? usuario = buscarPorId(id);
    if(usuario == null){
      print("Usuário com ID $id não encontrado.");
    } else {
      usuario.nome = nome;
      usuario.tipo = tipo;
      await salvarDados();
      print("Usuário com ID $id alterado com sucesso!");
    }
  }

  Future<void> removerUsuario(int id) async {
    Usuario? usuario = buscarPorId(id);
    if(usuario == null){
      print("Usuário com ID $id não encontrado.");
    } else {
      usuarios.remove(usuario);
      await salvarDados();
      print("Usuário com ID $id removido com sucesso!");
    }
  }
}
