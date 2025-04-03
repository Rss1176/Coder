import 'package:flutter_test/flutter_test.dart';
import 'package:coder_application/my_progress.dart';

// tests my progress update functions
// function from my progress witg stype switched to map instead of document snapshot

String pythonDescription = "";
num pythonXP = 0;
String javaDescription = "";
num javaXP = 0;
String csharpDescription = "";
num csharpXP = 0;

 void updateRanks(Map<String, dynamic> userDoc) async{
    // update the users python rank
    if (userDoc["pythonLevel"] > 5 && userDoc["pythonLevel"] <= 10){
      pythonDescription = "Intermediate";
      pythonXP = 11 - userDoc["pythonLevel"]; // questions need to reach for rank
    }
    else if (userDoc["pythonLevel"] > 10){
      pythonDescription = "Expert";
      pythonXP = 0; // questions no longer needed as already an expert
    }
    else{
      pythonDescription = "Beginner";
      pythonXP = 6 - userDoc["pythonLevel"]; // questions needed to reach for next rank
    }

    // update the users C# rank
    if (userDoc["c#Level"] > 5 && userDoc["c#Level"] <= 10){
      csharpDescription = "Intermediate";
      csharpXP = 11 - userDoc["c#Level"];  // questions needed to reach for next rank
    }
    else if (userDoc["c#Level"] > 10){
      csharpDescription = "Expert";
      csharpXP = 0; // questions no longer needed as already an expert
    }
    else{
      csharpDescription = "Beginner";
      csharpXP = 6 - userDoc["c#Level"]; 
    }

    //update the users java rank
    if (userDoc["javaLevel"] > 5 && userDoc["javaLevel"] <= 10){
      javaDescription = "Intermediate";
      javaXP = 11 - userDoc["javaLevel"]; // questions no longer needed as already an expert
    }
    else if (userDoc["javaLevel"] > 10){
      javaDescription = "Expert"; // questions needed to reach for next rank
      javaXP = 0;
    }
    else{
      javaDescription = "Beginner";
      javaXP = 6 - userDoc["javaLevel"]; // questions no longer needed as already an expert
    }
  }


// dummy firebase user 
Map<String, dynamic> user = {
  "pythonLevel": 0,
  "javaLevel": 0,
  "c#Level":0,
  "pythonDescription": "Expert",
  "javaDescription": "Expert",
  "c#Description":"Beginner",
};
void main() {
  group('calculate rank tests', () {
    test('Should return Beginner for python', () {
      user["pythonLevel"] = 0;
      updateRanks(user);
      expect(pythonDescription, "Beginner");
    });

    test('Should return Intermediate for java', () {
      user["javaLevel"] = 6;
      updateRanks(user);
      expect(javaDescription, "Intermediate");
    });

    test('Should return Expert for C#', () {
      user["c#Level"] = 11;
      updateRanks(user);
      expect(csharpDescription, "Expert");
    });
  });
}


