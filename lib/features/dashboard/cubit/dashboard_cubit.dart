import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Dashboard States
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardStats stats;
  final List<TopHackathon> topHackathons;
  final List<RecentActivity> recentActivities;

  const DashboardLoaded({
    required this.stats,
    required this.topHackathons,
    required this.recentActivities,
  });

  @override
  List<Object> get props => [stats, topHackathons, recentActivities];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}

// Dashboard Cubit
class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(DashboardInitial());

  Future<void> loadDashboardData() async {
    emit(DashboardLoading());

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock data - replace with actual API calls
      final stats = DashboardStats(
        totalHackathons: 24,
        activeEvents: 5,
        totalParticipants: 1247,
        teamsFormed: 89,
      );

      final topHackathons = [
        TopHackathon(
          name: 'AI Innovation Challenge',
          participants: 156,
          status: 'Active',
        ),
        TopHackathon(
          name: 'Blockchain Summit',
          participants: 89,
          status: 'Active',
        ),
        TopHackathon(
          name: 'IoT Hackfest',
          participants: 234,
          status: 'Upcoming',
        ),
        TopHackathon(
          name: 'Web3 Builder Day',
          participants: 67,
          status: 'Active',
        ),
      ];

      final activities = [
        RecentActivity(
          title: 'New team registered',
          description: 'Team "Code Warriors" joined AI Innovation Challenge',
          time: '2 minutes ago',
          type: 'team',
        ),
        RecentActivity(
          title: 'Event published',
          description:
              'Blockchain Summit is now live and accepting registrations',
          time: '1 hour ago',
          type: 'event',
        ),
        RecentActivity(
          title: 'New participant',
          description: 'Sarah Johnson registered for IoT Hackfest',
          time: '3 hours ago',
          type: 'user',
        ),
        RecentActivity(
          title: 'Judging completed',
          description: 'Web3 Builder Day results are being processed',
          time: '1 day ago',
          type: 'event',
        ),
      ];

      emit(
        DashboardLoaded(
          stats: stats,
          topHackathons: topHackathons,
          recentActivities: activities,
        ),
      );
    } catch (e) {
      emit(DashboardError('Failed to load dashboard data: ${e.toString()}'));
    }
  }
}

// Data Models
class DashboardStats {
  final int totalHackathons;
  final int activeEvents;
  final int totalParticipants;
  final int teamsFormed;

  DashboardStats({
    required this.totalHackathons,
    required this.activeEvents,
    required this.totalParticipants,
    required this.teamsFormed,
  });
}

class TopHackathon {
  final String name;
  final int participants;
  final String status;

  TopHackathon({
    required this.name,
    required this.participants,
    required this.status,
  });
}

class RecentActivity {
  final String title;
  final String description;
  final String time;
  final String type;

  RecentActivity({
    required this.title,
    required this.description,
    required this.time,
    required this.type,
  });
}
