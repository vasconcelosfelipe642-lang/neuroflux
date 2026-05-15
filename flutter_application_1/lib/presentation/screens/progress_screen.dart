import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/errors/app_exception.dart';
import '../../data/services/tarefa_service.dart';
import '../../domain/models/task_model.dart';
import '../../domain/models/user_model.dart';
import '../widgets/app_header.dart';
import '../widgets/progress_big_card.dart';

class ProgressScreen extends StatefulWidget {
  final UserModel user;
  const ProgressScreen({super.key, required this.user});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final _tarefaService = TarefaService.instance;
  List<TaskModel> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _tarefaService.addListener(_loadTasks);
  }

  @override
  void dispose() {
    _tarefaService.removeListener(_loadTasks);
    super.dispose();
  }

  Future<void> _loadTasks() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final tasks = await _tarefaService.listar();
      if (mounted) {
        setState(() {
          _tasks = tasks;
          _isLoading = false;
        });
      }
    } on AppException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message), behavior: SnackBarBehavior.floating));
      }
    }
  }

  void _handleLogout() {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final int completedCount = _tasks.where((t) => t.isCompleted).length;
    final int pendingCount = _tasks.where((t) => !t.isCompleted).length;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              user: widget.user,
              onLogout: _handleLogout,
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    )
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: _loadTasks,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(AppSizes.pagePadding),
                        child: Column(
                          children: [
                            ProgressBigCard(
                              completedTasks: completedCount,
                              totalTasks: _tasks.length,
                            ),
                            const SizedBox(height: AppSizes.md),
                            Row(
                              children: [
                                Expanded(
                                  child: StatCard(
                                    icon: Icons.trending_up_rounded,
                                    count: completedCount,
                                    label: AppStrings.tasksComplete,
                                  ),
                                ),
                                const SizedBox(width: AppSizes.md),
                                Expanded(
                                  child: StatCard(
                                    icon: Icons.calendar_today_outlined,
                                    count: pendingCount,
                                    label: AppStrings.tasksPending,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}