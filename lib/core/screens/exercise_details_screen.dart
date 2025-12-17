import 'package:flutter/material.dart';
import 'package:football/core/api/end_points.dart';
import 'package:football/core/constants/colors.dart';
import 'package:football/core/functions/string_capitlizer.dart';
import 'package:football/core/models/exercise.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final ExerciseModel exercise;
  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // IMAGE HEADER
          SliverAppBar(
            expandedHeight: 400.0,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                exercise.imageUrl720,
                fit: BoxFit.cover,
                headers: const {
                  'X-RapidAPI-Key': EndPoints.apiKey,
                  'X-RapidAPI-Host': EndPoints.apiHost,
                },
                errorBuilder:
                    (c, e, s) =>
                        Image.network(exercise.gifUrl, fit: BoxFit.cover),
              ),
            ),
          ),

          // DETAILS BODY
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name.capitalize(),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // TAGS
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _tagChip(Icons.accessibility_new, exercise.bodyPart),
                      _tagChip(Icons.fitness_center, exercise.equipment),
                      _tagChip(Icons.center_focus_strong, exercise.target),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // SECONDARY MUSCLES
                  if (exercise.secondaryMuscles.isNotEmpty) ...[
                    const Text(
                      "Secondary Muscles",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children:
                          exercise.secondaryMuscles
                              .map(
                                (m) => Chip(
                                  label: Text(
                                    m.capitalize(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  backgroundColor: Colors.grey.shade100,
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 25),
                  ],

                  // INSTRUCTIONS LIST
                  const Text(
                    "Instructions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),

                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: exercise.instructions.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${index + 1}.",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                exercise.instructions[index],
                                style: const TextStyle(
                                  height: 1.5,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 5),
          Text(
            text.capitalize(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
