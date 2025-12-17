import 'package:football/core/models/exercise.dart';

enum UiState { loading, data, error }

class HomeState {
  final UiState uiState;
  final List<String> bodyParts;
  final List<String> equipment;
  final List<ExerciseModel> featuredExercises;

  const HomeState({
    required this.uiState,
    required this.bodyParts,
    required this.equipment,
    required this.featuredExercises,
  });

  factory HomeState.initial() {
    return const HomeState(
      uiState: UiState.loading,
      bodyParts: [],
      equipment: [],
      featuredExercises: [],
    );
  }

  HomeState copyWith({
    UiState? uiState,
    List<String>? bodyParts,
    List<String>? equipment,
    List<ExerciseModel>? featuredExercises,
  }) {
    return HomeState(
      uiState: uiState ?? this.uiState,
      bodyParts: bodyParts ?? this.bodyParts,
      equipment: equipment ?? this.equipment,
      featuredExercises: featuredExercises ?? this.featuredExercises,
    );
  }
}
