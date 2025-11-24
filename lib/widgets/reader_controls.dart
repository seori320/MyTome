import 'package:flutter/material.dart';

import '../models/user_preferences.dart';

class ReaderControls extends StatelessWidget {
  const ReaderControls({
    super.key,
    required this.preferences,
    required this.onChanged,
  });

  final UserPreferences preferences;
  final ValueChanged<UserPreferences> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: 6,
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '읽기 환경 설정',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.text_increase),
                Expanded(
                  child: Slider(
                    value: preferences.fontSize,
                    min: 14,
                    max: 28,
                    divisions: 14,
                    label: preferences.fontSize.toStringAsFixed(0),
                    onChanged: (value) => onChanged(
                      preferences.copyWith(fontSize: value),
                    ),
                  ),
                ),
                Text('${preferences.fontSize.toStringAsFixed(0)}pt'),
              ],
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: preferences.useDarkTheme,
              onChanged: (value) => onChanged(
                preferences.copyWith(useDarkTheme: value),
              ),
              secondary: const Icon(Icons.dark_mode),
              title: const Text('다크 테마'),
              subtitle: const Text('어두운 배경에서 읽기'),
            ),
          ],
        ),
      ),
    );
  }
}
