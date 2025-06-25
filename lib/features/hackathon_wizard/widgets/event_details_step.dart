import 'package:flutter/material.dart';
import 'package:hackathon_web/shared/widgets/modern_widgets.dart';
import 'package:provider/provider.dart';
import '../../../shared/utils/validation_utils.dart';
import '../providers/hackathon_wizard_provider.dart';

class EventDetailsStep extends StatelessWidget {
  const EventDetailsStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HackathonWizardProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Start Date and Time
            ModernDateTimePicker(
              label: 'Start Date and Time',
              value: provider.startDate,
              onChanged: provider.updateStartDate,
              required: true,
              hint: 'Select when the hackathon begins',
              validator: (value) =>
                  ValidationUtils.validateDate(value, fieldName: 'Start date'),
            ),
            const SizedBox(height: 24),

            // End Date and Time
            ModernDateTimePicker(
              label: 'End Date and Time',
              value: provider.endDate,
              onChanged: provider.updateEndDate,
              required: true,
              hint: 'Select when the hackathon ends',
              validator: (value) {
                final dateValidation = ValidationUtils.validateDate(
                  value,
                  fieldName: 'End date',
                );
                if (dateValidation != null) return dateValidation;

                if (provider.startDate != null && value != null) {
                  return ValidationUtils.validateDateRange(
                    provider.startDate!,
                    value,
                  );
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Duration Display
            if (provider.startDate != null && provider.endDate != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Duration: ${_getDurationString(provider.startDate!, provider.endDate!)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            if (provider.startDate != null && provider.endDate != null)
              const SizedBox(height: 24),

            // Prize Pool Details
            ModernTextField(
              label: 'Prize Pool Details',
              hint:
                  'e.g., \$10,000 total: 1st - \$5,000, 2nd - \$3,000, 3rd - \$2,000',
              value: provider.prizePoolDetails,
              onChanged: provider.updatePrizePoolDetails,
              required: true,
              maxLines: 3,
              validator: (value) => ValidationUtils.validateRequired(
                value,
                fieldName: 'Prize pool details',
              ),
            ),
            const SizedBox(height: 24),

            // Registration Fee (Optional)
            Row(
              children: [
                Expanded(
                  child: ModernTextField(
                    label: 'Registration Fee',
                    hint: 'Enter amount or leave empty for free',
                    value: provider.registrationFee?.toString() ?? '',
                    onChanged: (value) {
                      if (value.isEmpty) {
                        provider.updateRegistrationFee(null);
                      } else {
                        final fee = double.tryParse(value);
                        if (fee != null && fee >= 0) {
                          provider.updateRegistrationFee(fee);
                        }
                      }
                    },
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        provider.registrationFee == null ||
                            provider.registrationFee == 0
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    provider.registrationFee == null ||
                            provider.registrationFee == 0
                        ? 'FREE'
                        : 'PAID',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                          provider.registrationFee == null ||
                              provider.registrationFee == 0
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),

            // Registration Fee Justification (if fee is set)
            if (provider.registrationFee != null &&
                provider.registrationFee! > 0) ...[
              const SizedBox(height: 16),
              ModernTextField(
                label: 'Registration Fee Justification',
                hint: 'e.g., Covers venue and catering costs',
                value: provider.registrationFeeJustification,
                onChanged: provider.updateRegistrationFeeJustification,
                required: false,
                maxLines: 2,
              ),
            ],

            const SizedBox(height: 24),

            // Information Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.secondaryContainer.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withOpacity(0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.event,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Event Planning Tips',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Consider time zones for online events. A typical hackathon duration is 24-48 hours. Make sure your prize structure is clear and motivating for participants.',
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

  String _getDurationString(DateTime startDate, DateTime endDate) {
    final difference = endDate.difference(startDate);

    if (difference.inDays > 0) {
      final hours = difference.inHours % 24;
      if (hours > 0) {
        return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} and $hours hour${hours == 1 ? '' : 's'}';
      } else {
        return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'}';
      }
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'}';
    } else {
      return 'Less than a minute';
    }
  }
}
