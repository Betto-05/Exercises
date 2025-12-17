import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:football/core/api/dio_consumer.dart';
import 'package:football/core/api/end_points.dart';
import 'package:football/core/constants/colors.dart';
import 'package:football/core/models/exercise.dart';
import 'package:football/features/home/ui/components/section_header.dart';

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

// ---------------------------------------------------------------------------
// 3. UI CARDS (Clickable -> DetailScreen)
// ---------------------------------------------------------------------------

// Featured Card
class FeaturedExerciseCard extends StatelessWidget {
  final ExerciseModel exercise;
  const FeaturedExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // ✅ NAVIGATION TO DETAILS
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExerciseDetailScreen(exercise: exercise),
          ),
        );
      },
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  exercise.imageUrl720,
                  fit: BoxFit.cover,
                  headers: const {
                    'X-RapidAPI-Key': EndPoints.apiKey,
                    'X-RapidAPI-Host': EndPoints.apiHost,
                  },
                  errorBuilder: (c, e, s) {
                    return Image.network(exercise.gifUrl, fit: BoxFit.cover);
                  },
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 15,
              right: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.target.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    exercise.name.capitalize(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Grid Card
class ExerciseGridCard extends StatelessWidget {
  final ExerciseModel exercise;
  const ExerciseGridCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // ✅ NAVIGATION TO DETAILS
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
                child: Image.network(
                  exercise.imageUrl720,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  headers: const {
                    'X-RapidAPI-Key': EndPoints.apiKey,
                    'X-RapidAPI-Host': EndPoints.apiHost,
                  },
                  errorBuilder:
                      (c, o, s) =>
                          Image.network(exercise.gifUrl, fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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

// ---------------------------------------------------------------------------
// 4. ✅ EXERCISE DETAIL SCREEN (NEW TASK)
// ---------------------------------------------------------------------------
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
              icon: const Icon(Icons.arrow_back, color: Colors.white),
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

// ---------------------------------------------------------------------------
// 5. LIST & FILTER SCREENS
// ---------------------------------------------------------------------------

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
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueAccent,
      ), // AppColors.primary
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

class StringListScreen extends StatefulWidget {
  final String title;
  final String listEndpoint;
  final String Function(String item) getNextEndpoint;
  const StringListScreen({
    super.key,
    required this.title,
    required this.listEndpoint,
    required this.getNextEndpoint,
  });
  @override
  State<StringListScreen> createState() => _StringListScreenState();
}

class _StringListScreenState extends State<StringListScreen> {
  List<String> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final consumer = DioConsumer(dio: Dio());
      final data = await consumer.get(widget.listEndpoint);
      if (mounted) {
        setState(() {
          items = List<String>.from(data);
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
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueAccent,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                itemCount: items.length,
                separatorBuilder: (c, i) => const Divider(),
                itemBuilder:
                    (context, index) => ListTile(
                      title: Text(items[index].capitalize()),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ExerciseListScreen(
                                  title: items[index].capitalize(),
                                  apiPath: widget.getNextEndpoint(items[index]),
                                ),
                          ),
                        );
                      },
                    ),
              ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. HOME SCREEN (Updated UI & Clickable Equipment)
// ---------------------------------------------------------------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  // Search Controller
  final TextEditingController _searchController = TextEditingController();

  List<String> bodyParts = [];
  List<String> equipmentList = [];
  List<ExerciseModel> featuredExercises = [];

  // Icon logic for Body Parts
  IconData _getBodyPartIcon(String s) {
    if (s.contains('cardio')) return Icons.directions_run;
    if (s.contains('chest')) return Icons.fitness_center;
    if (s.contains('waist')) return Icons.boy;
    return Icons.accessibility_new;
  }

  // Icon logic for Equipment (Just to vary the visuals slightly)
  IconData _getEquipmentIcon(String s) {
    if (s.contains('weight') || s.contains('dumb')) return Icons.fitness_center;
    if (s.contains('cable') || s.contains('machine'))
      return Icons.confirmation_number_outlined;
    if (s.contains('band')) return Icons.linear_scale;
    return Icons.handyman; // generic
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final consumer = DioConsumer(dio: Dio());
      final res = await Future.wait([
        consumer.get(EndPoints.bodyPartList),
        consumer.get(EndPoints.equipmentList),
        consumer.get(EndPoints.getAllExercises, queryParameters: {'limit': 6}),
      ]);
      if (mounted) {
        setState(() {
          bodyParts = List<String>.from(res[0]).take(10).toList();
          equipmentList = List<String>.from(res[1]).take(10).toList();
          featuredExercises =
              (res[2] as List).map((e) => ExerciseModel.fromJson(e)).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _performSearch(String query) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Find Your Workout',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // --- SEARCH BAR ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) => _performSearch(value),
                          decoration: InputDecoration(
                            hintText: "Search workout...",
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.blueAccent,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // --- BODY PARTS ---
                    SectionHeader(
                      title: "Body Parts",
                      onSeeAll:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => StringListScreen(
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
                        itemCount: bodyParts.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 15),
                        itemBuilder: (_, i) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => ExerciseListScreen(
                                        title: bodyParts[i].capitalize(),
                                        apiPath:
                                            "${EndPoints.getExercisesByBodyPart}${bodyParts[i]}",
                                      ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _getBodyPartIcon(bodyParts[i]),
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  bodyParts[i].capitalize(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- FEATURED ---
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
                        itemCount: featuredExercises.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 15),
                        itemBuilder:
                            (_, i) => FeaturedExerciseCard(
                              exercise: featuredExercises[i],
                            ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // --- EQUIPMENT (NEW & IMPROVED) ---
                    SectionHeader(
                      title: "Equipment",
                      onSeeAll:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => StringListScreen(
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
                      height: 60, // Increased height for better UI
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: equipmentList.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, i) {
                          return GestureDetector(
                            // ✅ CLICKABLE EQUIPMENT
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => ExerciseListScreen(
                                        title: equipmentList[i].capitalize(),
                                        apiPath:
                                            "${EndPoints.getExercisesByEquipment}${equipmentList[i]}",
                                      ),
                                ),
                              );
                            },
                            // ✅ IMPROVED UI CARD
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueAccent.withOpacity(0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _getEquipmentIcon(equipmentList[i]),
                                    size: 18,
                                    color: Colors.blueAccent,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    equipmentList[i].capitalize(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
    );
  }
}
