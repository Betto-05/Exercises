import 'package:football/core/models/exercise.dart';
import 'package:football/core/utils/ui_state.dart';

class HomeState {
  final UiState? uiState;
  final List<String>? bodyParts;
  final List<String>? equipmentList;
  final List<ExerciseModel>? exercisesList;

  const HomeState({
    this.bodyParts,

    this.uiState = UiState.loading,
    this.equipmentList,
    this.exercisesList,
  });
  HomeState copywith({
    UiState? uiState,
    bool? fetchYearsDataSuccessfully,
    List<String>? yearNames,
  }) {
    return HomeState(
      uiState: uiState ?? this.uiState,
      bodyParts: bodyParts ?? bodyParts,
      equipmentList: equipmentList ?? equipmentList,
      exercisesList: exercisesList ?? exercisesList,
    );
  }
}
