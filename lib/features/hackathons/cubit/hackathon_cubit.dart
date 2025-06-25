import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../shared/models/hackathon_model.dart';
import '../../../shared/services/http_service.dart';

// Hackathon States
abstract class HackathonState extends Equatable {
  const HackathonState();

  @override
  List<Object?> get props => [];
}

class HackathonInitial extends HackathonState {}

class HackathonLoading extends HackathonState {}

class HackathonListLoaded extends HackathonState {
  final List<HackathonModel> hackathons;

  const HackathonListLoaded(this.hackathons);

  @override
  List<Object> get props => [hackathons];
}

class HackathonLoaded extends HackathonState {
  final HackathonModel hackathon;

  const HackathonLoaded(this.hackathon);

  @override
  List<Object> get props => [hackathon];
}

class HackathonCreated extends HackathonState {
  final HackathonModel hackathon;

  const HackathonCreated(this.hackathon);

  @override
  List<Object> get props => [hackathon];
}

class HackathonUpdated extends HackathonState {
  final HackathonModel hackathon;

  const HackathonUpdated(this.hackathon);

  @override
  List<Object> get props => [hackathon];
}

class HackathonDeleted extends HackathonState {
  final String hackathonId;

  const HackathonDeleted(this.hackathonId);

  @override
  List<Object> get props => [hackathonId];
}

class HackathonError extends HackathonState {
  final String message;

  const HackathonError(this.message);

  @override
  List<Object> get props => [message];
}

// Hackathon Cubit
@injectable
class HackathonCubit extends Cubit<HackathonState> {
  final HttpService _httpService;

  HackathonCubit(this._httpService) : super(HackathonInitial());

  Future<void> loadHackathons() async {
    emit(HackathonLoading());

    try {
      final response = await _httpService.get<List<dynamic>>(
        '/hackathons',
        fromJson: (data) => data as List<dynamic>,
      );

      if (response.isSuccess) {
        final hackathons = response.data!
            .map((json) => HackathonModel.fromJson(json as Map<String, dynamic>))
            .toList();
        emit(HackathonListLoaded(hackathons));
      } else {
        emit(HackathonError(response.message ?? 'Failed to load hackathons'));
      }
    } catch (e) {
      emit(HackathonError('Failed to load hackathons: ${e.toString()}'));
    }
  }

  Future<void> loadHackathon(String id) async {
    emit(HackathonLoading());

    try {
      final response = await _httpService.get<Map<String, dynamic>>(
        '/hackathons/$id',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.isSuccess) {
        final hackathon = HackathonModel.fromJson(response.data!);
        emit(HackathonLoaded(hackathon));
      } else {
        emit(HackathonError(response.message ?? 'Failed to load hackathon'));
      }
    } catch (e) {
      emit(HackathonError('Failed to load hackathon: ${e.toString()}'));
    }
  }

  Future<void> createHackathon(HackathonModel hackathon) async {
    emit(HackathonLoading());

    try {
      final response = await _httpService.post<Map<String, dynamic>>(
        '/hackathons',
        data: hackathon.toJson(),
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.isSuccess) {
        final createdHackathon = HackathonModel.fromJson(response.data!);
        emit(HackathonCreated(createdHackathon));
      } else {
        emit(HackathonError(response.message ?? 'Failed to create hackathon'));
      }
    } catch (e) {
      emit(HackathonError('Failed to create hackathon: ${e.toString()}'));
    }
  }

  Future<void> updateHackathon(String id, HackathonModel hackathon) async {
    emit(HackathonLoading());

    try {
      final response = await _httpService.put<Map<String, dynamic>>(
        '/hackathons/$id',
        data: hackathon.toJson(),
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.isSuccess) {
        final updatedHackathon = HackathonModel.fromJson(response.data!);
        emit(HackathonUpdated(updatedHackathon));
      } else {
        emit(HackathonError(response.message ?? 'Failed to update hackathon'));
      }
    } catch (e) {
      emit(HackathonError('Failed to update hackathon: ${e.toString()}'));
    }
  }

  Future<void> deleteHackathon(String id) async {
    emit(HackathonLoading());

    try {
      final response = await _httpService.delete(
        '/hackathons/$id',
      );

      if (response.isSuccess) {
        emit(HackathonDeleted(id));
      } else {
        emit(HackathonError(response.message ?? 'Failed to delete hackathon'));
      }
    } catch (e) {
      emit(HackathonError('Failed to delete hackathon: ${e.toString()}'));
    }
  }

  Future<void> generateLandingPage(String hackathonId) async {
    emit(HackathonLoading());

    try {
      final response = await _httpService.post<Map<String, dynamic>>(
        '/hackathons/$hackathonId/generate-landing-page',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.isSuccess) {
        // Reload the hackathon to get updated landing page URL
        await loadHackathon(hackathonId);
      } else {
        emit(HackathonError(response.message ?? 'Failed to generate landing page'));
      }
    } catch (e) {
      emit(HackathonError('Failed to generate landing page: ${e.toString()}'));
    }
  }
}
