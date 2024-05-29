import 'dart:convert';
import 'package:flutter/material.dart';
User userFromJson(Map<String, dynamic> jsonStr) => User.fromJson(jsonStr);
String loginJson(LoginFormData data) => json.encode(data.toJson());
enum Gender {
  male('Male'),
  female('Female'),
  unspecified('I don\'t want to specify');
  const Gender(this.label);
  final String label;
}
class User {

  String? name;
  String? surname;
  Gender? gender;
  String? email;
  String accessToken;
  String refreshToken;
  User({this.name, this.surname, this.email, this.gender, required this.accessToken, required this.refreshToken});
  factory User.fromJson(Map<String, dynamic> json){
    debugPrint("json: $json");
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

class RegisterFormData {
  String email;
  String password;
  String name;
  String surname;
  Gender gender;
  RegisterFormData({required this.email, required this.password, required this.name, required this.surname, required this.gender});
  Map<String, dynamic> toJson() => {
    "email": email,
    "password" : password,
    "name": name,
    "surname": surname,
    "gender": gender.index
  };
}