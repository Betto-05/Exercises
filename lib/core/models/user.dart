import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String uid;
  final String? email;
  final String? name;
  final bool isEmailVerified;

  AppUser({
    required this.uid,
    this.email,
    this.name,
    this.isEmailVerified = false,
  });

  factory AppUser.fromFirebase(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email,
      name: user.displayName,
      isEmailVerified: user.emailVerified,
    );
  }

  /// Convert to JSON Map
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'isEmailVerified': isEmailVerified,
    };
  }

  /// Create AppUser from JSON Map
  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      isEmailVerified: json['isEmailVerified'] ?? false,
    );
  }

  /// Copy user with modifications
  AppUser copyWith({
    String? uid,
    String? email,
    String? name,
    bool? isEmailVerified,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory AppUser.fromJsonString(String jsonString) =>
      AppUser.fromJson(jsonDecode(jsonString));
}
