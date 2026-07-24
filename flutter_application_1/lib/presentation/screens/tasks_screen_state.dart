import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/errors/app_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_rebuild.dart';
import '../../core/theme/theme_scope.dart';
import '../../core/utils/day_confetti_session.dart';
import '../../core/utils/task_sound_feedback.dart';
import '../../data/services/subtarefa_service.dart';
import '../../data/services/tarefa_service.dart';
import '../../domain/models/subtask_model.dart';
import '../../domain/models/task_model.dart';
import '../widgets/app_header.dart';
import '../widgets/day_progress_card.dart';
import '../widgets/motivational_message.dart';
import '../widgets/new_task_modal.dart';
import '../widgets/shimmer_task_list.dart';
import '../widgets/task_list_empty.dart';
import 'focus_screen.dart';
import 'new_task_button.dart';
import 'task_list.dart';
import 'tasks_screen.dart';
import 'tasks_screen_divider.dart';

class TasksScreenState extends State<TasksScreen> {
  final _tarefaService = TarefaService.instance;
  final _subtarefaService = SubtarefaService.instance;
  late final ConfettiController _confettiController;

  List<TaskModel> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _loadTasks();
    _tarefaService.addListener(_loadTasks);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _tarefaService.removeListener(_loadTasks);
    super.dispose();
  }

  void _onDayCompleted() {
    if (DayConfettiSession.tryShow()) {
      _confettiController.play();
      HapticFeedback.heavyImpact();
    }
  }

  int get _completedCount => _tasks.where((t) => t.isCompleted).length;

  List<TaskModel> get _pendingTasks =>
      _tasks.where((t) => !t.isCompleted).toList();

  Future<void> _loadTasks() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final tasks = await _tarefaService.listar();
      if (mounted) {
        setState(() => _tasks = tasks);
      }
    } on AppException catch (e) {
      _showError(e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _onAddTask({
    required String title,
    String? description,
    required List<String> subtaskTitles,
  }) async {
    try {
      final novaTarefa = await _tarefaService.criar(
        titulo: title,
        descricao: description,
      );

      final subtasks = await Future.wait(
        subtaskTitles.map(
          (titulo) => _subtarefaService.criar(
            titulo: titulo,
            tarefaId: novaTarefa.id,
          ),
        ),
      );

      setState(() {
        _tasks = [novaTarefa.copyWith(subtasks: subtasks), ..._tasks];
      });
      _tarefaService.notifyTasksChanged();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Tarefa adicionada com sucesso!'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on AppException catch (e) {
      _showError(e.message);
    }
  }

  Future<void> _toggleTask(TaskModel task) async {
    if (!task.isCompleted && !task.canComplete) {
      _showError("Conclua todas as subtarefas antes de finalizar a tarefa.");
      return;
    }

    final markingComplete = !task.isCompleted;

    setState(() {
      _tasks = _tasks
          .map((t) =>
              t.id == task.id ? t.copyWith(isCompleted: !t.isCompleted) : t)
          .toList();
    });

    if (markingComplete) {
      HapticFeedback.mediumImpact();
      TaskSoundFeedback.instance.playComplete();
    }

    try {
      final updated = await _tarefaService.alternarConcluida(task);
      setState(() {
        _tasks = _tasks.map((t) => t.id == updated.id ? updated : t).toList();
      });
    } on AppException catch (e) {
      setState(() {
        _tasks = _tasks.map((t) => t.id == task.id ? task : t).toList();
      });
      _showError(e.message);
    }
  }

  Future<void> _toggleSubtask(
      TaskModel parentTask, SubtaskModel subtask) async {
    final markingComplete = !subtask.isCompleted;
    try {
      final updatedSub = await _subtarefaService.alternarConcluida(subtask);

      setState(() {
        _tasks = _tasks.map((t) {
          if (t.id != parentTask.id) return t;

          final newSubs = t.subtasks
              .map((s) => s.id == updatedSub.id ? updatedSub : s)
              .toList();

          final algumaPendente = newSubs.any((s) => !s.isCompleted);
          final deveDesmarcarPai = t.isCompleted && algumaPendente;

          return t.copyWith(
            subtasks: newSubs,
            isCompleted: deveDesmarcarPai ? false : t.isCompleted,
          );
        }).toList();
      });

      final tarefaAtualizada = _tasks.firstWhere((t) => t.id == parentTask.id);
      if (parentTask.isCompleted && !tarefaAtualizada.isCompleted) {
        await _tarefaService.atualizar(tarefaAtualizada);
      }

      _tarefaService.notifyTasksChanged();

      if (markingComplete) {
        HapticFeedback.lightImpact();
      }
    } on AppException catch (e) {
      _showError(e.message);
    }
  }

  Future<void> _deleteTask(TaskModel task) async {
    try {
      await _tarefaService.deletar(task.id);
      setState(() => _tasks.removeWhere((t) => t.id == task.id));
    } on AppException catch (e) {
      _showError(e.message);
    }
  }

  Future<void> _editTaskTitle(TaskModel task) async {
    final controller = TextEditingController(text: task.title);
    final result = await _showStyledDialog(
      title: 'Editar Tarefa',
      hint: 'Novo título da tarefa',
      controller: controller,
      confirmLabel: 'Salvar',
    );

    if (result != null && result.isNotEmpty && result != task.title) {
      try {
        final updated =
            await _tarefaService.atualizar(task.copyWith(title: result));
        setState(() {
          _tasks = _tasks.map((t) => t.id == task.id ? updated : t).toList();
        });
      } on AppException catch (e) {
        _showError(e.message);
      }
    }
  }

  Future<void> _addSubtaskToExisting(TaskModel task) async {
    final controller = TextEditingController();
    final result = await _showStyledDialog(
      title: 'Nova Subtarefa',
      hint: 'Digite a subtarefa',
      controller: controller,
      confirmLabel: 'Adicionar',
    );

    if (result != null && result.isNotEmpty) {
      try {
        final novaSub =
            await _subtarefaService.criar(titulo: result, tarefaId: task.id);

        setState(() {
          _tasks = _tasks.map((t) {
            if (t.id != task.id) return t;

            return t.copyWith(
              subtasks: [...t.subtasks, novaSub],
              isCompleted: false,
            );
          }).toList();
        });

        if (task.isCompleted) {
          final tarefaAtualizada = _tasks.firstWhere((t) => t.id == task.id);
          await _tarefaService.atualizar(tarefaAtualizada);
        }

        _tarefaService.notifyTasksChanged();
      } on AppException catch (e) {
        _showError(e.message);
      }
    }
  }

  Future<void> _editSubtask(TaskModel parentTask, SubtaskModel subtask) async {
    final controller = TextEditingController(text: subtask.title);
    final result = await _showStyledDialog(
      title: 'Editar Subtarefa',
      hint: 'Novo título da subtarefa',
      controller: controller,
      confirmLabel: 'Salvar',
    );

    if (result != null && result.isNotEmpty && result != subtask.title) {
      try {
        final updatedSub =
            await _subtarefaService.atualizar(subtask.copyWith(title: result));
        setState(() {
          _tasks = _tasks.map((t) {
            if (t.id == parentTask.id) {
              final newSubs = t.subtasks
                  .map((s) => s.id == subtask.id ? updatedSub : s)
                  .toList();
              return t.copyWith(subtasks: newSubs);
            }
            return t;
          }).toList();
        });
      } on AppException catch (e) {
        _showError(e.message);
      }
    }
  }

  Future<String?> _showStyledDialog({
    required String title,
    required String hint,
    required TextEditingController controller,
    required String confirmLabel,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
        title: Text(title, style: AppTextStyles.modalTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: hint),
        ),
        actionsPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.lg, vertical: AppSizes.md),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCELAR',
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ),
          const SizedBox(width: AppSizes.sm),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(110, 44),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
            ),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  void _openNewTaskModal() {
    HapticFeedback.lightImpact();
    NewTaskModal.show(
      context,
      onAddTask: ({
        required String title,
        String? description,
        required List<String> subtaskTitles,
      }) =>
          _onAddTask(
        title: title,
        description: description,
        subtaskTitles: subtaskTitles,
      ),
    );
  }

  void _openFocusMode() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FocusScreen(
          pendingTasks: _pendingTasks,
          onToggleTask: _toggleTask,
          onToggleSubtask: (task, sub) async {
            await _toggleSubtask(task, sub);
            return _tasks.firstWhere((t) => t.id == task.id);
          },
        ),
      ),
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);

    return ThemeRebuild(
      builder: (context) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppHeader(
                      user: widget.user,
                      onLogout: widget.onLogout,
                      showFocusButton: _pendingTasks.isNotEmpty,
                      onOpenFocus: _openFocusMode,
                    ),
                    const TasksScreenDivider(),
                    Expanded(
                      child: _isLoading
                          ? const SingleChildScrollView(
                              padding: EdgeInsets.all(AppSizes.pagePadding),
                              child: ShimmerTaskList(),
                            )
                          : RefreshIndicator(
                              color: AppColors.primary,
                              onRefresh: _loadTasks,
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.all(AppSizes.pagePadding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DayProgressCard(
                                      completedTasks: _completedCount,
                                      totalTasks: _tasks.length,
                                      onDayCompleted: _onDayCompleted,
                                    ),
                                    const SizedBox(height: AppSizes.md),
                                    MotivationalMessage(
                                      completedTasks: _completedCount,
                                      totalTasks: _tasks.length,
                                    ),
                                    const SizedBox(height: AppSizes.lg),
                                    Text(AppStrings.today,
                                        style: AppTextStyles.sectionTitle),
                                    const SizedBox(height: AppSizes.md),
                                    _tasks.isEmpty
                                        ? TaskListEmpty(
                                            onCreateTask: _openNewTaskModal)
                                        : TaskList(
                                            tasks: _tasks,
                                            onToggle: _toggleTask,
                                            onToggleSubtask: _toggleSubtask,
                                            onEdit: _editTaskTitle,
                                            onEditSubtask: _editSubtask,
                                            onAddSubtask: _addSubtaskToExisting,
                                            onDelete: _deleteTask,
                                          ),
                                    const SizedBox(height: AppSizes.xl),
                                    NewTaskButton(onPressed: _openNewTaskModal),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              IgnorePointer(
                child: Align(
                  alignment: Alignment.center,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    numberOfParticles: 32,
                    maxBlastForce: 22,
                    minBlastForce: 8,
                    gravity: 0.1,
                    colors: const [
                      Color.fromARGB(255, 255, 143, 95),
                      Color.fromARGB(255, 255, 143, 95),
                      Colors.white,
                    ],
                    createParticlePath: (_) => Path()
                      ..addOval(
                          Rect.fromCircle(center: Offset.zero, radius: 4)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
