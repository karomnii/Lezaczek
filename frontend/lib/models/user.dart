import 'dart:convert';
User userFromJson(Map<String, dynamic> jsonStr) => User.fromJson(jsonStr);
String loginJson(LoginFormData data) => json.encode(data.toJson());

class User {
  String? name;
  String? surname;
  int? gender;
  String? email;
  String accessToken;
  String refreshToken;
  User({this.name, this.surname, this.email, this.gender, required this.accessToken, required this.refreshToken});
  factory User.fromJson(Map<String, dynamic> json){
    return User(name: json["name"],
                surname: json["surname"],
                email: json["email"],
                gender: json["gender"],
                accessToken: json["accessToken"],
                refreshToken: json["refreshToken"]);
  }
}

class LoginFormData {
  String email;
  String password;

  LoginFormData({required this.email, required this.password});
  Map<String, String> toJson() => {
    "email" : email,
    "password" : password,
  };
}