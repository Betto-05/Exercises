class ExerciseModel {
  final String id;
  final String name;
  final String gifUrl;
  final String target;
  final String bodyPart;
  final String equipment;
  final List<String> instructions;
  final List<String> secondaryMuscles;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.gifUrl,
    required this.target,
    required this.bodyPart,
    required this.equipment,
    required this.instructions,
    required this.secondaryMuscles,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown',
      gifUrl: json['gifUrl'] ?? '',
      target: json['target'] ?? '',
      bodyPart: json['bodyPart'] ?? '',
      equipment: json['equipment'] ?? '',
      // ✅ SAFELY PARSE LISTS
      instructions:
          (json['instructions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      secondaryMuscles:
          (json['secondaryMuscles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  // ✅ 720p Image Logic
  String get imageUrl720 {
    return 'https://exercisedb.p.rapidapi.com/image?exerciseId=$id&resolution=720';
  }
}
