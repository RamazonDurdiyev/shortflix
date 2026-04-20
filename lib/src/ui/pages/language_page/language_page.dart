import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shortflix/app/app_constants.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/l10n/app_localizations.dart';

class LanguageOption {
  final String code;
  final String nativeName;
  final String flag;

  const LanguageOption({
    required this.code,
    required this.nativeName,
    required this.flag,
  });
}

const List<LanguageOption> _languages = [
  LanguageOption(code: 'uz', nativeName: 'O\'zbekcha', flag: '🇺🇿'),
  LanguageOption(code: 'ru', nativeName: 'Русский', flag: '🇷🇺'),
  LanguageOption(code: 'en', nativeName: 'English', flag: '🇬🇧'),
];

String languageLabelFor(AppLocalizations l, String? code) {
  switch (code) {
    case 'uz':
      return l.languageUzbek;
    case 'ru':
      return l.languageRussian;
    default:
      return l.languageEnglish;
  }
}

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final Box _box = Hive.box('default');
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = (_box.get(LANGUAGE) as String?) ?? 'en';
  }

  Future<void> _select(String code) async {
    if (_selected == code) return;
    await _box.put(LANGUAGE, code);
    if (!mounted) return;
    setState(() => _selected = code);
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
          l.language,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          physics: const BouncingScrollPhysics(),
          children: [
            Container(
              decoration: BoxDecoration(
                color: ColorName.backgroundSecondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ColorName.surfaceSecondary),
              ),
              child: Column(
                children: List.generate(_languages.length, (index) {
                  final lang = _languages[index];
                  final isLast = index == _languages.length - 1;
                  final isSelected = lang.code == _selected;
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => _select(lang.code),
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              Text(
                                lang.flag,
                                style: const TextStyle(fontSize: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lang.nativeName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      languageLabelFor(l, lang.code),
                                      style: TextStyle(
                                        color: ColorName.contentSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? ColorName.accent
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(11),
                                  border: Border.all(
                                    color: isSelected
                                        ? ColorName.accent
                                        : ColorName.surfaceSecondary,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 14,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!isLast)
                        Container(
                          height: 1,
                          margin: const EdgeInsets.only(left: 52),
                          color: ColorName.surfaceSecondary,
                        ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
