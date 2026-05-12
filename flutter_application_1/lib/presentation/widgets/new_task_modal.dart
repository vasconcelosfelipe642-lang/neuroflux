import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../domain/models/subtask_model.dart';

/// Callback chamado quando o usuário confirma a criação da tarefa.
/// O backend da equipe irá implementar a lógica de persistência.
typedef OnAddTask = void Function({
  required String title,
  required List<SubtaskModel> subtasks,
});

class NewTaskModal extends StatefulWidget {
  final OnAddTask onAddTask;

  const NewTaskModal({super.key, required this.onAddTask});

  /// Abre o modal como bottom sheet.
  static Future<void> show(BuildContext context, {required OnAddTask onAddTask}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NewTaskModal(onAddTask: onAddTask),
    );
  }

  @override
  State<NewTaskModal> createState() => _NewTaskModalState();
}

class _NewTaskModalState extends State<NewTaskModal> {
  final _taskController = TextEditingController();
  final _subtaskController = TextEditingController();
  final _taskFocus = FocusNode();
  final _subtasks = <SubtaskModel>[];

  @override
  void dispose() {
    _taskController.dispose();
    _subtaskController.dispose();
    _taskFocus.dispose();
    super.dispose();
  }

  void _addSubtask() {
    final text = _subtaskController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _subtasks.add(SubtaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: text,
      ));
      _subtaskController.clear();
    });
  }

  void _submit() {
    final title = _taskController.text.trim();
    if (title.isEmpty) return;
    widget.onAddTask(title: title, subtasks: List.unmodifiable(_subtasks));
    Navigator.of(context).pop();
  }

  bool get _canSubmit => _taskController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXl),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSizes.xl,
        AppSizes.xl,
        AppSizes.xl,
        AppSizes.xl + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ModalHeader(onClose: () => Navigator.of(context).pop()),
          const SizedBox(height: AppSizes.xl),
          _TaskField(
            controller: _taskController,
            focusNode: _taskFocus,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSizes.lg),
          _SubtaskField(
            controller: _subtaskController,
            onAdd: _addSubtask,
          ),
          if (_subtasks.isNotEmpty) ...[
            const SizedBox(height: AppSizes.md),
            _SubtaskChips(subtasks: _subtasks),
          ],
          const SizedBox(height: AppSizes.xxl),
          ElevatedButton(
            onPressed: _canSubmit ? _submit : null,
            child: Text(AppStrings.addTask, style: AppTextStyles.fabLabel),
          ),
        ],
      ),
    );
  }
}

class _ModalHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _ModalHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(AppStrings.modalTitle, style: AppTextStyles.modalTitle),
        IconButton(
          onPressed: onClose,
          icon: const Icon(Icons.close, size: AppSizes.iconMd),
          color: AppColors.textSecondary,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

class _TaskField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;

  const _TaskField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.taskFieldLabel, style: AppTextStyles.fieldLabel),
        const SizedBox(height: AppSizes.sm),
        TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: AppStrings.taskFieldHint,
          ),
        ),
      ],
    );
  }
}

class _SubtaskField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;

  const _SubtaskField({required this.controller, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.subtaskFieldLabel, style: AppTextStyles.fieldLabel),
        const SizedBox(height: AppSizes.sm),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: AppStrings.subtaskFieldHint,
                ),
                onSubmitted: (_) => onAdd(),
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            _AddSubtaskButton(onPressed: onAdd),
          ],
        ),
      ],
    );
  }
}

class _AddSubtaskButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddSubtaskButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.border, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.md,
        ),
      ),
      child: Text(AppStrings.addSubtask, style: AppTextStyles.fieldLabel),
    );
  }
}

class _SubtaskChips extends StatelessWidget {
  final List<SubtaskModel> subtasks;

  const _SubtaskChips({required this.subtasks});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.sm,
      runSpacing: AppSizes.sm,
      children: subtasks
          .map((s) => Chip(
                label: Text(s.title, style: const TextStyle(fontSize: 12)),
                backgroundColor: AppColors.primaryLight,
                labelStyle: const TextStyle(color: AppColors.primary),
                side: BorderSide.none,
              ))
          .toList(),
    );
  }
}
