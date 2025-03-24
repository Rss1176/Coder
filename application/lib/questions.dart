import 'package:flutter/material.dart';
import 'GeminiAPI.dart';

class Questions extends StatelessWidget {
  const Questions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image.asset(
                "assets/images/Background Main_Dark Mode_No Scroll.png",
                fit: BoxFit.cover,
              ),
            ),
            QuestionsPage(),
          ],
        ),
      );
  }
}

class QuestionsPage extends StatefulWidget{
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPage();
}

class _QuestionsPage extends State<QuestionsPage>{
  final GeminiAIService geminiService = GeminiAIService(); // get an instantiation of the AI call class so the method can be called off it
  Map<String, dynamic> response = {"Response" : "no : response"} ; // set an base value map that can be changed by function

  String? pLanguage = "Python";
  String? aptitude = "beginner";
  bool languageSelected = false;

  @override 
  void initState(){
   super.initState();
   generateQuestions();
  }

  void generateQuestions() async { //set inital state of function so the page can be built, will be recalled every time the drop down box is pressed
  try{Map<String, dynamic> questionResponse = await geminiService.generateQuestions(aptitude,pLanguage);
    setState(() {
      response = questionResponse;
    });}
    catch (e){
      setState(() {
        response = {"Response": "Failed to generate Questions: $e"};
      });
    }
  }

  void setButtonToActive(String? value){
  setState(() {
    languageSelected = value != null;
    pLanguage = value; // only allows the generate question button be pressed if a language has been chosed in the drop down
    });
    generateQuestions(); // rerun the generate questions call with the new language selected to istantiate with the correct language
  }

  @override
  Widget build(BuildContext context){
    return Center
    (
      child: Column
      (
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // button to select the programing language of the question
          DropdownButtonFormField<String>(
                      value: pLanguage,
                      decoration: InputDecoration(
                        prefixIcon: Visibility(
                          child: Icon(Icons.place, color: Color.fromARGB(255, 213, 213, 213)),
                        ),
                        
                        hintText: "Select Programing Language",
                        hintStyle: TextStyle(color: Color.fromARGB(255, 168, 168, 168)),
                        labelText: "",
                        floatingLabelBehavior: FloatingLabelBehavior.always, 
                        floatingLabelStyle: TextStyle(fontSize: 20),
                        filled: true,
                        fillColor: const Color.fromARGB(11, 225, 225, 225),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(value: 'Python', child: Text('Python')),
                        DropdownMenuItem(value: 'C*', child: Text('C*')),
                        DropdownMenuItem(value: 'Java', child: Text('Java')),
                      ],
                      hint: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Location', style: TextStyle(color: Color.fromARGB(255, 168, 168, 168))),
                      ),
                      onChanged: (value) {
                        setButtonToActive(value);
                      }         
          ),
          // add a firebase call to get the aptitude of a user later

          ElevatedButton(onPressed: languageSelected ? (){
            generateQuestions();
          } : null, // logic for making the elevated button rely on the boolean
           child: Text("Get Next Question")),
          if (response["question"] != null && response["question"]!.isNotEmpty)
          Column(children: <Widget>[
            Text(response["question"]),
            Text(response["optionA"]),
            Text(response["optionB"]),
            Text(response["optionC"]),
            Text(response["optionD"]),
            Text(response["explination"]), 
          ],
          )
          else
          Text("Please select a language")
        ]
      ),
    );
  } 
}