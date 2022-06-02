
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodify/utils/signin_button/Auth_Service.dart';
import 'package:foodify/utils/theme.dart';


class ResetPage extends StatefulWidget {
  const ResetPage({Key? key}) : super(key: key);

  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetPage> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  

  // firebase
  final _auth = FirebaseAuth.instance;
  
  // string for displaying the error Message
  String? errorMessage;

  

  @override
  Widget build(BuildContext context) {
    //email field
    final Size screenSize = MediaQuery.of(context).size;
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    AuthClass authClass = AuthClass();
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
          hintText: "Enter Your Email",
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
        
    final loginButton = InkWell(
                onTap: () async {
                  var methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailController.text);
                  if (methods.contains('password')) {
                    authClass.sendPasswordResetEmail(emailController.text,context);
                  }
                  else {
                    Fluttertoast.showToast(msg: "Email Doesn't Exit ");
                  }
                  
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 100,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(
                      "SUBMIT",
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
          SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:35, vertical: 20),
            child: emailField,
          ),
          SizedBox(height: 0),
          
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:35, vertical: 0),
            child: loginButton,
          ),
          SizedBox(height: 15),
          
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
  

  
}