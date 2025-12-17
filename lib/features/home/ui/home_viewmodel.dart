import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football/core/api/dio_consumer.dart';
import 'package:football/core/api/end_points.dart';
import 'package:football/core/models/exercise.dart';

import 'home_state.dart';

class HomeViewModel extends StateNotifier<HomeState> {
  HomeViewModel() : super(HomeState.initial()) {
    fetchHomeData();
  }

  final DioConsumer _consumer = DioConsumer(dio: Dio());

  Future<void> fetchHomeData() async {
    try {
      final res = await Future.wait([
        _consumer.get(EndPoints.bodyPartList),
        _consumer.get(EndPoints.equipmentList),
        _consumer.get(EndPoints.getAllExercises, queryParameters: {'limit': 6}),
      ]);

      state = state.copyWith(
        uiState: UiState.data,
        bodyParts: List<String>.from(res[0]).take(10).toList(),
        equipment: List<String>.from(res[1]).take(10).toList(),
        featuredExercises:
            (res[2] as List).map((e) => ExerciseModel.fromJson(e)).toList(),
      );
    } catch (_) {
      state = state.copyWith(uiState: UiState.error);
    }
  }
}

final homeViewModelProvider = StateNotifierProvider<HomeViewModel, HomeState>(
  (ref) => HomeViewModel(),
);
