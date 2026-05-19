import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';

/// Callback que entrega ao caller o título, descrição e lista de
/// títulos de subtarefas. O caller (TasksScreen) é quem chama a API
/// na sequência correta: cria tarefa → pega id → cria subtarefas.
typedef OnAddTask = Future<void> Function({
  required String title,
  String? description,
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
  State<NewTaskModal> createState() => _NewTaskModalState();
}

class _NewTaskModalState extends State<NewTaskModal> {
  final _taskController = TextEditingController();
  final _subtaskController = TextEditingController();
  final _taskFocus = FocusNode();

  /// Títulos das subtarefas adicionadas localmente antes de salvar
  final _subtaskTitles = <String>[];
  bool _isSaving = false;

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
      _subtaskTitles.add(text);
      _subtaskController.clear();
    });
  }

  void _removeSubtask(int index) {
    setState(() => _subtaskTitles.removeAt(index));
  }

  Future<void> _submit() async {
    final title = _taskController.text.trim();
    if (title.isEmpty) return;

    setState(() => _isSaving = true);
    try {
      await widget.onAddTask(
        title: title,
        description: null,
        subtaskTitles: List.from(_subtaskTitles),
      );
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  bool get _canSubmit => _taskController.text.trim().isNotEmpty && !_isSaving;

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
        AppSizes.xl, AppSizes.xl, AppSizes.xl, AppSizes.xl + bottomInset,
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
          if (_subtaskTitles.isNotEmpty) ...[
            const SizedBox(height: AppSizes.md),
            _SubtaskList(
              titles: _subtaskTitles,
              onRemove: _removeSubtask,
            ),
          ],
          const SizedBox(height: AppSizes.xxl),
          ElevatedButton(
            onPressed: _canSubmit ? _submit : null,
            child: _isSaving
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : const Text(AppStrings.addTask),
          ),
        ],
      ),
    );
  }
}

// ── Subwidgets ───────────────────────────────────────────────

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
          decoration: const InputDecoration(hintText: AppStrings.taskFieldHint),
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
        TextField(
          controller: controller,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: AppStrings.subtaskFieldHint,
            suffixIcon: IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
            ),
          ),
          onSubmitted: (_) => onAdd(),
        ),
      ],
    );
  }
}

/// Lista das subtarefas adicionadas — com botão de remover
class _SubtaskList extends StatelessWidget {
  final List<String> titles;
  final ValueChanged<int> onRemove;

  const _SubtaskList({required this.titles, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: titles.asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.xs),
          child: Row(
            children: [
              const Icon(Icons.drag_handle, size: 16, color: AppColors.textHint),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  entry.value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => onRemove(entry.key),
                child: const Icon(Icons.close, size: 16, color: AppColors.textHint),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}