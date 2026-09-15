import 'dart:io';

import 'enums/tipo_usuario.dart';

import 'models/Usuario.dart';
import 'models/Livro.dart';
import 'models/Exemplar.dart';
import 'models/Emprestimo.dart';
import 'models/Reserva.dart';

import 'services/usuario_service.dart';
import 'services/livro_service.dart';
import 'services/exemplar_service.dart';
import 'services/emprestimo_service.dart';
import 'services/reserva_service.dart';
import 'services/relatorio_service.dart';

void main() {
  UsuarioService usuarioService = UsuarioService();
  LivroService livroService = LivroService();
  ExemplarService exemplarService = ExemplarService();
  ReservaService reservaService = ReservaService();
  EmprestimoService emprestimoService = EmprestimoService();

  int opcao = -1;

  while (opcao != 0) {
    try {
      print("\n=== Sistema de Biblioteca ===");
      print("1. Gerenciar Usuários");
      print("2. Gerenciar Livros");
      print("3. Gerenciar Exemplares");
      print("4. Gerenciar Empréstimos");
      print("5. Gerenciar Reservas");
      print("6. Gerar Relatórios");
      print("0. Sair");
      stdout.write("Escolha uma opção: ");
      opcao = int.parse(stdin.readLineSync()!);
    } catch (e) {
      print("Erro: Entrada inválida. Por favor, digite um número.");
    }
    switch (opcao) {
      case 1:
        int opcaoUsuario = 0;

        try {
          print("\n=== Gerenciar Usuários ===");
          print("1. Adicionar Usuário");
          print("2. Listar Usuários");
          print("3. Alterar Usuário");
          print("4. Remover Usuário");

          stdout.write("Escolha uma opção: ");
          opcaoUsuario = int.parse(stdin.readLineSync()!);
        } catch (e) {
          print("Erro: Entrada inválida. Por favor, digite um número.");
        }

        if (opcaoUsuario == 1) {
          try {
            stdout.write("Digite o ID do usuário: ");
            int id = int.parse(stdin.readLineSync()!);

            stdout.write("Digite o nome do usuário: ");
            String nome = stdin.readLineSync()!;

            print("Escolha o tipo do usuário:");
            print("1. Aluno");
            print("2. Professor");
            print("3. Comunidade\n");
            stdout.write("Digite o número correspondente ao tipo do usuário: ");

            int tipo = int.parse(stdin.readLineSync()!);
            tipo_usuario tipoUsuario;

            switch (tipo) {
              case 1:
                tipoUsuario = tipo_usuario.Aluno;
                break;
              case 2:
                tipoUsuario = tipo_usuario.Professor;
                break;
              case 3:
                tipoUsuario = tipo_usuario.Comunidade;
                break;
              default:
                print("Opção inválida!");
                return;
            }

            Usuario usuario = Usuario(
              id,
              nome,
              tipoUsuario.toString().split('.').last,
            );

            usuarioService.adicionarUsuario(usuario);
          } catch (e) {
            print("Erro: Dados inválidos. Verifique as informações digitadas.");
          }
        } else if (opcaoUsuario == 2) {
          try {
            usuarioService.ListarUsuarios();
          } catch (e) {
            print("Erro ao listar usuários.");
          }
        } else if (opcaoUsuario == 3) {
          try {
            stdout.write("Digite o ID do usuário a ser alterado: ");
            int id = int.parse(stdin.readLineSync()!);

            stdout.write("Digite o novo nome do usuário: ");
            String nome = stdin.readLineSync()!;

            print("Escolha o novo tipo do usuário:");
            print("1. Aluno");
            print("2. Professor");
            print("3. Comunidade\n");
            stdout.write("Digite o número correspondente ao tipo do usuário: ");

            int tipo = int.parse(stdin.readLineSync()!);
            tipo_usuario tipoUsuario;

            switch (tipo) {
              case 1:
                tipoUsuario = tipo_usuario.Aluno;
                break;
              case 2:
                tipoUsuario = tipo_usuario.Professor;
                break;
              case 3:
                tipoUsuario = tipo_usuario.Comunidade;
                break;
              default:
                print("Opção inválida!");
                return;
            }

            usuarioService.alterarUsuario(
              id,
              nome,
              tipoUsuario.toString().split('.').last,
            );
          } catch (e) {
            print("Erro: Dados inválidos. Verifique as informações digitadas.");
          }
        } else if (opcaoUsuario == 4) {
          try {
            stdout.write("Digite o ID do usuário a ser removido: ");
            int id = int.parse(stdin.readLineSync()!);

            usuarioService.removerUsuario(id);
          } catch (e) {
            print("Erro: O ID deve ser um número.");
          }
        } else {
          print("Opção inválida!");
        }
        break;
      case 2:
        int opcaoLivro = 0;

        try {
          print("\n=== Gerenciar Livros ===");
          print("1. Adicionar Livro");
          print("2. Listar Livros");
          print("3. Alterar Livro");
          print("4. Remover Livro");
          stdout.write("Digite a opção desejada: ");
          opcaoLivro = int.parse(stdin.readLineSync()!);
        } catch (e) {
          print("Erro: Dados inválidos. Verifique as informações digitadas.");
        }

        if (opcaoLivro == 1) {
          try {
            stdout.write("Digite o ID do livro: ");
            int id = int.parse(stdin.readLineSync()!);

            stdout.write("Digite o título do livro: ");
            String titulo = stdin.readLineSync()!;

            stdout.write("Digite o autor do livro: ");
            String autor = stdin.readLineSync()!;

            stdout.write("Digite a categoria do livro: ");
            String categoria = stdin.readLineSync()!;

            Livro livro = Livro(id, titulo, autor, categoria);
            livroService.adicionarLivro(livro);
          } catch (e) {
            print("Erro: Dados inválidos. Verifique as informações digitadas.");
          }
        } else if (opcaoLivro == 2) {
          try {
            livroService.ListarLivros();
          } catch (e) {
            print("Erro ao listar livros.");
          }
        } else if (opcaoLivro == 3) {
          try {
            stdout.write("Digite o ID do livro a ser alterado: ");
            int id = int.parse(stdin.readLineSync()!);

            stdout.write("Digite o novo título do livro: ");
            String titulo = stdin.readLineSync()!;

            stdout.write("Digite o novo autor do livro: ");
            String autor = stdin.readLineSync()!;

            stdout.write("Digite a nova categoria do livro: ");
            String categoria = stdin.readLineSync()!;

            livroService.alterarLivro(id, titulo, autor, categoria);
          } catch (e) {
            print("Erro: Dados inválidos. Verifique as informações digitadas.");
          }
        } else if (opcaoLivro == 4) {
          try {
            stdout.write("Digite o ID do livro a ser removido: ");
            int id = int.parse(stdin.readLineSync()!);

            livroService.removerLivro(id);
          } catch (e) {
            print("Erro: O ID deve ser um número.");
          }
        } else {
          print("Opção inválida!");
        }
        break;
      case 3:
        int opcaoExemplar = 0;

        try {
          print("\n=== Gerenciar Exemplares ===");
          print("1. Adicionar Exemplar");
          print("2. Listar Exemplares");
          print("3. Alterar Exemplar");
          print("4. Remover Exemplar");
          stdout.write("Digite a opção desejada: ");
          opcaoExemplar = int.parse(stdin.readLineSync()!);
        } catch (e) {
          print("Erro: Dados inválidos. Verifique as informações digitadas.");
        }
        if (opcaoExemplar == 1) {
          try {
            stdout.write("Digite o ID do exemplar: ");
            int id = int.parse(stdin.readLineSync()!);

            stdout.write("Digite o ID do livro: ");
            int livroId = int.parse(stdin.readLineSync()!);

            stdout.write("Digite se o exemplar está disponível (true/false): ");
            bool disponivel = bool.parse(stdin.readLineSync()!);

            Exemplar exemplar = Exemplar(id, livroId, disponivel);
            exemplarService.adicionarExemplar(exemplar);
          } catch (e) {
            print("Erro: Dados inválidos. Verifique as informações digitadas.");
          }
        } else if (opcaoExemplar == 2) {
          try {
            exemplarService.ListarExemplares();
          } catch (e) {
            print("Erro ao listar exemplares.");
          }
        } else if (opcaoExemplar == 3) {
          try {
            stdout.write("Digite o ID do exemplar a ser alterado: ");
            int id = int.parse(stdin.readLineSync()!);

            stdout.write("Digite o novo ID do livro: ");
            int livroId = int.parse(stdin.readLineSync()!);

            stdout.write("Digite se o exemplar está disponível (true/false): ");
            bool disponivel = bool.parse(stdin.readLineSync()!);

            exemplarService.alterarExemplar(id, livroId, disponivel);
          } catch (e) {
            print("Erro: Dados inválidos. Verifique as informações digitadas.");
          }
        } else if (opcaoExemplar == 4) {
          try {
            stdout.write("Digite o ID do exemplar a ser removido: ");
            int id = int.parse(stdin.readLineSync()!);

            exemplarService.removerExemplar(id);
          } catch (e) {
            print("Erro: O ID deve ser um número.");
          }
        } else {
          print("Opção inválida!");
        }
        break;
      case 4:
        int opcaoEmprestimo = 0;
        try {
          do {
            print("\n=== Gerenciar Empréstimos ===");
            print("1. Realizar empréstimo");
            print("2. Devolver exemplar");
            print("3. Listar empréstimos");
            print("0. Voltar ao menu principal");

            stdout.write("Digite a opção desejada: ");
            opcaoEmprestimo = int.parse(stdin.readLineSync()!);
          } while (opcaoEmprestimo < 0 || opcaoEmprestimo > 3);
        } catch (e) {
          print("Erro: Digite uma opção válida.");
          break;
        }

        switch (opcaoEmprestimo) {
          case 1:
            try {
              stdout.write("Digite o ID do empréstimo: ");
              int id = int.parse(stdin.readLineSync()!);
              stdout.write("Digite o ID do usuário: ");
              int usuarioId = int.parse(stdin.readLineSync()!);
              stdout.write("Digite o ID do exemplar: ");
              int exemplarId = int.parse(stdin.readLineSync()!);

              if (usuarioService.buscarPorId(usuarioId) == null) {
                print("Usuário não encontrado.");
                break;
              }

              Exemplar? exemplar = exemplarService.buscarPorId(exemplarId);
              if (exemplar == null) {
                print("Exemplar não encontrado.");
                break;
              }
              if (!exemplar.disponivel) {
                print("O exemplar não está disponível.");
                break;
              }

              stdout.write(
                "Digite a data prevista de devolução (AAAA-MM-DD): ",
              );
              DateTime dataPrevista = DateTime.parse(stdin.readLineSync()!);
              Emprestimo emprestimo = Emprestimo(
                id,
                usuarioId,
                exemplarId,
                DateTime.now(),
                dataPrevista,
              );
              emprestimoService.adicionarEmprestimo(emprestimo);
              exemplar.disponivel = false;
            } catch (e) {
              print(
                "Erro: Dados inválidos. Verifique as informações digitadas.",
              );
            }
            break;
          case 2:
            try {
              stdout.write("Digite o ID do empréstimo: ");
              int id = int.parse(stdin.readLineSync()!);
              Emprestimo? emprestimo = emprestimoService.buscarPorId(id);
              if (emprestimo == null) {
                print("Empréstimo não encontrado.");
                break;
              }
              if (emprestimo.dataDevolucao != null) {
                print("Este empréstimo já foi devolvido.");
                break;
              }

              emprestimoService.devolverEmprestimo(id, DateTime.now());
              Exemplar? exemplar = exemplarService.buscarPorId(
                emprestimo.exemplarId,
              );
              if (exemplar != null) {
                exemplar.disponivel = true;
              }
            } catch (e) {
              print("Erro: O ID deve ser um número.");
            }
            break;
          case 3:
            emprestimoService.ListarEmprestimos();
            break;
          case 0:
            print("Voltando ao menu principal...");
            break;
          default:
            print("Opção inválida!");
        }

        break;
      case 5:
        int opcaoReserva = 0;
        try {
          do {
            print("\n=== Gerenciar Reservas ===");
            print("1. Adicionar reserva");
            print("2. Listar reservas");
            print("3. Cancelar reserva");
            print("0. Voltar ao menu principal");
            stdout.write("Digite a opção desejada: ");
            opcaoReserva = int.parse(stdin.readLineSync()!);
          } while (opcaoReserva < 0 || opcaoReserva > 3);

          switch (opcaoReserva) {
            case 1:
              stdout.write("Digite o ID da reserva: ");
              int id = int.parse(stdin.readLineSync()!);
              stdout.write("Digite o ID do usuário: ");
              int usuarioId = int.parse(stdin.readLineSync()!);
              stdout.write("Digite o ID do livro: ");
              int livroId = int.parse(stdin.readLineSync()!);

              if (usuarioService.buscarPorId(usuarioId) == null) {
                print("Usuário não encontrado.");
                break;
              }
              if (livroService.buscarPorId(livroId) == null) {
                print("Livro não encontrado.");
                break;
              }
              reservaService.adicionarReserva(
                Reserva(id, usuarioId, livroId, DateTime.now()),
              );
              break;
            case 2:
              reservaService.ListarReservas();
              break;
            case 3:
              stdout.write("Digite o ID da reserva: ");
              int id = int.parse(stdin.readLineSync()!);
              reservaService.cancelarReserva(id);
              break;
            case 0:
              print("Voltando ao menu principal...");
              break;
          }
        } catch (e) {
          print("Erro: Dados inválidos. Verifique as informações digitadas.");
        }
        break;
      case 6:
        int opcaoRelatorio = 0;
        RelatorioService relatorioService = RelatorioService(
          livroService: livroService,
          exemplarService: exemplarService,
          emprestimoService: emprestimoService,
          reservaService: reservaService,
        );
        try {
          do {
            print("\n=== Gerar Relatórios ===");
            print("1. Relatório de livros");
            print("2. Relatório de empréstimos");
            print("3. Relatório de reservas");
            print("4. Resumo geral");
            print("0. Voltar ao menu principal");
            stdout.write("Digite a opção desejada: ");
            opcaoRelatorio = int.parse(stdin.readLineSync()!);
          } while (opcaoRelatorio < 0 || opcaoRelatorio > 4);

          switch (opcaoRelatorio) {
            case 1:
              relatorioService.imprimirRelatorioLivros();
              break;
            case 2:
              relatorioService.imprimirRelatorioEmprestimos();
              break;
            case 3:
              relatorioService.imprimirRelatorioReservas();
              break;
            case 4:
              relatorioService.imprimirResumo();
              break;
            case 0:
              print("Voltando ao menu principal...");
              break;
          }
        } catch (e) {
          print("Erro: Digite uma opção válida.");
        }
        break;
      case 0:
        print("Saindo do sistema...");
        break;
      default:
        print("Opção inválida!");
    }
  }
}
