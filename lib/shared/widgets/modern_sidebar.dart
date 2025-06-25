import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../utils/responsive_utils.dart';

class ModernSidebar extends StatelessWidget {
  final List<SidebarItem> items;
  final String selectedRoute;
  final Function(String) onItemSelected;
  final bool isCollapsed;
  final VoidCallback? onToggleCollapse;

  const ModernSidebar({
    super.key,
    required this.items,
    required this.selectedRoute,
    required this.onItemSelected,
    this.isCollapsed = false,
    this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: isCollapsed ? 80 : 280,
      decoration: BoxDecoration(
        color: isDark ? AppColors.sidebarDark : AppColors.sidebarLight,
        border: Border(
          right: BorderSide(
            color: isDark ? AppColors.grey700 : AppColors.grey200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.rocket_launch,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'HackAdmin',
                      style: AppTextStyles.sidebarTitle.copyWith(
                        color: isDark ? AppColors.textDark : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
                if (onToggleCollapse != null && !ResponsiveUtils.isMobile(context))
                  IconButton(
                    onPressed: onToggleCollapse,
                    icon: Icon(
                      isCollapsed ? Icons.menu_open : Icons.menu,
                      color: isDark ? AppColors.textDark : AppColors.textPrimary,
                    ),
                  ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Navigation Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                
                if (item.isCategory) {
                  return _buildCategoryHeader(context, item);
                }
                
                return _buildNavItem(context, item);
              },
            ),
          ),
          
          // Footer
          if (!isCollapsed)
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: const Icon(
                          Icons.person,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'John Doe',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: isDark ? AppColors.textDark : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Administrator',
                              style: AppTextStyles.caption.copyWith(
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(BuildContext context, SidebarItem item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (isCollapsed) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        item.title.toUpperCase(),
        style: AppTextStyles.sidebarCategory.copyWith(
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, SidebarItem item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = selectedRoute == item.route;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => onItemSelected(item.route!),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark ? AppColors.sidebarItemActiveDark : AppColors.sidebarItemActive)
                  : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 24,
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item.title,
                      style: AppTextStyles.sidebarItem.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.textDark : AppColors.textPrimary),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
                if (item.badge != null && !isCollapsed) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item.badge!,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
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
}

class SidebarItem {
  final String title;
  final IconData icon;
  final String? route;
  final String? badge;
  final bool isCategory;

  const SidebarItem({
    required this.title,
    required this.icon,
    this.route,
    this.badge,
    this.isCategory = false,
  });

  static SidebarItem category(String title) {
    return SidebarItem(
      title: title,
      icon: Icons.category,
      isCategory: true,
    );
  }
}

class ResponsiveLayout extends StatefulWidget {
  final Widget child;
  final List<SidebarItem> sidebarItems;
  final String currentRoute;
  final Function(String) onRouteChanged;

  const ResponsiveLayout({
    super.key,
    required this.child,
    required this.sidebarItems,
    required this.currentRoute,
    required this.onRouteChanged,
  });

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  bool _isSidebarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    
    if (isMobile) {
      return _buildMobileLayout();
    } else if (isTablet) {
      return _buildTabletLayout();
    } else {
      return _buildDesktopLayout();
    }
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: widget.child,
      drawer: ModernSidebar(
        items: widget.sidebarItems,
        selectedRoute: widget.currentRoute,
        onItemSelected: (route) {
          widget.onRouteChanged(route);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      body: Row(
        children: [
          ModernSidebar(
            items: widget.sidebarItems,
            selectedRoute: widget.currentRoute,
            onItemSelected: widget.onRouteChanged,
            isCollapsed: true,
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          ModernSidebar(
            items: widget.sidebarItems,
            selectedRoute: widget.currentRoute,
            onItemSelected: widget.onRouteChanged,
            isCollapsed: _isSidebarCollapsed,
            onToggleCollapse: () {
              setState(() {
                _isSidebarCollapsed = !_isSidebarCollapsed;
              });
            },
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
