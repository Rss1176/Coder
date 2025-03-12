import 'package:flutter/material.dart';
import 'GeminiAPI.dart';

void main(){
  runApp(const Home());
}

class Home extends StatelessWidget{
  const Home({super.key});

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
            HomePage(),
          ],
        ),
      );
  }
}

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
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