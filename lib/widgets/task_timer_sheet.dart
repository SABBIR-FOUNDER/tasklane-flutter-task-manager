import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/task_model.dart';
import '../providers/task_timer_provider.dart';


Future<void> showTaskTimerSheet(
  BuildContext context,
  TaskModel task,
) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _TaskTimerSheet(task: task),
  );
}


class _TaskTimerSheet extends StatefulWidget {
  final TaskModel task;

  const _TaskTimerSheet({
    required this.task,
  });

  @override
  State<_TaskTimerSheet> createState() => _TaskTimerSheetState();
}


class _TaskTimerSheetState extends State<_TaskTimerSheet> {
  static const int _maximumHours = 99;

  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();

  bool _showCustomDuration = false;
  bool _isStarting = false;
  String? _validationMessage;

  @override
  void dispose() {
    _hoursController.dispose();
    _minutesController.dispose();
    super.dispose();
  }

  int get _enteredHours =>
      int.tryParse(_hoursController.text.trim()) ?? 0;

  int get _enteredMinutes =>
      int.tryParse(_minutesController.text.trim()) ?? 0;

  int get _customDurationSeconds =>
      ((_enteredHours * 60) + _enteredMinutes) * 60;

  String get _customDurationLabel {
    final hours = _enteredHours;
    final minutes = _enteredMinutes;

    if (hours == 0 && minutes == 0) {
      return 'Enter a duration';
    }

    if (hours > 0 && minutes > 0) {
      return '$hours ${hours == 1 ? 'hour' : 'hours'} '
          '$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    }

    if (hours > 0) {
      return '$hours ${hours == 1 ? 'hour' : 'hours'}';
    }

    return '$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
  }

  Future<void> _startTimerWithSeconds(int durationSeconds) async {
    if (_isStarting || durationSeconds <= 0) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isStarting = true;
      _validationMessage = null;
    });

    try {
      await context.read<TaskTimerProvider>().startTimer(
            taskId: widget.task.id,
            taskTitle: widget.task.title,
            durationSeconds: durationSeconds,
          );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isStarting = false;
      });

      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(
          content: Text('Unable to start the timer. Please try again.'),
        ),
      );
    }
  }

  Future<void> _startCustomTimer() async {
    final hours = _enteredHours;
    final minutes = _enteredMinutes;

    if (hours < 0 || hours > _maximumHours) {
      setState(() {
        _validationMessage = 'Hours must be between 0 and $_maximumHours.';
      });
      return;
    }

    if (minutes < 0 || minutes > 59) {
      setState(() {
        _validationMessage = 'Minutes must be between 0 and 59.';
      });
      return;
    }

    if (hours == 0 && minutes == 0) {
      setState(() {
        _validationMessage = 'Enter at least 1 minute.';
      });
      return;
    }

    await _startTimerWithSeconds(_customDurationSeconds);
  }

  void _toggleCustomDuration() {
    FocusScope.of(context).unfocus();

    setState(() {
      _showCustomDuration = !_showCustomDuration;
      _validationMessage = null;
    });
  }

  void _handleCustomValueChanged(String _) {
    setState(() {
      _validationMessage = null;
    });
  }

  Future<void> _pauseTimer() async {
    await context.read<TaskTimerProvider>().pauseTimer();
  }

  Future<void> _resumeTimer() async {
    await context.read<TaskTimerProvider>().resumeTimer();
  }

  Future<void> _stopTimer() async {
    await context.read<TaskTimerProvider>().stopTimer();

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Material(
          color: colorScheme.surface,
          clipBehavior: Clip.antiAlias,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.88,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Consumer<TaskTimerProvider>(
                builder: (context, provider, child) {
                  final hasTimerForTask =
                      provider.isTimerForTask(widget.task.id);

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SheetHandle(colorScheme: colorScheme),
                      const SizedBox(height: 14),
                      _SheetHeader(
                        title: hasTimerForTask
                            ? 'Focus timer'
                            : 'Start focus timer',
                        taskTitle: widget.task.title,
                        onClose: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(height: 22),
                      if (hasTimerForTask)
                        _ActiveTimerControls(
                          displayTime: provider.displayForTask(widget.task.id),
                          isRunning: provider.isRunning,
                          onPause: _pauseTimer,
                          onResume: _resumeTimer,
                          onStop: _stopTimer,
                        )
                      else
                        _buildDurationPicker(context),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDurationPicker(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick select',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            _TimerPreset(label: '15 min', minutes: 15),
            _TimerPreset(label: '25 min', minutes: 25),
            _TimerPreset(label: '45 min', minutes: 45),
            _TimerPreset(label: '1 hour', minutes: 60),
            _TimerPreset(label: '2 hours', minutes: 120),
            _TimerPreset(label: '4 hours', minutes: 240),
          ].map((preset) {
            return _PresetButton(
              label: preset.label,
              onPressed: _isStarting
                  ? null
                  : () => _startTimerWithSeconds(preset.minutes * 60),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _isStarting ? null : _toggleCustomDuration,
            icon: Icon(
              _showCustomDuration
                  ? Icons.keyboard_arrow_up
                  : Icons.timer_outlined,
            ),
            label: Text(
              _showCustomDuration
                  ? 'Hide custom duration'
                  : 'Set custom duration',
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: _showCustomDuration
              ? Padding(
                  key: const ValueKey('custom-duration'),
                  padding: const EdgeInsets.only(top: 18),
                  child: _buildCustomDurationFields(context),
                )
              : const SizedBox.shrink(
                  key: ValueKey('custom-duration-hidden'),
                ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: _isStarting
                ? null
                : () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomDurationFields(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.45),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Custom duration',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DurationField(
                  controller: _hoursController,
                  label: 'Hours',
                  hintText: '0',
                  maxLength: 2,
                  onChanged: _handleCustomValueChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DurationField(
                  controller: _minutesController,
                  label: 'Minutes',
                  hintText: '0',
                  maxLength: 2,
                  onChanged: _handleCustomValueChanged,
                  onSubmitted: (_) => _startCustomTimer(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 18,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Duration: $_customDurationLabel',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          if (_validationMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _validationMessage!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _isStarting ? null : _startCustomTimer,
              icon: _isStarting
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow_rounded),
              label: Text(_isStarting ? 'Starting...' : 'Start timer'),
            ),
          ),
        ],
      ),
    );
  }
}


class _TimerPreset {
  final String label;
  final int minutes;

  const _TimerPreset({
    required this.label,
    required this.minutes,
  });
}


class _PresetButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _PresetButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 50) / 2,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}


class _DurationField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;

  const _DurationField({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.maxLength,
    required this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textInputAction:
          onSubmitted == null ? TextInputAction.next : TextInputAction.done,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxLength),
      ],
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        counterText: '',
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}


class _SheetHandle extends StatelessWidget {
  final ColorScheme colorScheme;

  const _SheetHandle({
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 44,
        height: 4,
        decoration: BoxDecoration(
          color: Theme.of(context).dividerColor,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}


class _SheetHeader extends StatelessWidget {
  final String title;
  final String taskTitle;
  final VoidCallback onClose;

  const _SheetHeader({
    required this.title,
    required this.taskTitle,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                taskTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Close',
          onPressed: onClose,
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}


class _ActiveTimerControls extends StatelessWidget {
  final String displayTime;
  final bool isRunning;
  final Future<void> Function() onPause;
  final Future<void> Function() onResume;
  final Future<void> Function() onStop;

  const _ActiveTimerControls({
    required this.displayTime,
    required this.isRunning,
    required this.onPause,
    required this.onResume,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withOpacity(0.55),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                isRunning ? 'Timer running' : 'Timer paused',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  displayTime,
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: isRunning ? onPause : onResume,
            icon: Icon(
              isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
            ),
            label: Text(isRunning ? 'Pause timer' : 'Resume timer'),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onStop,
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.error,
              side: BorderSide(color: colorScheme.error),
            ),
            icon: const Icon(Icons.stop_rounded),
            label: const Text('Stop timer'),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ),
      ],
    );
  }
}
