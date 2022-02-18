class UserModel {
  String? name, email, gender, imageUrl, userId, number;

  UserModel(
      {this.name,
      this.gender,
      this.email,
      this.imageUrl,
      this.userId,
      this.number});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'imageUrl': imageUrl,
      'uid': userId,
      'number': number
    };
  }

  factory UserModel.fromMap(map) {
    return UserModel(
        name: map['name'],
        email: map['email'],
        gender: map['gender'],
        imageUrl: map['imageUrl'],
        userId: map['uid'],
        number: map['number']);
  }
}
