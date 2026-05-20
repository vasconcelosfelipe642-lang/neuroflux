import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_scope.dart';
import 'new_subtask_field.dart';
import 'new_subtask_list.dart';
import 'new_task_field.dart';
import 'new_task_modal.dart';
import 'new_task_modal_header.dart';

class NewTaskModalState extends State<NewTaskModal> {
  final _taskController = TextEditingController();
  final _subtaskController = TextEditingController();
  final _taskFocus = FocusNode();

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
    ThemeScope.watch(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
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
          NewTaskModalHeader(onClose: () => Navigator.of(context).pop()),
          const SizedBox(height: AppSizes.xl),
          NewTaskField(
            controller: _taskController,
            focusNode: _taskFocus,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSizes.lg),
          NewSubtaskField(
            controller: _subtaskController,
            onAdd: _addSubtask,
          ),
          if (_subtaskTitles.isNotEmpty) ...[
            const SizedBox(height: AppSizes.md),
            NewSubtaskList(
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
