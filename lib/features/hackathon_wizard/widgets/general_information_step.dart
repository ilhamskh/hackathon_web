import 'package:flutter/material.dart';
import 'package:hackathon_web/shared/widgets/modern_widgets.dart';
import 'package:provider/provider.dart';
import '../../../shared/utils/validation_utils.dart';
import '../../../config/app_config.dart';
import '../providers/hackathon_wizard_provider.dart';

class GeneralInformationStep extends StatelessWidget {
  const GeneralInformationStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HackathonWizardProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hackathon Name
            ModernTextField(
              label: 'Hackathon Name',
              hint: 'e.g., CodeFest 2025',
              value: provider.name,
              onChanged: provider.updateName,
              required: true,
              validator: (value) => ValidationUtils.validateRequired(
                value,
                fieldName: 'Hackathon name',
              ),
            ),
            const SizedBox(height: 24),

            // Description
            ModernTextField(
              label: 'Description',
              hint:
                  'Provide a detailed overview of the event\'s purpose, themes, or goals',
              value: provider.description,
              onChanged: provider.updateDescription,
              required: true,
              maxLines: 4,
              validator: (value) => ValidationUtils.validateMinLength(
                value,
                50,
                fieldName: 'Description',
              ),
            ),
            const SizedBox(height: 24),

            // Hackathon Type
            ModernDropdown(
              label: 'Hackathon Type',
              value: provider.type.isNotEmpty ? provider.type : null,
              items: AppConfig.hackathonTypes,
              onChanged: (value) => provider.updateType(value ?? ''),
              required: true,
              hint: 'Select event format',
              validator: (value) => ValidationUtils.validateRequired(
                value,
                fieldName: 'Hackathon type',
              ),
            ),
            const SizedBox(height: 24),

            // Theme or Focus Area (Optional)
            ModernTextField(
              label: 'Theme or Focus Area',
              hint: 'e.g., AI for Healthcare, Sustainable Tech (Optional)',
              value: provider.themeOrFocus,
              onChanged: provider.updateThemeOrFocus,
              required: false,
            ),
            const SizedBox(height: 24),

            // Information Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Getting Started',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'This step captures the core identity of your hackathon. Make sure to choose a unique name and provide a clear description that will help participants understand your event\'s purpose.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
