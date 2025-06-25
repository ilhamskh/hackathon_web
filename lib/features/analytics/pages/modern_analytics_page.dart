import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/animations/app_animations.dart';
import '../../../shared/widgets/custom_widgets.dart';
import '../../../shared/widgets/modern_sidebar.dart';
import '../../../shared/utils/responsive_utils.dart';
import '../../dashboard/cubit/dashboard_cubit.dart';

class ModernAnalyticsPage extends StatefulWidget {
  const ModernAnalyticsPage({super.key});

  @override
  State<ModernAnalyticsPage> createState() => _ModernAnalyticsPageState();
}

class _ModernAnalyticsPageState extends State<ModernAnalyticsPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int _selectedIndex = 1; // Analytics tab

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
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
        child: _AnalyticsView(
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

class _AnalyticsView extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const _AnalyticsView({
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
      ),
      const SidebarItem(
        title: 'Participants',
        icon: Icons.people_rounded,
        route: '/participants',
      ),
    ];

    return ResponsiveLayout(
      sidebarItems: sidebarItems,
      currentRoute: '/analytics',
      onRouteChanged: (route) {
        // Handle route changes
      },
      child: const _AnalyticsContent(),
    );
  }
}

class _AnalyticsContent extends StatefulWidget {
  const _AnalyticsContent();

  @override
  State<_AnalyticsContent> createState() => _AnalyticsContentState();
}

class _AnalyticsContentState extends State<_AnalyticsContent>
    with TickerProviderStateMixin {
  late AnimationController _chartController;
  late AnimationController _metricsController;
  String _selectedPeriod = '7d';

  @override
  void initState() {
    super.initState();
    _chartController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _metricsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _metricsController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _chartController.forward();
    });
  }

  @override
  void dispose() {
    _chartController.dispose();
    _metricsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          body: Column(
            children: [
              _buildAnimatedHeader(context),
              Expanded(child: _buildAnalyticsContent(context, state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedHeader(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: _metricsController,
              curve: Curves.easeOutCubic,
            ),
          ),
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analytics Dashboard',
                    style: AppTextStyles.h2.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textDark
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Comprehensive insights and metrics for your hackathons',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            _buildPeriodSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = [
      {'label': '7D', 'value': '7d'},
      {'label': '30D', 'value': '30d'},
      {'label': '90D', 'value': '90d'},
      {'label': '1Y', 'value': '1y'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.cardDark
            : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.grey600
              : AppColors.grey200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: periods.map((period) {
          final isSelected = _selectedPeriod == period['value'];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPeriod = period['value']!;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                period['label']!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAnalyticsContent(BuildContext context, DashboardState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildAnimatedMetrics(state),
          const SizedBox(height: 32),
          _buildAnimatedCharts(context),
          const SizedBox(height: 32),
          _buildPerformanceMetrics(context),
        ],
      ),
    );
  }

  Widget _buildAnimatedMetrics(DashboardState state) {
    final metrics = [
      {
        'title': 'Total Revenue',
        'value': '\$125,430',
        'trend': '+12.5%',
        'icon': Icons.attach_money,
        'color': AppColors.success,
        'isPositive': true,
      },
      {
        'title': 'Active Hackathons',
        'value': '12',
        'trend': '+2',
        'icon': Icons.event,
        'color': AppColors.primary,
        'isPositive': true,
      },
      {
        'title': 'Total Participants',
        'value': '2,847',
        'trend': '+18.7%',
        'icon': Icons.people,
        'color': AppColors.secondary,
        'isPositive': true,
      },
      {
        'title': 'Avg. Team Size',
        'value': '3.4',
        'trend': '-0.2',
        'icon': Icons.group,
        'color': AppColors.warning,
        'isPositive': false,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.isMobile(context) ? 2 : 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return AnimatedBuilder(
          animation: _metricsController,
          builder: (context, child) {
            final delay = index * 0.1;
            final animationValue = Curves.easeOutBack.transform(
              (_metricsController.value - delay).clamp(0.0, 1.0) /
                  (1.0 - delay),
            );

            return Transform.scale(
              scale: animationValue,
              child: Transform.translate(
                offset: Offset(0, 50 * (1 - animationValue)),
                child: Opacity(
                  opacity: animationValue,
                  child: _buildMetricCard(metric),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMetricCard(Map<String, dynamic> metric) {
    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (metric['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(metric['icon'], color: metric['color'], size: 20),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: metric['isPositive']
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        metric['isPositive']
                            ? Icons.trending_up
                            : Icons.trending_down,
                        size: 12,
                        color: metric['isPositive']
                            ? AppColors.success
                            : AppColors.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        metric['trend'],
                        style: AppTextStyles.bodySmall.copyWith(
                          color: metric['isPositive']
                              ? AppColors.success
                              : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              metric['value'],
              style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              metric['title'],
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCharts(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(-1, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _chartController,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: _buildRegistrationChart(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .animate(
                  CurvedAnimation(
                    parent: _chartController,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: _buildEventTypesChart(),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationChart() {
    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Registration Trends',
                  style: AppTextStyles.h6.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Icon(Icons.trending_up, color: AppColors.success, size: 20),
                const SizedBox(width: 4),
                Text(
                  '+24.5%',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(height: 200, child: _buildAnimatedLineChart()),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedLineChart() {
    return AnimatedBuilder(
      animation: _chartController,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(double.infinity, 200),
          painter: LineChartPainter(_chartController.value),
        );
      },
    );
  }

  Widget _buildEventTypesChart() {
    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Types',
              style: AppTextStyles.h6.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(height: 200, child: _buildAnimatedDonutChart()),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDonutChart() {
    return AnimatedBuilder(
      animation: _chartController,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(double.infinity, 200),
          painter: DonutChartPainter(_chartController.value),
        );
      },
    );
  }

  Widget _buildPerformanceMetrics(BuildContext context) {
    return AppAnimations.staggeredList(
      children: [
        Text(
          'Performance Insights',
          style: AppTextStyles.h5.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildPerformanceCard(
                'Completion Rate',
                '87.3%',
                Icons.check_circle,
                AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPerformanceCard(
                'Avg. Rating',
                '4.6/5',
                Icons.star,
                AppColors.warning,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildPerformanceCard(
                'Return Rate',
                '73.2%',
                Icons.repeat,
                AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildDetailedMetrics(),
      ],
    );
  }

  Widget _buildPerformanceCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              value,
              style: AppTextStyles.h4.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedMetrics() {
    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed Metrics',
              style: AppTextStyles.h6.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildMetricRow('Average Project Submissions', '156', 'per event'),
            _buildMetricRow('Team Formation Rate', '92%', 'of participants'),
            _buildMetricRow('Judge Satisfaction', '4.8/5', 'average rating'),
            _buildMetricRow(
              'Sponsor Engagement',
              '78%',
              'active participation',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: AppTextStyles.h6.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final double progress;

  LineChartPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.2, size.height * 0.6),
      Offset(size.width * 0.4, size.height * 0.4),
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.2),
      Offset(size.width, size.height * 0.1),
    ];

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        final animatedX = points[i].dx * progress;
        if (animatedX <= points[i].dx) {
          path.lineTo(animatedX, points[i].dy);
        }
      }
    }

    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      final animatedX = points[i].dx * progress;
      if (animatedX <= points[i].dx) {
        canvas.drawCircle(Offset(animatedX, points[i].dy), 4, pointPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DonutChartPainter extends CustomPainter {
  final double progress;

  DonutChartPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;
    final strokeWidth = 20.0;

    final data = [
      {'value': 40, 'color': AppColors.primary},
      {'value': 30, 'color': AppColors.secondary},
      {'value': 20, 'color': AppColors.warning},
      {'value': 10, 'color': AppColors.success},
    ];

    double startAngle = -90 * (3.14159 / 180);

    for (final item in data) {
      final sweepAngle = (item['value'] as int) / 100 * 2 * 3.14159 * progress;

      final paint = Paint()
        ..color = item['color'] as Color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
