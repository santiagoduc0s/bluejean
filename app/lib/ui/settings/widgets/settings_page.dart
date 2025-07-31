import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/core/ui/spacing/spacing.dart';
import 'package:lune/core/ui/widgets/widgets.dart';
import 'package:lune/l10n/l10n.dart';
import 'package:lune/ui/auth/notifiers/notifiers.dart';
import 'package:lune/ui/devices/devices.dart';
import 'package:lune/ui/preference/widgets/widgets.dart';
import 'package:lune/ui/privacy_policy/privacy_policy.dart';
import 'package:lune/ui/settings/settings.dart';
import 'package:lune/ui/support/support.dart';
import 'package:lune/ui/terms_conditions/terms_conditions.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;
    final buttonStyles = context.buttonStyles;

    var paddingTop = context.paddingTop;
    if (paddingTop == 0) {
      paddingTop = 6.space;
    }

    final currentUser = context.watch<AuthNotifier>().currentUser;

    return Scaffold(
      body: Container(
        height: double.infinity,
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
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: paddingTop,
            left: 6.space,
            right: 6.space,
            bottom: 6.space,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settings,
                style: textStyles.headlineLarge.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              )
                  .animate()
                  .slideY(
                    duration: 700.ms,
                    curve: Curves.easeInOut,
                  )
                  .fadeIn(),
              3.spaceY,
              Card(
                elevation: 0,
                color: colors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.space),
                  side: BorderSide(
                    color: colors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(4.space),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.options,
                        style: textStyles.titleMedium.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3.space),
                      const ListLanguages(),
                      SizedBox(height: 3.space),
                      FilledButton.tonal(
                        onPressed: () {
                          context.pushNamed<void>(SupportScreen.path);
                        },
                        style: buttonStyles.primaryFilledTonal,
                        child: Text(l10n.support),
                      ),
                      SizedBox(height: 3.space),
                      FilledButton.tonal(
                        onPressed: () {
                          context.pushNamed<void>(DevicesScreen.path);
                        },
                        style: buttonStyles.primaryFilledTonal,
                        child: Text(l10n.manageDevices),
                      ),
                    ],
                  ),
                ),
              )
                  .animate()
                  .slide(
                    begin: const Offset(0, 1),
                    curve: Curves.easeInOut,
                    end: Offset.zero,
                    delay: 800.ms,
                    duration: 700.ms,
                  )
                  .fadeIn(),
              SizedBox(height: 4.space),
              Card(
                elevation: 0,
                color: colors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.space),
                  side: BorderSide(
                    color: colors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(4.space),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.appearance,
                        style: textStyles.titleMedium.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3.space),
                      const ToggleButtonTheme(),
                      SizedBox(height: 3.space),
                      const ToggleTextScale(),
                    ],
                  ),
                ),
              )
                  .animate()
                  .slide(
                    begin: const Offset(0, 1),
                    curve: Curves.easeInOut,
                    end: Offset.zero,
                    delay: 900.ms,
                    duration: 700.ms,
                  )
                  .fadeIn(),
              if (!kIsWeb) ...[
                SizedBox(height: 4.space),
                const NotificationsSettings()
                    .animate()
                    .slide(
                      begin: const Offset(0, 1),
                      curve: Curves.easeInOut,
                      end: Offset.zero,
                      delay: 1000.ms,
                      duration: 700.ms,
                    )
                    .fadeIn(),
              ],
              SizedBox(height: 4.space),
              Card(
                elevation: 0,
                color: colors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.space),
                  side: BorderSide(
                    color: colors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(4.space),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Legal',
                        style: textStyles.titleMedium.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3.space),
                      ListTile(
                        onTap: () {
                          context.pushNamed<void>(TermsConditionsScreen.path);
                        },
                        title: Text(l10n.termsAndConditions),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: colors.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      Divider(color: colors.outline.withValues(alpha: 0.2)),
                      ListTile(
                        onTap: () {
                          context.pushNamed<void>(PrivacyPolicyScreen.path);
                        },
                        title: Text(l10n.privacyPolicy),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: colors.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  .animate()
                  .slide(
                    begin: const Offset(0, 1),
                    curve: Curves.easeInOut,
                    end: Offset.zero,
                    delay: 1100.ms,
                    duration: 700.ms,
                  )
                  .fadeIn(),
              AuthButtonsAnimatedRow(show: currentUser != null),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthButtonsAnimatedRow extends StatefulWidget {
  const AuthButtonsAnimatedRow({
    required this.show,
    super.key,
  });

  final bool show;

  @override
  State<AuthButtonsAnimatedRow> createState() => _AuthButtonsAnimatedRowState();
}

class _AuthButtonsAnimatedRowState extends State<AuthButtonsAnimatedRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: 700.ms,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.show) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AuthButtonsAnimatedRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show != oldWidget.show) {
      if (widget.show) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final textStyles = context.textStyles;
    final buttonStyles = context.buttonStyles;

    final isDeletingAccount =
        context.watch<SettingsNotifier>().isDeletingAccount;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Column(
          children: [
            4.spaceY,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: LoadingButton(
                    type: ButtonType.tonal,
                    onPressed: () {
                      context.read<SettingsNotifier>().signOut();
                    },
                    style: buttonStyles.primaryOutlined.copyWith(
                      side: WidgetStateProperty.all(
                        BorderSide(color: colors.error),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: colors.error),
                        SizedBox(width: 2.space),
                        Flexible(
                          child: Text(
                            l10n.signOut,
                            style: textStyles.labelLarge.copyWith(
                              color: colors.error,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                4.spaceX,
                Flexible(
                  child: LoadingButton(
                    isLoading: isDeletingAccount,
                    type: ButtonType.tonal,
                    onPressed: () {
                      context.read<SettingsNotifier>().deleteAccount();
                    },
                    style: buttonStyles.primaryOutlined.copyWith(
                      side: WidgetStateProperty.all(
                        BorderSide(color: colors.error),
                      ),
                    ),
                    loaderColor: colors.error,
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: colors.error),
                        SizedBox(width: 2.space),
                        Flexible(
                          child: Text(
                            l10n.deleteAccount,
                            style: textStyles.labelLarge.copyWith(
                              color: colors.error,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
