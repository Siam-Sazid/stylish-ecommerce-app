import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../controllers/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                left: 24,
                right: 24,
                bottom: 32,
              ),
              child: Obx(() => Column(
                    children: [
                      // Avatar
                      Stack(
                        children: [
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: ClipOval(
                              child: auth.currentUser.value?.avatarUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: auth.currentUser.value!.avatarUrl!,
                                      fit: BoxFit.cover,
                                      errorWidget: (_, __, ___) => _avatarPlaceholder(),
                                    )
                                  : _avatarPlaceholder(),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.edit, size: 14, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        auth.currentUser.value?.name ?? 'Guest User',
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        auth.currentUser.value?.email ?? 'Sign in for full access',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      // Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatItem(label: 'Orders', value: '12'),
                          _StatDivider(),
                          _StatItem(label: 'Wishlist', value: '5'),
                          _StatDivider(),
                          _StatItem(label: 'Reviews', value: '8'),
                        ],
                      ),
                    ],
                  )),
            ),
          ),

          // Menu items
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text('Account', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  _MenuSection(items: [
                    _MenuItem(icon: Icons.shopping_bag_outlined, label: 'My Orders', badge: '2 active', onTap: () {}),
                    _MenuItem(icon: Icons.favorite_outline_rounded, label: 'Wishlist', onTap: () {}),
                    _MenuItem(icon: Icons.location_on_outlined, label: 'Addresses', onTap: () {}),
                    _MenuItem(icon: Icons.payment_outlined, label: 'Payment Methods', onTap: () {}),
                  ]),
                  const SizedBox(height: 20),
                  Text('Settings', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  _MenuSection(items: [
                    _MenuItem(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () {}),
                    _MenuItem(icon: Icons.lock_outline, label: 'Privacy & Security', onTap: () {}),
                    _MenuItem(icon: Icons.help_outline_rounded, label: 'Help & Support', onTap: () {}),
                    _MenuItem(icon: Icons.info_outline_rounded, label: 'About ShopEase', onTap: () {}),
                  ]),
                  const SizedBox(height: 20),
                  _MenuSection(items: [
                    _MenuItem(
                      icon: Icons.logout_rounded,
                      label: 'Sign Out',
                      iconColor: AppColors.accent,
                      labelColor: AppColors.accent,
                      showArrow: false,
                      onTap: () => _confirmLogout(auth),
                    ),
                  ]),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarPlaceholder() => Container(
        color: Colors.white.withValues(alpha: 0.3),
        child: const Icon(Icons.person, size: 44, color: Colors.white),
      );

  void _confirmLogout(AuthController auth) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              auth.logout();
            },
            child: const Text('Sign Out', style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 12)),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: Colors.white.withValues(alpha: 0.3));
  }
}

class _MenuSection extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          return Column(
            children: [
              items[index],
              if (index < items.length - 1)
                const Divider(height: 1, indent: 56),
            ],
          );
        }),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? badge;
  final Color? iconColor;
  final Color? labelColor;
  final bool showArrow;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.badge,
    this.iconColor,
    this.labelColor,
    this.showArrow = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: iconColor ?? AppColors.primary),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: labelColor ?? AppColors.text,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(badge!, style: const TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 4),
          ],
          if (showArrow) const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
        ],
      ),
    );
  }
}
