import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'medals.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class MyAccountDialog extends StatefulWidget {
  final DocumentSnapshot userData;

  const MyAccountDialog({required this.userData, Key? key}) : super(key: key);

  @override
  _MyAccountDialogState createState() => _MyAccountDialogState();
}

class _MyAccountDialogState extends State<MyAccountDialog> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  // this class had the implementation to connect to firebase and save account images however it currently does not work as firebase storage costs
  // all lines using this have been commented out

  String cAward = "c1"; // variables that denote what award should be displayed as a medal for language efficiency
  String pAward = "p1"; // default to the bronze shield so that if firebase fails to be fetched and update it has a default value
  String jAward = "j1";

  @override
  void initState(){
    super.initState();
    _loadData(); // set the medals to appropriate level
  }

  Future<void> _pickImage(ImageSource source) async {
    // function to pick the image for an account
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
        await _uploadImage(File(_imageFile!.path)); // send image to firebase
      }
    } catch (e) {
      print('Image picker error: $e');
    }
  }

  Future<void> _uploadImage(File image) async {
    // upload the image to firebase - currently cannot be used
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
//      Reference storageRef = FirebaseStorage.instance.ref().child('profile_images/$userId.png');
//      UploadTask uploadTask = storageRef.putFile(image);
//      TaskSnapshot snapshot = await uploadTask;
//      String downloadURL = await snapshot.ref.getDownloadURL();
//      print("Download URL: $downloadURL");

//      await FirebaseFirestore.instance.collection('users').doc(userId).update({'profileImage': downloadURL});

      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _loadData() async { // loads the data from the medals.dart function for the home page
    setState(() {
      cAward = getMedalString("csharp", widget.userData); // access the constructor to get userData
      pAward = getMedalString("python", widget.userData); 
      jAward = getMedalString("java", widget.userData); 
    });
  }

  @override
  Widget build(BuildContext context) {
    // create dialog box
    return Dialog(
      insetPadding: EdgeInsets.zero,
      alignment: Alignment.topCenter,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      // create a container the width of the screen
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 600,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 85, 155),
          borderRadius: BorderRadius.circular(15),
        ),

        // adding padding around the container
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 65),

              // add row showing profile 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Coder Profile",
                    style: GoogleFonts.anton(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),

                  // icon button to close dialog
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 25,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),

              // divider between the top 3rd of the dialog and the rest
              const Divider(color: Colors.white, thickness: 1),

              // adding white space
              const SizedBox(height: 20),

              // Profile Picture
              Stack(
                children: [
                  GestureDetector(
                  onTap: () => _pickImage(ImageSource.gallery),
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: _imageFile != null //if the file is not null
                        ? FileImage(File(_imageFile!.path)) as ImageProvider // the the image path ..
                        : (widget.userData.data() as Map<String, dynamic>?)?.containsKey("profileImage") == true && widget.userData["profileImage"].toString().isNotEmpty                      ? NetworkImage(widget.userData["profileImage"]) // from firebase
                        : const AssetImage("assets/images/profile_image_placeholder.png"), // if null or error use placeholder image
                    backgroundColor: const Color.fromARGB(255, 205, 205, 205),
                  ),
                ),

                // "edit" icon on the image insert
                Positioned(
                bottom: 0,
                left: 120,
                right: 0,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 85, 155),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    child: Icon(Icons.edit, color: Colors.white, size: 30),
                    
                  )
                )

              ],
              ),

              // white space
              const SizedBox(height: 20),

              // user details
              Text(
                "${widget.userData["firstName"] ?? "First Name"} ${widget.userData["lastName"] ?? "Last Name"}",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              // white space
              const SizedBox(height: 10),

              // the rest of the user details
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.white),
                  const SizedBox(width: 5),
                  Text(
                    widget.userData["pronoun"] ?? "N/A",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: Colors.white),
                  const SizedBox(width: 5),
                  Text(
                    widget.userData["location"] ?? "Unknown",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Divider(color: Colors.white, thickness: 1),
              const SizedBox(height: 10),

              // Awards
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "Awards",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              SizedBox(height:5),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
              child:Row(children: [
                
                // python rank image
                Image(
                  image: AssetImage("assets/images/$pAward.png"),
                  width: 80.0,
                  height: 80.0),

                  SizedBox(width: 10),

                // java rank image    
                Image(
                  image: AssetImage("assets/images/$jAward.png"),
                  width: 80.0,
                  height: 80.0),

                  SizedBox(width: 10),

                // c# rank image
                Image(
                  image: AssetImage("assets/images/$cAward.png"),
                  width: 80.0,
                  height: 80.0),

                // Adding sized box to compensate for lack of awards
                SizedBox(width:200),

                ]
              )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Function to show dialog box
Future<void> showMyAccountDialog(BuildContext context) async {
  // ensure data is passed in and calls for the dialog build
  try {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    String? iD = _auth.currentUser?.uid;
    if (iD == null) {
      throw Exception("You are not logged in");
    }

    DocumentSnapshot userDoc = await _firestore.collection('users').doc(iD).get();

    if (!userDoc.exists) {
      throw Exception("Failed to find user document");
    }

    showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) {
        return MyAccountDialog(userData: userDoc);
      },
    );
  } catch (e) {
    print("Error fetching user data: $e");
  }
}