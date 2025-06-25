import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/animations/app_animations.dart';
import '../../../shared/widgets/custom_widgets.dart';
import '../../../shared/widgets/modern_sidebar.dart';
import '../../../shared/utils/responsive_utils.dart';
import '../cubit/dashboard_cubit.dart';

class ModernDashboardPage extends StatefulWidget {
  const ModernDashboardPage({super.key});

  @override
  State<ModernDashboardPage> createState() => _ModernDashboardPageState();
}

class _ModernDashboardPageState extends State<ModernDashboardPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit()..loadDashboardData(),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: _DashboardView(
          selectedIndex: _selectedIndex,
          onItemSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class _DashboardView extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const _DashboardView({
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final sidebarItems = [
      SidebarItem.category('Overview'),
      const SidebarItem(
        title: 'Dashboard',
        icon: Icons.dashboard_rounded,
        route: '/dashboard',
      ),
      const SidebarItem(
        title: 'Analytics',
        icon: Icons.analytics_rounded,
        route: '/analytics',
      ),

      SidebarItem.category('Management'),
      const SidebarItem(
        title: 'Hackathons',
        icon: Icons.event_rounded,
        route: '/hackathons',
        badge: '3',
      ),
      const SidebarItem(
        title: 'Participants',
        icon: Icons.people_rounded,
        route: '/participants',
      ),
      const SidebarItem(
        title: 'Teams',
        icon: Icons.groups_rounded,
        route: '/teams',
      ),
      const SidebarItem(
        title: 'Judges',
        icon: Icons.gavel_rounded,
        route: '/judges',
      ),

      SidebarItem.category('Content'),
      const SidebarItem(
        title: 'Create Event',
        icon: Icons.add_circle_rounded,
        route: '/create-hackathon',
      ),
      const SidebarItem(
        title: 'Templates',
        icon: Icons.library_books_rounded,
        route: '/templates',
      ),

      SidebarItem.category('System'),
      const SidebarItem(
        title: 'Settings',
        icon: Icons.settings_rounded,
        route: '/settings',
      ),
      const SidebarItem(
        title: 'Help',
        icon: Icons.help_rounded,
        route: '/help',
      ),
    ];

    return ResponsiveLayout(
      sidebarItems: sidebarItems,
      currentRoute: '/dashboard',
      onRouteChanged: (route) {
        // Handle navigation - will be connected to GoRouter later
        print('Navigate to: $route');
      },
      child: const _DashboardContent(),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DashboardError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: AppColors.error),
                const SizedBox(height: 16),
                Text('Error loading dashboard', style: AppTextStyles.h5),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ModernButton(
                  text: 'Retry',
                  onPressed: () {
                    context.read<DashboardCubit>().loadDashboardData();
                  },
                ),
              ],
            ),
          );
        }

        if (state is DashboardLoaded) {
          return _buildDashboard(context, state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDashboard(BuildContext context, DashboardLoaded state) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 32),
            _buildStatsCards(context, state, isMobile, isTablet),
            const SizedBox(height: 32),
            _buildChartsSection(context, state, isMobile),
            const SizedBox(height: 32),
            _buildRecentActivity(context, state, isMobile),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: ResponsiveUtils.isMobile(context),
      title: Row(
        children: [
          if (!ResponsiveUtils.isMobile(context)) ...[
            Text(
              'Dashboard',
              style: AppTextStyles.h4.copyWith(
                color: isDark ? AppColors.textDark : AppColors.textPrimary,
              ),
            ),
            const Spacer(),
          ],
          // Search bar
          SizedBox(
            width: ResponsiveUtils.isMobile(context) ? null : 300,
            child: const ModernTextField(
              hint: 'Search...',
              prefixIcon: Icons.search,
            ),
          ),
          const SizedBox(width: 16),
          // Theme toggle
          IconButton(
            onPressed: () {
              // TODO: Toggle theme
            },
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? AppColors.textDark : AppColors.textPrimary,
            ),
          ),
          // Notifications
          IconButton(
            onPressed: () {},
            icon: Badge(
              label: const Text('3'),
              child: Icon(
                Icons.notifications_outlined,
                color: isDark ? AppColors.textDark : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, John! 👋',
          style: AppTextStyles.h2.copyWith(
            color: isDark ? AppColors.textDark : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Here\'s what\'s happening with your hackathons today.',
          style: AppTextStyles.bodyLarge.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards(
    BuildContext context,
    DashboardLoaded state,
    bool isMobile,
    bool isTablet,
  ) {
    final crossAxisCount = isMobile ? 2 : (isTablet ? 3 : 4);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isMobile ? 1.5 : 1.8,
      children: [
        StatCard(
          title: 'Total Hackathons',
          value: '${state.stats.totalHackathons}',
          icon: Icons.event_rounded,
          iconColor: AppColors.primary,
          trend: '+12%',
          isPositiveTrend: true,
        ),
        StatCard(
          title: 'Active Events',
          value: '${state.stats.activeEvents}',
          icon: Icons.play_circle_rounded,
          iconColor: AppColors.success,
          trend: '+5%',
          isPositiveTrend: true,
        ),
        StatCard(
          title: 'Participants',
          value: '${state.stats.totalParticipants}',
          icon: Icons.people_rounded,
          iconColor: AppColors.info,
          trend: '+23%',
          isPositiveTrend: true,
        ),
        StatCard(
          title: 'Teams Formed',
          value: '${state.stats.teamsFormed}',
          icon: Icons.groups_rounded,
          iconColor: AppColors.warning,
          trend: '-2%',
          isPositiveTrend: false,
        ),
      ],
    );
  }

  Widget _buildChartsSection(
    BuildContext context,
    DashboardLoaded state,
    bool isMobile,
  ) {
    return Row(
      children: [
        Expanded(
          flex: isMobile ? 1 : 2,
          child: _buildEventTrendsChart(context),
        ),
        if (!isMobile) ...[
          const SizedBox(width: 24),
          Expanded(child: _buildTopHackathons(context, state)),
        ],
      ],
    );
  }

  Widget _buildEventTrendsChart(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Event Trends',
                style: AppTextStyles.h5.copyWith(
                  color: isDark ? AppColors.textDark : AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Last 6 months',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withOpacity(0.3),
                  AppColors.primary.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                '📊 Chart Placeholder\nIntegrate your favorite chart library',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHackathons(BuildContext context, DashboardLoaded state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Hackathons',
            style: AppTextStyles.h5.copyWith(
              color: isDark ? AppColors.textDark : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          ...state.topHackathons.map(
            (hackathon) => _buildHackathonItem(
              context,
              hackathon.name,
              hackathon.participants.toString(),
              hackathon.status,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHackathonItem(
    BuildContext context,
    String name,
    String participants,
    String status,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.code, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isDark ? AppColors.textDark : AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$participants participants',
                  style: AppTextStyles.caption.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: status == 'Active'
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: AppTextStyles.caption.copyWith(
                color: status == 'Active'
                    ? AppColors.success
                    : AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(
    BuildContext context,
    DashboardLoaded state,
    bool isMobile,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: AppTextStyles.h5.copyWith(
                  color: isDark ? AppColors.textDark : AppColors.textPrimary,
                ),
              ),
              ModernButton(
                text: 'View All',
                isOutlined: true,
                fontSize: 14,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...state.recentActivities.map(
            (activity) => _buildActivityItem(
              context,
              activity.title,
              activity.description,
              activity.time,
              activity.type,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    String title,
    String description,
    String time,
    String type,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getActivityColor(type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getActivityIcon(type),
              color: _getActivityColor(type),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isDark ? AppColors.textDark : AppColors.textPrimary,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: AppTextStyles.caption.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'event':
        return AppColors.primary;
      case 'user':
        return AppColors.success;
      case 'team':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'event':
        return Icons.event;
      case 'user':
        return Icons.person_add;
      case 'team':
        return Icons.group_add;
      default:
        return Icons.info;
    }
  }
}
