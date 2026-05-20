import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/theme_scope.dart';
import 'pomodoro_timer.dart';
import 'timer_ring_painter.dart';

class PomodoroTimerSheetState extends State<PomodoroTimerSheet>
    with SingleTickerProviderStateMixin {
  static const _durations = [10, 15, 25];

  late AnimationController _ringController;
  Timer? _timer;
  int _selectedMinutes = 25;
  int _remainingSeconds = 25 * 60;
  bool _isRunning = false;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _ringController.value = 1;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ringController.dispose();
    super.dispose();
  }

  bool get _canChangeDuration => !_isRunning && !_finished;

  void _resetDuration() {
    _remainingSeconds = _selectedMinutes * 60;
    _ringController.value = 1;
    _finished = false;
  }

  void _selectMinutes(int minutes) {
    if (!_canChangeDuration) return;
    setState(() {
      _selectedMinutes = minutes;
      _resetDuration();
    });
  }

  void _start() {
    if (_finished) _resetDuration();
    _timer?.cancel();
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _resetDuration();
    });
  }

  void _tick(Timer timer) {
    if (_remainingSeconds <= 1) {
      timer.cancel();
      setState(() {
        _remainingSeconds = 0;
        _isRunning = false;
        _finished = true;
      });
      _ringController.animateTo(0, duration: const Duration(milliseconds: 300));
      HapticFeedback.heavyImpact();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tempo esgotado! Faça uma pausa de 5 minutos.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    setState(() => _remainingSeconds--);
    final total = _selectedMinutes * 60;
    _ringController.value = _remainingSeconds / total;
  }

  String get _timeLabel {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    ThemeScope.watch(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSizes.xl,
        AppSizes.lg,
        AppSizes.xl,
        AppSizes.xxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          Text(
            'Foco: ${widget.taskTitle}',
            style: AppTextStyles.sectionTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSizes.xl),
          SizedBox(
            width: 200,
            height: 200,
            child: AnimatedBuilder(
              animation: _ringController,
              builder: (context, child) {
                return CustomPaint(
                  painter: TimerRingPainter(progress: _ringController.value),
                  child: Center(
                    child: Text(
                      _timeLabel,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _durations.map((m) {
              final selected = _selectedMinutes == m;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: Text('$m min'),
                  selected: selected,
                  onSelected: _canChangeDuration ? (_) => _selectMinutes(m) : null,
                  selectedColor: AppColors.primaryLightTint,
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: selected ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide(color: AppColors.border),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSizes.lg),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _isRunning ? _pause : _start,
                  child: Text(_isRunning ? 'Pausar' : 'Iniciar'),
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: OutlinedButton(
                  onPressed: _reset,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                  ),
                  child: const Text('Resetar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
