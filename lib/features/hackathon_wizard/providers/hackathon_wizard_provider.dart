import 'package:flutter/foundation.dart';
import '../../../shared/models/hackathon_model.dart';
import '../../../shared/services/http_service.dart';
import '../../../config/app_config.dart';

class HackathonWizardProvider with ChangeNotifier {
  final HttpService _httpService = HttpService();
  
  // Wizard state
  int _currentStep = 0;
  bool _isLoading = false;
  String? _error;
  
  // Form data
  HackathonModel? _hackathon;
  
  // Form field controllers data
  String _name = '';
  String _description = '';
  String _type = '';
  String _themeOrFocus = '';
  DateTime? _startDate;
  DateTime? _endDate;
  String _prizePoolDetails = '';
  String _rules = '';
  int _minTeamSize = AppConfig.minTeamSize;
  int _maxTeamSize = AppConfig.maxTeamSize;
  double? _registrationFee;
  String _registrationFeeJustification = '';

  // Getters
  int get currentStep => _currentStep;
  bool get isLoading => _isLoading;
  String? get error => _error;
  HackathonModel? get hackathon => _hackathon;
  
  // Form data getters
  String get name => _name;
  String get description => _description;
  String get type => _type;
  String get themeOrFocus => _themeOrFocus;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  String get prizePoolDetails => _prizePoolDetails;
  String get rules => _rules;
  int get minTeamSize => _minTeamSize;
  int get maxTeamSize => _maxTeamSize;
  double? get registrationFee => _registrationFee;
  String get registrationFeeJustification => _registrationFeeJustification;

  // Step validation
  bool get isStep1Valid => _name.isNotEmpty && _description.isNotEmpty && _type.isNotEmpty;
  bool get isStep2Valid => _startDate != null && _endDate != null && _prizePoolDetails.isNotEmpty;
  bool get isStep3Valid => _rules.isNotEmpty && _minTeamSize > 0 && _maxTeamSize > 0 && _minTeamSize <= _maxTeamSize;
  
  bool get canProceedToNextStep {
    switch (_currentStep) {
      case 0:
        return isStep1Valid;
      case 1:
        return isStep2Valid;
      case 2:
        return isStep3Valid;
      default:
        return false;
    }
  }

  bool get canGoBack => _currentStep > 0;
  bool get isLastStep => _currentStep == 2;

  // Navigation methods
  void nextStep() {
    if (canProceedToNextStep && _currentStep < 2) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (canGoBack) {
      _currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 2) {
      _currentStep = step;
      notifyListeners();
    }
  }

  // Form data setters
  void updateName(String value) {
    _name = value;
    _clearError();
    notifyListeners();
  }

  void updateDescription(String value) {
    _description = value;
    _clearError();
    notifyListeners();
  }

  void updateType(String value) {
    _type = value;
    _clearError();
    notifyListeners();
  }

  void updateThemeOrFocus(String value) {
    _themeOrFocus = value;
    _clearError();
    notifyListeners();
  }

  void updateStartDate(DateTime? value) {
    _startDate = value;
    _clearError();
    notifyListeners();
  }

  void updateEndDate(DateTime? value) {
    _endDate = value;
    _clearError();
    notifyListeners();
  }

  void updatePrizePoolDetails(String value) {
    _prizePoolDetails = value;
    _clearError();
    notifyListeners();
  }

  void updateRules(String value) {
    _rules = value;
    _clearError();
    notifyListeners();
  }

  void updateMinTeamSize(int value) {
    _minTeamSize = value;
    _clearError();
    notifyListeners();
  }

  void updateMaxTeamSize(int value) {
    _maxTeamSize = value;
    _clearError();
    notifyListeners();
  }

  void updateRegistrationFee(double? value) {
    _registrationFee = value;
    _clearError();
    notifyListeners();
  }

  void updateRegistrationFeeJustification(String value) {
    _registrationFeeJustification = value;
    _clearError();
    notifyListeners();
  }

  // Create hackathon model from current form data
  HackathonModel _createHackathonModel() {
    return HackathonModel(
      name: _name,
      description: _description,
      type: _type,
      themeOrFocus: _themeOrFocus.isNotEmpty ? _themeOrFocus : null,
      startDate: _startDate!,
      endDate: _endDate!,
      prizePoolDetails: _prizePoolDetails,
      rules: _rules,
      minTeamSize: _minTeamSize,
      maxTeamSize: _maxTeamSize,
      registrationFee: _registrationFee,
      registrationFeeJustification: _registrationFeeJustification.isNotEmpty 
          ? _registrationFeeJustification 
          : null,
    );
  }

  // Submit hackathon
  Future<bool> submitHackathon() async {
    if (!isStep1Valid || !isStep2Valid || !isStep3Valid) {
      _setError('Please fill in all required fields');
      return false;
    }

    _setLoading(true);
    
    try {
      final hackathonData = _createHackathonModel();
      final response = await _httpService.post<Map<String, dynamic>>(
        AppConfig.createHackathonEndpoint,
        data: hackathonData.toJson(),
      );

      if (response.success && response.data != null) {
        _hackathon = HackathonModel.fromJson(response.data!);
        _setLoading(false);
        return true;
      } else {
        _setError(response.errors?['error'] ?? 'Failed to create hackathon');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred');
      _setLoading(false);
      return false;
    }
  }

  // Preview hackathon data
  HackathonModel getPreviewData() {
    return _createHackathonModel();
  }

  // Load existing hackathon for editing
  void loadHackathon(HackathonModel hackathon) {
    _hackathon = hackathon;
    _name = hackathon.name;
    _description = hackathon.description;
    _type = hackathon.type;
    _themeOrFocus = hackathon.themeOrFocus ?? '';
    _startDate = hackathon.startDate;
    _endDate = hackathon.endDate;
    _prizePoolDetails = hackathon.prizePoolDetails;
    _rules = hackathon.rules;
    _minTeamSize = hackathon.minTeamSize;
    _maxTeamSize = hackathon.maxTeamSize;
    _registrationFee = hackathon.registrationFee;
    _registrationFeeJustification = hackathon.registrationFeeJustification ?? '';
    notifyListeners();
  }

  // Reset wizard
  void reset() {
    _currentStep = 0;
    _isLoading = false;
    _error = null;
    _hackathon = null;
    
    _name = '';
    _description = '';
    _type = '';
    _themeOrFocus = '';
    _startDate = null;
    _endDate = null;
    _prizePoolDetails = '';
    _rules = '';
    _minTeamSize = AppConfig.minTeamSize;
    _maxTeamSize = AppConfig.maxTeamSize;
    _registrationFee = null;
    _registrationFeeJustification = '';
    
    notifyListeners();
  }

  // Validate current step
  bool validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return isStep1Valid;
      case 1:
        return isStep2Valid;
      case 2:
        return isStep3Valid;
      default:
        return false;
    }
  }

  // Get step title
  String getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'General Information';
      case 1:
        return 'Event Details';
      case 2:
        return 'Participant Settings';
      default:
        return '';
    }
  }

  // Get step description
  String getStepDescription(int step) {
    switch (step) {
      case 0:
        return 'Define the core identity and basic structure of your hackathon';
      case 1:
        return 'Set scheduling and prize-related details for your event';
      case 2:
        return 'Configure rules and requirements for participants';
      default:
        return '';
    }
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
}
