import 'package:flutter/material.dart';
import 'GeminiAPI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
            Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar( // AppBar variables set
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
              backgroundColor: Color.fromARGB(255, 77, 175, 255),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Question Page",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'LuckiestGuy',
                    ),
                  ),
                  SizedBox(width: 110),
                ]
             )
            )
          )
        ]
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // variables for getting user details, used in dialog box
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<DocumentSnapshot> data;

  // same function block as used in all other firebase calls, fetches the user data, ensure the ID matches and gets the userdocument
  @override
  void initState() {
    super.initState();
    data = getFirebaseData();
  }

      Future<DocumentSnapshot> getFirebaseData() async{
      String? iD = _auth.currentUser?.uid;
      if (iD == null){
        throw Exception("You are not logged in");
      }
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(iD).get();

      if (!userDoc.exists){
        throw Exception("failed to find user document");
      }
      return userDoc;
    }


  final GeminiAIService geminiService = GeminiAIService(); // get an instantiation of the AI call class so the method can be called off it
  Map<String, dynamic> response = {"Response" : "no : response"} ; // set an base value map that can be changed by function

  String? pLanguage = "Python";
  String? aptitude = "beginner";
  bool languageSelected = false;
  Color _buttonColor1 = Colors.white;
  Color _buttonColor2 = Colors.white;
  Color _buttonColor3 = Colors.white;
  Color _buttonColor4 = Colors.white;
  String? _selectedAnswer = "";
  bool _questionChecked = false;
  String _buttonText = "Submit";
  String _resultText = "";

  void generateQuestions() async { //set inital state of function so the page can be built, will be recalled every time the drop down box is pressed
  try{Map<String, dynamic> questionResponse = await geminiService.generateQuestions(aptitude,pLanguage);
    setState(() {
      response = questionResponse;
      // reset all vars that change to answer the question back to their basic values
      _selectedAnswer = "";
      _questionChecked = false;
      _buttonText = "Submit";
      _buttonColor1 = _buttonColor2 = _buttonColor3 = _buttonColor4 = Colors.white;
    });}
    catch (e){
      setState(() {
        response = {"Response": "Failed to generate Questions: $e"};
      });
    }
  }

  void checkAnswer(){
    // ensure that nothing happens if an answer has not yet been chosen
    if (_selectedAnswer == null || _selectedAnswer!.isEmpty || _selectedAnswer == "") return;
    String apiAnswer = response["answer"];

    String correctAnswer = apiAnswer;
    setState((){
      _questionChecked = true;
      _buttonText = "Next Question";
    });

    _resultText = _selectedAnswer == correctAnswer ? "Correct!" : "Incorrect, the answer is $apiAnswer";
  }

  void setButtonToActive(String? value){
  setState(() {
    pLanguage = value;
    languageSelected = value != null; // only allows the generate question button be pressed if a language has been chosed in the drop down
    });

    data.then((userDoc){
      updateAptitude(pLanguage, userDoc); // update language and aptitiude each time the language is changed
    });

    generateQuestions(); // rerun the generate questions call with the new language selected to istantiate with the correct language
  }

  void updateAptitude(String? pLanguage, DocumentSnapshot userDoc){
    setState((){
    // function that checks the users level with a language and sets it to a valid difficulty
    if (pLanguage == "Java"){
      int checker = userDoc["javaLevel"];
      if (checker > 5 &&  checker <= 10){
        aptitude = 'intermediate';
      }
      else if (checker > 10){
        aptitude = 'expert';
      }
      else{
        aptitude = 'beginner';
      }
    }
    else if (pLanguage == 'C#') {
      int checker = userDoc["c#Level"];
      if (checker > 5 &&  checker <= 10){
        aptitude = 'intermediate';
      }
      else if (checker > 10){
        aptitude = 'expert';
      }
      else{
        aptitude = 'beginner';
      }
    }
    else {
      int checker = userDoc["pythonLevel"];
      if (checker > 5 &&  checker <= 10){
        aptitude = 'intermediate';
      }
      else if (checker > 10){
        aptitude = 'expert';
      }
      else{
        aptitude = 'beginner';
      }
    }
  });
  }

  @override
  Widget build(BuildContext context){
    return Center(
          // scroll view for page 
          child: SingleChildScrollView(
            child: Padding(padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:<Widget>[

          // adding white sppace
          SizedBox(
            height:65.0
          ),

          // button to select the programing language of the question
          DropdownButtonFormField<String>(
                value: pLanguage,
                decoration: InputDecoration(
                  prefixIcon: Visibility(
                    child: Icon(Icons.place, color: Color.fromARGB(255, 213, 213, 213)),
                  ),
                  
                  hintText: "Select Programing Language",
                  hintStyle: TextStyle(color: Colors.black),
                  labelText: "",
                  floatingLabelBehavior: FloatingLabelBehavior.always, 
                  floatingLabelStyle: TextStyle(fontSize: 20, color: Colors.black),
                  filled: true,
                  fillColor: const Color.fromARGB(11, 225, 225, 225),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                items: [
                  DropdownMenuItem(value: 'Python', child: Text('Python',
                    style: TextStyle(color: Colors.black))),
                  DropdownMenuItem(value: 'C#', child: Text('C#',
                    style: TextStyle(color: Colors.black))),
                  DropdownMenuItem(value: 'Java', child: Text('Java',
                    style: TextStyle(color: Colors.black))),
                ],
                hint: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Location', style: TextStyle(color: Color.fromARGB(255, 168, 168, 168))),
                ),
                onChanged: (value) {
                  setButtonToActive(value);
                }         
              ),

          // sized box
          SizedBox(
            height:25.0
          ),

          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/questions_background_1.png"),
                fit: BoxFit.cover
                ),
              border: Border.all(
                color: const Color.fromARGB(255, 77, 175, 255),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(25),
              color: Color.fromARGB(81, 255, 255, 255),
            ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
                        
              // adding white sppace
              SizedBox(
                height:30.0
              ),

          // add a firebase call to get the aptitude of a user later
          if (response["question"] != null && response["question"]!.isNotEmpty)

          Column(children: <Widget>[

            // Question String
            Text(response["question"], style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold
              ),
            ),

            // adding white space
            SizedBox(
              height:50.0
            ),

            // First answer button
            Row(children:<Widget>[
              ElevatedButton(onPressed: (){setState(() {
                _buttonColor1 = Colors.blue;
                _buttonColor2 = Colors.white;
                _buttonColor3 = Colors.white;
                _buttonColor4 = Colors.white;
                _selectedAnswer = "A";
              });},
              style: ElevatedButton.styleFrom(shape: CircleBorder(),
                                             padding: EdgeInsets.all(0),
                                             backgroundColor: _buttonColor1, 
                                             elevation: 4), 
                                             child: Container(width: 32,
                                             height: 32,
                                             alignment: Alignment.center,
                                             child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(color: _buttonColor1,
                                              shape: BoxShape.circle),
                                             )
                                            ),
  
                ),        
                Flexible(
                  child: Text(response["optionA"], style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,),
                    softWrap: true, // ensures text can feed to next line
                ),
                ),
              ] 
            ),

            // adding white space
            SizedBox(
              height:20.0
            ),

            //second answer button
            Row(children:<Widget>[
              ElevatedButton(onPressed: (){setState(() {
                _buttonColor2 = Colors.blue;
                _buttonColor1 = Colors.white;
                _buttonColor3 = Colors.white;
                _buttonColor4 = Colors.white;
                _selectedAnswer = "B";
              });},  
              style: ElevatedButton.styleFrom(shape: CircleBorder(),
                                             padding: EdgeInsets.all(0),
                                             backgroundColor: _buttonColor2, 
                                             elevation: 4), 
                                             child: Container(width: 32,
                                             height: 32,
                                             alignment: Alignment.center,
                                             child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(color: _buttonColor2,
                                              shape: BoxShape.circle),
                                             )
                                            ),
                ),        
                Flexible(
                  child: Text(response["optionB"], style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,),
                    softWrap: true, // ensures text can feed to next line
                  ),
                )
              ]
            ),
            
            // adding white space
            SizedBox(
              height:20.0
            ),

            //Third answer button
            Row(children:<Widget>[
              ElevatedButton(onPressed: (){setState(() {
                _buttonColor3 = Colors.blue;
                _buttonColor1 = Colors.white;
                _buttonColor2 = Colors.white;
                _buttonColor4 = Colors.white;
                _selectedAnswer = "C";
              });},  
              style: ElevatedButton.styleFrom(shape: CircleBorder(),
                                             padding: EdgeInsets.all(0),
                                             backgroundColor: _buttonColor3, 
                                             elevation: 4), 
                                             child: Container(width: 32,
                                             height: 32,
                                             alignment: Alignment.center,
                                             child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(color: _buttonColor3,
                                              shape: BoxShape.circle),
                                             )
                                            ),
                ),        
                Flexible(
                  child: Text(response["optionC"], style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,),
                    softWrap: true, // ensures text can feed to next line
                  ),
                )
              ] 
            ),

            // adding white space
            SizedBox(
              height:20.0
            ),

            //Forth answer button
            Row(children:<Widget>[
              ElevatedButton(onPressed: (){setState(() {
                _buttonColor4 = Colors.blue;
                _buttonColor1 = Colors.white;
                _buttonColor2 = Colors.white;
                _buttonColor3 = Colors.white;
                _selectedAnswer = "D";
              });},  
              style: ElevatedButton.styleFrom(shape: CircleBorder(),
                                             padding: EdgeInsets.all(0),
                                             backgroundColor: _buttonColor4, 
                                             elevation: 4), 
                                             child: Container(width: 32,
                                             height: 32,
                                             alignment: Alignment.center,
                                             child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: BoxDecoration(color: _buttonColor4,
                                              shape: BoxShape.circle),
                                             )
                                            ),
                ),
                Flexible(
                  child: Text(response["optionD"], style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,),
                    softWrap: true, // ensures text can feed to next line
                ),
              ),
              ],
            ),

            // add white space
          SizedBox(
            height:30.0
          ),

          if (_questionChecked)
          Text(_resultText, style: TextStyle(
            color: _resultText == "Correct!" ? Colors.green : Colors.red, // make the text green if correct red if wrong
            fontSize: 22,
            fontWeight:  FontWeight.bold,
          ),),

          SizedBox(
            height: 30.0,
            ),

            if(_questionChecked)
            Text(response["explination"], style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold
              )
            )
            else
            SizedBox(
              height: 30,
            ),

            // adding white space
            SizedBox(
              height:40.0
            ),

            ElevatedButton(onPressed: languageSelected ? (){
              if (!_questionChecked){
                checkAnswer();
              } else {
                generateQuestions();
              }
          } : null, // logic for making the elevated button rely on the boolean
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 77, 175, 255),
            minimumSize: Size(50, 80),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: Row(
            children:[

              Text(_buttonText, 
                style: TextStyle(
                  color: Colors.white)
              ),

              SizedBox(
                width: 5.0
              ),

              Icon(Icons.arrow_forward_ios, 
                color: Colors.white,
              ),
            ],
          ),
          )
          ],
          )
          else
          Column(
            children: <Widget> [

              // adding white space
              SizedBox(
                height: 300,
                width: 500,
              ),

              // adding hint text
              Text("Please select a language", 
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
              ),

              // adding white space
              SizedBox(
                height: 300,
              )
            ],
          )

            ]
           )
           )
          )
        ]
      ),
    )
    ),
    );
  } 
}