import 'dart:io';
import 'package:tint/tint.dart';
import 'models/Emprestimo.dart';
import 'models/Exemplar.dart';
import 'models/Livro.dart';
import 'models/Reserva.dart';
import 'models/Usuario.dart';
import 'services/emprestimo_service.dart';
import 'services/exemplar_service.dart';
import 'services/livro_service.dart';
import 'services/politica_emprestimo_service.dart';
import 'services/relatorio_service.dart';
import 'services/reserva_service.dart';
import 'services/usuario_service.dart';

Future<void> main() async {
  final usuarios = UsuarioService();
  final livros = LivroService();
  final exemplares = ExemplarService();
  final emprestimos = EmprestimoService();
  final reservas = ReservaService();
  
  final relatorios = RelatorioService(
    livroService: livros, 
    exemplarService: exemplares, 
    emprestimoService: emprestimos, 
    reservaService: reservas
  );
  
  await Future.wait([
    usuarios.carregarDados(), 
    livros.carregarDados(), 
    exemplares.carregarDados(), 
    emprestimos.carregarDados(), 
    reservas.carregarDados()
  ]);
  
  int opcao;
  do {
    opcao = menu('SISTEMA DE BIBLIOTECA', [
      '1. Usuários', 
      '2. Títulos / Acervo', 
      '3. Exemplares', 
      '4. Empréstimos', 
      '5. Reservas', 
      '6. Pendências financeiras', 
      '7. Relatórios', 
      '0. Sair'
    ]);
    
    try {
      if (opcao == 1) await menuUsuarios(usuarios, emprestimos);
      if (opcao == 2) await menuLivros(livros, exemplares, reservas);
      if (opcao == 3) await menuExemplares(exemplares, livros, emprestimos);
      if (opcao == 4) await menuEmprestimos(usuarios, livros, exemplares, emprestimos, reservas);
      if (opcao == 5) await menuReservas(usuarios, livros, exemplares, reservas);
      if (opcao == 6) await menuPendencias(usuarios);
      if (opcao == 7) menuRelatorios(relatorios);
    } catch (e) { 
      erro(e.toString().replaceFirst('Bad state: ', '')); 
    }
  } while (opcao != 0);
  
  await Future.wait([
    usuarios.salvarDados(), 
    livros.salvarDados(), 
    exemplares.salvarDados(), 
    emprestimos.salvarDados(), 
    reservas.salvarDados()
  ]);
  
  sucesso('Sistema encerrado. Até logo!');
}

Future<void> menuUsuarios(UsuarioService s, EmprestimoService es) async { 
  int o; 
  do { 
    o = menu('USUÁRIOS', [
      '1. Cadastrar', 
      '2. Listar', 
      '3. Alterar', 
      '4. Remover', 
      '5. Consultar por ID', 
      '0. Voltar'
    ]); 
    
    if (o == 1) {
      await s.adicionarUsuario(Usuario(lerInt('ID: ', minimo: 1), lerTexto('Nome: '), lerTipoUsuario())); 
    }
    if (o == 2) {
      s.ListarUsuarios(); 
    }
    if (o == 3) {
      await s.alterarUsuario(lerInt('ID: ', minimo: 1), lerTexto('Novo nome: '), lerTipoUsuario()); 
    }
    if (o == 4) { 
      final id = lerInt('ID: ', minimo: 1); 
      if (es.ativosDoUsuario(id).isNotEmpty) {
        throw StateError('Não é possível remover usuário com empréstimos ativos.'); 
      }
      await s.removerUsuario(id); 
    } 
    if (o == 5) {
      imprimirUsuario(s.buscarPorId(lerInt('ID: ', minimo: 1))); 
    }
  } while (o != 0); 
}

Future<void> menuLivros(LivroService s, ExemplarService es, ReservaService rs) async { 
  int o; 
  do { 
    o = menu('TÍTULOS / ACERVO', [
      '1. Cadastrar título', 
      '2. Listar títulos', 
      '3. Alterar título', 
      '4. Baixar título', 
      '5. Consultar por ID', 
      '0. Voltar'
    ]); 
    
    if (o == 1) {
      await s.adicionarLivro(lerLivro()); 
    }
    if (o == 2) {
      s.ListarLivros(); 
    }
    if (o == 3) { 
      final l = lerLivro('ID do título: '); 
      await s.alterarLivro(l.id, l.titulo, l.autor, l.categoria, l.natureza); 
    } 
    if (o == 4) { 
      final id = lerInt('ID: ', minimo: 1); 
      if (es.exemplares.any((e) => e.livroId == id) || rs.reservas.any((r) => r.livroId == id)) {
        throw StateError('Remova exemplares e cancele reservas antes de baixar o título.'); 
      }
      await s.removerLivro(id); 
    } 
    if (o == 5) {
      imprimirLivro(s.buscarPorId(lerInt('ID: ', minimo: 1))); 
    }
  } while (o != 0); 
}

Future<void> menuExemplares(ExemplarService s, LivroService ls, EmprestimoService es) async { 
  int o; 
  do { 
    o = menu('EXEMPLARES', [
      '1. Adquirir/cadastrar', 
      '2. Listar', 
      '3. Alterar disponibilidade', 
      '4. Baixar exemplar', 
      '5. Consultar por ID', 
      '6. Consultar disponível por título', 
      '0. Voltar'
    ]); 
    
    if (o == 1) { 
      final e = lerExemplar(); 
      if (ls.buscarPorId(e.livroId) == null) {
        throw StateError('Título não encontrado.'); 
      }
      await s.adicionarExemplar(e); 
    } 
    if (o == 2) {
      s.ListarExemplares(); 
    }
    if (o == 3) { 
      final e = s.buscarPorId(lerInt('ID: ', minimo: 1)); 
      if (e == null) {
        throw StateError('Exemplar não encontrado.'); 
      }
      await s.alterarExemplar(e.id, e.livroId, lerSimNao('Disponível?')); 
    } 
    if (o == 4) { 
      final id = lerInt('ID: ', minimo: 1); 
      if (es.emprestimos.any((x) => x.exemplarId == id && x.ativo)) {
        throw StateError('Não é possível baixar exemplar emprestado.'); 
      }
      await s.removerExemplar(id); 
    } 
    if (o == 5) {
      imprimirExemplar(s.buscarPorId(lerInt('ID: ', minimo: 1))); 
    }
    if (o == 6) {
      imprimirExemplar(s.buscarDisponivel(lerInt('ID do título: ', minimo: 1))); 
    }
  } while (o != 0); 
}

Future<void> menuEmprestimos(UsuarioService us, LivroService ls, ExemplarService xs, EmprestimoService es, ReservaService rs) async { 
  int o; 
  do { 
    o = menu('EMPRÉSTIMOS', [
      '1. Realizar empréstimo', 
      '2. Registrar devolução', 
      '3. Listar', 
      '4. Consultar por ID', 
      '5. Consultar ativos por usuário', 
      '0. Voltar'
    ]); 
    
    if (o == 1) await realizarEmprestimo(us, ls, xs, es, rs); 
    if (o == 2) await devolverEmprestimo(us, ls, xs, es); 
    if (o == 3) es.ListarEmprestimos(); 
    if (o == 4) { 
      final item = es.buscarPorId(lerInt('ID: ', minimo: 1)); 
      if (item == null) {
        erro('Empréstimo não encontrado.'); 
      } else {
        imprimirEmprestimo(item); 
      }
    } 
    if (o == 5) { 
      final itens = es.ativosDoUsuario(lerInt('ID do usuário: ', minimo: 1)); 
      if (itens.isEmpty) {
        aviso('Nenhum empréstimo ativo.'); 
      } else {
        itens.forEach(imprimirEmprestimo); 
      }
    } 
  } while (o != 0); 
}

Future<void> realizarEmprestimo(UsuarioService us, LivroService ls, ExemplarService xs, EmprestimoService es, ReservaService rs) async {
  final id = lerInt('ID do empréstimo: ', minimo: 1); 
  final usuario = us.buscarPorId(lerInt('ID do usuário: ', minimo: 1)); 
  final livro = ls.buscarPorId(lerInt('ID do título: ', minimo: 1));
  
  if (usuario == null || livro == null) {
    throw StateError('Usuário ou título não encontrado.');
  }
  if (usuario.bloqueado) {
    throw StateError('Usuário bloqueado: pendência de R\$ ${usuario.pendenciaFinanceira.toStringAsFixed(2)}.');
  }
  if (es.usuarioPossuiAtraso(usuario.id, DateTime.now())) {
    throw StateError('Usuário possui empréstimo em atraso.');
  }
  
  final limite = PoliticaEmprestimoService.limitePara(usuario, livro);
  if (es.ativosDoUsuario(usuario.id).length >= limite) {
    throw StateError('Limite atingido: $limite exemplar(es).');
  }
  
  final exemplar = xs.buscarDisponivel(livro.id);
  if (exemplar == null) { 
    aviso('Não há exemplar disponível. Use Reservas para entrar na fila.'); 
    return; 
  }
  
  if (rs.reservas.any((r) => r.livroId == livro.id && r.usuarioId != usuario.id)) {
    throw StateError('Há reserva pendente para outro usuário.');
  }
  
  final prazo = PoliticaEmprestimoService.prazoEmDiasPara(usuario, livro); 
  final prevista = DateTime.now().add(Duration(days: prazo));
  
  await es.adicionarEmprestimo(Emprestimo(id, usuario.id, exemplar.id, DateTime.now(), prevista)); 
  exemplar.disponivel = false;
  rs.reservas.removeWhere((r) => r.livroId == livro.id && r.usuarioId == usuario.id);
  
  await Future.wait([xs.salvarDados(), rs.salvarDados()]); 
  sucesso('Empréstimo realizado. Prazo: $prazo dia(s), até ${formatarData(prevista)}.');
}

Future<void> devolverEmprestimo(UsuarioService us, LivroService ls, ExemplarService xs, EmprestimoService es) async {
  final emprestimo = es.buscarPorId(lerInt('ID do empréstimo: ', minimo: 1)); 
  if (emprestimo == null || !emprestimo.ativo) {
    throw StateError('Empréstimo não encontrado ou já devolvido.');
  }
  
  final exemplar = xs.buscarPorId(emprestimo.exemplarId); 
  final livro = exemplar == null ? null : ls.buscarPorId(exemplar.livroId); 
  if (livro == null) {
    throw StateError('Título do empréstimo não encontrado.');
  }
  
  final atraso = DateTime.now().difference(emprestimo.dataPrevistaDevolucao).inDays; 
  final multa = atraso > 0 ? atraso * PoliticaEmprestimoService.multaDiariaPara(livro) : 0.0; 
  final ocorrencia = escolherOcorrencia(); 
  final ressarcimento = ocorrencia == null ? 0.0 : PoliticaEmprestimoService.valorRessarcimentoPara(livro);
  
  await es.devolverEmprestimo(emprestimo.id, DateTime.now(), multa: multa, ressarcimento: ressarcimento, ocorrencia: ocorrencia); 
  
  if (multa + ressarcimento > 0) {
    await us.registrarPendencia(emprestimo.usuarioId, multa + ressarcimento); 
  }
  
  if (exemplar != null) { 
    exemplar.disponivel = ocorrencia == null; 
    await xs.salvarDados(); 
  }
  
  if (multa > 0) aviso('Atraso: $atraso dia(s); multa: R\$ ${multa.toStringAsFixed(2)}.'); 
  if (ressarcimento > 0) aviso('Ocorrência: $ocorrencia; ressarcimento: R\$ ${ressarcimento.toStringAsFixed(2)}. Exemplar baixado.'); 
  sucesso('Devolução registrada.');
}

Future<void> menuReservas(UsuarioService us, LivroService ls, ExemplarService xs, ReservaService s) async { 
  int o; 
  do { 
    o = menu('RESERVAS', [
      '1. Reservar título indisponível', 
      '2. Listar fila', 
      '3. Cancelar', 
      '4. Consultar por ID', 
      '0. Voltar'
    ]); 
    
    if (o == 1) { 
      final id = lerInt('ID da reserva: ', minimo: 1); 
      final u = lerInt('ID do usuário: ', minimo: 1); 
      final l = lerInt('ID do título: ', minimo: 1); 
      
      if (us.buscarPorId(u) == null || ls.buscarPorId(l) == null) {
        throw StateError('Usuário ou título não encontrado.'); 
      }
      if (xs.quantidadeDisponivel(l) > 0) {
        throw StateError('O título está disponível; faça o empréstimo diretamente.'); 
      }
      if (s.reservas.any((r) => r.usuarioId == u && r.livroId == l)) {
        throw StateError('Usuário já possui reserva para este título.'); 
      }
      await s.adicionarReserva(Reserva(id, u, l, DateTime.now())); 
    } 
    if (o == 2) s.ListarReservas(); 
    if (o == 3) await s.cancelarReserva(lerInt('ID: ', minimo: 1)); 
    if (o == 4) imprimirReserva(s.buscarPorId(lerInt('ID: ', minimo: 1))); 
  } while (o != 0); 
}

Future<void> menuPendencias(UsuarioService s) async { 
  int o; 
  do { 
    o = menu('PENDÊNCIAS FINANCEIRAS', [
      '1. Listar bloqueados', 
      '2. Registrar pagamento', 
      '0. Voltar'
    ]); 
    
    if (o == 1) { 
      final itens = s.usuarios.where((u) => u.bloqueado); 
      if (itens.isEmpty) {
        sucesso('Não há usuários bloqueados.'); 
      } else {
        itens.forEach(imprimirUsuario); 
      }
    } 
    if (o == 2) {
      await s.quitarPendencia(lerInt('ID do usuário: ', minimo: 1), lerDouble('Valor pago: R\$ ')); 
    }
  } while (o != 0); 
}

void menuRelatorios(RelatorioService s) { 
  int o; 
  do { 
    o = menu('RELATÓRIOS', [
      '1. Livros', 
      '2. Empréstimos', 
      '3. Reservas', 
      '4. Resumo', 
      '0. Voltar'
    ]); 
    
    if (o == 1) s.imprimirRelatorioLivros(); 
    if (o == 2) s.imprimirRelatorioEmprestimos(); 
    if (o == 3) s.imprimirRelatorioReservas(); 
    if (o == 4) s.imprimirResumo(); 
  } while (o != 0); 
}

int menu(String t, List<String> opcoes) { 
  print('\n${'═' * 54}'.brightCyan()); 
  print('  $t'.bold().brightWhite().onBlue()); 
  for (final o in opcoes) {
    print('  $o'.cyan()); 
  }
  print('${'─' * 54}'.brightCyan()); 
  return lerInt('Escolha uma opção: ', minimo: 0, maximo: opcoes.length - 1); 
}

int lerInt(String m, {int? minimo, int? maximo}) {
  while (true) {
    final valor = lerTexto(m);
    final numero = int.tryParse(valor);
    if (numero != null &&
        (minimo == null || numero >= minimo) &&
        (maximo == null || numero <= maximo)) {
      return numero;
    }

    final intervalo = [
      if (minimo != null) 'a partir de $minimo',
      if (maximo != null) 'até $maximo',
    ].join(' e ');
    erro(intervalo.isEmpty
        ? 'Informe um número inteiro válido.'
        : 'Informe um número inteiro válido $intervalo.');
  }
}

double lerDouble(String m, {double? minimo, double? maximo}) {
  while (true) {
    final valor = lerTexto(m).replaceAll(',', '.');
    final numero = double.tryParse(valor);
    if (numero != null && numero.isFinite &&
        (minimo == null || numero >= minimo) &&
        (maximo == null || numero <= maximo)) {
      return numero;
    }

    erro('Informe um número decimal válido.');
  }
}

String lerTexto(String m) { 
  stdout.write(m.brightYellow()); 
  final v = stdin.readLineSync()?.trim(); 
  if (v == null || v.isEmpty) {
    throw const FormatException('Entrada obrigatória.'); 
  }
  return v; 
} 

bool lerSimNao(String m) {
  while (true) {
    final valor = lerTexto('$m (s/n): ').toLowerCase();
    if (valor == 's' || valor == 'sim') return true;
    if (valor == 'n' || valor == 'nao' || valor == 'não') return false;
    erro('Responda apenas com s ou n.');
  }
}

String lerTipoUsuario() { 
  final o = menu('TIPO DE VÍNCULO', ['1. Aluno', '2. Professor', '3. Comunidade']); 
  if (o == 1) return 'Aluno'; 
  if (o == 2) return 'Professor'; 
  if (o == 3) return 'Comunidade'; 
  throw const FormatException('Tipo inválido.'); 
} 

String? escolherOcorrencia() { 
  final o = menu('ESTADO DO EXEMPLAR', ['1. Em bom estado', '2. Danificado', '3. Perdido']); 
  if (o == 1) return null; 
  if (o == 2) return 'Danificado'; 
  if (o == 3) return 'Perdido'; 
  throw const FormatException('Opção inválida.'); 
}

Livro lerLivro([String m = 'ID do título: ']) {
  return Livro(
    lerInt(m, minimo: 1),
    lerTexto('Título: '),
    lerTexto('Autor: '),
    lerTexto('Categoria: '),
    lerNatureza()
  );
}

String lerNatureza() {
  const validas = ['Livro', 'Periódico', 'Referência'];
  while (true) {
    final valor = lerTexto('Natureza (Livro, Periódico ou Referência): ');
    for (final natureza in validas) {
      if (natureza.toLowerCase() == valor.toLowerCase()) return natureza;
    }
    erro('Natureza inválida. Informe Livro, Periódico ou Referência.');
  }
}

Exemplar lerExemplar() => Exemplar(lerInt('ID do exemplar: ', minimo: 1), lerInt('ID do título: ', minimo: 1), true); 

String formatarData(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

void sucesso(String t) => print('✓ $t'.brightGreen()); 
void aviso(String t) => print('! $t'.brightYellow()); 
void erro(String t) => print('✗ $t'.brightRed()); 

void imprimirUsuario(Usuario? i) {
  if (i == null) {
    erro('Usuário não encontrado.');
  } else {
    print('ID: ${i.id} | ${i.nome} | ${i.tipo} | ${i.bloqueado ? 'BLOQUEADO — R\$ ${i.pendenciaFinanceira.toStringAsFixed(2)}' : 'Regular'}');
  }
}

void imprimirLivro(Livro? i) {
  if (i == null) {
    erro('Título não encontrado.');
  } else {
    print('ID: ${i.id} | ${i.titulo} | ${i.autor} | ${i.categoria} | Natureza: ${i.natureza}');
  }
}

void imprimirExemplar(Exemplar? i) {
  if (i == null) {
    erro('Exemplar não encontrado.');
  } else {
    print('ID: ${i.id} | Título: ${i.livroId} | ${i.disponivel ? 'Disponível' : 'Indisponível'}');
  }
}

void imprimirEmprestimo(Emprestimo i) {
  print('ID: ${i.id} | Usuário: ${i.usuarioId} | Exemplar: ${i.exemplarId} | Previsto: ${formatarData(i.dataPrevistaDevolucao)} | ${i.ativo ? 'ATIVO' : 'Devolvido'} | Multa: R\$ ${i.multa.toStringAsFixed(2)} | Ressarcimento: R\$ ${i.ressarcimento.toStringAsFixed(2)}');
}

void imprimirReserva(Reserva? i) {
  if (i == null) {
    erro('Reserva não encontrada.');
  } else {
    print('ID: ${i.id} | Usuário: ${i.usuarioId} | Título: ${i.livroId} | ${formatarData(i.dataReserva)}');
  }
}