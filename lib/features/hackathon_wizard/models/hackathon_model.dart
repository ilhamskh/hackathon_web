class HackathonModel {
  final String? id;
  final String name;
  final String description;
  final String type;
  final String? themeOrFocus;
  final DateTime startDate;
  final DateTime endDate;
  final String prizePoolDetails;
  final String rules;
  final int minTeamSize;
  final int maxTeamSize;
  final double? registrationFee;
  final String? registrationFeeJustification;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? status;

  HackathonModel({
    this.id,
    required this.name,
    required this.description,
    required this.type,
    this.themeOrFocus,
    required this.startDate,
    required this.endDate,
    required this.prizePoolDetails,
    required this.rules,
    required this.minTeamSize,
    required this.maxTeamSize,
    this.registrationFee,
    this.registrationFeeJustification,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  // Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'theme_or_focus': themeOrFocus,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'prize_pool_details': prizePoolDetails,
      'rules': rules,
      'min_team_size': minTeamSize,
      'max_team_size': maxTeamSize,
      'registration_fee': registrationFee,
      'registration_fee_justification': registrationFeeJustification,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'status': status,
    };
  }

  // Create from JSON response
  factory HackathonModel.fromJson(Map<String, dynamic> json) {
    return HackathonModel(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      themeOrFocus: json['theme_or_focus'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      prizePoolDetails: json['prize_pool_details'] ?? '',
      rules: json['rules'] ?? '',
      minTeamSize: json['min_team_size'] ?? 2,
      maxTeamSize: json['max_team_size'] ?? 6,
      registrationFee: json['registration_fee']?.toDouble(),
      registrationFeeJustification: json['registration_fee_justification'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      status: json['status'],
    );
  }

  // Copy with method for updates
  HackathonModel copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    String? themeOrFocus,
    DateTime? startDate,
    DateTime? endDate,
    String? prizePoolDetails,
    String? rules,
    int? minTeamSize,
    int? maxTeamSize,
    double? registrationFee,
    String? registrationFeeJustification,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
  }) {
    return HackathonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      themeOrFocus: themeOrFocus ?? this.themeOrFocus,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      prizePoolDetails: prizePoolDetails ?? this.prizePoolDetails,
      rules: rules ?? this.rules,
      minTeamSize: minTeamSize ?? this.minTeamSize,
      maxTeamSize: maxTeamSize ?? this.maxTeamSize,
      registrationFee: registrationFee ?? this.registrationFee,
      registrationFeeJustification:
          registrationFeeJustification ?? this.registrationFeeJustification,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }

  // Check if hackathon is valid
  bool get isValid {
    return name.isNotEmpty &&
        description.isNotEmpty &&
        type.isNotEmpty &&
        prizePoolDetails.isNotEmpty &&
        rules.isNotEmpty &&
        minTeamSize > 0 &&
        maxTeamSize > 0 &&
        minTeamSize <= maxTeamSize &&
        startDate.isBefore(endDate);
  }

  // Get duration in days
  int get durationInDays {
    return endDate.difference(startDate).inDays;
  }

  // Check if registration is free
  bool get isFree {
    return registrationFee == null || registrationFee == 0;
  }

  // Get formatted registration fee
  String get formattedRegistrationFee {
    if (isFree) {
      return 'Free';
    }
    return '\$${registrationFee!.toStringAsFixed(2)}';
  }

  // Check if hackathon is in the past
  bool get isPast {
    return endDate.isBefore(DateTime.now());
  }

  // Check if hackathon is currently running
  bool get isRunning {
    final now = DateTime.now();
    return startDate.isBefore(now) && endDate.isAfter(now);
  }

  // Check if hackathon is upcoming
  bool get isUpcoming {
    return startDate.isAfter(DateTime.now());
  }

  // Get status display text
  String get statusDisplay {
    if (status != null) {
      return status!;
    }

    if (isPast) {
      return 'Completed';
    } else if (isRunning) {
      return 'Running';
    } else if (isUpcoming) {
      return 'Upcoming';
    } else {
      return 'Draft';
    }
  }

  @override
  String toString() {
    return 'HackathonModel{id: $id, name: $name, type: $type, startDate: $startDate, endDate: $endDate}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HackathonModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.type == type &&
        other.themeOrFocus == themeOrFocus &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.prizePoolDetails == prizePoolDetails &&
        other.rules == rules &&
        other.minTeamSize == minTeamSize &&
        other.maxTeamSize == maxTeamSize &&
        other.registrationFee == registrationFee;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      id,
      name,
      description,
      type,
      themeOrFocus,
      startDate,
      endDate,
      prizePoolDetails,
      rules,
      minTeamSize,
      maxTeamSize,
      registrationFee,
    ]);
  }
}
