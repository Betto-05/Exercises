import 'package:football/features/home/ui/home_state.dart';
import 'package:football/features/profile/data/models/profile_model.dart';

class ProfileState {
  final UiState uiState;
  final ProfileModel? profile;

  const ProfileState({required this.uiState, required this.profile});

  factory ProfileState.initial() {
    return const ProfileState(uiState: UiState.loading, profile: null);
  }

  ProfileState copyWith({UiState? uiState, ProfileModel? profile}) {
    return ProfileState(
      uiState: uiState ?? this.uiState,
      profile: profile ?? this.profile,
    );
  }
}
