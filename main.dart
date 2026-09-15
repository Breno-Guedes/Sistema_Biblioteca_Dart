import 'dart:io';

import 'enums/tipo_usuario.dart';
import 'models/Emprestimo.dart';
import 'models/Exemplar.dart';
import 'models/Livro.dart';
import 'models/Reserva.dart';
import 'models/Usuario.dart';
import 'services/emprestimo_service.dart';
import 'services/exemplar_service.dart';
import 'services/livro_service.dart';
import 'services/relatorio_service.dart';
import 'services/reserva_service.dart';
import 'services/usuario_service.dart';

void main() {
  final usuarios = UsuarioService();
  final livros = LivroService();
  final exemplares = ExemplarService();
  final emprestimos = EmprestimoService();
  final reservas = ReservaService();
  final relatorios = RelatorioService(livroService: livros, exemplarService: exemplares,
      emprestimoService: emprestimos, reservaService: reservas);

  var opcao = -1;
  while (opcao != 0) {
    menu('Sistema de Biblioteca', const [
      '1. Gerenciar Usuários', '2. Gerenciar Livros',
      '3. Gerenciar Exemplares', '4. Gerenciar Empréstimos',
      '5. Gerenciar Reservas', '6. Gerar Relatórios', '0. Sair',
    ]);
    opcao = lerOpcao();
    switch (opcao) {
      case 1: menuUsuarios(usuarios); break;
      case 2: menuLivros(livros); break;
      case 3: menuExemplares(exemplares); break;
      case 4: menuEmprestimos(usuarios, exemplares, emprestimos); break;
      case 5: menuReservas(usuarios, livros, reservas); break;
      case 6: menuRelatorios(relatorios); break;
      case 0: print('Saindo do sistema...'); break;
      default: print('Opção inválida!');
    }
  }
}

void menu(String titulo, List<String> opcoes) {
  print('\n========================================');
  print('=== $titulo ===');
  print('----------------------------------------');
  for (final opcao in opcoes) print(opcao);
  print('----------------------------------------');
  stdout.write('Escolha uma opção: ');
}

int lerOpcao() {
  try { return int.parse(stdin.readLineSync()!); }
  catch (_) { print('Erro: entrada inválida. Por favor, digite um número.'); return -1; }
}

void menuUsuarios(UsuarioService service) {
  var opcao = -1;
  while (opcao != 0) {
    menu('Gerenciar Usuários', const ['1. Adicionar usuário', '2. Listar usuários',
      '3. Alterar usuário', '4. Remover usuário', '5. Buscar usuário por ID',
      '0. Voltar ao Menu Principal']);
    opcao = lerOpcao();
    try {
      switch (opcao) {
        case 1:
          service.adicionarUsuario(Usuario(lerInt('Digite o ID do usuário: '),
              lerTexto('Digite o nome do usuário: '), lerTipoUsuario())); break;
        case 2: service.ListarUsuarios(); break;
        case 3:
          final id = lerInt('Digite o ID do usuário a ser alterado: ');
          service.alterarUsuario(id, lerTexto('Digite o novo nome do usuário: '), lerTipoUsuario()); break;
        case 4: service.removerUsuario(lerInt('Digite o ID do usuário a ser removido: ')); break;
        case 5: imprimirUsuario(service.buscarPorId(lerInt('Digite o ID do usuário: '))); break;
        case 0: voltar(); break;
        default: print('Opção inválida!');
      }
    } catch (_) { dadosInvalidos(); }
  }
}

String lerTipoUsuario() {
  print('Escolha o tipo do usuário:');
  print('1. Aluno'); print('2. Professor'); print('3. Comunidade');
  stdout.write('Escolha uma opção: ');
  switch (lerOpcao()) {
    case 1: return tipo_usuario.Aluno.toString().split('.').last;
    case 2: return tipo_usuario.Professor.toString().split('.').last;
    case 3: return tipo_usuario.Comunidade.toString().split('.').last;
    default: throw const FormatException();
  }
}

void menuLivros(LivroService service) {
  var opcao = -1;
  while (opcao != 0) {
    menu('Gerenciar Livros', const ['1. Adicionar livro', '2. Listar livros',
      '3. Alterar livro', '4. Remover livro', '5. Buscar livro por ID',
      '0. Voltar ao Menu Principal']);
    opcao = lerOpcao();
    try {
      switch (opcao) {
        case 1: service.adicionarLivro(lerLivro()); break;
        case 2: service.ListarLivros(); break;
        case 3:
          final livro = lerLivro('Digite o ID do livro a ser alterado: ');
          service.alterarLivro(livro.id, livro.titulo, livro.autor, livro.categoria); break;
        case 4: service.removerLivro(lerInt('Digite o ID do livro a ser removido: ')); break;
        case 5: imprimirLivro(service.buscarPorId(lerInt('Digite o ID do livro: '))); break;
        case 0: voltar(); break;
        default: print('Opção inválida!');
      }
    } catch (_) { dadosInvalidos(); }
  }
}

Livro lerLivro([String perguntaId = 'Digite o ID do livro: ']) => Livro(
  lerInt(perguntaId), lerTexto('Digite o título do livro: '),
  lerTexto('Digite o autor do livro: '), lerTexto('Digite a categoria do livro: '));

void menuExemplares(ExemplarService service) {
  var opcao = -1;
  while (opcao != 0) {
    menu('Gerenciar Exemplares', const ['1. Adicionar exemplar', '2. Listar exemplares',
      '3. Alterar exemplar', '4. Remover exemplar', '5. Buscar exemplar por ID',
      '6. Buscar exemplar disponível por ID do livro', '0. Voltar ao Menu Principal']);
    opcao = lerOpcao();
    try {
      switch (opcao) {
        case 1: service.adicionarExemplar(lerExemplar()); break;
        case 2: service.ListarExemplares(); break;
        case 3:
          final exemplar = lerExemplar('Digite o ID do exemplar a ser alterado: ');
          service.alterarExemplar(exemplar.id, exemplar.livroId, exemplar.disponivel); break;
        case 4: service.removerExemplar(lerInt('Digite o ID do exemplar a ser removido: ')); break;
        case 5: imprimirExemplar(service.buscarPorId(lerInt('Digite o ID do exemplar: '))); break;
        case 6: imprimirExemplar(service.buscarDisponivel(lerInt('Digite o ID do livro: '))); break;
        case 0: voltar(); break;
        default: print('Opção inválida!');
      }
    } catch (_) { dadosInvalidos(); }
  }
}

Exemplar lerExemplar([String perguntaId = 'Digite o ID do exemplar: ']) => Exemplar(
  lerInt(perguntaId), lerInt('Digite o ID do livro: '),
  bool.parse(lerTexto('Digite se o exemplar está disponível (true/false): ')));

void menuEmprestimos(UsuarioService usuarios, ExemplarService exemplares, EmprestimoService service) {
  var opcao = -1;
  while (opcao != 0) {
    menu('Gerenciar Empréstimos', const ['1. Realizar empréstimo', '2. Devolver exemplar',
      '3. Listar empréstimos', '4. Buscar empréstimo por ID',
      '5. Buscar empréstimo por ID de usuário', '0. Voltar ao Menu Principal']);
    opcao = lerOpcao();
    try {
      switch (opcao) {
        case 1: realizarEmprestimo(usuarios, exemplares, service); break;
        case 2: devolverEmprestimo(exemplares, service); break;
        case 3: service.ListarEmprestimos(); break;
        case 4: imprimirEmprestimo(service.buscarPorId(lerInt('Digite o ID do empréstimo: '))); break;
        case 5: imprimirEmprestimo(service.buscarPorUsuarioId(lerInt('Digite o ID do usuário: '))); break;
        case 0: voltar(); break;
        default: print('Opção inválida!');
      }
    } catch (_) { dadosInvalidos(); }
  }
}

void realizarEmprestimo(UsuarioService usuarios, ExemplarService exemplares, EmprestimoService service) {
  final id = lerInt('Digite o ID do empréstimo: ');
  final usuarioId = lerInt('Digite o ID do usuário: ');
  final exemplarId = lerInt('Digite o ID do exemplar: ');
  if (usuarios.buscarPorId(usuarioId) == null) { print('Usuário não encontrado.'); return; }
  final exemplar = exemplares.buscarPorId(exemplarId);
  if (exemplar == null) { print('Exemplar não encontrado.'); return; }
  if (!exemplar.disponivel) { print('O exemplar não está disponível.'); return; }
  final data = DateTime.parse(lerTexto('Digite a data prevista de devolução (AAAA-MM-DD): '));
  service.adicionarEmprestimo(Emprestimo(id, usuarioId, exemplarId, DateTime.now(), data));
  exemplar.disponivel = false;
}

void devolverEmprestimo(ExemplarService exemplares, EmprestimoService service) {
  final id = lerInt('Digite o ID do empréstimo: ');
  final emprestimo = service.buscarPorId(id);
  if (emprestimo == null) { print('Empréstimo não encontrado.'); return; }
  if (emprestimo.dataDevolucao != null) { print('Este empréstimo já foi devolvido.'); return; }
  service.devolverEmprestimo(id, DateTime.now());
  final exemplar = exemplares.buscarPorId(emprestimo.exemplarId);
  if (exemplar != null) exemplar.disponivel = true;
}

void menuReservas(UsuarioService usuarios, LivroService livros, ReservaService service) {
  var opcao = -1;
  while (opcao != 0) {
    menu('Gerenciar Reservas', const ['1. Adicionar reserva', '2. Listar reservas',
      '3. Cancelar reserva', '4. Buscar reserva por ID',
      '5. Buscar reserva por ID de usuário', '0. Voltar ao Menu Principal']);
    opcao = lerOpcao();
    try {
      switch (opcao) {
        case 1: adicionarReserva(usuarios, livros, service); break;
        case 2: service.ListarReservas(); break;
        case 3: service.cancelarReserva(lerInt('Digite o ID da reserva: ')); break;
        case 4: imprimirReserva(service.buscarPorId(lerInt('Digite o ID da reserva: '))); break;
        case 5: imprimirReserva(service.buscarPorUsuarioId(lerInt('Digite o ID do usuário: '))); break;
        case 0: voltar(); break;
        default: print('Opção inválida!');
      }
    } catch (_) { dadosInvalidos(); }
  }
}

void adicionarReserva(UsuarioService usuarios, LivroService livros, ReservaService service) {
  final id = lerInt('Digite o ID da reserva: ');
  final usuarioId = lerInt('Digite o ID do usuário: ');
  final livroId = lerInt('Digite o ID do livro: ');
  if (usuarios.buscarPorId(usuarioId) == null) { print('Usuário não encontrado.'); return; }
  if (livros.buscarPorId(livroId) == null) { print('Livro não encontrado.'); return; }
  service.adicionarReserva(Reserva(id, usuarioId, livroId, DateTime.now()));
}

void menuRelatorios(RelatorioService service) {
  var opcao = -1;
  while (opcao != 0) {
    menu('Gerar Relatórios', const ['1. Relatório de livros', '2. Relatório de empréstimos',
      '3. Relatório de reservas', '4. Resumo geral', '0. Voltar ao Menu Principal']);
    opcao = lerOpcao();
    switch (opcao) {
      case 1: service.imprimirRelatorioLivros(); break;
      case 2: service.imprimirRelatorioEmprestimos(); break;
      case 3: service.imprimirRelatorioReservas(); break;
      case 4: service.imprimirResumo(); break;
      case 0: voltar(); break;
      default: print('Opção inválida!');
    }
  }
}

int lerInt(String mensagem) => int.parse(lerTexto(mensagem));
String lerTexto(String mensagem) { stdout.write(mensagem); return stdin.readLineSync()!; }
void voltar() => print('Voltando ao Menu Principal...');
void dadosInvalidos() => print('Erro: dados inválidos. Verifique as informações digitadas.');

void imprimirUsuario(Usuario? item) {
  if (item == null) {
    print('Usuário não encontrado.');
  } else {
    print('ID: ${item.id} | Nome: ${item.nome} | Tipo: ${item.tipo}');
  }
}

void imprimirLivro(Livro? item) {
  if (item == null) {
    print('Livro não encontrado.');
  } else {
    print('ID: ${item.id} | Título: ${item.titulo} | Autor: ${item.autor} | Categoria: ${item.categoria}');
  }
}

void imprimirExemplar(Exemplar? item) {
  if (item == null) {
    print('Exemplar não encontrado.');
  } else {
    print('ID: ${item.id} | Livro ID: ${item.livroId} | Disponível: ${item.disponivel}');
  }
}

void imprimirEmprestimo(Emprestimo? item) {
  if (item == null) {
    print('Empréstimo não encontrado.');
  } else {
    print('ID: ${item.id} | Usuário ID: ${item.usuarioId} | Exemplar ID: ${item.exemplarId} | Data Empréstimo: ${item.dataEmprestimo} | Data Devolução: ${item.dataDevolucao}');
  }
}

void imprimirReserva(Reserva? item) {
  if (item == null) {
    print('Reserva não encontrada.');
  } else {
    print('ID: ${item.id} | Usuário ID: ${item.usuarioId} | Livro ID: ${item.livroId} | Data da Reserva: ${item.dataReserva}');
  }
}
