import 'dart:async';

import 'package:findpg/config/ApiLinks.dart';
import 'package:findpg/provider/MyProvider.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/StaticMethod.dart';
import '../pages/VerificationPage.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final baseUrl = ApiLinks.baseUrl;

  final List<String> _userCategory = [
    'guest',
    'room owner',
  ];

  String _selectedUserCategory = 'guest';
  bool obscuredPass = true;

  //----------------------------------------------------------------------------SUBMIT LOGIN CRED METHOD
  void _submitLoginCred(BuildContext context,appState) async {
    print('submit login called');

    if (_selectedUserCategory == 'guest') {
      var userLoginCred = {
        "email": _emailController.text,
        "password": _passwordController.text,
        "selectedUserCategory": _selectedUserCategory,
      };
      var url = Uri.parse(ApiLinks.loginGuestApi);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final response = await StaticMethod.loginUser(userLoginCred, url);
      if (response.isNotEmpty) {
        Navigator.pop(context);
        StaticMethod.showDialogMessage(
          context,
          response,
          appState,
          'Login Response',
          userType: 'guest',
        );
      }

    } else {
      var userLoginCred = {
        "email": _emailController.text,
        "password": _passwordController.text,
        "selectedUserCategory": _selectedUserCategory
      };
      var url=Uri.parse(ApiLinks.loginOwnerApi);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      final response = await StaticMethod.loginUser(userLoginCred, url);
      Navigator.pop(context);
      if(response.isNotEmpty){
        StaticMethod.showDialogMessage(context, response, appState, 'Login Response',userType:'owner' );
      }
    }
  }

  //----------------------------------------------------------------------------show bottom sheet for forgot password
  void _showBottomSheetForForgotPassword(BuildContext context, appState) {
    final _emailControllerForgot = TextEditingController();
    final _otpControllerForgot = TextEditingController();
    final _newPasswordControllerForgot = TextEditingController();
    final FocusNode _emailFocusNodeForgot = FocusNode();
    final FocusNode _otpFocusNodeForgot = FocusNode();
    final FocusNode _passwordFocusNodeForgot = FocusNode();
    final _formKeyForgot = GlobalKey<FormState>();
    String userCategory='';
    int _countdownTime = 60; // Initial countdown time in seconds
    void startCountdownTimer() {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_countdownTime == 0) {
          timer.cancel();
        } else {
          setState(() {
            _countdownTime--;
          });
        }
      });
    }

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (BuildContext context)=>StatefulBuilder(
            builder: (context,setState){
              print(userCategory);
              return SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    padding:
                    EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 15),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                    ),
                    child: Form(
                      key: _formKeyForgot,
                      child: Column(
                      children: [
                        const Text(
                          'forgot password',
                          style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        //--------------------------------------------choose user container
                        Container(
                            margin: const EdgeInsets.all(15),
                            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                               InkWell(
                                   onTap: (){
                                     setState((){
                                       userCategory='owner';
                                     });
                                   },
                                   child: Container(
                                  width:100,
                                  padding:EdgeInsets.all(8),
                                  decoration:BoxDecoration(
                                    color: userCategory=='owner' ? Colors.deepPurple : Colors.black45,
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Center(child:Text('room owner',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                                )),
                                SizedBox(width: 50,),
                                InkWell(
                                    onTap: (){
                                      setState((){
                                        userCategory = 'guest';
                                      });
                                    },
                                    child:Container(
                                  width: 100,
                                  padding:EdgeInsets.all(8),
                                  decoration:BoxDecoration(
                                      color: userCategory=='guest' ? Colors.deepPurple : Colors.black45 ,
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Center(child:Text('guest', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                                ))
                              ],
                            )),
                        //------------------------------------------------------email
                        Container(
                          margin: const EdgeInsets.only(left: 15, right: 15,top: 0,bottom: 0),
                          child: TextFormField(
                            focusNode: _emailFocusNodeForgot,
                            validator: (value) {
                              if (value!.isEmpty ||
                                  !value.contains('@gmail.com') ||
                                  value.length < 11) {
                                return 'please enter valid email';
                              }
                              return null;
                            },
                            controller: _emailControllerForgot,
                            maxLines: null, // Allows an unlimited number of lines
                            decoration: InputDecoration(
                              labelText: 'Enter your email address...',
                              hintText: 'Enter your email address...',
                            ),
                          ),
                        ),

                        Row(children: [
                          //------------------------------------------------------send otp btn
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                              alignment: Alignment.topLeft,
                              child: TextButton(
                                onPressed: ()async{
                                  if(userCategory=='owner' || userCategory=='guest'){
                                    var sendOtpModel = {
                                      "email":_emailControllerForgot.text,
                                      "userCategory":userCategory,
                                      "forWhich":"forgotPassword"
                                    };
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (dialogContext) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                    final response = await StaticMethod.sendOtp(sendOtpModel, appState);
                                    if (response.isNotEmpty) {
                                      Navigator.pop(context);
                                      StaticMethod.showDialogMessage(
                                          context,
                                          response,
                                          appState,
                                          'Send Otp Response'
                                      );
                                      startCountdownTimer();
                                    }

                                  }else{
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext dialogContext){
                                          return AlertDialog(
                                            title: Text(
                                              'Warning',
                                              style: TextStyle(color: Theme.of(context).primaryColorDark),
                                            ),
                                            content: Text('please select user category', style: TextStyle(color: Colors.red),) ,
                                            actions: [
                                              TextButton(
                                                  onPressed: (){
                                                    Navigator.pop(dialogContext);
                                                  },
                                                  child: Text(
                                                    'ok',
                                                    style: TextStyle(color: Theme.of(context).primaryColorDark),
                                                  )
                                              )
                                            ],
                                          );
                                        }
                                    );
                                  }
                                },
                                child: Text('send otp'),
                              )
                          ),
                          TimerBuilder.periodic(const Duration(seconds: 1), builder: (context) {
                            return Text('Countdown Timer: $_countdownTime seconds');
                          }),
                        ],),
                        //------------------------------------------------------enter otp
                        Container(
                          margin: const EdgeInsets.only(left: 15, right: 15,top: 0,bottom: 0),
                          child: TextFormField(
                            controller: _otpControllerForgot,
                            focusNode: _otpFocusNodeForgot,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty || value.length != 6 ) {
                                return 'please enter valid otp';
                              }
                              return null;
                            },
                            maxLines: null, // Allows an unlimited number of lines
                            decoration: InputDecoration(
                              labelText: 'Enter your otp...',
                              hintText: 'Enter your otp...',

                            ),
                          ),
                        ),
                        //------------------------------------------------------choose new password
                        Container(
                          margin: const EdgeInsets.only(left: 15, right: 15,top: 0,bottom: 0),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty || value.length < 8) {
                                return 'password should be long by 8 character';
                              }
                              return null;
                            },
                            focusNode: _passwordFocusNodeForgot,
                            controller: _newPasswordControllerForgot,
                            keyboardType: TextInputType.text,
                            obscureText: obscuredPass,
                            decoration: InputDecoration(
                              labelText: 'new password',
                              hintText: 'enter new password',
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obscuredPass = !obscuredPass;
                                  });
                                },
                                child: Icon(obscuredPass
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                          ),
                        ),
                        //--------------------------------------------------SUBMIT NOW
                        ElevatedButton(
                            onPressed: () async {
                              if (_formKeyForgot.currentState!.validate()) {
                                var forgotPasswordModel = {
                                  "userCategory": userCategory,
                                  "email": _emailControllerForgot.text,
                                  "userEnteredOtp": _otpControllerForgot.text,
                                  "newPassword": _newPasswordControllerForgot.text,
                                };

                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (dialogContext) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );

                                final response = await StaticMethod.verifyAndUpdatePassword(forgotPasswordModel);
                                if (response.isNotEmpty) {
                                  Navigator.pop(context);
                                  StaticMethod.showDialogMessage(
                                    context,
                                    response,
                                    appState,
                                    'Forgot Password Response',
                                  );
                                }
                              }
                            },
                            child: const Text('submit'))
                      ],
                    ),)
                  ));
            }
        )
    );
  }


  //----------------------------------------------------------------------------WIDGET HERE
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    return WillPopScope(
        onWillPop: ()async{
          appState.activeWidget='hostleListWidget';
          appState.currentState=0;
          return false;
        },
        child:Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              color: Theme.of(context).primaryColorLight,
              margin: const EdgeInsets.only(
                  left: 25, right: 25, top: 30, bottom: 30),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    //----------------------------------------------------------REGISTRATION HEADING
                    const Text('Login Here',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20) ,),
                    const SizedBox(
                      height: 16,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // drop down menu for category with align--------CATEGORY
                            Row(
                              children: [
                                const Text('select user category : '),
                                DropdownButton(
                                  value: _selectedUserCategory,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedUserCategory = newValue!;
                                    });
                                    //print(_selectedUserCategory);
                                  },
                                  items: _userCategory.map((category) {
                                    return DropdownMenuItem(

                                      value: category,
                                      child: Text(category,style: const TextStyle(fontWeight: FontWeight.bold),),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            //--------------------------------------------------EMAIL FIELD
                             TextFormField(
                              focusNode: _emailFocusNode,
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'email',
                                hintText: 'email id',
                              ),
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !value.contains('@gmail.com') ||
                                    value.length < 11) {
                                  return 'please enter valid email';
                                }
                                return null;
                              },
                            ),
                            //--------------------------------------------------PASSWORD
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty || value.length < 8) {
                                  return 'password should be long by 8 character';
                                }
                                return null;
                              },
                              focusNode: _passwordFocusNode,
                              controller: _passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: obscuredPass,
                              decoration: InputDecoration(
                                labelText: 'password',
                                hintText: 'enter password',
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      obscuredPass = !obscuredPass;
                                    });
                                  },
                                  child: Icon(obscuredPass
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            //------------------------------------------------------------------LOGIN BUTTON SECTION
            Container(
              width: 300,
              alignment: Alignment.bottomCenter,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColorDark,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(10))),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitLoginCred(context,appState);
                    //print('submit successful');
                  }
                },
                child: const Text('login now'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('new user!'),
                //-----------------------------------REGISTRATION BTN
                TextButton(
                    onPressed: () {
                      appState.activeWidget =
                      'registrationWidget';
                    },
                    child: const Text('register here'))
              ],
            ),
            //------------------------------------------------------------------forgot password
            TextButton(
                onPressed: (){
                  _showBottomSheetForForgotPassword(context, appState);
                },
                child: Text('forgot password')
            )
          ],
        ),
      ),
    ));
  }
}
