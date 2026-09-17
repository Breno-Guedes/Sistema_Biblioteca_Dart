import 'dart:convert';
import 'dart:io';

class StorageService {
  static Future<void> salvarDados(String caminho, List<dynamic> lista) async {
    final file = File(caminho);
    await file.parent.create(recursive: true);
    final jsonList = lista.map((item) => item.toJson()).toList();
    final jsonString = const JsonEncoder.withIndent('  ').convert(jsonList);
    await file.writeAsString(jsonString);
  }

  static Future<List<dynamic>> lerDoTexto(String caminho) async {
    final file = File(caminho);
    if (!await file.exists()) {
      return [];
    }
    final jsonString = await file.readAsString();
    if (jsonString.trim().isEmpty) {
      return [];
    }
    final dados = jsonDecode(jsonString);
    if (dados is! List) {
      throw const FormatException('O arquivo JSON deve conter uma lista.');
    }
    return dados;
  }

  static Future<List<T>> carregarDados<T>(
    String caminho,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    final dados = await lerDoTexto(caminho);
    return dados.map((item) => fromJson(Map<String, dynamic>.from(item))).toList();
  }
}
