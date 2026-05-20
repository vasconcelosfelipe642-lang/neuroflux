import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

import '../../core/theme/app_text_styles.dart';

import '../../core/constants/app_sizes.dart';

import '../../domain/models/user_model.dart';

import '../../core/theme/theme_scope.dart';

import 'app_header_avatar.dart';
import 'theme_toggle_button.dart';



class AppHeader extends StatelessWidget {

  final UserModel user;

  final Future<void> Function() onLogout;

  final VoidCallback? onOpenFocus;

  final bool showFocusButton;



  const AppHeader({

    super.key,

    required this.user,

    required this.onLogout,

    this.onOpenFocus,

    this.showFocusButton = false,

  });



  void _showProfileModal(BuildContext context) {

    showModalBottomSheet(

      context: context,

      backgroundColor: Colors.transparent,

      builder: (modalContext) {

        ThemeScope.watch(modalContext);

        return Container(

          decoration: BoxDecoration(

            color: AppColors.surface,

            borderRadius: const BorderRadius.vertical(

              top: Radius.circular(AppSizes.radiusXl),

            ),

          ),

          padding: const EdgeInsets.all(AppSizes.xl),

          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              Container(

                width: 40,

                height: 4,

                margin: const EdgeInsets.only(bottom: AppSizes.lg),

                decoration: BoxDecoration(

                  color: AppColors.border,

                  borderRadius: BorderRadius.circular(2),

                ),

              ),

              ListTile(

                leading: Icon(Icons.person_outline, color: AppColors.textPrimary),

                title: Text(user.nome, style: AppTextStyles.fieldLabel),

              ),

              Divider(color: AppColors.border),

              ListTile(

                onTap: () async {

                  Navigator.pop(modalContext);

                  await onLogout();

                },

                leading: const Icon(Icons.logout, color: Colors.redAccent),

                title: const Text(

                  'Sair do Aplicativo',

                  style: TextStyle(

                    color: Colors.redAccent,

                    fontWeight: FontWeight.bold,

                  ),

                ),

              ),

              const SizedBox(height: AppSizes.lg),

            ],

          ),

        );

      },

    );

  }



  @override

  Widget build(BuildContext context) {

    ThemeScope.watch(context);



    return Container(

      color: AppColors.surface,

      padding: const EdgeInsets.fromLTRB(

        AppSizes.xl,

        AppSizes.md,

        AppSizes.xl,

        AppSizes.lg,

      ),

      child: Row(

        children: [

          GestureDetector(

            onTap: () => _showProfileModal(context),

            child: AppHeaderAvatar(initials: user.initials, color: user.avatarColor),

          ),

          const SizedBox(width: AppSizes.md),

          Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(user.greeting, style: AppTextStyles.greetingSmall),

                const SizedBox(height: 2),

                Text(user.nome, style: AppTextStyles.greetingName),

              ],

            ),

          ),

          if (showFocusButton && onOpenFocus != null) ...[

            IconButton(

              onPressed: onOpenFocus,

              tooltip: 'Modo Foco',

              icon: const Icon(

                Icons.center_focus_strong_rounded,

                color: AppColors.primary,

              ),

            ),

          ],

          const ThemeToggleButton(),

        ],

      ),

    );

  }

}

