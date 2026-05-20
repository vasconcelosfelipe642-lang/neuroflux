import 'dart:io';

import '../../core/errors/app_exception.dart';
import '../../domain/models/admin_stats_model.dart';
import '../../domain/models/user_task_stats_model.dart';
import '../../domain/models/task_model.dart';
import '../../domain/models/user_model.dart';
import 'api_client.dart';
import 'tarefa_service.dart';
import 'token_storage_service.dart';

/// Operações do painel administrativo usando endpoints existentes.
class AdminService {
  AdminService._();
  static final instance = AdminService._();

  final _client = ApiClient.instance;
  final _tarefaService = TarefaService.instance;

  Future<List<UserModel>> listarUsuarios() async {
    try {
      final list = await _client.getList('/usuarios');
      return list
          .map((j) => UserModel.fromJson(j as Map<String, dynamic>))
          .toList();
    } on SocketException {
      throw AppException.network();
    }
  }

  Future<UserModel> buscarUsuario(String id) async {
    try {
      final json = await _client.get('/usuarios/$id');
      return UserModel.fromJson(json);
    } on SocketException {
      throw AppException.network();
    }
  }

  Future<List<TaskModel>> listarTodasTarefas() => _tarefaService.listar();

  Future<List<UserModel>> listarBanidos() => TokenStorageService.getBannedUsers();

  Future<AdminStatsModel> buscarEstatisticas() async {
    final users = await listarUsuarios();
    final tasks = await listarTodasTarefas();
    final banned = await listarBanidos();
    final registeredUsers =
        users.where((u) => u.role != 'admin').length;
    return AdminStatsModel(
      totalUsers: registeredUsers,
      totalTasks: tasks.length,
      completedTasks: tasks.where((t) => t.isCompleted).length,
      bannedUsers: banned.length,
    );
  }

  List<TaskModel> tarefasDoUsuario(List<TaskModel> all, String userId) =>
      all.where((t) => t.usuarioId == userId).toList();

  UserTaskStatsModel statsDoUsuario(List<TaskModel> tasks) {
    final created = tasks.length;
    final completed = tasks.where((t) => t.isCompleted).length;
    return UserTaskStatsModel(created: created, completed: completed);
  }

  /// Promove usuário comum a administrador via PUT existente.
  Future<UserModel> promoverParaAdmin(UserModel user) async {
    try {
      await _client.put('/usuarios/${user.id}', {'role': 'admin'});
      return UserModel(
        id: user.id,
        nome: user.nome,
        email: user.email,
        role: 'admin',
      );
    } on SocketException {
      throw AppException.network();
    }
  }

  /// Banir = DELETE /usuarios/:id (admin) + cache local para UI de banidos.
  Future<void> banirUsuario(UserModel user) async {
    try {
      await _client.delete('/usuarios/${user.id}');
      await TokenStorageService.addBannedUser(user);
    } on SocketException {
      throw AppException.network();
    }
  }
}
