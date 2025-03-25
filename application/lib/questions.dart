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
              ElevatedButton(onPressed: null,  
              style: ElevatedButton.styleFrom(shape: CircleBorder(),
                                             padding: EdgeInsets.all(0),
                                             backgroundColor: Colors.blue, 
                                             elevation: 4), 
                                             child: Container(width: 32,
                                             height: 32,
                                             alignment: Alignment.center,
                                             child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: const BoxDecoration(color:Colors.white,
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
              ElevatedButton(onPressed: null,  
              style: ElevatedButton.styleFrom(shape: CircleBorder(),
                                             padding: EdgeInsets.all(0),
                                             backgroundColor: Colors.blue, 
                                             elevation: 4), 
                                             child: Container(width: 32,
                                             height: 32,
                                             alignment: Alignment.center,
                                             child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: const BoxDecoration(color:Colors.white,
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
              ElevatedButton(onPressed: null,  
              style: ElevatedButton.styleFrom(shape: CircleBorder(),
                                             padding: EdgeInsets.all(0),
                                             backgroundColor: Colors.blue, 
                                             elevation: 4), 
                                             child: Container(width: 32,
                                             height: 32,
                                             alignment: Alignment.center,
                                             child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: const BoxDecoration(color:Colors.white,
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
              ElevatedButton(onPressed: null,  
              style: ElevatedButton.styleFrom(shape: CircleBorder(),
                                             padding: EdgeInsets.all(0),
                                             backgroundColor: Colors.blue, 
                                             elevation: 4), 
                                             child: Container(width: 32,
                                             height: 32,
                                             alignment: Alignment.center,
                                             child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: const BoxDecoration(color:Colors.blue,
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
            height:100.0
          ),

            Text(response["explination"], style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold
              )
            ),

            // adding white space
            SizedBox(
              height:40.0
            ),

            ElevatedButton(onPressed: languageSelected ? (){
            generateQuestions();
          } : null, // logic for making the elevated button rely on the boolean
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 77, 175, 255),
            minimumSize: Size(50, 80),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: Row(
            children:[

              Text("Next Question ", 
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
          Text("Please select a language", style: TextStyle(color: Colors.white))
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