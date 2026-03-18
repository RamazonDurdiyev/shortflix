import 'package:flutter/material.dart';
import 'package:shortflix/gen/colors.gen.dart';

Widget movieImagePlaceholder() {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.movie_creation_outlined,
          color: ColorName.accent.withOpacity(0.7),
          size: 32,
        ),
        const SizedBox(height: 4),
        Text(
          'N',
          style: TextStyle(
            color: ColorName.accent.withOpacity(0.5),
            fontSize: 18,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ),
  );
}