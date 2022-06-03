import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/AllWidgets/progressDialog.dart';
import 'package:rider_app/Screens/RegisterationScreen.dart';
import 'package:rider_app/Screens/main_page_screen.dart';
import 'package:rider_app/main.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = 'login';
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

//  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 35,
              ),
              Image(
                image: AssetImage('images/logo.png'),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Login as Rider',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontFamily: 'Brand Bold'),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 1,
                    ),
                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 14),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 14),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (!emailTextEditingController.text.contains('@')) {
                          displayToastMessage(
                              'Enter Valid Email Address', context);
                        }
                        if (passwordTextEditingController.text.isEmpty) {
                          displayToastMessage('Password is mandatory', context);
                        } else {
                          loginAndAuthenticateUser(context);
                        }

                        print('Log in CLick');
                      },
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 18, fontFamily: 'Brand Bold'),
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    )
                  ],
                ),
              ),
              FlatButton(
                  onPressed: () {
                    print('Clicked');
                    Navigator.pushNamedAndRemoveUntil(context,
                        RegisterationScreen.idScreen, (route) => false);
                  },
                  child: Text('New here ? Register Here'))
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog('Authenticating, please wait...');
        });
    final UserCredential res = await _firebaseAuth
        .signInWithEmailAndPassword(
            email: emailTextEditingController.text,
            password: passwordTextEditingController.text)
        .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    });

    User firebaseUser = res.user;
    if (firebaseUser != null) {
      //save user info to databse

      userRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
          displayToastMessage('You are logged-in', context);
        } else {
          // error occured
                Navigator.pop(context);

          _firebaseAuth.signOut();
          displayToastMessage(
              'No records exists, Please Register Again', context);
        }
      });
    } else {
       Navigator.pop(context);
      // error occured
      displayToastMessage('No records exists, Please Log in Again', context);
    }
  }
}
