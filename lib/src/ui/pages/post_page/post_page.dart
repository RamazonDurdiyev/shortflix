import 'package:flutter/material.dart';
import 'package:shortflix/gen/colors.gen.dart';

// ─────────────────────────────────────────
//  POST PAGE
// ─────────────────────────────────────────
class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.backgroundPrimary,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // ── Media upload ──────────────────────
                    _buildSectionLabel('Film'),
                    const SizedBox(height: 12),
                    _buildMediaUpload(),
                    const SizedBox(height: 20),

                    // ── Thumbnail upload ──────────────────
                    _buildSectionLabel('Thumbnail'),
                    const SizedBox(height: 12),
                    _buildThumbnailUpload(),
                    const SizedBox(height: 24),

                    // ── Season & Episode ──────────────────
                    _buildSectionLabel('Episode Info'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNumberField(
                            label: 'Season',
                            hint: '1',
                            icon: Icons.layers_outlined,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNumberField(
                            label: 'Episode',
                            hint: '1',
                            icon: Icons.play_circle_outline_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNumberField(
                            label: 'Release Year',
                            hint: '2024',
                            icon: Icons.calendar_today_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Category ──────────────────────────
                    _buildSectionLabel('Category'),
                    const SizedBox(height: 12),
                    _buildCategoryDropdown(),
                    const SizedBox(height: 24),

                    // ── Title (3 langs) ───────────────────
                    _buildSectionLabel('Title'),
                    const SizedBox(height: 12),
                    _buildLangField(
                      flag: '🇺🇿',
                      label: 'Uzbek',
                      hint: 'Uzbekcha nomi',
                    ),
                    const SizedBox(height: 12),
                    _buildLangField(
                      flag: '🇷🇺',
                      label: 'Russian',
                      hint: 'Название на русском',
                    ),
                    const SizedBox(height: 12),
                    _buildLangField(
                      flag: '🇬🇧',
                      label: 'English',
                      hint: 'Title in English',
                    ),
                    const SizedBox(height: 24),

                    // ── Description (3 langs) ─────────────
                    _buildSectionLabel('Description'),
                    const SizedBox(height: 12),
                    _buildLangField(
                      flag: '🇺🇿',
                      label: 'Uzbek',
                      hint: 'Uzbekcha tavsif...',
                      multiline: true,
                    ),
                    const SizedBox(height: 12),
                    _buildLangField(
                      flag: '🇷🇺',
                      label: 'Russian',
                      hint: 'Описание на русском...',
                      multiline: true,
                    ),
                    const SizedBox(height: 12),
                    _buildLangField(
                      flag: '🇬🇧',
                      label: 'English',
                      hint: 'Description in English...',
                      multiline: true,
                    ),
                    const SizedBox(height: 32),

                    // ── Submit ────────────────────────────
                    _buildSubmitButton(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  TOP BAR
// ─────────────────────────────────────────
Widget _buildTopBar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
    child: Row(
      children: [
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'Upload Content',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: ColorName.backgroundSecondary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorName.surfaceSecondary),
          ),
          child: Text(
            'Save draft',
            style: TextStyle(
              color: ColorName.contentSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────
//  SECTION LABEL
// ─────────────────────────────────────────
Widget _buildSectionLabel(String label) {
  return Row(
    children: [
      Container(
        width: 4,
        height: 16,
        decoration: BoxDecoration(
          color: ColorName.accent,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.2,
        ),
      ),
    ],
  );
}

// ─────────────────────────────────────────
//  MEDIA UPLOAD (film)
// ─────────────────────────────────────────
Widget _buildMediaUpload() {
  return GestureDetector(
    onTap: () {},
    child: Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorName.backgroundSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorName.accent.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: ColorName.accent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cloud_upload_outlined,
              color: ColorName.accent,
              size: 26,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Tap to upload film',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'MP4, MKV, MOV — max 4GB',
            style: TextStyle(
              color: ColorName.contentSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: ColorName.accent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Browse files',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// ─────────────────────────────────────────
//  THUMBNAIL UPLOAD
// ─────────────────────────────────────────
Widget _buildThumbnailUpload() {
  return GestureDetector(
    onTap: () {},
    child: Container(
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorName.backgroundSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorName.surfaceSecondary,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Left: preview placeholder
          Container(
            width: 100,
            height: double.infinity,
            decoration: BoxDecoration(
              color: ColorName.surfaceSecondary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_outlined,
                  color: ColorName.contentSecondary,
                  size: 30,
                ),
                const SizedBox(height: 6),
                Text(
                  'Preview',
                  style: TextStyle(
                    color: ColorName.contentSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // Right: upload info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Upload Thumbnail',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'JPG, PNG — recommended 1280×720',
                    style: TextStyle(
                      color: ColorName.contentSecondary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: ColorName.backgroundSecondary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: ColorName.accent.withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          color: ColorName.accent,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Choose image',
                          style: TextStyle(
                            color: ColorName.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// ─────────────────────────────────────────
//  NUMBER FIELD
// ─────────────────────────────────────────
Widget _buildNumberField({
  required String label,
  required String hint,
  required IconData icon,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: ColorName.contentSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 6),
      Container(
        height: 48,
        decoration: BoxDecoration(
          color: ColorName.backgroundSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorName.surfaceSecondary),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Icon(icon, color: ColorName.contentSecondary, size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: ColorName.contentSecondary,
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

// ─────────────────────────────────────────
//  CATEGORY DROPDOWN
// ─────────────────────────────────────────
Widget _buildCategoryDropdown() {
  return Container(
    height: 52,
    decoration: BoxDecoration(
      color: ColorName.backgroundSecondary,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: ColorName.surfaceSecondary),
    ),
    child: Row(
      children: [
        const SizedBox(width: 16),
        Icon(
          Icons.category_outlined,
          color: ColorName.contentSecondary,
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Select category',
            style: TextStyle(
              color: ColorName.contentSecondary,
              fontSize: 14,
            ),
          ),
        ),
        Icon(
          Icons.keyboard_arrow_down_rounded,
          color: ColorName.contentSecondary,
          size: 20,
        ),
        const SizedBox(width: 14),
      ],
    ),
  );
}

// ─────────────────────────────────────────
//  LANGUAGE FIELD
// ─────────────────────────────────────────
Widget _buildLangField({
  required String flag,
  required String label,
  required String hint,
  bool multiline = false,
}) {
  return Container(
    decoration: BoxDecoration(
      color: ColorName.backgroundSecondary,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: ColorName.surfaceSecondary),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: ColorName.surfaceSecondary),
            ),
          ),
          child: Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: ColorName.contentSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: TextField(
            maxLines: multiline ? 4 : 1,
            minLines: 1,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: ColorName.contentSecondary,
                fontSize: 13,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────
//  SUBMIT BUTTON
// ─────────────────────────────────────────
Widget _buildSubmitButton() {
  return GestureDetector(
    onTap: () {},
    child: Container(
      height: 52,
      decoration: BoxDecoration(
        color: ColorName.accent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.upload_rounded, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text(
            'Publish',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    ),
  );
}