import 'dart:io';
import '../../domain/models/subtask_model.dart';
import '../../core/errors/app_exception.dart';
import 'api_client.dart';

/// Todas as operações de Subtarefa com a API.
///

class SubtarefaService {
  SubtarefaService._();
  static final instance = SubtarefaService._();

  final _client = ApiClient.instance;

  /// POST /subtarefas → { titulo, tarefaId }
  /// Chamado APÓS a tarefa ser criada, passando o id retornado pela API.
  Future<SubtaskModel> criar({
    required String titulo,
    required String tarefaId, // id da tarefa já persistida no banco
  }) async {
    try {
      final json = await _client.post('/subtarefas', {
        'titulo': titulo,
        'tarefaId': int.parse(tarefaId), // backend espera INTEGER
      });
      return SubtaskModel.fromJson(json);
    } on SocketException {
      throw AppException.network();
    }
  }

  /// PUT /subtarefas/:id → { titulo, concluida }
  Future<SubtaskModel> atualizar(SubtaskModel subtarefa) async {
    try {
      final json = await _client.put(
        '/subtarefas/${subtarefa.id}',
        subtarefa.toJson(),
      );
      return SubtaskModel.fromJson(json);
    } on SocketException {
      throw AppException.network();
    }
  }

  /// PUT /subtarefas/:id → apenas alterna o campo concluida
  Future<SubtaskModel> alternarConcluida(SubtaskModel subtarefa) async {
    return atualizar(subtarefa.copyWith(isCompleted: !subtarefa.isCompleted));
  }

  /// DELETE /subtarefas/:id
  Future<void> deletar(String id) async {
    try {
      await _client.delete('/subtarefas/$id');
    } on SocketException {
      throw AppException.network();
    }
  }
}
