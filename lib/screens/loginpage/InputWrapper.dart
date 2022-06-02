import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodify/nav/bottom_nav_bar.dart';
import 'package:foodify/screens/loginpage/email_login.dart';
import 'package:foodify/screens/loginpage/intl_phonefield.dart/intl_phone_field.dart';

import 'package:foodify/utils/signin_button/Auth_Service.dart';
import 'package:foodify/utils/signin_button/button_list.dart';
import 'package:foodify/utils/signin_button/button_view.dart';
import 'package:foodify/utils/theme.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';



class InputWrapper extends StatefulWidget {
  @override
  State<InputWrapper> createState() => _InputWrapperState();
}

class _InputWrapperState extends State<InputWrapper> {
  
  
  
  
  int start = 30;
  bool wait = false;
  String buttonName = "SEND";
  TextEditingController phoneController = TextEditingController();
  AuthClass authClass = AuthClass();
  String verificationIdFinal = "";
  String smsCode = "";
  String? Phone;
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.light;
    bool validate = false;
    

  

  

  showAlertDialog(BuildContext context){

    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
          SizedBox(width: 8,),
          Text('Please wait')
        ],
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context, builder: (BuildContext context){
        return alert;
      });
  }

  

  @override
  void dispose() {
    showAlertDialog(context);
    super.dispose();
  }

  

  
    return Column(
      
      children: <Widget>[
        
        Stack(
          children:  
              [
                
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 50,),
                    Align(
              alignment: Alignment.topCenter,
              child: Image.asset(isDarkMode ? "assets/logo/foodify-text.png": "assets/logo/foodify-text-darktheme.png",height: 100,fit: BoxFit.fitWidth,)
              ),
                  ],
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 35,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async{
                        dynamic result = await authClass.signInAnon();
            if(result == null){
              print('error signing in');
            } else {
              print('signed in');
              print(result);
            }
            Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => BottomNavView()),
          (route) => false);
                      },
                      child: Text("SKIP",
                      style: isDarkMode ? lightThemeData(context).textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold) : darkThemeData(context).textTheme.subtitle2!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )])
              
            ],
        ),
        const SizedBox(height: 22),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:35, vertical: 20),
          child: IntlPhoneField(
            invalidNumberMessage: 'This Number Is Invalid',
            dropdownTextStyle: isDarkMode ? lightThemeData(context).textTheme.subtitle1 : darkThemeData(context).textTheme.subtitle2,
            enabled: true,
            
            showCountryFlag: true,
            disableLengthCheck: true,
            decoration: InputDecoration(
              suffixIcon: InkWell(
            onTap: wait
                ? null
                : () async {
                    setState(() {
                      start = 30;
                      buttonName ="";
                      wait = true;
                      
                    });
                    
                      
                        authClass.verifyPhoneNumber(
                        Phone!, context, setData);
                      
                      
                      
                   
                    
                        
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                    child: (buttonName=="SEND" || buttonName == "RESEND" ) ? 
                    Text(
                
                buttonName,
                style: isDarkMode? lightThemeData(context).textTheme.overline!.copyWith(
                   color: isDarkMode ? Colors.black : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ) : darkThemeData(context).textTheme.overline!.copyWith(
                  color: isDarkMode ? Colors.black : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                // style: TextStyle(
                //   color: isDarkMode ? Colors.black : Colors.white,
                //   fontSize: 17,
                //   fontWeight: FontWeight.bold,
                // ),
              ) : Text(
          "00:$start",
                    style: isDarkMode ? lightThemeData(context).textTheme.subtitle2 : darkThemeData(context).textTheme.subtitle2,
        ),
                  ),
           
          )
            ),
            style: isDarkMode ? lightThemeData(context).textTheme.subtitle1 : darkThemeData(context).textTheme.subtitle1,
            countriesTextStyle: isDarkMode? lightThemeData(context).textTheme.button : darkThemeData(context).textTheme.button,
            cursorColor: isDarkMode ? Colors.black : Colors.white,
            initialCountryCode: 'IN',
            flagsButtonPadding: const EdgeInsets.all(0),
            onChanged: (phone) {
              
              setState(() {
                
                  Phone = phone.completeNumber;
                
                
                
                
              });
            },
          ),
        ),
        
        
        
        otpField(),
        
        // RichText(
        //           text: TextSpan(
        //         children: [
        //           TextSpan(
        //             text: "Send OTP again in ",
        //             style: TextStyle(fontSize: 16, color: Colors.yellowAccent),
        //           ),
        //           TextSpan(
        //             text: "00:$start",
        //             style: TextStyle(fontSize: 16, color: Colors.pinkAccent),
        //           ),
        //           TextSpan(
        //             text: " sec ",
        //             style: TextStyle(fontSize: 16, color: Colors.yellowAccent),
        //           ),
        //         ],
        //       )),
        SizedBox(height: 40,),
        InkWell(
                onTap: () {
                  authClass.signInwithPhoneNumber(
                      verificationIdFinal, smsCode, context);
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 100,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(
                      "LETS GO",
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
              ),
        
        const SizedBox(height: 25),
        Row(children: <Widget>[
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 30.0, right: 20.0),
                    child: Divider(
                      color: isDarkMode? Colors.black.withAlpha(70) : Colors.white.withAlpha(70),
                      height: 36,
                    )),
              ),
              const Text("OR"),
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 30.0),
                    child: Divider(
                      color: isDarkMode? Colors.black.withAlpha(70) : Colors.white.withAlpha(70),
                      height: 36,
                    )),
              ),
            ]),

            const SizedBox(height: 25),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SignInButton(
                  Buttons.Google ,
                  text: "Google",
  
                  height: 50,
                  width: 125,
                  onPressed: () async {
                    await authClass.googleSignIn(context);
                  },
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.transparent,
                      width: 1,
                      style: BorderStyle.solid
                    ),
                    borderRadius: BorderRadius.circular(8)
                  ),
                ),
                SignInButton(
                  Buttons.Facebook ,
                  text: "Facebook",
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.transparent,
                      width: 1,
                      style: BorderStyle.solid
                    ),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  height: 50,
                  width: 125,
                  onPressed: () {},
                ),    
              ],
            ),
            SizedBox(height: 25,),
            if (Platform.isAndroid) ...[
                SignInButton(
                  Buttons.Email ,
                  text: "        Countinue With Email",
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.transparent,
                      width: 1,
                      style: BorderStyle.solid
                    ),
                    borderRadius: BorderRadius.circular(8),
                    
                  ),
  
                  height: 50,
                  width: 300,
                  onPressed: () {
                    Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EmailLogin()));
                  },
                )
            ] else if (Platform.isIOS) ...[
                SignInButton(
                  Buttons.Apple ,
                  text: "         Countinue With Apple Id",
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.transparent,
                      width: 1,
                      style: BorderStyle.solid
                    ),
                    borderRadius: BorderRadius.circular(8)
                  ),
  
                  height: 50,
                  width: 300,
                  onPressed: () {},
)
            ],
            SizedBox(height: 30,),
            Text(
              "By Continuing, you agree to our ",
              style: isDarkMode ? lightThemeData(context).textTheme.overline : darkThemeData(context).textTheme.overline,
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
                    color: isDarkMode?  Colors.black : Colors.white,
                    width: 1.0, // This would be the width of the underline
                  )
                  )
                  ),
                child: Text(
                  "Terms Of Services",style: isDarkMode ? lightThemeData(context).textTheme.overline : darkThemeData(context).textTheme.overline,
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
                    color: isDarkMode?  Colors.black : Colors.white,
                    width: 1.0, // This would be the width of the underline
                  )
                  )
                  ),
                child: Text(
                  "Privacy Policy",style: isDarkMode ? lightThemeData(context).textTheme.overline : darkThemeData(context).textTheme.overline,
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
                    color: isDarkMode?  Colors.black : Colors.white,
                    width: 1.0, // This would be the width of the underline
                  )
                  )
                  ),
                child: Text(
                  "Content Policy",style: isDarkMode ? lightThemeData(context).textTheme.overline : darkThemeData(context).textTheme.overline,
                ),)
              ],
            )
            
        
      ],
    );
  }
  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer _timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
          buttonName = "RESEND";
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }
  void setData(String verificationId) {
    setState(() {
      verificationIdFinal = verificationId;
    });
    startTimer();
  }
  Widget otpField() {
    final isDarkMode = Theme.of(context).brightness == Brightness.light;
    return OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width - 100,
      
      fieldWidth: 30,
      keyboardType: TextInputType.number,
      
      
      
      otpFieldStyle: OtpFieldStyle(
        
        enabledBorderColor: isDarkMode? Colors.black26 : Colors.white60,
        

        
      ),
      style: darkThemeData(context).textTheme.bodyText1!.copyWith(fontSize: 17, color: isDarkMode? Colors.black : Colors.white),
      // textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.underline,
      onCompleted: (pin) {
        print("Completed: " + pin);
        setState(() {
          smsCode = pin;
        });
      },
      onChanged: (pin) {
            print("Changed: " + pin);
          },
    );
  }
}
