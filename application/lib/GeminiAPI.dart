import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiAIService {
  
  Future<Map<String, dynamic>> generateQuestions(String abilityLevel, String codingLanguage) async{
    final String apiKey = 'AIzaSyAZxxFD_mRrNw60wuJfzD4ykUxItEEw9Nw';
    final String modelName = 'models/gemini-1.5-pro-002'; // chnaged model a couple times in debugging so made its own variable for ease
    final String endpoint = "https://generativelanguage.googleapis.com/v1/models/$modelName:generateContent";
    //future object that creates a dictionary (map) of json response and name
    //the name is a string and the json response is of type dynamic to avoid type errors
    //accepts input string of an ability level used in the promp given to the AI
    //the ability level will allow us to edit the type of questions based on the user
    //accepts a language parameter so that mutiple coding languages can be used
    try {
      final questionResponse = await http.post(
        Uri.parse(endpoint + '?key=$apiKey'), //sets the end point to the api key creating the link to the AI account
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [{"parts":[
            {"text" : "wrtie a short story"}//used """ for multiline strings and readability
            ]
            }
          ]
        })
      );
      
      if (questionResponse.statusCode == 200) {//enssure http has connected properly with a response
        final data = jsonDecode(questionResponse.body);
        String textResponse = data['candidates'][0]['content']['parts'][0]['text']; //gemini produces json with these headings
        // candidates is the full response (only matters if we decided to do mutiple prompts), content is a single response, part isnt used here, text is the text of the question
        return {"question": textResponse};
      } else {
          return {"failure to complete http ai request": "the body said: ${questionResponse.body}"};
      }
    }
    catch (e){
      return {"error": "$e"};
    }
    }
  }

  // """Generate a multiple choice question about the coding langauge $codingLanguage"
  //                     "It should be aimed at someone at a $abilityLevel level"
  //                     "There should be 4 answers to the questions."
  //                     "the final part of the response should be the correct answer, i.e A,B,C,D with the final part being C"""