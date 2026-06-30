import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';

/// Placeholder shown in the Upload tab until the upload feature is implemented.
class UploadPlaceholderScreen extends StatelessWidget {
  const UploadPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.upload)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.video_call_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.uploadComingSoon,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
