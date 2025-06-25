import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_typography.dart';
import '../../core/design/app_spacing.dart';
import '../../features/auth/cubit/auth_cubit.dart';
import '../utils/responsive_utils.dart';
import 'modern_widgets.dart';

class AdminLayout extends StatefulWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  
  const AdminLayout({
    super.key,
    required this.child,
    required this.title,
    this.actions,
    this.showBackButton = false,
  });

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> 
    with TickerProviderStateMixin {
  bool _sidebarCollapsed = false;
  late AnimationController _sidebarController;
  late Animation<double> _sidebarAnimation;

  @override
  void initState() {
    super.initState();
    _sidebarController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _sidebarAnimation = Tween<double>(begin: 280, end: 80).animate(
      CurvedAnimation(parent: _sidebarController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() => _sidebarCollapsed = !_sidebarCollapsed);
    if (_sidebarCollapsed) {
      _sidebarController.forward();
    } else {
      _sidebarController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    
    if (isMobile) {
      return _buildMobileLayout();
    } else {
      return _buildDesktopLayout();
    }
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      body: Row(
        children: [
          // Sidebar
          AnimatedBuilder(
            animation: _sidebarAnimation,
            builder: (context, child) {
              return Container(
                width: _sidebarAnimation.value,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  border: Border(
                    right: BorderSide(color: AppColors.gray200, width: 1),
                  ),
                ),
                child: _buildSidebar(),
              );
            },
          ),
          
          // Main Content Area
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: _buildMobileAppBar(),
      drawer: Container(
        width: 280,
        decoration: const BoxDecoration(
          color: AppColors.white,
        ),
        child: _buildSidebar(),
      ),
      body: widget.child,
    );
  }

  PreferredSizeWidget _buildMobileAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: false,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Text(
        widget.title,
        style: AppTypography.h5.copyWith(color: AppColors.gray900),
      ),
      actions: [
        ...?widget.actions,
        _buildUserMenu(),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 72,
      padding: AppSpacing.horizontalLG,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.gray200, width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _sidebarCollapsed 
                ? Icons.menu_open_rounded 
                : Icons.menu_rounded,
            ),
            onPressed: _toggleSidebar,
          ),
          AppSpacing.horizontalGapMD,
          if (widget.showBackButton) ...[
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
            AppSpacing.horizontalGapMD,
          ],
          Text(
            widget.title,
            style: AppTypography.h5.copyWith(color: AppColors.gray900),
          ),
          const Spacer(),
          ...?widget.actions,
          AppSpacing.horizontalGapMD,
          _buildUserMenu(),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Column(
      children: [
        // Logo/Brand Area
        Container(
          height: 72,
          padding: AppSpacing.paddingLG,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.gray200, width: 1),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.rocket_launch_rounded,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
              if (!_sidebarCollapsed) ...[
                AppSpacing.horizontalGapMD,
                Expanded(
                  child: Text(
                    'Hackathon\nAdmin',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.gray900,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // Navigation Menu
        Expanded(
          child: Padding(
            padding: AppSpacing.paddingMD,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_sidebarCollapsed) ...[
                  Text(
                    'MAIN MENU',
                    style: AppTypography.overline.copyWith(
                      color: AppColors.gray500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.verticalGapMD,
                ],
                
                _buildNavItem(
                  icon: Icons.dashboard_rounded,
                  title: 'Dashboard',
                  route: '/dashboard',
                  isActive: true,
                ),
                _buildNavItem(
                  icon: Icons.event_rounded,
                  title: 'Hackathons',
                  route: '/hackathons',
                ),
                _buildNavItem(
                  icon: Icons.add_circle_rounded,
                  title: 'Create Hackathon',
                  route: '/hackathon/create',
                ),
                _buildNavItem(
                  icon: Icons.people_rounded,
                  title: 'Participants',
                  route: '/participants',
                ),
                _buildNavItem(
                  icon: Icons.assessment_rounded,
                  title: 'Analytics',
                  route: '/analytics',
                ),
                
                AppSpacing.verticalGapLG,
                
                if (!_sidebarCollapsed) ...[
                  Text(
                    'SETTINGS',
                    style: AppTypography.overline.copyWith(
                      color: AppColors.gray500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  AppSpacing.verticalGapMD,
                ],
                
                _buildNavItem(
                  icon: Icons.settings_rounded,
                  title: 'Settings',
                  route: '/settings',
                ),
                _buildNavItem(
                  icon: Icons.help_rounded,
                  title: 'Help & Support',
                  route: '/help',
                ),
              ],
            ),
          ),
        ),
        
        // User Profile Section
        if (!_sidebarCollapsed)
          Container(
            padding: AppSpacing.paddingMD,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.gray200, width: 1),
              ),
            ),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          state.user.name.substring(0, 1).toUpperCase(),
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      AppSpacing.horizontalGapMD,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.user.name,
                              style: AppTypography.labelMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              state.user.email,
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.gray500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
      ],
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required String route,
    bool isActive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppBorderRadius.radiusLG,
          onTap: () {
            // Navigation logic here
            Navigator.of(context).pushNamed(route);
          },
          child: Container(
            padding: AppSpacing.paddingMD,
            decoration: BoxDecoration(
              color: isActive 
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
              borderRadius: AppBorderRadius.radiusLG,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive ? AppColors.primary : AppColors.gray600,
                  size: 20,
                ),
                if (!_sidebarCollapsed) ...[
                  AppSpacing.horizontalGapMD,
                  Expanded(
                    child: Text(
                      title,
                      style: AppTypography.labelMedium.copyWith(
                        color: isActive ? AppColors.primary : AppColors.gray700,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserMenu() {
    return PopupMenuButton<String>(
      child: Container(
        padding: AppSpacing.paddingSM,
        decoration: BoxDecoration(
          color: AppColors.gray100,
          borderRadius: AppBorderRadius.radiusFull,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthAuthenticated) {
                    return Text(
                      state.user.name.substring(0, 1).toUpperCase(),
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }
                  return const Icon(Icons.person, size: 16);
                },
              ),
            ),
            AppSpacing.horizontalGapSM,
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: AppColors.gray600,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person_outline_rounded),
              SizedBox(width: 12),
              Text('Profile'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings_outlined),
              SizedBox(width: 12),
              Text('Settings'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout_rounded, color: AppColors.error),
              SizedBox(width: 12),
              Text('Logout', style: TextStyle(color: AppColors.error)),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'logout':
            context.read<AuthCubit>().logout();
            break;
          case 'profile':
            // Navigate to profile
            break;
          case 'settings':
            // Navigate to settings
            break;
        }
      },
    );
  }
}
