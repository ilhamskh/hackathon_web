import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/animations/app_animations.dart';
import '../../../shared/widgets/custom_widgets.dart';
import '../../../shared/widgets/modern_sidebar.dart';
import '../../../shared/utils/responsive_utils.dart';
import '../../../shared/services/http_service.dart';
import '../cubit/hackathon_cubit.dart';
import '../../../shared/models/hackathon_model.dart';

class ModernHackathonListPage extends StatefulWidget {
  const ModernHackathonListPage({super.key});

  @override
  State<ModernHackathonListPage> createState() => _ModernHackathonListPageState();
}

class _ModernHackathonListPageState extends State<ModernHackathonListPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int _selectedIndex = 1; // Hackathons tab

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
      create: (context) => HackathonCubit(context.read<HttpService>())..loadHackathons(),
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: _HackathonListView(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          );
        },
      ),
    );
  }
}

class _HackathonListView extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const _HackathonListView({
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
        icon: Icons.group_rounded,
        route: '/teams',
      ),
      const SidebarItem(
        title: 'Submissions',
        icon: Icons.assignment_rounded,
        route: '/submissions',
      ),
      
      SidebarItem.category('Settings'),
      const SidebarItem(
        title: 'Configuration',
        icon: Icons.settings_rounded,
        route: '/settings',
      ),
    ];

    return ResponsiveLayout(
      sidebarItems: sidebarItems,
      currentRoute: '/hackathons',
      onRouteChanged: (route) {
        // Handle route changes
      },
      child: const _HackathonContent(),
    );
  }
}

class _HackathonContent extends StatefulWidget {
  const _HackathonContent();

  @override
  State<_HackathonContent> createState() => _HackathonContentState();
}

class _HackathonContentState extends State<_HackathonContent>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _listController;
  String _filterStatus = 'all';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _listController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _listController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HackathonCubit, HackathonState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          body: Column(
            children: [
              _buildAnimatedHeader(context),
              Expanded(
                child: _buildAnimatedContent(context, state),
              ),
            ],
          ),
          floatingActionButton: AppAnimations.floatingAction(
            FloatingActionButton.extended(
              onPressed: () {
                _showCreateHackathonDialog(context);
              },
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: AppColors.white),
              label: const Text(
                'New Hackathon',
                style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedHeader(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _headerController,
        curve: Curves.easeOutCubic,
      )),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.surfaceDark
              : AppColors.surfaceLight,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hackathons',
                        style: AppTextStyles.h2.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.textDark
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage and organize your hackathon events',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ModernButton(
                  text: 'Export Data',
                  icon: Icons.download,
                  isOutlined: true,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ModernTextField(
                    hint: 'Search hackathons...',
                    prefixIcon: Icons.search,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatusFilter(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.grey400.withOpacity(0.3)
              : AppColors.grey200,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _filterStatus,
          hint: const Text('Filter by status'),
          items: [
            DropdownMenuItem(value: 'all', child: Text('All Status')),
            DropdownMenuItem(value: 'active', child: Text('Active')),
            DropdownMenuItem(value: 'upcoming', child: Text('Upcoming')),
            DropdownMenuItem(value: 'completed', child: Text('Completed')),
          ],
          onChanged: (value) {
            setState(() {
              _filterStatus = value ?? 'all';
            });
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedContent(BuildContext context, HackathonState state) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _listController,
        curve: Curves.easeOutCubic,
      )),
      child: _buildContent(context, state),
    );
  }

  Widget _buildContent(BuildContext context, HackathonState state) {
    if (state is HackathonLoading) {
      return _buildLoadingState();
    }

    if (state is HackathonListLoaded) {
      var filteredHackathons = state.hackathons;
      
      if (_searchQuery.isNotEmpty) {
        filteredHackathons = filteredHackathons
            .where((h) => h.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();
      }
      
      if (_filterStatus != 'all') {
        filteredHackathons = filteredHackathons
            .where((h) => h.status?.toLowerCase() == _filterStatus)
            .toList();
      }

      if (filteredHackathons.isEmpty) {
        return _buildEmptyState();
      }

      return _buildHackathonGrid(filteredHackathons);
    }

    if (state is HackathonError) {
      return _buildErrorState(state.message);
    }

    return _buildEmptyState();
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.isMobile(context) ? 1 : 
                      ResponsiveUtils.isTablet(context) ? 2 : 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return AppAnimations.shimmer(
          child: ModernCard(
            child: Container(
              height: 200,
              color: Colors.grey[300],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: AppAnimations.scaleIn(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No hackathons found',
              style: AppTextStyles.h5.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first hackathon to get started',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ModernButton(
              text: 'Create Hackathon',
              icon: Icons.add,
              onPressed: () => _showCreateHackathonDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: AppAnimations.scaleIn(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading Hackathons',
              style: AppTextStyles.h5.copyWith(
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ModernButton(
              text: 'Retry',
              icon: Icons.refresh,
              onPressed: () {
                context.read<HackathonCubit>().loadHackathons();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHackathonGrid(List<HackathonModel> hackathons) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.isMobile(context) ? 1 : 
                      ResponsiveUtils.isTablet(context) ? 2 : 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: hackathons.length,
      itemBuilder: (context, index) {
        final hackathon = hackathons[index];
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 100)),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value,
                child: _buildHackathonCard(hackathon),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHackathonCard(HackathonModel hackathon) {
    return ModernCard(
      child: InkWell(
        onTap: () {
          // Navigate to hackathon details
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      hackathon.name,
                      style: AppTextStyles.h6.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusBadge(hackathon.status ?? 'draft'),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                hackathon.description,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(hackathon.startDate),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.people,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${hackathon.minTeamSize}-${hackathon.maxTeamSize} per team',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;

    switch (status.toLowerCase()) {
      case 'active':
        color = AppColors.success;
        text = 'Active';
        break;
      case 'upcoming':
        color = AppColors.warning;
        text = 'Upcoming';
        break;
      case 'completed':
        color = AppColors.textSecondary;
        text = 'Completed';
        break;
      default:
        color = AppColors.grey500;
        text = 'Draft';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showCreateHackathonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Hackathon'),
        content: const Text('Navigate to hackathon creation wizard?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ModernButton(
            text: 'Create',
            onPressed: () {
              Navigator.pop(context);
              // Navigate to wizard
            },
          ),
        ],
      ),
    );
  }
}
