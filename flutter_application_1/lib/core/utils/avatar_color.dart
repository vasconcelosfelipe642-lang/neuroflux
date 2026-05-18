import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

abstract final class AvatarColor {
  static Color forInitials(String initials) {
    final code = initials.codeUnits.fold<int>(0, (a, b) => a + b);
    return AppColors.avatarPalette[code % AppColors.avatarPalette.length];
  }
}
