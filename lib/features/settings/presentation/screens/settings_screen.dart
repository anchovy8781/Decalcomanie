import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_strings.dart';

/// Theme mode preference stored in memory; in a production app this would
/// be persisted to SharedPreferences or Firestore user settings.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
        leading: IconButton(
          onPressed: context.pop,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: ListView(
        children: [
          const _SectionHeader(title: '표시'),
          SwitchListTile(
            title: const Text(AppStrings.darkMode),
            secondary: const Icon(Icons.dark_mode_outlined),
            value: themeMode == ThemeMode.dark,
            onChanged: (isDark) {
              ref.read(themeModeProvider.notifier).state =
                  isDark ? ThemeMode.dark : ThemeMode.light;
            },
          ),
          const Divider(),
          const _SectionHeader(title: '정보'),
          const ListTile(
            leading: Icon(Icons.info_outline_rounded),
            title: Text(AppStrings.appVersion),
            trailing: Text('1.0.0', style: TextStyle(color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('개인정보 처리방침'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              // Will link to privacy policy page in a future update
            },
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('서비스 이용약관'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              // Will link to terms of service in a future update
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
