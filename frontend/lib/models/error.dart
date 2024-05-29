class Error {
  String text;

  Error({required this.text});

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(text: json["errorReason"]);
  }
}