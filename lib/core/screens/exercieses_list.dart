import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:football/core/api/dio_consumer.dart';
import 'package:football/core/models/exercise.dart';
import 'package:football/core/widgets/custom_appbar.dart';
import 'package:football/core/widgets/exercise_gird_card.dart';

class ExerciseListScreen extends StatefulWidget {
  final String title;
  final String apiPath;
  final Map<String, dynamic>? params;
  const ExerciseListScreen({
    super.key,
    required this.title,
    required this.apiPath,
    this.params,
  });
  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  List<ExerciseModel> exercises = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final consumer = DioConsumer(dio: Dio());
      Map<String, dynamic> qParams = widget.params ?? {};
      if (!qParams.containsKey('limit')) qParams['limit'] = 50;
      final data = await consumer.get(widget.apiPath, queryParameters: qParams);
      if (mounted) {
        setState(() {
          exercises =
              (data as List).map((e) => ExerciseModel.fromJson(e)).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: exercises.length,
                itemBuilder:
                    (context, index) =>
                        ExerciseGridCard(exercise: exercises[index]),
              ),
    );
  }
}
