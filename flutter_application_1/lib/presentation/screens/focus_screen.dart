import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/models/subtask_model.dart';
import '../../domain/models/task_model.dart';

class FocusScreen extends StatefulWidget {
  final List<TaskModel> pendingTasks;
  final Future<void> Function(TaskModel task) onToggleTask;

  const FocusScreen({
    super.key,
    required this.pendingTasks,
    required this.onToggleTask,
  });

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  static const _focusBackground = Color(0xFF1A1A2E);

  late List<TaskModel> _pending;
  int _currentIndex = 0;
  int _slideKey = 0;

  @override
  void initState() {
    super.initState();
    _pending = List.from(widget.pendingTasks);
  }

  TaskModel? get _currentTask =>
      _pending.isEmpty || _currentIndex >= _pending.length
          ? null
          : _pending[_currentIndex];

  int get _total => widget.pendingTasks.length;

  Future<void> _completeAndAdvance() async {
    final task = _currentTask;
    if (task == null) return;

    await widget.onToggleTask(task);
    HapticFeedback.mediumImpact();

    if (!mounted) return;

    setState(() {
      _pending.removeAt(_currentIndex);
      if (_currentIndex >= _pending.length && _pending.isNotEmpty) {
        _currentIndex = 0;
      }
      _slideKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final task = _currentTask;

    return Scaffold(
      backgroundColor: _focusBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white70),
                    tooltip: 'Sair do Foco',
                  ),
                  const Spacer(),
                  if (_pending.isNotEmpty)
                    Text(
                      'Tarefa ${_currentIndex + 1} de $_total',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              if (_pending.isNotEmpty) ...[
                const SizedBox(height: AppSizes.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / _total,
                    minHeight: 6,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
              ],
              Expanded(
                child: _pending.isEmpty
                    ? _buildCongrats()
                    : _buildTaskFocus(task!, _slideKey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCongrats() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.celebration_rounded, size: 72, color: AppColors.primary),
          const SizedBox(height: AppSizes.lg),
          const Text(
            'Parabéns!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          const Text(
            'Você concluiu todas as tarefas pendentes no Modo Foco.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSizes.xxl),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 48),
            ),
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskFocus(TaskModel task, int slideKey) {
    return Column(
      key: ValueKey(slideKey),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          task.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.3,
          ),
        )
            .animate()
            .fadeIn(duration: 350.ms)
            .slideX(begin: 0.08, end: 0, duration: 350.ms, curve: Curves.easeOutCubic),
        if (task.hasSubtasks) ...[
          const SizedBox(height: AppSizes.xl),
          ...task.subtasks.map(_buildSubtaskRow),
        ],
        const SizedBox(height: AppSizes.xxl),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _completeAndAdvance,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
            ),
            child: const Text(
              'Concluir e avançar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubtaskRow(SubtaskModel sub) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            sub.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: sub.isCompleted ? AppColors.primary : Colors.white38,
            size: 20,
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              sub.title,
              style: TextStyle(
                fontSize: 15,
                color: sub.isCompleted ? Colors.white54 : Colors.white,
                decoration: sub.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
