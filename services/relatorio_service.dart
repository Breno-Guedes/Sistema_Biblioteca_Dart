import 'emprestimo_service.dart';
import 'exemplar_service.dart';
import 'livro_service.dart';
import 'reserva_service.dart';

class RelatorioService {
	final LivroService livroService;
	final ExemplarService exemplarService;
	final EmprestimoService emprestimoService;
	final ReservaService reservaService;

	RelatorioService({
		required this.livroService,
		required this.exemplarService,
		required this.emprestimoService,
		required this.reservaService,
	});

	String gerarRelatorioLivros() {
		final totalLivros = livroService.livros.length;
		final totalExemplares = exemplarService.exemplares.length;
		final exemplaresDisponiveis = exemplarService.exemplares
				.where((exemplar) => exemplar.disponivel)
				.length;

		return 'Relatório de livros\n'
				'Total de livros: $totalLivros\n'
				'Total de exemplares: $totalExemplares\n'
				'Exemplares disponíveis: $exemplaresDisponiveis\n'
				'Exemplares emprestados: ${totalExemplares - exemplaresDisponiveis}';
	}

	String gerarRelatorioEmprestimos({DateTime? dataReferencia}) {
		final referencia = dataReferencia ?? DateTime.now();
		final totalEmprestimos = emprestimoService.emprestimos.length;
		final emprestimosAtivos = emprestimoService.emprestimos
				.where((emprestimo) => emprestimo.dataDevolucao == null)
				.length;
		final emprestimosAtrasados = emprestimoService.emprestimos.where((emprestimo) {
			return emprestimo.dataDevolucao == null &&
					emprestimo.dataPrevistaDevolucao.isBefore(referencia);
		}).length;

		return 'Relatório de empréstimos\n'
				'Total de empréstimos: $totalEmprestimos\n'
				'Empréstimos ativos: $emprestimosAtivos\n'
				'Empréstimos atrasados: $emprestimosAtrasados\n'
				'Empréstimos devolvidos: ${totalEmprestimos - emprestimosAtivos}';
	}

	String gerarRelatorioReservas() {
		final totalReservas = reservaService.reservas.length;

		return 'Relatório de reservas\n'
				'Total de reservas: $totalReservas';
	}

	String gerarResumo({DateTime? dataReferencia}) {
		return '${gerarRelatorioLivros()}\n\n'
				'${gerarRelatorioEmprestimos(dataReferencia: dataReferencia)}\n\n'
				'${gerarRelatorioReservas()}';
	}

	void imprimirRelatorioLivros() {
		print(gerarRelatorioLivros());
	}

	void imprimirRelatorioEmprestimos({DateTime? dataReferencia}) {
		print(gerarRelatorioEmprestimos(dataReferencia: dataReferencia));
	}

	void imprimirRelatorioReservas() {
		print(gerarRelatorioReservas());
	}

	void imprimirResumo({DateTime? dataReferencia}) {
		print(gerarResumo(dataReferencia: dataReferencia));
	}
}
