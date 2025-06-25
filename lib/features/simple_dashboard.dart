import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/custom_widgets.dart';

class SimpleDashboard extends StatelessWidget {
  const SimpleDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'HackAdmin Dashboard',
          style: AppTextStyles.h5.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textDark
                : AppColors.textPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.surfaceLight,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              // Toggle theme
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(context),
            const SizedBox(height: 32),
            _buildStatsGrid(context),
            const SizedBox(height: 32),
            _buildQuickActions(context),
            const SizedBox(height: 32),
            _buildRecentActivity(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCreateDialog(context);
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: const Text(
          'New Hackathon',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return ModernCard(
      gradient: AppColors.primaryGradient,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, Admin!',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You have 3 active hackathons and 156 new registrations today.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ModernButton(
                    text: 'View Analytics',
                    backgroundColor: AppColors.white,
                    textColor: AppColors.primary,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.dashboard,
                size: 48,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    final stats = [
      {
        'title': 'Active Hackathons',
        'value': '12',
        'icon': Icons.event,
        'color': AppColors.primary,
        'trend': '+2 this month',
      },
      {
        'title': 'Total Participants',
        'value': '2,847',
        'icon': Icons.people,
        'color': AppColors.secondary,
        'trend': '+18% this month',
      },
      {
        'title': 'Projects Submitted',
        'value': '156',
        'icon': Icons.assignment,
        'color': AppColors.success,
        'trend': '+23% this month',
      },
      {
        'title': 'Total Revenue',
        'value': '\$125k',
        'icon': Icons.attach_money,
        'color': AppColors.warning,
        'trend': '+12% this month',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getGridCount(context),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return StatCard(
          title: stat['title'] as String,
          value: stat['value'] as String,
          icon: stat['icon'] as IconData,
          iconColor: stat['color'] as Color,
          subtitle: stat['trend'] as String,
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.h5.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ModernButton(
                text: 'Create Hackathon',
                icon: Icons.add_circle,
                onPressed: () => _showCreateDialog(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ModernButton(
                text: 'View Analytics',
                icon: Icons.analytics,
                isOutlined: true,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ModernButton(
                text: 'Export Data',
                icon: Icons.download,
                isOutlined: true,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    final activities = [
      'John Smith registered for AI Challenge 2024',
      'Team Alpha submitted project "Smart City"',
      'New hackathon "Blockchain Summit" created',
      'Judge panel confirmed for Web3 Challenge',
      'Prize pool updated for Mobile App Contest',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: AppTextStyles.h5.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ModernCard(
          child: Column(
            children: activities.asMap().entries.map((entry) {
              final index = entry.key;
              final activity = entry.value;
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Icon(
                        _getActivityIcon(index),
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      activity,
                      style: AppTextStyles.bodyMedium,
                    ),
                    subtitle: Text(
                      '${index + 1} hour${index == 0 ? '' : 's'} ago',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  if (index < activities.length - 1)
                    Divider(
                      height: 1,
                      color: AppColors.grey200.withOpacity(0.5),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  IconData _getActivityIcon(int index) {
    final icons = [
      Icons.person_add,
      Icons.upload,
      Icons.event,
      Icons.gavel,
      Icons.monetization_on,
    ];
    return icons[index % icons.length];
  }

  int _getGridCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 2;
    if (width < 900) return 3;
    return 4;
  }

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Hackathon'),
        content: const Text('Would you like to start the hackathon creation wizard?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ModernButton(
            text: 'Start Wizard',
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
