class EndPoints {
  static const String baseUrl = 'https://exercisedb.p.rapidapi.com';
  static const String apiKey =
      '1b72214af9mshcc21786fce0b75cp15f9a7jsne17daf1dd4dc';
  static const String apiHost = 'exercisedb.p.rapidapi.com';

  // Core Listings
  static const String getAllExercises = "/exercises";
  static const String bodyPartList = "/exercises/bodyPartList";
  static const String equipmentList = "/exercises/equipmentList";
  static const String targetList = "/exercises/targetList";

  // Search/Filter endpoints
  static const String getExerciseById = "/exercises/exercise/"; // + id
  static const String getExercisesByBodyPart = "/exercises/bodyPart/"; // + part
  static const String getExercisesByTarget = "/exercises/target/"; // + target
  static const String getExercisesByEquipment = "/exercises/equipment/"; // + eq
  static const String getExercisesByName = "/exercises/name/"; // + name
  static const String images = "/image";
}
