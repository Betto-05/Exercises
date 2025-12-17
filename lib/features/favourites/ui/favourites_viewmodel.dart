import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football/core/models/exercise.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favoritesProvider =
    StateNotifierProvider<FavoritesViewModel, List<ExerciseModel>>(
      (ref) => FavoritesViewModel(),
    );

class FavoritesViewModel extends StateNotifier<List<ExerciseModel>> {
  static const _favoritesKey = 'favorites';

  FavoritesViewModel() : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_favoritesKey) ?? [];
    state = data.map((e) => ExerciseModel.fromJson(jsonDecode(e))).toList();
  }

  Future<void> toggleFavorite(ExerciseModel exercise) async {
    final prefs = await SharedPreferences.getInstance();
    final isFav = state.any((e) => e.id == exercise.id);

    if (isFav) {
      state = state.where((e) => e.id != exercise.id).toList();
    } else {
      state = [...state, exercise];
    }

    // Save to SharedPreferences
    final data = state.map((e) => jsonEncode(_exerciseToJson(e))).toList();
    await prefs.setStringList(_favoritesKey, data);
  }

  bool isFavorite(String id) {
    return state.any((e) => e.id == id);
  }

  // Ensure all fields needed for display are saved here
  Map<String, dynamic> _exerciseToJson(ExerciseModel e) {
    return {
      'id': e.id,
      'name': e.name,
      'gifUrl': e.gifUrl, // Crucial for fallback
      'target': e.target,
      'bodyPart': e.bodyPart,
      'equipment': e.equipment,
      'instructions': e.instructions,
      'secondaryMuscles': e.secondaryMuscles,
      // If your model has a specific 'imageUrl' field that isn't derived from ID,
      // add it here. e.g.: 'imageUrl': e.imageUrl,
    };
  }
}
