import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football/core/api/end_points.dart';
import 'package:football/core/constants/colors.dart';
import 'package:football/core/functions/string_capitlizer.dart';
import 'package:football/core/models/exercise.dart';
import 'package:football/features/favourites/ui/favourites_viewmodel.dart';

class FeaturedExerciseCard extends ConsumerWidget {
  final ExerciseModel exercise;
  final double? width;

  const FeaturedExerciseCard({super.key, required this.exercise, this.width});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.any((element) => element.id == exercise.id);

    return Container(
      width:
          width, // Respects width if provided (Home), flexible if null (Favs)
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- IMAGE SECTION ----------------
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: Image.network(
                    // 1. Try High Quality Image First
                    exercise.imageUrl720,
                    fit: BoxFit.cover,
                    headers: const {
                      'X-RapidAPI-Key': EndPoints.apiKey,
                      'X-RapidAPI-Host': EndPoints.apiHost,
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 140,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      // 2. If Image Fails, Fallback to GIF
                      return Image.network(
                        exercise.gifUrl,
                        fit: BoxFit.cover,
                        // Don't forget headers here too!
                        headers: const {
                          'X-RapidAPI-Key': EndPoints.apiKey,
                          'X-RapidAPI-Host': EndPoints.apiHost,
                        },
                        errorBuilder: (context, error, stackTrace) {
                          // 3. If both fail, show broken icon
                          return Container(
                            height: 140,
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              // ---------------- TEXT CONTENT ----------------
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name.capitalize(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildTag(exercise.target.capitalize()),
                        const SizedBox(width: 8),
                        _buildTag(exercise.equipment.capitalize()),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ---------------- HEART BUTTON ----------------
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                ref.read(favoritesProvider.notifier).toggleFavorite(exercise);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
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
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
