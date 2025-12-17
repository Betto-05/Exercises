class ProfileModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;

  ProfileModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'name': name, 'email': email, 'photoUrl': photoUrl};
  }

  ProfileModel copyWith({String? name, String? photoUrl}) {
    return ProfileModel(
      uid: uid,
      name: name ?? this.name,
      email: email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
