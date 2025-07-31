import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/core/ui/spacing/spacing.dart';
import 'package:lune/l10n/l10n.dart';
import 'package:lune/ui/public_onboard/notifiers/notifiers.dart';
import 'package:provider/provider.dart';

class PublicOnboardPage extends StatelessWidget {
  const PublicOnboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // final assets = context.assets;
    final l10n = context.l10n;
    final textStyles = context.textStyles;
    final buttonStyles = context.buttonStyles;

    var bottomPadding = context.paddingBottom;
    if (bottomPadding == 0) {
      bottomPadding = 4.space;
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.primary.withValues(alpha: 0.5),
                colors.secondary.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.space),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ClipRRect(
                        //   borderRadius: BorderRadius.circular(4.space),
                        //   child: Image.asset(
                        //     assets.publicOnboardPage1,
                        //     height: 40.space,
                        //   ),
                        // )
                        //     .animate()
                        //     .scale(
                        //       duration: 800.ms,
                        //       curve: Curves.elasticOut,
                        //     )
                        //     .then()
                        //     .shimmer(
                        //       duration: 1200.ms,
                        //       color: colors.primary.withValues(alpha: 0.3),
                        //     ),
                        SizedBox(height: 6.space),
                        Text(
                          l10n.onboard_title,
                          style: textStyles.headlineMedium.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 400.ms)
                            .slideY(begin: 0.3, end: 0),
                        SizedBox(height: 3.space),
                        Text(
                          l10n.onboard_description,
                          textAlign: TextAlign.center,
                          style: textStyles.bodyLarge.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.7),
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 600.ms)
                            .slideY(begin: 0.3, end: 0),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: bottomPadding),
                    child: FilledButton(
                      onPressed: () => _finishOnboard(context),
                      style: buttonStyles.primaryFilled,
                      child: Text(l10n.onboard_start),
                    ),
                  ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.3, end: 0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _finishOnboard(BuildContext context) {
    context.read<PublicOnboardNotifier>().finishOnboard();
  }
}
