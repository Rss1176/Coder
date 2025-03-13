import 'package:flutter/material.dart';
import 'GeminiAPI.dart';

void main() {
  runApp(const Questions());
}

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
            Questions(),
          ],
        ),
      );
  }
}

class QuestionsPage extends StatefulWidget{
  const QuestionsPage({super.key})

  @override
  State<QuestionsPage> createState() => _QuestionsPage();
}

class _QuestionsPage extends State<QuestionsPage>{
  List<String> questions = [];
  String errorMessage = '';
    void fetchQuestions() async {
    try {
      List<String> fetchedQuestions = await GeminiAIService().generateQuestions("Intermediate", 5);
      setState(() {
        questions = fetchedQuestions;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton(onPressed: (){
            fetchQuestions();
          },
          child: Text("Get Questions", 
          style: TextStyle(fontSize: 18,))),
          if (errorMessage.isNotEmpty)
            Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          if (questions.isNotEmpty) 
            Column(
              children: questions.map((q) => Text(q)).toList(),
            ),
        ],
      )
    );
  } 
}