import 'package:flutter/material.dart';
import 'package:shortflix/gen/colors.gen.dart';
import 'package:shortflix/l10n/app_localizations.dart';
import 'package:shortflix/src/models/report_model/report_model.dart';

typedef ReportFetchCategories = Future<List<ReportCategoryModel>> Function();
typedef ReportSubmit = Future<void> Function({
  required String subcategoryId,
  String? text,
});

Future<void> showReportSheet({
  required BuildContext context,
  required ReportFetchCategories onFetchCategories,
  required ReportSubmit onSubmit,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: const Color(0xFF121212),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => ReportSheet(
      onFetchCategories: onFetchCategories,
      onSubmit: onSubmit,
    ),
  );
  if (result == true && context.mounted) {
    _showReportSubmittedDialog(context);
  }
}

class ReportSheet extends StatefulWidget {
  final ReportFetchCategories onFetchCategories;
  final ReportSubmit onSubmit;

  const ReportSheet({
    super.key,
    required this.onFetchCategories,
    required this.onSubmit,
  });

  @override
  State<ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<ReportSheet> {
  late Future<List<ReportCategoryModel>> _future;
  ReportCategoryModel? _category;
  ReportSubcategoryModel? _pendingSubcategory;
  final _textController = TextEditingController();
  bool _showDetails = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _future = widget.onFetchCategories();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _retry() {
    setState(() {
      _future = widget.onFetchCategories();
    });
  }

  void _onCategoryTapped(ReportCategoryModel category) {
    setState(() => _category = category);
  }

  void _onSubcategoryTapped(ReportSubcategoryModel sub) {
    if (sub.requiresText) {
      setState(() {
        _showDetails = true;
        _pendingSubcategory = sub;
      });
      return;
    }
    _submit(sub.id);
  }

  Future<void> _submit(String subcategoryId, {String? text}) async {
    setState(() => _submitting = true);
    try {
      await widget.onSubmit(subcategoryId: subcategoryId, text: text);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _submitting = false);
    }
  }

  void _onBack() {
    setState(() {
      if (_showDetails) {
        _showDetails = false;
        _pendingSubcategory = null;
        _textController.clear();
      } else {
        _category = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: FutureBuilder<List<ReportCategoryModel>>(
          future: _future,
          builder: (ctx, snapshot) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                _Header(
                  title: _showDetails
                      ? l.reportDescribeLabel
                      : (_category?.name ?? l.selectReason),
                  canGoBack: _category != null || _showDetails,
                  onBack: _onBack,
                ),
                const SizedBox(height: 8),
                _buildBody(snapshot, l),
                const SizedBox(height: 8),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    AsyncSnapshot<List<ReportCategoryModel>> snapshot,
    AppLocalizations l,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: CircularProgressIndicator(color: ColorName.accent),
      );
    }
    if (snapshot.hasError || !snapshot.hasData) {
      return _LoadError(
        message: l.reportLoadError,
        retryLabel: l.tryAgain,
        onRetry: _retry,
      );
    }
    if (_showDetails) {
      return _DetailsView(
        controller: _textController,
        submitLabel: l.reportSubmit,
        submitting: _submitting,
        onSubmit: () => _submit(
          _pendingSubcategory!.id,
          text: _textController.text.trim(),
        ),
      );
    }
    if (_category == null) {
      return _CategoriesList(
        categories: snapshot.data!,
        onTap: _onCategoryTapped,
      );
    }
    return _SubcategoriesList(
      subcategories: _category!.subcategories,
      onTap: _onSubcategoryTapped,
    );
  }
}

class _Header extends StatelessWidget {
  final String title;
  final bool canGoBack;
  final VoidCallback onBack;
  const _Header({
    required this.title,
    required this.canGoBack,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          if (canGoBack)
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: onBack,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          if (canGoBack) const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoriesList extends StatelessWidget {
  final List<ReportCategoryModel> categories;
  final ValueChanged<ReportCategoryModel> onTap;
  const _CategoriesList({required this.categories, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final c = categories[i];
          return ListTile(
            title: Text(
              c.name,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: const Icon(Icons.chevron_right_rounded,
                color: Colors.white38),
            onTap: () => onTap(c),
          );
        },
      ),
    );
  }
}

class _SubcategoriesList extends StatelessWidget {
  final List<ReportSubcategoryModel> subcategories;
  final ValueChanged<ReportSubcategoryModel> onTap;
  const _SubcategoriesList({
    required this.subcategories,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: subcategories.length,
        itemBuilder: (_, i) {
          final s = subcategories[i];
          return ListTile(
            title: Text(
              s.name,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: s.requiresText
                ? const Icon(Icons.edit_outlined,
                    color: Colors.white38, size: 18)
                : null,
            onTap: () => onTap(s),
          );
        },
      ),
    );
  }
}

class _DetailsView extends StatelessWidget {
  final TextEditingController controller;
  final String submitLabel;
  final bool submitting;
  final VoidCallback onSubmit;
  const _DetailsView({
    required this.controller,
    required this.submitLabel,
    required this.submitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            maxLines: 4,
            maxLength: 500,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF1F1F1F),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              counterStyle: const TextStyle(color: Colors.white38),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: submitting ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorName.accent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: submitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    submitLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;
  const _LoadError({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded,
              color: ColorName.contentSecondary, size: 36),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: ColorName.contentSecondary),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRetry,
            child: Text(
              retryLabel,
              style: TextStyle(
                color: ColorName.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showReportSubmittedDialog(BuildContext context) {
  final l = AppLocalizations.of(context);
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: ColorName.backgroundSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        l.reportSubmittedTitle,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: Text(
        l.reportSubmittedMessage,
        style: TextStyle(color: ColorName.contentSecondary, fontSize: 13),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(
            l.gotIt,
            style: TextStyle(
              color: ColorName.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
