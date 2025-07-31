import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/core/ui/spacing/spacing.dart';

class PrimarySnackBar extends SnackBar {
  PrimarySnackBar({
    required String text,
    void Function()? onTap,
    super.key,
  }) : super(
          content: PrimarySnackBarContent(
            text: text,
            onTap: onTap,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          duration: 5.seconds,
        );
}

class PrimarySnackBarContent extends StatelessWidget {
  const PrimarySnackBarContent({
    required this.text,
    super.key,
    this.onTap,
  });

  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final colorsProvider = context.colors;
    final textStylesProvider = context.textStyles;

    final bgColor = colorsProvider.primary;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 4.space,
          vertical: 4.space,
        ),
        child: Container(
          padding: EdgeInsets.only(
            left: 4.space,
            right: 4.space,
            top: 4.space,
            bottom: 4.space,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(
              1.space,
            ),
            boxShadow: [
              BoxShadow(
                color: colorsProvider.shadow.withValues(alpha: 0.3),
                spreadRadius: 0.25.space,
                blurRadius: 1.space,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: textStylesProvider.bodySmall.copyWith(
                    color: colorsProvider.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
