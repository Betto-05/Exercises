import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football/core/api/end_points.dart';
import 'package:football/core/constants/colors.dart';
import 'package:football/core/functions/string_capitlizer.dart';
import 'package:football/core/screens/exercieses_categories_list.dart';
import 'package:football/core/screens/exercieses_list.dart';
import 'package:football/features/home/ui/components/body_part.dart';
import 'package:football/features/home/ui/components/equipment_card.dart';
import 'package:football/features/home/ui/components/featured_exercised_card.dart';
import 'package:football/features/home/ui/components/search_bar.dart';
import 'package:football/features/home/ui/components/section_header.dart';
import 'package:football/features/home/ui/home_state.dart';
import 'package:football/features/home/ui/home_viewmodel.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Find Your Workout',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
      ),
      body:
          state.uiState == UiState.loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SearchBarField(
                        controller: _searchController,
                        onSubmitted: (v) => _performSearch(context, v),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SectionHeader(
                      title: "Body Parts",
                      onSeeAll:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ExerciesesCategoriesListScreen(
                                    title: "Body Parts",
                                    listEndpoint: EndPoints.bodyPartList,
                                    getNextEndpoint:
                                        (i) =>
                                            "${EndPoints.getExercisesByBodyPart}$i",
                                  ),
                            ),
                          ),
                    ),
                    SizedBox(
                      height: 110,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.bodyParts.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 15),
                        itemBuilder:
                            (_, i) => GestureDetector(
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => ExerciseListScreen(
                                            title:
                                                state.bodyParts[i].capitalize(),
                                            apiPath:
                                                "${EndPoints.getExercisesByBodyPart}${state.bodyParts[i]}",
                                          ),
                                    ),
                                  ),
                              child: BodyPart(
                                icon: _getBodyPartIcon(state.bodyParts[i]),
                                text: state.bodyParts[i].capitalize(),
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SectionHeader(
                      title: "Featured Exercises",
                      onSeeAll:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => const ExerciseListScreen(
                                    title: "All",
                                    apiPath: EndPoints.getAllExercises,
                                  ),
                            ),
                          ),
                    ),
                    SizedBox(
                      height: 220,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.featuredExercises.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 15),
                        itemBuilder:
                            (_, i) => FeaturedExerciseCard(
                              exercise: state.featuredExercises[i],
                            ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SectionHeader(
                      title: "Equipment",
                      onSeeAll:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ExerciesesCategoriesListScreen(
                                    title: "Equipment",
                                    listEndpoint: EndPoints.equipmentList,
                                    getNextEndpoint:
                                        (i) =>
                                            "${EndPoints.getExercisesByEquipment}$i",
                                  ),
                            ),
                          ),
                    ),
                    SizedBox(
                      height: 60,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.equipment.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder:
                            (_, i) => GestureDetector(
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => ExerciseListScreen(
                                            title:
                                                state.equipment[i].capitalize(),
                                            apiPath:
                                                "${EndPoints.getExercisesByEquipment}${state.equipment[i]}",
                                          ),
                                    ),
                                  ),
                              child: EquipmentCard(
                                icon: _getEquipmentIcon(state.equipment[i]),
                                text: state.equipment[i].capitalize(),
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
    );
  }

  IconData _getBodyPartIcon(String s) {
    if (s.contains('cardio')) return Icons.directions_run;
    if (s.contains('chest')) return Icons.fitness_center;
    if (s.contains('waist')) return Icons.boy;
    return Icons.accessibility_new;
  }

  IconData _getEquipmentIcon(String s) {
    if (s.contains('weight') || s.contains('dumb')) {
      return Icons.fitness_center;
    }
    if (s.contains('cable') || s.contains('machine')) {
      return Icons.confirmation_number_outlined;
    }
    if (s.contains('band')) return Icons.linear_scale;
    return Icons.handyman;
  }

  void _performSearch(BuildContext context, String query) {
    if (query.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ExerciseListScreen(
              title: "Results: $query",
              apiPath: "/exercises/name/${query.toLowerCase()}",
            ),
      ),
    );
  }
}
