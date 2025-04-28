class GeminiResponse {
  final String response;

  GeminiResponse({required this.response});

  factory GeminiResponse.fromJson(Map<String, dynamic> json) {
    return GeminiResponse(response: json['response']);
  }
}
