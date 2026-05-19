import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../domain/models/task_model.dart';
import '../../core/errors/app_exception.dart';
import 'api_client.dart';

/// Todas as operações de Tarefa com a API.
class TarefaService extends ChangeNotifier {
  TarefaService._();
  static final instance = TarefaService._();

  final _client = ApiClient.instance;

  void notifyTasksChanged() {
    notifyListeners();
  }

  /// GET /tarefas → retorna tarefas do usuário autenticado com subtarefas
  Future<List<TaskModel>> listar() async {
    try {
      final list = await _client.getList('/tarefas');
      return list
          .map((j) => TaskModel.fromJson(j as Map<String, dynamic>))
          .toList();
    } on SocketException {
      throw AppException.network();
    }
  }

  /// POST /tarefas → { titulo, descricao } → retorna TaskModel criado
  Future<TaskModel> criar({
    required String titulo,
    String? descricao,
  }) async {
    try {
      final json = await _client.post('/tarefas', {
        'titulo': titulo,
        if (descricao != null && descricao.isNotEmpty) 'descricao': descricao,
      });
      final task = TaskModel.fromJson(json);
      notifyListeners();
      return task;
    } on SocketException {
      throw AppException.network();
    }
  }

  /// PUT /tarefas/:id → { titulo, descricao, concluida }
  Future<TaskModel> atualizar(TaskModel tarefa) async {
    try {
      final json = await _client.put(
        '/tarefas/${tarefa.id}',
        tarefa.toUpdateJson(),
      );
      final task = TaskModel.fromJson(json);
      notifyListeners();
      return task;
    } on SocketException {
      throw AppException.network();
    }
  }

  /// PUT /tarefas/:id → apenas alterna o campo concluida
  Future<TaskModel> alternarConcluida(TaskModel tarefa) async {
    return atualizar(tarefa.copyWith(isCompleted: !tarefa.isCompleted));
  }

  /// DELETE /tarefas/:id
  Future<void> deletar(String id) async {
    try {
      await _client.delete('/tarefas/$id');
      notifyListeners();
    } on SocketException {
      throw AppException.network();
    }
  }
}