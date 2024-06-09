import 'dart:convert';
import 'package:frontend/models/user.dart';
import 'package:frontend/models/error.dart';
import 'package:frontend/helpers/http_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UserApi {
  Future<dynamic> login(LoginFormData data) async {
    Response response = await HttpHelper.post(
        "http://10.0.2.2:8080/api/v1/auth/login",
        body: data);

    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      if (responseJson["result"] == "error") {
        return Error(text: responseJson["errorReason"]);
      }
      return userFromJson(responseJson);
    }
    return null;
  }

  Future<dynamic> register(RegisterFormData data) async {
    Response response = await HttpHelper.put(
        "http://10.0.2.2:8080/api/v1/auth/register",
        body: data);
    var responseJson = json.decode(response.body);
    if (responseJson["result"] == "error") {
      return Error(text: responseJson["errorReason"]);
    }
    return true;
  }

  Future<dynamic> deleteAccount(User user) async {
    Response response = await HttpHelper.post(
        "http://10.0.2.2:8080/api/v1/user/delete",
        body: {
          "accessToken": user.accessToken,
          "refreshToken": user.refreshToken
        });
    var responseJson = json.decode(response.body);
    if (responseJson["result"] == "error") {
      return Error(text: responseJson["errorReason"]);
    }
    return true;
  }
  
  Future<bool> isUserAnAdmin(User user) async {
    Response response = await HttpHelper.get(
        "http://10.0.2.2:8080/api/v1/user/isAdmin");
    if (response.statusCode == 200) {
      final List<dynamic> responseList = json.decode(response.body);
      int isAdmin = responseList[0];
      if(isAdmin == 1){
        return true;
      }
      return false;
    }
    else{
      throw Error(text: 'Couldn\'t get data');
    }
  }
}
