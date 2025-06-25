class ValidationUtils {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  // Minimum length validation
  static String? validateMinLength(
    String? value,
    int minLength, {
    String? fieldName,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (value.trim().length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }

    return null;
  }

  // Maximum length validation
  static String? validateMaxLength(
    String? value,
    int maxLength, {
    String? fieldName,
  }) {
    if (value != null && value.trim().length > maxLength) {
      return '${fieldName ?? 'This field'} must not exceed $maxLength characters';
    }

    return null;
  }

  // Number validation
  static String? validateNumber(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (int.tryParse(value) == null) {
      return '${fieldName ?? 'This field'} must be a valid number';
    }

    return null;
  }

  // Positive number validation
  static String? validatePositiveNumber(String? value, {String? fieldName}) {
    final numberValidation = validateNumber(value, fieldName: fieldName);
    if (numberValidation != null) {
      return numberValidation;
    }

    final number = int.parse(value!);
    if (number <= 0) {
      return '${fieldName ?? 'This field'} must be a positive number';
    }

    return null;
  }

  // URL validation
  static String? validateUrl(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  // Date validation
  static String? validateDate(DateTime? value, {String? fieldName}) {
    if (value == null) {
      return '${fieldName ?? 'Date'} is required';
    }

    return null;
  }

  // Date range validation
  static String? validateDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null) {
      return 'Start date is required';
    }

    if (endDate == null) {
      return 'End date is required';
    }

    if (startDate.isAfter(endDate)) {
      return 'Start date must be before end date';
    }

    return null;
  }

  // Team size validation
  static String? validateTeamSize(String? value, int minSize, int maxSize) {
    final numberValidation = validatePositiveNumber(
      value,
      fieldName: 'Team size',
    );
    if (numberValidation != null) {
      return numberValidation;
    }

    final size = int.parse(value!);
    if (size < minSize || size > maxSize) {
      return 'Team size must be between $minSize and $maxSize';
    }

    return null;
  }

  // Phone number validation
  static String? validatePhoneNumber(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Phone number'} is required';
    }

    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    // Check for at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one number
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }
}
