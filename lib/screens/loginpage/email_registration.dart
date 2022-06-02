import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:foodify/main.dart';
import 'package:foodify/nav/bottom_nav_bar.dart';
import 'package:foodify/screens/home_page/home_page.dart';
import 'package:foodify/screens/loginpage/email_login.dart';
import 'package:foodify/utils/theme.dart';
import 'package:foodify/utils/user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  
  // string for displaying the error Message
  String? errorMessage;


  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    //first name field
    final Size screenSize = MediaQuery.of(context).size;
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final firstNameField = Container(
      child: TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          hintStyle: isLightMode ? lightThemeData(context).textTheme.subtitle1 : darkThemeData(context).textTheme.subtitle1,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: isLightMode ? Colors.black.withAlpha(50) : Colors.white ),
            borderRadius: BorderRadius.circular(10)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: isLightMode ? Colors.black.withAlpha(50) : Colors.white ),
            borderRadius: BorderRadius.circular(10)
          ),
        )),
    );

    //second name field
    final secondNameField = Container(
      child: TextFormField(
        autofocus: false,
        controller: secondNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Second Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          secondNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Second Name",
          hintStyle: isLightMode ? lightThemeData(context).textTheme.subtitle1 : darkThemeData(context).textTheme.subtitle1,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: isLightMode ? Colors.black.withAlpha(50) : Colors.white ),
            borderRadius: BorderRadius.circular(10)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: isLightMode ? Colors.black.withAlpha(50) : Colors.white ),
            borderRadius: BorderRadius.circular(10)
          ),
        )),
    );

    //email field
    final emailField = Container(
      child: 
      TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          hintStyle: isLightMode ? lightThemeData(context).textTheme.subtitle1 : darkThemeData(context).textTheme.subtitle1,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: isLightMode ? Colors.black.withAlpha(50) : Colors.white ),
            borderRadius: BorderRadius.circular(10)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: isLightMode ? Colors.black.withAlpha(50) : Colors.white ),
            borderRadius: BorderRadius.circular(10)
          ),
          
        )),
    );

    //password field
    final passwordField = Container(
      child: TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          hintStyle: isLightMode ? lightThemeData(context).textTheme.subtitle1 : darkThemeData(context).textTheme.subtitle1,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: isLightMode ? Colors.black.withAlpha(50) : Colors.white ),
            borderRadius: BorderRadius.circular(10)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: isLightMode ? Colors.black.withAlpha(50) : Colors.white ),
            borderRadius: BorderRadius.circular(10)
          ),
        )),
    );

    //confirm password field
    final confirmPasswordField = Container(
      child: TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: true,
        validator: (value) {
          if (confirmPasswordEditingController.text !=
              passwordEditingController.text) {
            return "Password don't match";
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          hintStyle: isLightMode ? lightThemeData(context).textTheme.subtitle1 : darkThemeData(context).textTheme.subtitle1,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: isLightMode ? Colors.black.withAlpha(50) : Colors.white ),
            borderRadius: BorderRadius.circular(10)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: isLightMode ? Colors.black.withAlpha(50) : Colors.white ),
            borderRadius: BorderRadius.circular(10)
          ),
        )),
    );
    postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.secondName = secondNameEditingController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => BottomNavView()),
        (route) => false);
  }
    void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  } 
    final signUpButton = InkWell(
                onTap: () {
                  signUp(emailEditingController.text, passwordEditingController.text);
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 100,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(
                      "LOGIN",
                      style: darkThemeData(context).textTheme.headline5!.copyWith(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w500
                      ),
                      // style: TextStyle(
                      //     fontSize: 17,
                      //     color: Colors.white,
                      //     fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              );
  
    //signup button
    // final signUpButton = Material(
    //   elevation: 5,
    //   borderRadius: BorderRadius.circular(30),
    //   color: Colors.redAccent,
    //   child: MaterialButton(
    //       padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    //       minWidth: MediaQuery.of(context).size.width,
    //       onPressed: () {
    //         signUp(emailEditingController.text, passwordEditingController.text);
    //       },
    //       child: Text(
    //         "SignUp",
    //         textAlign: TextAlign.center,
    //         style: TextStyle(
    //             fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
    //       )),
    // );
    Widget login(){
      return Form(
                key: _formKey,
                child: Column(
                  
                  children: <Widget>[
                    Row(
          children:  
              [
                const SizedBox(width: 90,),
                Align(
              alignment: Alignment.topCenter,
              child: Image.asset(isLightMode ? "assets/logo/foodify-text.png": "assets/logo/foodify-text-darktheme.png",height: 100,fit: BoxFit.fitWidth,)
              ),
              
            ],
        ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:35, vertical: 20),
                      child: firstNameField,
                    ),
                    SizedBox(height: 0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:35, vertical: 0),
                      child: secondNameField,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:35, vertical: 0),
                      child: emailField,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:35, vertical: 0),
                      child: passwordField,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:35, vertical: 0),
                      child: confirmPasswordField,
                    ),
                    SizedBox(height: 15),
                    signUpButton,
                    SizedBox(height: 10,),
                    Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Have an account? ", style: isLightMode ? lightThemeData(context).textTheme.overline!.copyWith(fontSize: 12) : darkThemeData(context).textTheme.overline!.copyWith(fontSize: 12),),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EmailLogin()));
                  },
                  child: Text(
                    "Sign In",
                    style: isLightMode ? lightThemeData(context).textTheme.overline!.copyWith(fontSize: 14 , color: Colors.green , fontWeight: FontWeight.bold) : darkThemeData(context).textTheme.overline!.copyWith(fontSize: 14,color: Colors.green,fontWeight: FontWeight.bold)
                  ),
                )
              ]
              
              )
                    
                  ],
                ),
              );
  }
  
    return Listener(
      onPointerUp: (e) {
        final rb = context.findRenderObject() as RenderBox;
        final result = BoxHitTestResult();
        rb.hitTest(result, position: e.position);

        final hitTargetIsEditable =
            result.path.any((entry) => entry.target is RenderEditable);

        if (!hitTargetIsEditable) {
          final currentFocus = FocusScope.of(context);
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: double.infinity * 1.5,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/loginpage_backgroundimage.jpg"),fit: BoxFit.cover
            ),
          ),
          child: Column(
            children: <Widget>[
               SizedBox(height: screenSize.height * 0.27,),
              
              Expanded(child: Container(
                decoration: BoxDecoration(
                    color: (isLightMode ? lightThemeData(context).scaffoldBackgroundColor : darkThemeData(context).scaffoldBackgroundColor),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )
                ),
                child: login(),
              )),
              
            ],
          ),
        ),
      ),
    );
  
}}