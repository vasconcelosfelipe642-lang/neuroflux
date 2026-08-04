import 'package:flutter/material.dart';

import 'new_task_modal_state.dart';

/// Callback que entrega ao caller o título, descrição e lista de
/// títulos de subtarefas. O caller (TasksScreen) é quem chama a API
/// na sequência correta: cria tarefa → pega id → cria subtarefas.
typedef OnAddTask = Future<void> Function({
  required String title,
  String? description,
  required bool isDaily,
  required List<String> subtaskTitles,
});

class NewTaskModal extends StatefulWidget {
  final OnAddTask onAddTask;

  const NewTaskModal({super.key, required this.onAddTask});

  static Future<void> show(BuildContext context, {required OnAddTask onAddTask}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NewTaskModal(onAddTask: onAddTask),
    );
  }

  @override
  State<NewTaskModal> createState() => NewTaskModalState();
}
