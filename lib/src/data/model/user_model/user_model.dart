class UserModel {
  final String uid;
  final String email;
  final String name;
  final String designation;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.designation = "General Public", //Space Explorer//Default value
  });

  // Data ko Firestore mein bhejne ke liye (Map mein badalna)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'designation': designation,
    };
  }

  // Firestore se data nikal kar model banane ke liye
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      designation: map['designation'] ?? 'General Public',
    );
  }
}