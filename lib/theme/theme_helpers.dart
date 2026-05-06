import 'package:flutter/material.dart';

extension RoomieThemeHelpers on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  ColorScheme get colors => Theme.of(this).colorScheme;

  bool get isCompactWidth => MediaQuery.sizeOf(this).width < 600;

  bool get isWideWidth => MediaQuery.sizeOf(this).width >= 900;

  double get roomieContentMaxWidth => isWideWidth ? 1080 : double.infinity;

  EdgeInsets get roomiePagePadding {
    final width = MediaQuery.sizeOf(this).width;

    if (width >= 900) {
      return const EdgeInsets.all(24);
    }

    if (width >= 600) {
      return const EdgeInsets.all(18);
    }

    return const EdgeInsets.all(12);
  }

  double get roomieChartHeight {
    final height = MediaQuery.sizeOf(this).height;

    if (height < 650) {
      return 180;
    }

    if (isWideWidth) {
      return 260;
    }

    return 220;
  }

  LinearGradient get roomieBackgroundGradient {
    if (isDarkMode) {
      return const LinearGradient(
        colors: [
          Color(0xff0d1117),
          Color(0xff151b23),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }

    return const LinearGradient(
      colors: [
        Color(0xfff8f6ff),
        Color(0xffeef0ff),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  BoxDecoration roomieCardDecoration({
    double radius = 22,
  }) {
    final isDark = isDarkMode;

    return BoxDecoration(
      color: isDark ? colors.surface : Colors.white,
      border: Border.all(
        color: isDark
            ? colors.outlineVariant.withValues(alpha: 0.35)
            : Colors.transparent,
      ),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.28)
              : Colors.black.withValues(alpha: 0.05),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }
}
