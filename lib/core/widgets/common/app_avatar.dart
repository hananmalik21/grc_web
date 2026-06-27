import 'dart:typed_data';

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppAvatar extends StatelessWidget {
  final Object? image;
  final String? fallbackInitial;
  final double size;
  final Color? backgroundColor;
  final bool showStatusDot;
  final Color? statusDotColor;
  final BoxBorder? border;

  const AppAvatar({
    super.key,
    this.image,
    this.fallbackInitial,
    this.size = 40,
    this.backgroundColor,
    this.showStatusDot = false,
    this.statusDotColor,
    this.border,
  });

  String? _initialsFromName(String name) {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return null;
    final first = words[0];
    final firstLetter = first.isNotEmpty ? first[0].toUpperCase() : '';
    if (words.length >= 2) {
      final second = words[1];
      final secondLetter = second.isNotEmpty ? second[0].toUpperCase() : '';
      return '$firstLetter$secondLetter';
    }
    return firstLetter.isEmpty ? null : firstLetter;
  }

  ImageProvider? _resolveImageProvider(Object? image) {
    if (image == null) return null;
    if (image is ImageProvider) return image;
    if (image is String) {
      final s = image;
      if (s.startsWith('http://') || s.startsWith('https://')) {
        return NetworkImage(s);
      }
      return AssetImage(s);
    }
    if (image is Uint8List) return MemoryImage(image);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? AppColors.infoBg;
    final effectiveDotColor = statusDotColor ?? AppColors.statIconBlue;
    final provider = _resolveImageProvider(image);
    final initial = _initialsFromName(fallbackInitial ?? '');

    final content = provider != null
        ? Image(
            image: provider,
            fit: BoxFit.cover,
            width: size,
            height: size,
            errorBuilder: (_, _, _) =>
                _buildInitial(context, initial, effectiveBg, textColor: AppColors.statIconBlue),
          )
        : _buildInitial(context, initial, effectiveBg, textColor: AppColors.statIconBlue);

    Widget avatar = ClipOval(
      child: SizedBox(width: size, height: size, child: content),
    );
    if (border != null) {
      avatar = Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, border: border),
        child: avatar,
      );
    }

    if (showStatusDot) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(width: size, height: size, child: avatar),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: effectiveDotColor,
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).canvasColor, width: 1.5),
              ),
            ),
          ),
        ],
      );
    }
    return SizedBox(width: size, height: size, child: avatar);
  }

  Widget _buildInitial(BuildContext context, String? initial, Color backgroundColor, {Color? textColor}) {
    return Container(
      width: size.w,
      height: size.h,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        initial ?? '?',
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: (size * 0.40).sp,
          color: textColor,
        ),
      ),
    );
  }
}
