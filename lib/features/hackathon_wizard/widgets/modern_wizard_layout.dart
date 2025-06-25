import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/wizard_cubit.dart';
import '../../../shared/utils/responsive_utils.dart';

class ModernWizardLayout extends StatelessWidget {
  const ModernWizardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WizardCubit, WizardState>(
      builder: (context, state) {
        if (state is WizardStepChanged) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Create Hackathon'),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            body: Row(
              children: [
                if (!ResponsiveUtils.isMobile(context))
                  Container(
                    width: 250,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      border: Border(
                        right: BorderSide(
                          color: Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                    child: _buildSidebar(context, state),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      if (ResponsiveUtils.isMobile(context))
                        _buildMobileProgress(context, state),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: _buildStepContent(context, state),
                        ),
                      ),
                      _buildBottomNavigation(context, state),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        if (state is WizardSubmitting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Creating hackathon...'),
                ],
              ),
            ),
          );
        }

        if (state is WizardSubmitted) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Hackathon Created Successfully!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Hackathon "${state.hackathon.name}" has been created.'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Back to Dashboard'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is WizardError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Error',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(state.message),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WizardCubit>().reset();
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context, WizardStepChanged state) {
    final steps = [
      ('General Information', WizardStep.generalInformation, Icons.info),
      ('Event Details', WizardStep.eventDetails, Icons.event),
      ('Participant Settings', WizardStep.participantSettings, Icons.people),
      ('Judge Configuration', WizardStep.judgeConfiguration, Icons.gavel),
      ('Review & Submit', WizardStep.reviewAndSubmit, Icons.check),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        final isActive = step.$2 == state.currentStep;
        final isCompleted = step.$2.index < state.currentStep.index;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? Theme.of(context).primaryColor
                    : isCompleted
                        ? Colors.green
                        : Colors.grey[300],
              ),
              child: Icon(
                isCompleted ? Icons.check : step.$3,
                color: isActive || isCompleted ? Colors.white : Colors.grey[600],
                size: 18,
              ),
            ),
            title: Text(
              step.$1,
              style: TextStyle(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Theme.of(context).primaryColor : null,
              ),
            ),
            onTap: () {
              // Allow navigation to completed or current step
              if (isCompleted || isActive) {
                context.read<WizardCubit>().goToStep(step.$2);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildMobileProgress(BuildContext context, WizardStepChanged state) {
    final currentIndex = state.currentStep.index;
    final totalSteps = WizardStep.values.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${currentIndex + 1} of $totalSteps',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '${((currentIndex + 1) / totalSteps * 100).round()}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (currentIndex + 1) / totalSteps,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, WizardStepChanged state) {
    switch (state.currentStep) {
      case WizardStep.generalInformation:
        return _buildGeneralInformationStep(context, state);
      case WizardStep.eventDetails:
        return _buildEventDetailsStep(context, state);
      case WizardStep.participantSettings:
        return _buildParticipantSettingsStep(context, state);
      case WizardStep.judgeConfiguration:
        return _buildJudgeConfigurationStep(context, state);
      case WizardStep.reviewAndSubmit:
        return _buildReviewStep(context, state);
    }
  }

  Widget _buildGeneralInformationStep(BuildContext context, WizardStepChanged state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General Information',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Provide basic information about your hackathon event.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          
          // Hackathon Name
          TextFormField(
            initialValue: state.hackathon.name,
            decoration: const InputDecoration(
              labelText: 'Hackathon Name *',
              hintText: 'e.g., CodeFest 2025',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              context.read<WizardCubit>().updateGeneralInformation(name: value);
            },
          ),
          const SizedBox(height: 16),

          // Description
          TextFormField(
            initialValue: state.hackathon.description,
            decoration: const InputDecoration(
              labelText: 'Description *',
              hintText: 'Describe your hackathon event, themes, and goals',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            onChanged: (value) {
              context.read<WizardCubit>().updateGeneralInformation(description: value);
            },
          ),
          const SizedBox(height: 16),

          // Hackathon Type
          DropdownButtonFormField<String>(
            value: state.hackathon.type,
            decoration: const InputDecoration(
              labelText: 'Hackathon Type *',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Online', child: Text('Online')),
              DropdownMenuItem(value: 'Offline', child: Text('Offline')),
              DropdownMenuItem(value: 'Hybrid', child: Text('Hybrid')),
            ],
            onChanged: (value) {
              if (value != null) {
                context.read<WizardCubit>().updateGeneralInformation(type: value);
              }
            },
          ),
          const SizedBox(height: 16),

          // Theme or Focus Area
          TextFormField(
            initialValue: state.hackathon.themeOrFocus ?? '',
            decoration: const InputDecoration(
              labelText: 'Theme or Focus Area',
              hintText: 'e.g., AI for Healthcare, Sustainable Tech',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              context.read<WizardCubit>().updateGeneralInformation(themeOrFocus: value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetailsStep(BuildContext context, WizardStepChanged state) {
    return const Center(
      child: Text('Event Details Step - Coming Soon'),
    );
  }

  Widget _buildParticipantSettingsStep(BuildContext context, WizardStepChanged state) {
    return const Center(
      child: Text('Participant Settings Step - Coming Soon'),
    );
  }

  Widget _buildJudgeConfigurationStep(BuildContext context, WizardStepChanged state) {
    return const Center(
      child: Text('Judge Configuration Step - Coming Soon'),
    );
  }

  Widget _buildReviewStep(BuildContext context, WizardStepChanged state) {
    return const Center(
      child: Text('Review & Submit Step - Coming Soon'),
    );
  }

  Widget _buildBottomNavigation(BuildContext context, WizardStepChanged state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (context.read<WizardCubit>().canGoPrevious)
            OutlinedButton.icon(
              onPressed: () {
                context.read<WizardCubit>().previousStep();
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
            )
          else
            const SizedBox.shrink(),
          
          if (state.currentStep == WizardStep.reviewAndSubmit)
            ElevatedButton.icon(
              onPressed: () {
                context.read<WizardCubit>().submitHackathon();
              },
              icon: const Icon(Icons.send),
              label: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            )
          else if (context.read<WizardCubit>().canGoNext)
            ElevatedButton.icon(
              onPressed: () {
                context.read<WizardCubit>().nextStep();
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Next'),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}
