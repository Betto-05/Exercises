import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football/core/api/end_points.dart';
import 'package:football/core/functions/string_capitlizer.dart';
import 'package:football/core/models/exercise.dart';
import 'package:football/core/screens/exercise_details_screen.dart';
// Ensure this import matches your project structure for the provider
import 'package:football/features/favourites/ui/favourites_viewmodel.dart';

class ExerciseGridCard extends ConsumerWidget {
  final ExerciseModel exercise;
  const ExerciseGridCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the provider to see if this exercise is in favorites
    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.any((e) => e.id == exercise.id);

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
                    // ---------------- IMAGE ----------------
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
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to GIF if Image fails
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

                    // ---------------- HEART BUTTON ----------------
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          // Toggle favorite
                          ref
                              .read(favoritesProvider.notifier)
                              .toggleFavorite(exercise);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
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
