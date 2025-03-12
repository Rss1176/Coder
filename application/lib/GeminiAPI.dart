import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiAIService {
  final String apiKey = "AIzaSyCoVbgMFCvl45UgHdykSr_vwflMOYZcxbY";

  Future<List<String>> generateQuestions(String knowledgeLevel, int streak) async {
    const String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";

    final Map<String, dynamic> body = {
      "contents": [
        {
          "role": "user",
          "parts": [
            {
              "text": "You are a Python tutor. Generate two daily Python questions based on user engagement and knowledge level.\n"
                  "User has:\n"
                  "- Knowledge Level: $knowledgeLevel\n"
                  "- Login Streak: $streak days\n"
                  "Provide:\n"
                  "1. A simple warm-up question.\n"
                  "2. A challenging question."
            }
          ]
        }
      ]
    };

    final response = await http.post(
      Uri.parse("$endpoint?key=$apiKey"),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey("candidates") && jsonResponse["candidates"].isNotEmpty) {
        String textResponse = jsonResponse["candidates"][0]["content"]["parts"][0]["text"];
        return textResponse.split("\n").where((q) => q.trim().isNotEmpty).toList();  // Extracting questions
      } else {
        throw Exception("Invalid response structure: ${jsonResponse}");
      }
    } else {
      throw Exception("Failed to fetch AI questions: ${response.body}");
    }
  }
}

GeminiAIService geminiService = GeminiAIService();
// example function to be copy and pasted into classes where questions are required

void fetchQuestions() async {
  try {
    List<String> questions = await geminiService.generateQuestions("Intermediate", 5);
    print("Q1: ${questions[0]}");
    print("Q2: ${questions[1]}");
  } catch (e) {
    print("Error: $e");
  }
}