import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football/features/home/ui/home_state.dart';
import 'package:football/features/profile/repo/profile_repository.dart';

import 'profile_state.dart';

class ProfileViewModel extends StateNotifier<ProfileState> {
  final ProfileRepository repository;

  ProfileViewModel(this.repository) : super(ProfileState.initial()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final profile = await repository.fetchProfile();
      state = state.copyWith(uiState: UiState.data, profile: profile);
    } catch (_) {
      state = state.copyWith(uiState: UiState.error);
    }
  }

  Future<void> updateName(String name) async {
    final updated = state.profile!.copyWith(name: name);
    await repository.updateProfile(updated);
    state = state.copyWith(profile: updated);
  }

  Future<void> logout() async {
    await repository.signOut();
  }
}

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, ProfileState>(
      (ref) => ProfileViewModel(ProfileRepository()),
    );
