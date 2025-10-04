import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/core/ui/spacing/spacing.dart';
import 'package:lune/l10n/l10n.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';

class WebLandingPage extends StatelessWidget {
  const WebLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          _WebNavigationBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _WebHeroSection(),
                  _WebHowToUseSection(),
                  _WebVideoTutorialsSection(),
                  _WebFeaturesSection(),
                  _WebFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WebNavigationBar extends StatelessWidget {
  const _WebNavigationBar();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final iconProvider = context.icons;
    final isMobile = size.width < 768;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
        child: Row(
          children: [
            // Logo
            Row(
              children: [
                iconProvider.logo(size: isMobile ? 15.space : 12.space),
                const SizedBox(width: 12),
                if (!isMobile)
                  Text(
                    l10n.appName,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
              ],
            ),

            const Spacer(),

            // Navigation Links - Responsive
            // if (!isMobile)
            //   Row(
            //     children: [
            //       TextButton(
            //         onPressed:
            //             () => context.pushNamed(TermsConditionsScreen.path),
            //         child: Text(l10n.termsAndConditions),
            //       ),
            //       const SizedBox(width: 16),
            //       TextButton(
            //         onPressed:
            //             () => context.pushNamed(PrivacyPolicyScreen.path),
            //         child: Text(l10n.privacyPolicy),
            //       ),
            //       const SizedBox(width: 16),
            //       TextButton(
            //         onPressed: () => context.pushNamed(SupportScreen.path),
            //         child: Text(l10n.support),
            //       ),
            //     ],
            //   )
            // else
            //   // Mobile menu button
            //   PopupMenuButton<String>(
            //     icon: const Icon(Icons.menu),
            //     onSelected: (String route) {
            //       context.pushNamed(route);
            //     },
            //     itemBuilder:
            //         (BuildContext context) => [
            //           PopupMenuItem<String>(
            //             value: TermsConditionsScreen.path,
            //             child: Text(l10n.termsAndConditions),
            //           ),
            //           PopupMenuItem<String>(
            //             value: PrivacyPolicyScreen.path,
            //             child: Text(l10n.privacyPolicy),
            //           ),
            //           PopupMenuItem<String>(
            //             value: SupportScreen.path,
            //             child: Text(l10n.support),
            //           ),
            //         ],
            //   ),
          ],
        ),
      ),
    );
  }
}

class _WebHeroSection extends StatelessWidget {
  const _WebHeroSection();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 64),
      child:
          isMobile
              ? const Column(
                children: [
                  _WebHeroVisual(isMobile: true),
                  SizedBox(height: 32),
                  _WebHeroText(isMobile: true),
                ],
              )
              : const Row(
                children: [
                  Expanded(child: _WebHeroText(isMobile: false)),
                  SizedBox(width: 64),
                  Expanded(child: _WebHeroVisual(isMobile: false)),
                ],
              ),
    );
  }
}

class _WebHeroText extends StatelessWidget {
  const _WebHeroText({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final icons = context.icons;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              Text(
                l10n.onboard_title,
                style: (isMobile
                        ? textTheme.displayMedium
                        : textTheme.displayLarge)
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                      height: 1.2,
                    ),
                textAlign: isMobile ? TextAlign.center : TextAlign.start,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.onboard_description,
                style: (isMobile
                        ? textTheme.titleLarge
                        : textTheme.headlineSmall)
                    ?.copyWith(
                      color: colors.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.normal,
                      height: 1.4,
                    ),
                textAlign: isMobile ? TextAlign.center : TextAlign.start,
              ),
              const SizedBox(height: 24),
              if (isMobile)
                Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        const url =
                            'https://apps.apple.com/gb/app/bus-escolares/id6749213515?platform=iphone';
                        if (await canLaunchUrlString(url)) {
                          await launchUrlString(url);
                        }
                      },
                      child: icons.downloadIOS(width: 15.space * 3),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        const url =
                            'https://play.google.com/store/apps/details?id=com.santiagoducos.busescolares';
                        if (await canLaunchUrlString(url)) {
                          await launchUrlString(url);
                        }
                      },
                      child: icons.downloadAndroid(width: 15.space * 3),
                    ),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        const url =
                            'https://apps.apple.com/gb/app/bus-escolares/id6749213515?platform=iphone';
                        if (await canLaunchUrlString(url)) {
                          await launchUrlString(url);
                        }
                      },
                      child: icons.downloadIOS(width: 15.space * 3),
                    ),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () async {
                        const url =
                            'https://play.google.com/store/apps/details?id=com.santiagoducos.busescolares';
                        if (await canLaunchUrlString(url)) {
                          await launchUrlString(url);
                        }
                      },
                      child: icons.downloadAndroid(width: 15.space * 3),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WebHeroVisual extends StatelessWidget {
  const _WebHeroVisual({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final iconProvider = context.icons;
    final visualHeight = isMobile ? 300.0 : 400.0;
    final logoSize = isMobile ? 80.0 : 120.0;
    final containerSize = isMobile ? 150.0 : 200.0;

    return Container(
          height: visualHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.primary.withValues(alpha: 0.1),
                colors.secondary.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            children: [
              // Background pattern with animation
              Positioned.fill(
                child: CustomPaint(
                      painter: _CirclePatternPainter(
                        colors.primary.withValues(alpha: 0.1),
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(
                      duration: 3000.ms,
                      color: colors.primary.withValues(alpha: 0.1),
                    ),
              ),

              if (!isMobile) ...[
                Positioned(
                  top: 50,
                  right: 50,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.secondary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: colors.onSecondary,
                      size: 24,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 80,
                  left: 40,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.tertiary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.notifications,
                      color: colors.onTertiary,
                      size: 24,
                    ),
                  ),
                ),
              ],

              // Main logo
              Center(
                child: Container(
                      width: containerSize,
                      height: containerSize,
                      decoration: BoxDecoration(
                        color: const Color(0xfff1be6d),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xfff1be6d,
                            ).withValues(alpha: 0.5),
                            blurRadius: 32,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: Center(
                        child: iconProvider.logo(size: logoSize.space),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 800.ms, curve: Curves.easeOutQuart)
                    .then()
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .moveY(
                      begin: 15,
                      end: -15,
                      duration: 3000.ms,
                      curve: Curves.easeInOut,
                    ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: 200.ms)
        .slideX(
          begin: isMobile ? 0 : 0.3,
          end: 0,
          duration: 800.ms,
          delay: 200.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

class _WebVideoTutorialsSection extends StatelessWidget {
  const _WebVideoTutorialsSection();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 64),
      color: colors.surfaceContainerLowest,
      child: Column(
        children: [
          const SizedBox(width: double.infinity),
          Text(
            'Configura tu ruta en simples pasos',
            style: isMobile
                ? textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  )
                : textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 32 : 48),
          if (isMobile)
            Column(
              children: [
                _VideoTutorialCard(
                  videoPath: 'assets/videos/map.mp4',
                  title: 'Selecciona la ubicación de tu cliente, y marca el rango en el cual le llega la notificación',
                  isMobile: true,
                ),
                const SizedBox(height: 32),
                _VideoTutorialCard(
                  videoPath: 'assets/videos/notifications.mp4',
                  title: 'Tus clientes recibirán una notificación de que estás cerca de ellos',
                  isMobile: true,
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _VideoTutorialCard(
                    videoPath: 'assets/videos/map.mp4',
                    title: 'Selecciona la ubicación de tu cliente, y marca el rango en el cual le llega la notificación',
                    isMobile: false,
                  ),
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: _VideoTutorialCard(
                    videoPath: 'assets/videos/notifications.mp4',
                    title: 'Tus clientes recibirán una notificación de que estás cerca de ellos',
                    isMobile: false,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _VideoTutorialCard extends StatelessWidget {
  const _VideoTutorialCard({
    required this.videoPath,
    required this.title,
    required this.isMobile,
  });

  final String videoPath;
  final String title;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          title,
          style: (isMobile ? textTheme.bodyLarge : textTheme.titleLarge)
              ?.copyWith(
                color: colors.onSurface.withValues(alpha: 0.7),
                height: 1.4,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 600,
          ),
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Container(
              decoration: BoxDecoration(
                color: colors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: _VideoPlayer(videoPath: videoPath),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WebFeaturesSection extends StatelessWidget {
  const _WebFeaturesSection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(isMobile ? 24 : 64),
            color: colors.surfaceContainerHighest.withValues(alpha: 0.3),
            child: Column(
              children: [
                Text(
                  l10n.webKeyFeatures,
                  style:
                      isMobile
                          ? textTheme.headlineLarge
                          : textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.onSurface,
                          ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMobile ? 32 : 48),

                if (isMobile)
                  Column(
                    children: [
                      _WebFeatureCard(
                        icon: Icons.location_on,
                        title: l10n.webSimpleRouteDriving,
                        description: l10n.webSimpleRouteDrivingDescription,
                      ),
                      const SizedBox(height: 24),
                      _WebFeatureCard(
                        icon: Icons.notifications,
                        title: l10n.webHandsFreeOperation,
                        description: l10n.webHandsFreeOperationDescription,
                      ),
                      const SizedBox(height: 24),
                      _WebFeatureCard(
                        icon: Icons.route,
                        title: l10n.webEasyRouteSetup,
                        description: l10n.webEasyRouteSetupDescription,
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: _WebFeatureCard(
                          icon: Icons.location_on,
                          title: l10n.webSimpleRouteDriving,
                          description: l10n.webSimpleRouteDrivingDescription,
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        child: _WebFeatureCard(
                          icon: Icons.notifications,
                          title: l10n.webHandsFreeOperation,
                          description: l10n.webHandsFreeOperationDescription,
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        child: _WebFeatureCard(
                          icon: Icons.route,
                          title: l10n.webEasyRouteSetup,
                          description: l10n.webEasyRouteSetupDescription,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WebFeatureCard extends StatelessWidget {
  const _WebFeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 24 : 32),
        child: Column(
          children: [
            Container(
              width: isMobile ? 60 : 80,
              height: isMobile ? 60 : 80,
              decoration: BoxDecoration(
                color: const Color(0xfff1be6d),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                size: isMobile ? 30 : 40,
                color: colors.onPrimary,
              ),
            ),
            SizedBox(height: isMobile ? 16 : 24),
            Text(
              title,
              style: (isMobile ? textTheme.titleMedium : textTheme.titleLarge)
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Text(
              description,
              style: (isMobile ? textTheme.bodyMedium : textTheme.bodyLarge)
                  ?.copyWith(color: colors.onSurface.withValues(alpha: 0.7)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _WebFooter extends StatelessWidget {
  const _WebFooter();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final iconProvider = context.icons;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      padding: EdgeInsets.all(isMobile ? 32 : 48),
      color: colors.surface,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconProvider.logo(size: isMobile ? 24.space : 32.space),
              const SizedBox(width: 12),
              Text(
                l10n.appName,
                style: (isMobile ? textTheme.titleMedium : textTheme.titleLarge)
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.webCopyright(l10n.appName),
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              const url = 'https://santiagoducos.com';
              if (await canLaunchUrlString(url)) {
                await launchUrlString(url);
              }
            },
            child: Text(
              'Santiago Ducos',
              style: textTheme.bodySmall?.copyWith(
                color: colors.primary,
                decoration: TextDecoration.underline,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _WebHowToUseSection extends StatefulWidget {
  const _WebHowToUseSection();

  @override
  State<_WebHowToUseSection> createState() => _WebHowToUseSectionState();
}

class _WebHowToUseSectionState extends State<_WebHowToUseSection> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      padding: EdgeInsets.all(isMobile ? 24 : 64),
      color: colors.surfaceContainerLowest,
      child: Column(
        children: [
          const SizedBox(width: double.infinity),
          Text(
            l10n.webHowToUse,
            style:
                isMobile
                    ? textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    )
                    : textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 24 : 32),
          Text(
            'El primer paso es descargar la app, ve a la App Store o Play Store y escribe "Bus Escolares"',
            style: (isMobile ? textTheme.bodyLarge : textTheme.headlineSmall)
                ?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.7),
                  height: 1.4,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 32 : 48),
          Container(
            constraints: BoxConstraints(
              maxWidth: isMobile ? double.infinity : 800,
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: const Center(child: _VideoPlayer()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoPlayer extends StatefulWidget {
  const _VideoPlayer({this.videoPath = 'assets/videos/download.mp4'});

  final String videoPath;

  @override
  State<_VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.asset(widget.videoPath);
      await _controller.initialize();

      // Enable looping for continuous playback
      _controller.setLooping(true);
      // Mute video for autoplay (required by browsers)
      _controller.setVolume(0);

      _controller.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        // Auto-play the video
        await _controller.play();
        debugPrint('Video initialized successfully');
        debugPrint('Video duration: ${_controller.value.duration}');
        debugPrint('Video size: ${_controller.value.size}');
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
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
    final colors = Theme.of(context).colorScheme;

    if (_errorMessage != null) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primary.withValues(alpha: 0.1),
              colors.secondary.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: colors.error),
              const SizedBox(height: 16),
              Text(
                'Error loading video',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: colors.onSurface),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _errorMessage!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primary.withValues(alpha: 0.1),
              colors.secondary.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}

class _CirclePatternPainter extends CustomPainter {
  _CirclePatternPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    for (var i = 0; i < 10; i++) {
      for (var j = 0; j < 10; j++) {
        final x = (size.width / 10) * i + (size.width / 20);
        final y = (size.height / 10) * j + (size.height / 20);
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
