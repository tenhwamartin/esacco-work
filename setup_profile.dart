import 'package:eSacco/data/ProfileInfo/save_profile_info.dart';
import 'package:eSacco/data/ProfileInfo/profile_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'custom_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
        BorderSide(color: Color.fromARGB(255, 51, 153, 255), width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);

class SetupProfile extends StatefulWidget {
  const SetupProfile({Key? key}) : super(key: key);

  @override
  _SetupProfileState createState() {
    return _SetupProfileState();
  }
}

class _SetupProfileState extends State<SetupProfile> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  TextEditingController _ninController = TextEditingController(),
      _nameController = TextEditingController();
  Color confPasswordColor = Colors.white;
  Color? buttonColor = Color.fromARGB(255, 28, 49, 76);

  @override
  Widget build(BuildContext context) {
    final profileInfoDao = Provider.of<ProfileInfoDao>(context, listen: false);
    User? newUser;

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 28, 49, 76),
        body: Builder(builder: (context) {
          var dWidth = MediaQuery.of(context).size.width;
          var dHeight = MediaQuery.of(context).size.height;
          return ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: ListView(
                children: <Widget>[
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: (dHeight * 0.15))),
                  const Center(
                    child: Text(
                      'Setup Profile to continue:',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                  ),
                  const Text(
                    'Full Name(as indicated on national ID):',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  TextField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                      controller: _nameController,
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter your full name')),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                  ),
                  Text(
                    'National ID Number(NIN):',
                    style: TextStyle(
                      color: confPasswordColor,
                    ),
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                    controller: _ninController,
                    decoration: kTextFieldDecoration.copyWith(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: confPasswordColor, width: 3.0),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        hintText: 'Enter your valid NIN'),
                    onChanged: (value) {
                      if (_ninController.text.length != 14) {
                        setState(() {
                          buttonColor = Color.fromARGB(255, 28, 49, 76);
                          confPasswordColor = Colors.red;
                        });
                      } else {
                        setState(() {
                          buttonColor = Colors.green;
                          confPasswordColor = Colors.green;
                        });
                      }
                    },
                  ),
                  Center(
                      child: RoundedButton(
                    colour: buttonColor,
                    sColor: Colors.white54,
                    title: 'Save Profile',
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        if (_ninController.text.length == 14) {
                          newUser = await _auth.currentUser;
                          if (newUser != null) {
                            print('is created');
                            saveProfileInfo(profileInfoDao, newUser?.uid);
                            Navigator.pushNamed(context, 'choose_kibiina');
                          } else {
                            print('user not created');
                          }
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content:
                                Text('NIN number must be 14 characters long!'),
                            backgroundColor: Colors.red,
                          ));
                        }
                      } catch (e) {
                        print(e);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    },
                  )),
                ],
              ),
            ),
          );
        }));
  }

  void saveProfileInfo(ProfileInfoDao profileInfoDao, String? userId) {
    final info = ProfileInfo(
      fullName: _nameController.text,
      nin: _ninController.text,
      userId: userId as String,
    );
    print('saved info');
    profileInfoDao.saveInfo(info, _ninController.text);
  }
}
