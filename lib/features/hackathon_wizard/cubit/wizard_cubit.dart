import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../shared/models/hackathon_model.dart';
import '../../../shared/services/http_service.dart';

// Wizard Steps Enum
enum WizardStep {
  generalInformation,
  eventDetails,
  participantSettings,
  judgeConfiguration,
  reviewAndSubmit,
}

// Wizard States
abstract class WizardState extends Equatable {
  const WizardState();

  @override
  List<Object?> get props => [];
}

class WizardInitial extends WizardState {}

class WizardStepChanged extends WizardState {
  final WizardStep currentStep;
  final HackathonModel hackathon;

  const WizardStepChanged({required this.currentStep, required this.hackathon});

  @override
  List<Object> get props => [currentStep, hackathon];
}

class WizardLoading extends WizardState {}

class WizardSubmitting extends WizardState {}

class WizardSubmitted extends WizardState {
  final HackathonModel hackathon;

  const WizardSubmitted(this.hackathon);

  @override
  List<Object> get props => [hackathon];
}

class WizardError extends WizardState {
  final String message;

  const WizardError(this.message);

  @override
  List<Object> get props => [message];
}

// Wizard Cubit
@injectable
class WizardCubit extends Cubit<WizardState> {
  final HttpService _httpService;

  WizardStep _currentStep = WizardStep.generalInformation;
  HackathonModel _hackathon = HackathonModel(
    name: '',
    description: '',
    type: 'Online',
    startDate: DateTime.now().add(const Duration(days: 30)),
    endDate: DateTime.now().add(const Duration(days: 32)),
    prizePoolDetails: '',
    rules: '',
    minTeamSize: 2,
    maxTeamSize: 6,
  );

  WizardCubit(this._httpService) : super(WizardInitial()) {
    _emitCurrentState();
  }

  // Getters
  WizardStep get currentStep => _currentStep;
  HackathonModel get hackathon => _hackathon;
  bool get canGoNext => _currentStep != WizardStep.reviewAndSubmit;
  bool get canGoPrevious => _currentStep != WizardStep.generalInformation;

  void _emitCurrentState() {
    emit(WizardStepChanged(currentStep: _currentStep, hackathon: _hackathon));
  }

  // Navigation methods
  void nextStep() {
    if (canGoNext) {
      final steps = WizardStep.values;
      final currentIndex = steps.indexOf(_currentStep);
      _currentStep = steps[currentIndex + 1];
      _emitCurrentState();
    }
  }

  void previousStep() {
    if (canGoPrevious) {
      final steps = WizardStep.values;
      final currentIndex = steps.indexOf(_currentStep);
      _currentStep = steps[currentIndex - 1];
      _emitCurrentState();
    }
  }

  void goToStep(WizardStep step) {
    _currentStep = step;
    _emitCurrentState();
  }

  // Data update methods
  void updateGeneralInformation({
    String? name,
    String? description,
    String? type,
    String? themeOrFocus,
  }) {
    _hackathon = HackathonModel(
      id: _hackathon.id,
      name: name ?? _hackathon.name,
      description: description ?? _hackathon.description,
      type: type ?? _hackathon.type,
      themeOrFocus: themeOrFocus ?? _hackathon.themeOrFocus,
      startDate: _hackathon.startDate,
      endDate: _hackathon.endDate,
      prizePoolDetails: _hackathon.prizePoolDetails,
      rules: _hackathon.rules,
      minTeamSize: _hackathon.minTeamSize,
      maxTeamSize: _hackathon.maxTeamSize,
      registrationFee: _hackathon.registrationFee,
      registrationFeeJustification: _hackathon.registrationFeeJustification,
      createdAt: _hackathon.createdAt,
      updatedAt: _hackathon.updatedAt,
      status: _hackathon.status,
    );
    _emitCurrentState();
  }

  void updateEventDetails({
    DateTime? startDate,
    DateTime? endDate,
    String? prizePoolDetails,
  }) {
    _hackathon = HackathonModel(
      id: _hackathon.id,
      name: _hackathon.name,
      description: _hackathon.description,
      type: _hackathon.type,
      themeOrFocus: _hackathon.themeOrFocus,
      startDate: startDate ?? _hackathon.startDate,
      endDate: endDate ?? _hackathon.endDate,
      prizePoolDetails: prizePoolDetails ?? _hackathon.prizePoolDetails,
      rules: _hackathon.rules,
      minTeamSize: _hackathon.minTeamSize,
      maxTeamSize: _hackathon.maxTeamSize,
      registrationFee: _hackathon.registrationFee,
      registrationFeeJustification: _hackathon.registrationFeeJustification,
      createdAt: _hackathon.createdAt,
      updatedAt: _hackathon.updatedAt,
      status: _hackathon.status,
    );
    _emitCurrentState();
  }

  void updateParticipantSettings({
    String? rules,
    int? minTeamSize,
    int? maxTeamSize,
    double? registrationFee,
    String? registrationFeeJustification,
  }) {
    _hackathon = HackathonModel(
      id: _hackathon.id,
      name: _hackathon.name,
      description: _hackathon.description,
      type: _hackathon.type,
      themeOrFocus: _hackathon.themeOrFocus,
      startDate: _hackathon.startDate,
      endDate: _hackathon.endDate,
      prizePoolDetails: _hackathon.prizePoolDetails,
      rules: rules ?? _hackathon.rules,
      minTeamSize: minTeamSize ?? _hackathon.minTeamSize,
      maxTeamSize: maxTeamSize ?? _hackathon.maxTeamSize,
      registrationFee: registrationFee ?? _hackathon.registrationFee,
      registrationFeeJustification:
          registrationFeeJustification ??
          _hackathon.registrationFeeJustification,
      createdAt: _hackathon.createdAt,
      updatedAt: _hackathon.updatedAt,
      status: _hackathon.status,
    );
    _emitCurrentState();
  }

  // Validation methods
  bool validateGeneralInformation() {
    return _hackathon.name.isNotEmpty &&
        _hackathon.description.isNotEmpty &&
        _hackathon.type.isNotEmpty;
  }

  bool validateEventDetails() {
    return _hackathon.startDate.isBefore(_hackathon.endDate) &&
        _hackathon.prizePoolDetails.isNotEmpty;
  }

  bool validateParticipantSettings() {
    return _hackathon.rules.isNotEmpty &&
        _hackathon.minTeamSize <= _hackathon.maxTeamSize &&
        _hackathon.minTeamSize > 0;
  }

  bool validateAll() {
    return validateGeneralInformation() &&
        validateEventDetails() &&
        validateParticipantSettings();
  }

  // Submit hackathon
  Future<void> submitHackathon() async {
    if (!validateAll()) {
      emit(const WizardError('Please fill all required fields correctly'));
      return;
    }

    emit(WizardSubmitting());

    try {
      final response = await _httpService.post<Map<String, dynamic>>(
        '/hackathons',
        data: _hackathon.toJson(),
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.isSuccess) {
        final createdHackathon = HackathonModel.fromJson(response.data!);
        emit(WizardSubmitted(createdHackathon));
      } else {
        emit(WizardError(response.message ?? 'Failed to create hackathon'));
      }
    } catch (e) {
      emit(WizardError('Failed to create hackathon: ${e.toString()}'));
    }
  }

  // Reset wizard
  void reset() {
    _currentStep = WizardStep.generalInformation;
    _hackathon = HackathonModel(
      name: '',
      description: '',
      type: 'Online',
      startDate: DateTime.now().add(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 32)),
      prizePoolDetails: '',
      rules: '',
      minTeamSize: 2,
      maxTeamSize: 6,
    );
    _emitCurrentState();
  }
}
