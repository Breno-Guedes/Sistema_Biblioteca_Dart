import '../models/Reserva.dart';

class ReservaService{
  List<Reserva> reservas = [];

  void adicionarReserva(Reserva reserva){
    reservas.add(reserva);

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

  void cancelarReserva(int id){
    Reserva? reserva = buscarPorId(id);
    if(reserva == null){
      print("Reserva com ID $id não encontrada.");
    } else {
      reservas.remove(reserva);
      print("Reserva com ID $id cancelada com sucesso!");
    }
  }

  void removerReserva(int id){
    Reserva? reserva = buscarPorId(id);
    if(reserva == null){
      print("Reserva com ID $id não encontrada.");
    } else {
      reservas.remove(reserva);
      print("Reserva com ID $id removida com sucesso!");
    }
  }
}