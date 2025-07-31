import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/core/ui/spacing/spacing.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final iconProvider = context.icons;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: iconProvider
            .logo(size: 30.space)
            .animate()

            // ── 1. slide-in + fade-in ────────────────────────────────
            .move(
              begin: Offset(0, -h * .2),
              end: Offset.zero,
              curve: Curves.easeOutQuart,
              duration: 800.ms,
            )
            .fadeIn(duration: 800.ms)

            // ── 2. breathing pulse (scale 1 → 1.1 → 1) ──────────────
            .then()
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.1, 1.1),
              duration: 500.ms,
              curve: Curves.easeInOut,
            )
            .then()
            .scale(
              begin: const Offset(1.1, 1.1),
              end: const Offset(1, 1),
              duration: 500.ms,
              curve: Curves.easeInOut,
            )

            // ── 3. slide-out + fade-out ─────────────────────────────
            .then()
            .move(
              begin: Offset.zero,
              end: Offset(0, h * .5),
              curve: Curves.easeInCubic,
              duration: 800.ms,
            )
            .fadeOut(duration: 400.ms),
      ),
    );
  }
}
