import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class HttpHelper {
  static final JsonDecoder _decoder = new JsonDecoder();
  static final JsonEncoder _encoder = new JsonEncoder();

  static Map<String, String> headers = {"content-type": "application/json"};
  static Map<String, String> cookies = {};
  static void updateCookieFromHeaders(){
    headers['cookie'] = _generateCookieHeader();
  }
  static void _updateCookie(http.Response response) {
    String? allSetCookie = response.headers['set-cookie'];

    if (allSetCookie != null) {

      var setCookies = allSetCookie.split(',');

      for (var setCookie in setCookies) {
        var cookies = setCookie.split(';');

        for (var cookie in cookies) {
          setCookieVal(cookie);
        }
      }

      headers['cookie'] = _generateCookieHeader();
    }
  }

  static void setCookieVal(String rawCookie) {
    if (rawCookie.length > 0) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];

        // ignore keys that aren't cookies
        if (key == 'Path' || key == 'Expires' || key == 'Max-Age') {
          return;
        }

        cookies[key] = value;
      }
    }
  }
  static void _unsetCookie(String cookie) {

      cookies.remove(cookie);

  }

  static String _generateCookieHeader() {
    String cookie = "";

    for (var key in cookies.keys) {
      if (cookies[key]!.isNotEmpty) {
        cookie += ";";
        cookie += "$key=${cookies[key]}";
      }
    }

    return cookie;
  }

  static Future<http.Response> get(String url) {
    final Uri uri = Uri.parse(url);
    return http.get(uri, headers: headers).then((http.Response response) {
      _updateCookie(response);
      return response;
    });
  }

  static Future<http.Response> post(String url, {body, encoding}) {

    final Uri uri = Uri.parse(url);
    return http
        .post(uri, body: _encoder.convert(body), headers: headers, encoding: encoding)
        .then((http.Response response) {

      _updateCookie(response);
      return response;
    });
  }
  static Future<http.Response> put(String url, {body, encoding}) {
    final Uri uri = Uri.parse(url);
    return http
        .put(
        uri, body: _encoder.convert(body), headers: headers, encoding: encoding)
        .then((http.Response response) {
      _updateCookie(response);

      return response;
    });
  }
}