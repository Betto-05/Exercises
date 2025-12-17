import 'package:flutter/material.dart';
import 'package:football/core/api/end_points.dart';
import 'package:football/core/functions/string_capitlizer.dart';
import 'package:football/core/models/exercise.dart';
import 'package:football/core/screens/exercise_details_screen.dart';

class ExerciseGridCard extends StatelessWidget {
  final ExerciseModel exercise;
  const ExerciseGridCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExerciseDetailScreen(exercise: exercise),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      exercise.imageUrl720,
                      fit: BoxFit.cover,
                      headers: const {
                        'X-RapidAPI-Key': EndPoints.apiKey,
                        'X-RapidAPI-Host': EndPoints.apiHost,
                      },

                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;

                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      },

                      // ✅ FALLBACK IMAGE IF ERROR
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          exercise.gifUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          },
                          errorBuilder: (_, __, ___) {
                            return const Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 40,
                                color: Colors.grey,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // ---------------- TITLE ----------------
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                exercise.name.capitalize(),
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
