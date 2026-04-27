import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortflix/app/app_constants.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/l10n/app_localizations.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  late final Future<String> _markdown;

  @override
  void initState() {
    super.initState();
    _markdown = _loadMarkdown();
  }

  Future<String> _loadMarkdown() async {
    final code = (Hive.box('default').get(LANGUAGE) as String?) ?? 'en';
    final asset = switch (code) {
      'ru' => 'assets/docs/privacy_policy_ru.md',
      'uz' => 'assets/docs/privacy_policy_uz.md',
      _ => 'assets/docs/privacy_policy_en.md',
    };
    return rootBundle.loadString(asset);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: ColorName.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: ColorName.backgroundPrimary,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorName.backgroundSecondary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColorName.surfaceSecondary),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
        title: Text(
          l.privacyPolicy,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<String>(
          future: _markdown,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: CircularProgressIndicator(color: ColorName.accent),
              );
            }
            if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l.privacyPolicyLoadFailed,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorName.contentSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }
            return Markdown(
              data: snapshot.data!,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              physics: const BouncingScrollPhysics(),
              selectable: true,
              styleSheet: _markdownStyle(),
              onTapLink: (text, href, title) {
                // External links are not opened automatically; users can
                // long-press to copy. Add url_launcher if you want tap-to-open.
              },
            );
          },
        ),
      ),
    );
  }

  MarkdownStyleSheet _markdownStyle() {
    const baseColor = Colors.white;
    final secondary = ColorName.contentSecondary;
    return MarkdownStyleSheet(
      p: const TextStyle(color: baseColor, fontSize: 14, height: 1.5),
      h1: const TextStyle(
        color: baseColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.3,
      ),
      h2: const TextStyle(
        color: baseColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      h3: const TextStyle(
        color: baseColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      strong: const TextStyle(color: baseColor, fontWeight: FontWeight.bold),
      em: const TextStyle(color: baseColor, fontStyle: FontStyle.italic),
      listBullet: const TextStyle(color: baseColor, fontSize: 14),
      a: TextStyle(color: ColorName.accent, decoration: TextDecoration.underline),
      blockquote: TextStyle(color: secondary, fontSize: 13),
      code: TextStyle(
        color: ColorName.accent,
        fontSize: 13,
        backgroundColor: ColorName.backgroundSecondary,
      ),
      codeblockDecoration: BoxDecoration(
        color: ColorName.backgroundSecondary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorName.surfaceSecondary),
      ),
      tableHead: const TextStyle(
        color: baseColor,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
      tableBody: TextStyle(color: secondary, fontSize: 13),
      tableBorder: TableBorder.all(color: ColorName.surfaceSecondary, width: 1),
      tableCellsPadding: const EdgeInsets.all(8),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: ColorName.surfaceSecondary, width: 1),
        ),
      ),
    );
  }
}
