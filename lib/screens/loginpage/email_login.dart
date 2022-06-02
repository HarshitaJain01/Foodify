
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodify/main.dart';
import 'package:foodify/nav/bottom_nav_bar.dart';
import 'package:foodify/screens/home_page/home_page.dart';
import 'package:foodify/screens/loginpage/email_registration.dart';
import 'package:foodify/screens/loginpage/reset.dart';
import 'package:foodify/utils/theme.dart';


class EmailLogin extends StatefulWidget {
  const EmailLogin({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<EmailLogin> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance;
  
  // string for displaying the error Message
  String? errorMessage;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    //email field
    final Size screenSize = MediaQuery.of(context).size;
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final emailField = Container(
      height: 70,
      child:TextFormField(
        autofocus: false,
        controller: emailController,
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
          emailController.text = value!;
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
          
        ))
    );

    
        

    //password field
    final passwordField = Container(
      height: 70,
      child:TextFormField(
        autofocus: false,
        
        controller: passwordController,
        obscureText: _isObscure,
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
          passwordController.text = value!;
        },
        
        
        textInputAction: TextInputAction.done,
        
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          hintStyle: isLightMode ? lightThemeData(context).textTheme.subtitle1 : darkThemeData(context).textTheme.subtitle2,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: isLightMode ? Colors.black.withAlpha(50) : Colors.white ),
            borderRadius: BorderRadius.circular(10)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: isLightMode ? Colors.black.withAlpha(50) : Colors.white ),
            borderRadius: BorderRadius.circular(10)
          ),
          suffixIcon: IconButton(
            onPressed: (){
              setState(() {
                _isObscure = !_isObscure;
              });
            } , icon: Icon(
              _isObscure ? Icons.visibility : Icons.visibility_off
            )),
          
        
          
          
        ))
    );
    final loginButton = InkWell(
                onTap: () {
                  signIn(emailController.text, passwordController.text);
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
    
    Widget login(){
  return Form(
    key: _formKey,
    child: SingleChildScrollView(
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
          SizedBox(height: 45),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:35, vertical: 20),
            child: emailField,
          ),
          SizedBox(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:35, vertical: 0),
            child: passwordField,
          ),
          SizedBox(height: 35),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:35, vertical: 0),
            child: loginButton,
          ),
          SizedBox(height: 15),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Don't have an account? ", style: isLightMode ? lightThemeData(context).textTheme.overline!.copyWith(fontSize: 12) : darkThemeData(context).textTheme.overline!.copyWith(fontSize: 12),),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RegistrationScreen()));
                  },
                  child: Text(
                    "SignUp",
                    style: isLightMode ? lightThemeData(context).textTheme.overline!.copyWith(fontSize: 14 , color: Colors.green , fontWeight: FontWeight.bold) : darkThemeData(context).textTheme.overline!.copyWith(fontSize: 14,color: Colors.green,fontWeight: FontWeight.bold)
                  ),
                )
              ]
              
              ),
              SizedBox(height: 7,),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ResetPage()));
                  },
                  child: Text(
                    "Forgot Password ?",
                    style: isLightMode ? lightThemeData(context).textTheme.overline!.copyWith(fontSize: 14 , color: Colors.green , fontWeight: FontWeight.bold) : darkThemeData(context).textTheme.overline!.copyWith(fontSize: 14,color: Colors.green,fontWeight: FontWeight.bold)
                  ),
                ),
              SizedBox(height: screenSize.height * 0.1553,),
        
              Text(
                "By Continuing, you agree to our ",
                style: isLightMode ? lightThemeData(context).textTheme.overline : darkThemeData(context).textTheme.overline,
              ),
              SizedBox(height: 6,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                    bottom: 1, // This can be the space you need betweeb text and underline
                      ),
                    decoration:  BoxDecoration(
                      border: Border(bottom: BorderSide(
                      color: isLightMode?  Colors.black : Colors.white,
                      width: 1.0, // This would be the width of the underline
                    )
                    )
                    ),
                  child: Text(
                    "Terms Of Services",style: isLightMode ? lightThemeData(context).textTheme.overline : darkThemeData(context).textTheme.overline,
                  ),),
                  SizedBox(width: 3,),
                  Text(
                    '.'
                  ),
                  SizedBox(width: 3,),
                  Container(
                    padding: const EdgeInsets.only(
                    bottom: 1, // This can be the space you need betweeb text and underline
                      ),
                    decoration:  BoxDecoration(
                      border: Border(bottom: BorderSide(
                      color: isLightMode?  Colors.black : Colors.white,
                      width: 1.0, // This would be the width of the underline
                    )
                    )
                    ),
                  child: Text(
                    "Privacy Policy",style: isLightMode ? lightThemeData(context).textTheme.overline : darkThemeData(context).textTheme.overline,
                  ),),
                  SizedBox(width: 3,),
                  Text(
                    '.'
                  ),
                  SizedBox(width: 3,),
                  Container(
                    padding: const EdgeInsets.only(
                    bottom: 1, // This can be the space you need betweeb text and underline
                      ),
                    decoration:  BoxDecoration(
                      border: Border(bottom: BorderSide(
                      color: isLightMode?  Colors.black : Colors.white,
                      width: 1.0, // This would be the width of the underline
                    )
                    )
                    ),
                  child: Text(
                    "Content Policy",style: isLightMode ? lightThemeData(context).textTheme.overline : darkThemeData(context).textTheme.overline,
                  ),)
                ]
              )
        ],
      ),
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

    
  }

  // login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  // Fluttertoast.showToast(msg: "Login Successful"),
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => BottomNavView())),
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

  
}