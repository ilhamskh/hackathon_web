import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/utils/responsive_utils.dart';
import '../../../shared/widgets/custom_widgets.dart';
import '../providers/hackathon_wizard_provider.dart';

class WizardLayout extends StatelessWidget {
  final Widget child;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onSubmit;
  final bool showPreview;

  const WizardLayout({
    super.key,
    required this.child,
    this.onNext,
    this.onPrevious,
    this.onSubmit,
    this.showPreview = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HackathonWizardProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: Text(
              'Create Hackathon',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            centerTitle: false,
            actions: [
              if (showPreview)
                TextButton.icon(
                  onPressed: () => _showPreview(context, provider),
                  icon: const Icon(Icons.preview),
                  label: const Text('Preview'),
                ),
              const SizedBox(width: 16),
            ],
          ),
          body: ResponsiveUtils.isMobile(context)
              ? _buildMobileLayout(context, provider)
              : _buildDesktopLayout(context, provider),
        );
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context, HackathonWizardProvider provider) {
    return Column(
      children: [
        _buildProgressIndicator(context, provider),
        Expanded(
          child: SingleChildScrollView(
            padding: ResponsiveUtils.getResponsivePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepHeader(context, provider),
                const SizedBox(height: 24),
                child,
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        _buildNavigationButtons(context, provider),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, HackathonWizardProvider provider) {
    return Row(
      children: [
        // Sidebar with steps
        Container(
          width: 300,
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          child: Column(
            children: [
              const SizedBox(height: 24),
              _buildStepsList(context, provider),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(24),
                child: _buildNavigationButtons(context, provider),
              ),
            ],
          ),
        ),
        // Main content
        Expanded(
          child: SingleChildScrollView(
            padding: ResponsiveUtils.getResponsivePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepHeader(context, provider),
                const SizedBox(height: 24),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveUtils.getResponsiveContainerWidth(context),
                  ),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context, HackathonWizardProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Row(
            children: [
              for (int i = 0; i < 3; i++) ...[
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: i <= provider.currentStep
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (i < 2) const SizedBox(width: 8),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Step ${provider.currentStep + 1} of 3',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsList(BuildContext context, HackathonWizardProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Steps',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < 3; i++)
            _buildStepItem(context, provider, i),
        ],
      ),
    );
  }

  Widget _buildStepItem(BuildContext context, HackathonWizardProvider provider, int step) {
    final isActive = step == provider.currentStep;
    final isCompleted = step < provider.currentStep;
    final isClickable = step <= provider.currentStep;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: isClickable ? () => provider.goToStep(step) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : null,
            borderRadius: BorderRadius.circular(8),
            border: isActive
                ? Border.all(color: Theme.of(context).colorScheme.primary)
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? Theme.of(context).colorScheme.primary
                      : isActive
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                          : Theme.of(context).colorScheme.outline.withOpacity(0.3),
                ),
                child: Center(
                  child: isCompleted
                      ? Icon(
                          Icons.check,
                          size: 16,
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      : Text(
                          '${step + 1}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isActive
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.getStepTitle(step),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                        color: isActive
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      provider.getStepDescription(step),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepHeader(BuildContext context, HackathonWizardProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          provider.getStepTitle(provider.currentStep),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          provider.getStepDescription(provider.currentStep),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        if (provider.error != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    provider.error!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context, HackathonWizardProvider provider) {
    return Container(
      padding: ResponsiveUtils.isMobile(context)
          ? const EdgeInsets.all(16)
          : EdgeInsets.zero,
      decoration: ResponsiveUtils.isMobile(context)
          ? BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            )
          : null,
      child: Row(
        children: [
          if (provider.canGoBack)
            Expanded(
              child: ModernButton(
                text: 'Previous',
                onPressed: onPrevious ?? provider.previousStep,
                isOutlined: true,
                icon: Icons.arrow_back,
              ),
            ),
          if (provider.canGoBack) const SizedBox(width: 16),
          Expanded(
            child: ModernButton(
              text: provider.isLastStep ? 'Create Hackathon' : 'Next',
              onPressed: provider.isLoading
                  ? null
                  : provider.isLastStep
                      ? onSubmit
                      : provider.canProceedToNextStep
                          ? (onNext ?? provider.nextStep)
                          : null,
              isLoading: provider.isLoading,
              icon: provider.isLastStep ? Icons.check : Icons.arrow_forward,
            ),
          ),
        ],
      ),
    );
  }

  void _showPreview(BuildContext context, HackathonWizardProvider provider) {
    final hackathon = provider.getPreviewData();
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.preview,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Hackathon Preview',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPreviewSection(context, 'General Information', [
                        _buildPreviewItem(context, 'Name', hackathon.name),
                        _buildPreviewItem(context, 'Description', hackathon.description),
                        _buildPreviewItem(context, 'Type', hackathon.type),
                        if (hackathon.themeOrFocus?.isNotEmpty == true)
                          _buildPreviewItem(context, 'Theme/Focus', hackathon.themeOrFocus!),
                      ]),
                      const SizedBox(height: 24),
                      _buildPreviewSection(context, 'Event Details', [
                        _buildPreviewItem(context, 'Start Date', _formatDateTime(hackathon.startDate)),
                        _buildPreviewItem(context, 'End Date', _formatDateTime(hackathon.endDate)),
                        _buildPreviewItem(context, 'Prize Pool', hackathon.prizePoolDetails),
                      ]),
                      const SizedBox(height: 24),
                      _buildPreviewSection(context, 'Participant Settings', [
                        _buildPreviewItem(context, 'Rules', hackathon.rules),
                        _buildPreviewItem(context, 'Team Size', '${hackathon.minTeamSize} - ${hackathon.maxTeamSize} members'),
                        if (hackathon.registrationFee != null)
                          _buildPreviewItem(context, 'Registration Fee', hackathon.formattedRegistrationFee),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildPreviewItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${_formatTime(dateTime)}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour == 0
        ? 12
        : dateTime.hour > 12
            ? dateTime.hour - 12
            : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
