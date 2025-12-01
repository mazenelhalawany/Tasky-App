
class UserModel {
  final String? id;
  final String email;
  final String? password;

  UserModel({
    this.id,
    required this.email,
    this.password,
  });

  // ✅ تحويل الـ Model إلى Map لحفظه في Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'createdAt': DateTime.now(),
    };
  }

  // ✅ إنشاء UserModel من Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
    );
  }
}
