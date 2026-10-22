// AppLoader — spinner cha kawaida wakati data inasubiriwa.

import 'package:flutter/material.dart';

import 'package:koobus/core/constants/app_spacing.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key, this.message});

  /// Ujumbe wa hiari chini ya spinner (mfano: "Inapakia safari...").
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.page,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
