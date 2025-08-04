import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/role_switching_provider.dart';
import '../utlis/constants/colors.dart';
import '../utlis/constants/size.dart';

class RoleSwitchWidget extends StatelessWidget {
  final bool showAsButton;
  final bool showCurrentRole;
  final VoidCallback? onRoleChanged;

  const RoleSwitchWidget({
    Key? key,
    this.showAsButton = true,
    this.showCurrentRole = true,
    this.onRoleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RoleSwitchingProvider>(
      builder: (context, roleSwitchingProvider, child) {
        // Initialize role info if not already done
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (roleSwitchingProvider.currentRole == null && !roleSwitchingProvider.isLoading) {
            roleSwitchingProvider.initializeRoleInfo();
          }
        });

        if (roleSwitchingProvider.isLoading) {
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (!roleSwitchingProvider.hasMultipleRoles) {
          return showCurrentRole && roleSwitchingProvider.currentRole != null
              ? _buildCurrentRoleDisplay(context, roleSwitchingProvider)
              : const SizedBox.shrink();
        }

        return showAsButton
            ? _buildSwitchButton(context, roleSwitchingProvider)
            : _buildRoleSelector(context, roleSwitchingProvider);
      },
    );
  }

  Widget _buildCurrentRoleDisplay(BuildContext context, RoleSwitchingProvider provider) {
    final roleInfo = provider.getRoleDisplayInfo();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            roleInfo['currentRoleIcon'],
            size: 16,
            color: AppColors.primaryColor,
          ),
          const SizedBox(width: 6),
          Text(
            roleInfo['currentRoleDisplay'],
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchButton(BuildContext context, RoleSwitchingProvider provider) {
    final oppositeRole = provider.getOppositeRole();
    if (oppositeRole == null) return const SizedBox.shrink();

    return ElevatedButton.icon(
      onPressed: provider.canSwitchRoles
          ? () async {
              final success = await provider.quickSwitchRole();
              if (success && onRoleChanged != null) {
                onRoleChanged!();
              }
            }
          : null,
      icon: Icon(
        provider.getRoleIcon(oppositeRole),
        size: 18,
      ),
      label: Text('Switch to ${provider.getRoleDisplayName(oppositeRole)}'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
        ),
      ),
    );
  }

  Widget _buildRoleSelector(BuildContext context, RoleSwitchingProvider provider) {
    final roleInfo = provider.getRoleDisplayInfo();
    final availableRoles = List<Map<String, dynamic>>.from(roleInfo['availableRoles']);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
        border: Border.all(color: AppColors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Switch Role',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          ...availableRoles.map((roleData) {
            final isCurrent = roleData['isCurrent'] as bool;
            final role = roleData['role'] as String;
            final display = roleData['display'] as String;
            final icon = roleData['icon'] as IconData;

            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                icon,
                color: isCurrent ? AppColors.primaryColor : AppColors.grey,
              ),
              title: Text(
                display,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isCurrent ? AppColors.primaryColor : AppColors.primaryColor,
                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              trailing: isCurrent
                  ? Icon(
                      Icons.check_circle,
                      color: AppColors.primaryColor,
                      size: 20,
                    )
                  : null,
              onTap: isCurrent || !provider.canSwitchRoles
                  ? null
                  : () async {
                      final success = await provider.switchRole(role);
                      if (success && onRoleChanged != null) {
                        onRoleChanged!();
                      }
                    },
            );
          }).toList(),
        ],
      ),
    );
  }
}

class RoleSwitchDialog extends StatelessWidget {
  const RoleSwitchDialog({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const RoleSwitchDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Switch Role',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  color: AppColors.grey,
                ),
              ],
            ),
            const SizedBox(height: 16),
            RoleSwitchWidget(
              showAsButton: false,
              showCurrentRole: false,
              onRoleChanged: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RoleSwitchAppBarAction extends StatelessWidget {
  const RoleSwitchAppBarAction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RoleSwitchingProvider>(
      builder: (context, provider, child) {
        if (!provider.hasMultipleRoles) {
          return const SizedBox.shrink();
        }

        return IconButton(
          onPressed: () => RoleSwitchDialog.show(context),
          icon: const Icon(Icons.swap_horiz),
          tooltip: 'Switch Role',
        );
      },
    );
  }
}
