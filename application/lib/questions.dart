import 'package:flutter/material.dart';
import 'GeminiAPI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'page_animation.dart';
import 'package:google_fonts/google_fonts.dart';


class Questions extends StatelessWidget {
  const Questions({super.key});
  // set background image in stack
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image.asset(
                "assets/images/background_simple.png",
                fit: BoxFit.cover,
              ),
            ),
            QuestionsPage(),

            // set app bar
            Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar( // AppBar variables set
              automaticallyImplyLeading: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
              backgroundColor: Color.fromARGB(255, 0, 85, 155),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Questions",
                    style: GoogleFonts.anton(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),

                    // set back button
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        // show  a dialog between back and questions to people dont accidentally leave on a question theyre working on
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Return Home?"),
                              content: Text("All progress has been saved! \n\n"
                                  "Pressing 'Yes' will return you to the Dashboard"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("No"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(createPageRoute2(Home()));
                                  },
                                  child: Text("Yes"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
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
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    // start to get data as page is loaded, helps stop waiting time on screen
    data = getFirebaseData(); 
  }

    // same function block as used in all other firebase calls, fetches the user data, ensure the ID matches and gets the userdocument
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

  String? pLanguage = "Python"; // varibles passed into the API setting the language and the levels
  String? aptitude; // set default values to stop crashes as the page opens
  bool languageSelected = false; // stops a question being generated until a language has been selected
  Color _buttonColor1 = Colors.white;
  Color _buttonColor2 = Colors.white;
  Color _buttonColor3 = Colors.white; // default colours for multiple choice Q's
  Color _buttonColor4 = Colors.white;
  String? _selectedAnswer = ""; // answer to be checked against the API
  bool _questionChecked = false;
  String _buttonText = "Submit"; // changes button text based on the stage of the question screen
  String _resultText = "";
  bool daily = false; // set a variable about wether your daily questions have been used up or not

  void generateQuestions() async { //set inital state of function so the page can be built, will be recalled every time the drop down box is pressed
  setState(() {
      _isLoading = true;
  });
  try{Map<String, dynamic> questionResponse = await geminiService.generateQuestions(aptitude,pLanguage);
    setState(() {
      response = questionResponse;
      // reset all vars that change to answer the question back to their basic values
      _selectedAnswer = "";
      _questionChecked = false;
      _buttonText = "Submit";
      _buttonColor1 = _buttonColor2 = _buttonColor3 = _buttonColor4 = Colors.white; // set loading indicator waiting API call
    });}
    catch (e){
      setState(() {
        response = {"Response": "Failed to generate Questions: $e"};
      });
    } finally {
      setState(() {
        _isLoading = false; // hide loading indicator after API call
      });
    }
  }

  void checkAnswer(){
    // ensure that nothing happens if an answer has not yet been chosen
    if (_selectedAnswer == null || _selectedAnswer!.isEmpty || _selectedAnswer == "") return;
    String apiAnswer = response["answer"];
    bool isCorrect = _selectedAnswer == apiAnswer;
    incrementDailyAnswered();

    setState((){
      _questionChecked = true;
      _buttonText = "Next Question";
      data = getFirebaseData(); // updates daily question banner
    });

    _resultText = isCorrect ? "Correct!" : "Incorrect, the answer is $apiAnswer"; // check if the users' answer is correct

    if (isCorrect){
      // add a point to the user account if they got a question correct
      updateUserScore(pLanguage);
    }
  }

  Future<void> incrementDailyAnswered() async {
  try {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception("User not found");
    }
    DocumentReference userRef = _firestore.collection('users').doc(userId); // get users reference
    await userRef.update({
      "dailyAnswered": FieldValue.increment(1),  // Increment the users daily question count by 1
    });
  } catch (e) {
    throw Exception("Error updating dailyAnswered: $e");
  }
}


  void setButtonToActive(String? value){
  setState(() {
    pLanguage = value;
    languageSelected = value != null; // only allows the generate question button be pressed if a language has been chosed in the drop down
    });

    if (languageSelected){
      generateQuestions();
    }

    data.then((userDoc){
      updateAptitude(pLanguage, userDoc); // update language and aptitiude each time the language is changed
    });

    generateQuestions(); // rerun the generate questions call with the new language selected to istantiate with the correct language
  }

  void updateAptitude(String? pLanguage, DocumentSnapshot userDoc){
    setState((){
    // function that checks the users level with a language and sets it to a valid difficulty
    // after 5 correct become a intermediate - after 10 an expert - in a real deployment these values would be far higher
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

  Row buildDailyBanner(DocumentSnapshot userDoc){
    // function that returns the row widget at the top of the screen based on if the user still has daily question to answer of not
    if (userDoc["dailyAnswered"] < 6){
      daily = true; // boolean that sets if a user is getting double or single points from a question
      return Row(children: [
         Text(
            "You have answered ${userDoc["dailyAnswered"]} of 5 Daily Questions",
            style: GoogleFonts.anton(
              color: Colors.white,
              fontSize: 16,
              ),
         )
      ],
      );
    } else{
      daily = false;
      return Row(children: [
        Text(
          "Daily Questions Complete!",
          style: GoogleFonts.anton(
            color: Colors.white,
            fontSize: 16,
            ),
        )
      ],);
    }
  }

  Future<void> updateUserScore(String? progLanguage) async {
    // update a users score on a successful question answered
    // 2 points if its a daily question 1 if not (increment sets this)
    int increment = 1;
    if (daily == true) {
      increment = 2;
    }
    try{
      String? userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception("User not found");
      }

      DocumentReference userRef = _firestore.collection('users').doc(userId);
      DocumentSnapshot userDoc = await userRef.get();
      if (userDoc.exists) {
        if (progLanguage == "Python"){
          int currentScore = userDoc["pythonLevel"];
          await userRef.update({"pythonLevel": currentScore + increment});
        }
          if (progLanguage == "C#"){
          int currentScore = userDoc["c#Level"];
          await userRef.update({"c#Level": currentScore + 1});
        }
          if (progLanguage == "Java"){
          int currentScore = userDoc["javaLevel"];
          await userRef.update({"javaLevel": currentScore + 1});
        }
      }
    } catch(e){
      throw Exception("error $e");
    }
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
                  height:110.0
                ),

                FutureBuilder<DocumentSnapshot>(
                  future: data, 
                  builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading when data not ready
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // Handle errors
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  // Once the data is available build the daily banner
                  return buildDailyBanner(snapshot.data!);
                } else {
                  // Handle case where data is not available
                  return Text('No data available');
                }
              },
            ),

          // button to select the programing language of the question
              DropdownButtonFormField<String>(
                dropdownColor: Colors.grey[850],
                iconEnabledColor: Colors.white, 
                iconDisabledColor: Colors.white,
                value: pLanguage,
                decoration: InputDecoration(
                  prefixIcon: Visibility(
                    child: Icon(Icons.terminal, color: Color.fromARGB(255, 208, 208, 208)),
                  ),
                  
                  hintText: "Select Programing Language",
                  hintStyle: TextStyle(color: Color.fromARGB(255, 208, 208, 208)),
                  labelText: "",
                  floatingLabelBehavior: FloatingLabelBehavior.always, 
                  floatingLabelStyle: TextStyle(fontSize: 20, color: Color.fromARGB(255, 208, 208, 208)),
                  filled: true,
                  fillColor: const Color.fromARGB(120, 105, 190, 255),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      width: 1.0,
                    ),
                  ),
                ),
                items: [
                  DropdownMenuItem(value: 'Python', child: Text('Python',
                    style: TextStyle(color: Color.fromARGB(255, 208, 208, 208)))),
                  DropdownMenuItem(value: 'C#', child: Text('C#',
                    style: TextStyle(color: Color.fromARGB(255, 208, 208, 208)))),
                  DropdownMenuItem(value: 'Java', child: Text('Java',
                    style: TextStyle(color: Color.fromARGB(255, 208, 208, 208)))),
                ],
                hint: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Location', style: TextStyle(color: Color.fromARGB(255, 208, 208, 208))),
                ),
                onChanged: (value) {
                  setButtonToActive(value);
                }         
              ),

          // sized box
          SizedBox(
            height:25.0
          ),

          // container for questions
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(25),
              color: Color.fromARGB(120, 105, 190, 255),
            ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
                        
              // adding white sppace
              SizedBox(
                height:30.0
              ),

          // Display loading indicator when generating questions
          if (_isLoading)
            Column(
              children:[
                SizedBox(
                  height: 250,
                  width: 300,
                ),
                CircularProgressIndicator(
                    semanticsLabel: "A small circular loading indicator",
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white),
                    backgroundColor: const Color.fromARGB(121, 238, 238, 238),
                    strokeWidth: 6.0,
                ),
                SizedBox(
                  height: 250,
                  width: 350,
                ),
              ],
            )
          // add a firebase call to get the aptitude of a user later
          else if (response["question"] != null && response["question"]!.isNotEmpty)

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
            color: _resultText == "Correct!" ? const Color.fromARGB(255, 158, 255, 161) : const Color.fromARGB(255, 255, 117, 107), // make the text green if correct red if wrong
            fontSize: 22,
            fontWeight:  FontWeight.bold,
          ),),

          SizedBox(
            height: 30.0,
            ),

            if(_questionChecked)
            Text(response["explanation"], style: TextStyle(
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

            ElevatedButton(
              
              onPressed: languageSelected ? (){
              if (!_questionChecked){
                checkAnswer();
              } else {
                generateQuestions();
              }
          } : null, // logic for making the elevated button rely on the boolean
          
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 0, 85, 155),
            minimumSize: Size(30, 60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.white, width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[

              Text(_buttonText, 
                style: TextStyle(
                  color: Colors.white)
              ),

              SizedBox(
                width: 10.0
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
                height: 200,
                width: 500,
              ),

              // adding hint text
              Text("Please Select a Language", 
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
              ),

              // adding white space
              SizedBox(
                height: 200,
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