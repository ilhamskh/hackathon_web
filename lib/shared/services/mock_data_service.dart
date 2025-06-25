import '../models/user.dart';
import '../models/hackathon_model.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // Mock user for demo
  static final User demoUser = User(
    id: '1',
    email: 'admin@hackathon.com',
    name: 'Admin User',
    role: 'admin',
    isActive: true,
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  // Mock hackathons for demo
  static final List<HackathonModel> _mockHackathons = [
    HackathonModel(
      id: '1',
      name: 'AI Innovation Challenge 2024',
      description: 'Build innovative AI solutions that solve real-world problems. Join developers, designers, and entrepreneurs for 48 hours of intensive coding.',
      type: 'Online',
      themeOrFocus: 'Artificial Intelligence, Machine Learning',
      startDate: DateTime.now().add(const Duration(days: 30)),
      endDate: DateTime.now().add(const Duration(days: 32)),
      prizePoolDetails: '1st Place: \$10,000, 2nd Place: \$5,000, 3rd Place: \$2,500',
      rules: 'Teams of 2-5 members, original code only, submit by deadline',
      minTeamSize: 2,
      maxTeamSize: 5,
      registrationFee: 25.0,
      registrationFeeJustification: 'Platform and infrastructure costs',
      status: 'published',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    HackathonModel(
      id: '2',
      name: 'Web3 DeFi Hackathon',
      description: 'Create the next generation of decentralized finance applications. Build on Ethereum, Polygon, or Solana.',
      type: 'Hybrid',
      themeOrFocus: 'Blockchain, DeFi, Smart Contracts',
      startDate: DateTime.now().add(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 18)),
      prizePoolDetails: '1st Place: \$15,000, 2nd Place: \$8,000, Best Innovation: \$3,000',
      rules: 'Smart contracts must be deployed on testnet, demo required',
      minTeamSize: 1,
      maxTeamSize: 4,
      registrationFee: 50.0,
      registrationFeeJustification: 'Enhanced resources and mentorship',
      status: 'published',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    HackathonModel(
      id: '3',
      name: 'Mobile App Challenge',
      description: 'Design and develop mobile applications that enhance user productivity and daily life.',
      type: 'Offline',
      themeOrFocus: 'Mobile Development, UX/UI Design',
      startDate: DateTime.now().subtract(const Duration(days: 2)),
      endDate: DateTime.now().add(const Duration(days: 1)),
      prizePoolDetails: '1st Place: \$8,000, 2nd Place: \$4,000, People\'s Choice: \$2,000',
      rules: 'Cross-platform encouraged, must work on iOS and Android',
      minTeamSize: 2,
      maxTeamSize: 6,
      status: 'running',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
    HackathonModel(
      id: '4',
      name: 'Green Tech Solutions',
      description: 'Develop technology solutions for environmental sustainability and climate change.',
      type: 'Online',
      themeOrFocus: 'Environmental Tech, Sustainability',
      startDate: DateTime.now().add(const Duration(days: 60)),
      endDate: DateTime.now().add(const Duration(days: 63)),
      prizePoolDetails: '1st Place: \$12,000, 2nd Place: \$6,000, Impact Award: \$4,000',
      rules: 'Focus on environmental impact, sustainability metrics required',
      minTeamSize: 2,
      maxTeamSize: 5,
      registrationFee: 30.0,
      registrationFeeJustification: 'Expert mentorship and resources',
      status: 'draft',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    HackathonModel(
      id: '5',
      name: 'HealthTech Innovation Summit',
      description: 'Revolutionary healthcare solutions through technology. Partner with medical professionals.',
      type: 'Hybrid',
      themeOrFocus: 'Healthcare, Medical Technology',
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now().subtract(const Duration(days: 8)),
      prizePoolDetails: '1st Place: \$20,000, 2nd Place: \$10,000, Medical Impact: \$5,000',
      rules: 'Medical advisor required, HIPAA compliance essential',
      minTeamSize: 3,
      maxTeamSize: 6,
      registrationFee: 75.0,
      registrationFeeJustification: 'Medical expertise and compliance resources',
      status: 'ended',
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      updatedAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
    HackathonModel(
      id: '6',
      name: 'Gaming Revolution 2024',
      description: 'Create the next generation of gaming experiences using cutting-edge technology.',
      type: 'Online',
      themeOrFocus: 'Game Development, VR/AR, Graphics',
      startDate: DateTime.now().add(const Duration(days: 45)),
      endDate: DateTime.now().add(const Duration(days: 48)),
      prizePoolDetails: '1st Place: \$18,000, 2nd Place: \$9,000, Creative Award: \$3,000',
      rules: 'Any game engine allowed, multiplayer features bonus points',
      minTeamSize: 1,
      maxTeamSize: 4,
      registrationFee: 40.0,
      registrationFeeJustification: 'Game development tools and assets',
      status: 'published',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Authentication mock
  Future<User?> authenticateUser(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    
    // Demo credentials
    if ((email == 'admin@hackathon.com' && password == 'admin123') ||
        email.contains('demo@') ||
        email.contains('@')) {
      return demoUser;
    }
    
    throw Exception('Invalid credentials');
  }

  // Get all hackathons
  List<HackathonModel> getAllHackathons() {
    return List.from(_mockHackathons);
  }

  // Get hackathon by ID
  HackathonModel? getHackathonById(String id) {
    try {
      return _mockHackathons.firstWhere((h) => h.id == id);
    } catch (e) {
      return null;
    }
  }

  // Create new hackathon
  HackathonModel createHackathon(HackathonModel hackathon) {
    final newHackathon = hackathon.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: 'draft',
    );
    _mockHackathons.insert(0, newHackathon);
    return newHackathon;
  }

  // Update hackathon
  HackathonModel updateHackathon(HackathonModel hackathon) {
    final index = _mockHackathons.indexWhere((h) => h.id == hackathon.id);
    if (index != -1) {
      final updatedHackathon = hackathon.copyWith(
        updatedAt: DateTime.now(),
      );
      _mockHackathons[index] = updatedHackathon;
      return updatedHackathon;
    }
    throw Exception('Hackathon not found');
  }

  // Delete hackathon
  void deleteHackathon(String id) {
    _mockHackathons.removeWhere((h) => h.id == id);
  }

  // Get hackathons by status
  List<HackathonModel> getHackathonsByStatus(String status) {
    return _mockHackathons.where((h) => h.status == status).toList();
  }

  // Get analytics data
  Map<String, dynamic> getAnalytics() {
    final totalHackathons = _mockHackathons.length;
    final activeHackathons = _mockHackathons.where((h) => h.isRunning).length;
    final upcomingHackathons = _mockHackathons.where((h) => h.isUpcoming).length;
    final endedHackathons = _mockHackathons.where((h) => h.isPast).length;
    
    // Mock additional metrics
    const totalParticipants = 1247;
    const totalProjects = 456;
    const totalRevenue = 12450.0;
    
    return {
      'totalHackathons': totalHackathons,
      'activeHackathons': activeHackathons,
      'upcomingHackathons': upcomingHackathons,
      'endedHackathons': endedHackathons,
      'totalParticipants': totalParticipants,
      'totalProjects': totalProjects,
      'totalRevenue': totalRevenue,
      'monthlyGrowth': 12.5,
      'participantGrowth': 8.2,
      'projectGrowth': 15.3,
      'revenueGrowth': 24.1,
    };
  }

  // Search hackathons
  List<HackathonModel> searchHackathons(String query) {
    if (query.isEmpty) return getAllHackathons();
    
    final lowercaseQuery = query.toLowerCase();
    return _mockHackathons.where((hackathon) {
      return hackathon.name.toLowerCase().contains(lowercaseQuery) ||
             hackathon.description.toLowerCase().contains(lowercaseQuery) ||
             (hackathon.themeOrFocus?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  // Filter hackathons
  List<HackathonModel> filterHackathons({
    String? type,
    String? status,
    bool? hasFee,
  }) {
    var filtered = getAllHackathons();
    
    if (type != null && type.isNotEmpty) {
      filtered = filtered.where((h) => h.type == type).toList();
    }
    
    if (status != null && status.isNotEmpty) {
      filtered = filtered.where((h) => h.status == status).toList();
    }
    
    if (hasFee != null) {
      filtered = filtered.where((h) => !h.isFree == hasFee).toList();
    }
    
    return filtered;
  }
}
