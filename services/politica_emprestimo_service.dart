import '../models/Livro.dart';
import '../models/Usuario.dart';

/// Centraliza as regras de limite, prazo e cobranças da biblioteca.
class PoliticaEmprestimoService {
  static int limitePara(Usuario usuario, Livro livro) {
    final tipo = usuario.tipo.toLowerCase();
    final base = tipo == 'professor' ? 5 : tipo == 'comunidade' ? 2 : 3;
    return livro.ehConsultaLocal ? 1 : base;
  }

  static int prazoEmDiasPara(Usuario usuario, Livro livro) {
    if (livro.ehConsultaLocal) return 1;
    final tipo = usuario.tipo.toLowerCase();
    final prazoBase = tipo == 'professor' ? 21 : tipo == 'comunidade' ? 7 : 14;
    return livro.ehPeriodico ? 3 : prazoBase;
  }

  static double multaDiariaPara(Livro livro) {
    final natureza = livro.natureza.toLowerCase();
    if (natureza == 'periódico' || natureza == 'periodico') return 1.50;
    if (livro.ehConsultaLocal) return 3.00;
    return 1.00;
  }

  static double valorRessarcimentoPara(Livro livro) {
    final natureza = livro.natureza.toLowerCase();
    if (natureza == 'periódico' || natureza == 'periodico') return 30.0;
    return livro.ehConsultaLocal ? 80.0 : 50.0;
  }
}
