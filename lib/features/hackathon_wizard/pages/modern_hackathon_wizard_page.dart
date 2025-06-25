import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/animations/app_animations.dart';
import '../../../shared/widgets/custom_widgets.dart';
import '../../../shared/utils/responsive_utils.dart';
import '../../../shared/services/http_service.dart';
import '../cubit/wizard_cubit.dart';

class ModernHackathonWizardPage extends StatefulWidget {
  const ModernHackathonWizardPage({super.key});

  @override
  State<ModernHackathonWizardPage> createState() => _ModernHackathonWizardPageState();
}

class _ModernHackathonWizardPageState extends State<ModernHackathonWizardPage>
    with TickerProviderStateMixin {
  late AnimationController _pageController;
  late AnimationController _stepController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _pageController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _stepController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pageController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _pageController, curve: Curves.easeOutCubic));
    
    _pageController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _stepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WizardCubit(context.read<HttpService>()),
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: const _WizardView(),
          ),
        ),
      ),
    );
  }
}

class _WizardView extends StatefulWidget {
  const _WizardView();

  @override
  State<_WizardView> createState() => _WizardViewState();
}

class _WizardViewState extends State<_WizardView>
    with TickerProviderStateMixin {
  late AnimationController _sidebarController;
  late AnimationController _contentController;

  @override
  void initState() {
    super.initState();
    _sidebarController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _sidebarController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WizardCubit, WizardState>(
      builder: (context, state) {
        if (state is WizardStepChanged) {
          return ResponsiveUtils.isMobile(context)
              ? _buildMobileLayout(state)
              : _buildDesktopLayout(state);
        }
        
        return _buildLoadingState();
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildMobileLayout(WizardStepChanged state) {
    return Column(
      children: [
        _buildMobileHeader(state),
        _buildMobileProgress(state),
        Expanded(
          child: _buildStepContent(state),
        ),
        _buildBottomNavigation(state),
      ],
    );
  }

  Widget _buildDesktopLayout(WizardStepChanged state) {
    return Row(
      children: [
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _sidebarController,
            curve: Curves.easeOutCubic,
          )),
          child: Container(
            width: 350,
            child: _buildSidebar(state),
          ),
        ),
        Expanded(
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _contentController,
              curve: Curves.easeOutCubic,
            )),
            child: Column(
              children: [
                _buildHeader(state),
                Expanded(
                  child: _buildStepContent(state),
                ),
                _buildBottomNavigation(state),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileHeader(WizardStepChanged state) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 16),
          Text(
            'Create Hackathon',
            style: AppTextStyles.h5.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(WizardStepChanged state) {
    return Container(
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
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create New Hackathon',
                  style: AppTextStyles.h4.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Step ${_getStepNumber(state.currentStep)} of 5',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ModernButton(
            text: 'Save Draft',
            isOutlined: true,
            onPressed: () {
              // Save draft functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(WizardStepChanged state) {
    final steps = [
      _StepInfo(
        step: WizardStep.generalInformation,
        title: 'General Information',
        subtitle: 'Basic hackathon details',
        icon: Icons.info_outline,
      ),
      _StepInfo(
        step: WizardStep.eventDetails,
        title: 'Event Details',
        subtitle: 'Dates, duration & logistics',
        icon: Icons.event_outlined,
      ),
      _StepInfo(
        step: WizardStep.participantSettings,
        title: 'Participant Settings',
        subtitle: 'Team size & registration',
        icon: Icons.people_outline,
      ),
      _StepInfo(
        step: WizardStep.judgeConfiguration,
        title: 'Judge Configuration',
        subtitle: 'Judging criteria & panel',
        icon: Icons.gavel_outlined,
      ),
      _StepInfo(
        step: WizardStep.reviewAndSubmit,
        title: 'Review & Submit',
        subtitle: 'Final review & publication',
        icon: Icons.check_circle_outline,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.rocket_launch,
                        color: AppColors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hackathon Wizard',
                            style: AppTextStyles.h6.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Create your event',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                LinearProgressIndicator(
                  value: (_getStepNumber(state.currentStep) - 1) / 4,
                  backgroundColor: AppColors.grey200,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: steps.length,
              itemBuilder: (context, index) {
                final stepInfo = steps[index];
                final isActive = stepInfo.step == state.currentStep;
                final isCompleted = _getStepNumber(stepInfo.step) < _getStepNumber(state.currentStep);
                
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 200 + (index * 100)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(-50 * (1 - value), 0),
                      child: Opacity(
                        opacity: value,
                        child: _buildStepItem(stepInfo, isActive, isCompleted, state),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(_StepInfo stepInfo, bool isActive, bool isCompleted, WizardStepChanged state) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.read<WizardCubit>().goToStep(stepInfo.step);
          },
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isActive
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.success
                        : isActive
                            ? AppColors.primary
                            : AppColors.grey300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : stepInfo.icon,
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stepInfo.title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                          color: isActive ? AppColors.primary : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        stepInfo.subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileProgress(WizardStepChanged state) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${_getStepNumber(state.currentStep)} of 5',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${((_getStepNumber(state.currentStep) - 1) / 4 * 100).round()}% Complete',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_getStepNumber(state.currentStep) - 1) / 4,
            backgroundColor: AppColors.grey200,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(WizardStepChanged state) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: AppAnimations.fadeIn(
          _getStepWidget(state.currentStep, state),
          duration: const Duration(milliseconds: 500),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(WizardStepChanged state) {
    final isFirstStep = state.currentStep == WizardStep.generalInformation;
    final isLastStep = state.currentStep == WizardStep.reviewAndSubmit;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (!isFirstStep)
            Expanded(
              child: ModernButton(
                text: 'Previous',
                isOutlined: true,
                icon: Icons.arrow_back,
                onPressed: () {
                  context.read<WizardCubit>().previousStep();
                },
              ),
            ),
          if (!isFirstStep) const SizedBox(width: 16),
          Expanded(
            flex: isFirstStep ? 1 : 1,
            child: ModernButton(
              text: isLastStep ? 'Create Hackathon' : 'Next',
              icon: isLastStep ? Icons.rocket_launch : Icons.arrow_forward,
              onPressed: () {
                if (isLastStep) {
                  context.read<WizardCubit>().submitHackathon();
                } else {
                  context.read<WizardCubit>().nextStep();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getStepWidget(WizardStep step, WizardStepChanged state) {
    switch (step) {
      case WizardStep.generalInformation:
        return _buildGeneralInfoStep(state);
      case WizardStep.eventDetails:
        return _buildEventDetailsStep(state);
      case WizardStep.participantSettings:
        return _buildParticipantSettingsStep(state);
      case WizardStep.judgeConfiguration:
        return _buildJudgeConfigStep(state);
      case WizardStep.reviewAndSubmit:
        return _buildReviewStep(state);
    }
  }

  Widget _buildGeneralInfoStep(WizardStepChanged state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'General Information',
          style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Let\'s start with the basic information about your hackathon.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),
        AppAnimations.staggeredList(
          children: [
            const ModernTextField(
              label: 'Hackathon Name',
              hint: 'Enter a catchy name for your hackathon',
            ),
            const SizedBox(height: 24),
            const ModernTextField(
              label: 'Description',
              hint: 'Describe what your hackathon is about',
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            const ModernTextField(
              label: 'Theme/Focus Area',
              hint: 'e.g., AI, Blockchain, Healthcare (optional)',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventDetailsStep(WizardStepChanged state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event Details',
          style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Configure the dates, duration, and logistics of your event.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),
        AppAnimations.staggeredList(
          children: [
            Row(
              children: [
                Expanded(
                  child: ModernTextField(
                    label: 'Start Date & Time',
                    hint: 'Select start date',
                    suffixIcon: Icons.calendar_today,
                    onSuffixIconPressed: () {
                      // Show date picker
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ModernTextField(
                    label: 'End Date & Time',
                    hint: 'Select end date',
                    suffixIcon: Icons.calendar_today,
                    onSuffixIconPressed: () {
                      // Show date picker
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const ModernTextField(
              label: 'Prize Pool Details',
              hint: 'Describe the prizes and awards',
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            const ModernTextField(
              label: 'Rules & Guidelines',
              hint: 'Enter the rules and guidelines for participants',
              maxLines: 5,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildParticipantSettingsStep(WizardStepChanged state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Participant Settings',
          style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Configure team sizes, registration fees, and participant requirements.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),
        AppAnimations.staggeredList(
          children: [
            Row(
              children: [
                Expanded(
                  child: ModernTextField(
                    label: 'Minimum Team Size',
                    hint: '1',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ModernTextField(
                    label: 'Maximum Team Size',
                    hint: '5',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const ModernTextField(
              label: 'Registration Fee',
              hint: 'Enter amount (leave empty for free)',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            const ModernTextField(
              label: 'Fee Justification',
              hint: 'Explain what the registration fee covers',
              maxLines: 3,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildJudgeConfigStep(WizardStepChanged state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Judge Configuration',
          style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Set up judging criteria and configure the judging panel.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),
        AppAnimations.staggeredList(
          children: [
            ModernCard(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Judging Criteria',
                      style: AppTextStyles.h6.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text('• Innovation and Creativity'),
                    const Text('• Technical Implementation'),
                    const Text('• User Experience'),
                    const Text('• Business Viability'),
                    const Text('• Presentation Quality'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ModernButton(
              text: 'Add Judge',
              icon: Icons.person_add,
              isOutlined: true,
              onPressed: () {
                // Add judge functionality
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewStep(WizardStepChanged state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review & Submit',
          style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Review all the details before creating your hackathon.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),
        AppAnimations.staggeredList(
          children: [
            _buildReviewSection('General Information', [
              'Name: AI Innovation Challenge 2024',
              'Description: Build the next generation...',
              'Theme: Artificial Intelligence',
            ]),
            const SizedBox(height: 20),
            _buildReviewSection('Event Details', [
              'Start: Dec 15, 2024 9:00 AM',
              'End: Dec 17, 2024 6:00 PM',
              'Duration: 2 days 9 hours',
            ]),
            const SizedBox(height: 20),
            _buildReviewSection('Participant Settings', [
              'Team Size: 1-5 members',
              'Registration: Free',
              'Max Participants: Unlimited',
            ]),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewSection(String title, List<String> items) {
    return ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.h6.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                item,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  int _getStepNumber(WizardStep step) {
    switch (step) {
      case WizardStep.generalInformation:
        return 1;
      case WizardStep.eventDetails:
        return 2;
      case WizardStep.participantSettings:
        return 3;
      case WizardStep.judgeConfiguration:
        return 4;
      case WizardStep.reviewAndSubmit:
        return 5;
    }
  }
}

class _StepInfo {
  final WizardStep step;
  final String title;
  final String subtitle;
  final IconData icon;

  _StepInfo({
    required this.step,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}
