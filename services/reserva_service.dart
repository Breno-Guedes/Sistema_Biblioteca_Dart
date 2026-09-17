import '../models/Reserva.dart';
import 'storage_service.dart';

class ReservaService{
  static const _caminhoDados = 'dados/reservas.json';
  List<Reserva> reservas = [];

  Future<void> carregarDados() async {
    reservas = await StorageService.carregarDados(_caminhoDados, Reserva.fromJson);
  }

  Future<void> salvarDados() => StorageService.salvarDados(_caminhoDados, reservas);

  Future<void> adicionarReserva(Reserva reserva) async {
    reservas.add(reserva);
    await salvarDados();
    print("Reserva com ID ${reserva.id} adicionada com sucesso!");
  }

  void ListarReservas(){
    if(reservas.isEmpty){
      print("Nenhuma reserva cadastrada.");
    } else {
      print("Lista de reservas:");
      for(var reserva in reservas){
        print(
           'ID: ${reserva.id} | ' 
           'Usuário ID: ${reserva.usuarioId} | ' 
           'Livro ID: ${reserva.livroId} | ' 
           'Data da Reserva: ${reserva.dataReserva}',
        );
      }
    }
  }

  Reserva? buscarPorId(int id){
    for(var reserva in reservas){
      if(reserva.id == id){
        return reserva;
      }
    }
    return null;
  }

  Reserva? buscarPorUsuarioId(int usuarioId){
    for(var reserva in reservas){
      if(reserva.usuarioId == usuarioId){
        return reserva;
      }
    }
    return null;
  }

  Future<void> cancelarReserva(int id) async {
    Reserva? reserva = buscarPorId(id);
    if(reserva == null){
      print("Reserva com ID $id não encontrada.");
    } else {
      reservas.remove(reserva);
      await salvarDados();
      print("Reserva com ID $id cancelada com sucesso!");
    }
  }

  Future<void> removerReserva(int id) async {
    Reserva? reserva = buscarPorId(id);
    if(reserva == null){
      print("Reserva com ID $id não encontrada.");
    } else {
      reservas.remove(reserva);
      await salvarDados();
      print("Reserva com ID $id removida com sucesso!");
    }
  }
}
