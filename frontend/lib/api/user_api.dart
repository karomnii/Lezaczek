import 'dart:convert';
import 'package:frontend/models/user.dart';
import 'package:frontend/models/error.dart';
import 'package:frontend/helpers/http_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UserApi {
  Future<dynamic> login(LoginFormData data) async {
    Response response = await HttpHelper.post("http://localhost:8080/api/v1/auth/login", body: data);
    
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      debugPrint("response: ${responseJson}");
      if(responseJson["result"] == "error"){
        return Error(text: responseJson["errorReason"]);
      }
      return userFromJson(responseJson);
    }
    return null;
  }
}