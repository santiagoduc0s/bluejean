import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lune/core/extensions/extensions.dart';
import 'package:lune/gen/assets.gen.dart';
import 'package:lune/l10n/l10n.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  String _markdownData = '';

  @override
  void initState() {
    super.initState();
    _loadMarkdown();
  }

  Future<void> _loadMarkdown() async {
    final data = await rootBundle.loadString(Assets.files.privacyPolicy);

    setState(() {
      _markdownData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.textStyles;

    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.privacyPolicy),
      ),
      body: _markdownData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Markdown(
              data: _markdownData,
              styleSheet: MarkdownStyleSheet(
                p: textStyles.bodyMedium,
              ),
              onTapLink: (text, href, title) {
                if (href == null) return;
                launchUrlString(href);
              },
            ),
    );
  }
}
