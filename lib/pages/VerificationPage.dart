import 'dart:async';

import 'package:findpg/config/StaticMethod.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/MyProvider.dart';

class VerificationPage extends StatefulWidget {
  final Map<String,dynamic> model;

  const VerificationPage({Key? key, required this.model}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool otpSent = false;
  Duration countdownDuration = const Duration(minutes: 10); // Example: 10 minutes
  Timer? countdownTimer;
  String remainingTime = '';
  //----------------------------------------------------------------------------COUNTDOWN METHODS
  void startCountdown() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdownDuration.inSeconds > 0) {
          countdownDuration -= const Duration(seconds: 1);
          remainingTime = formatDuration(countdownDuration);
        } else {
          countdownTimer?.cancel();
          // Countdown has reached 0, perform any desired actions here
        }
      });
    });
  }

  String formatDuration(Duration duration) {
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
  //----------------------------------------------------------------------------


  //----------------------------------------------------------------------------SEND OTP METHODS
  _sendOtp(BuildContext context, appState)async{
    print('send otp called');
      var sendOtpModel = {
        "email":widget.model['ownerEmail'],
        "forWhich":widget.model['forWhich']
      };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
      final response = await StaticMethod.sendOtp(sendOtpModel,appState);
      Navigator.pop(context);
      if(response['success']==true){
        startCountdown();
      }
      if(response.isNotEmpty){
        StaticMethod.showDialogMessage(context, response, appState, "Send Otp Response");
      }

  }




  //----------------------------------------------------------------------------VERIFY OTP METHODS
   _submitOtp(BuildContext context, appState)async {

    if (widget.model['forWhich'] == "userVerification") {
      var verificationModel = {
        "email": appState.userDetail['result']['email'],
        "userEnteredOtp": _otpController.text
      };
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      final response = await StaticMethod.verifyOtpAndUser(verificationModel,appState);
      Navigator.pop(context);
      if(response.isNotEmpty){
        StaticMethod.showDialogMessage(
            context, response, appState, "User Verification Response");
      }

    }
    else if(widget.model['forWhich']=="bookHostle"){
      var bookModel = {
        "ownerEmail":widget.model['ownerEmail'],
        "bookedHostleName":widget.model['bookedHostleName'],
        "guestEmail":widget.model['guestEmail'],
        "year":widget.model['year'],
        "month":widget.model['month'],
        "paidStatus":widget.model['paidStatus'],
        "bookedStatus":widget.model['bookedStatus'],
        "userEnteredOtp":_otpController.text
      };
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      final response = await StaticMethod.verifyOtpAndBook(bookModel);
      Navigator.pop(context);
      if(response.isNotEmpty){
        StaticMethod.showDialogMessage(context, response, appState, 'Book Response');
      }
    }else if(widget.model['forWhich']=="unBookHostle"){
      var unBookModel = {
        "ownerEmail":widget.model['ownerEmail'],
        "bookedHostleName":widget.model['bookedHostleName'],
        "guestEmail":widget.model['guestEmail'],
        "bookedStatus":widget.model['bookedStatus'],
        "userEnteredOtp":_otpController.text
      };
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      final response = await StaticMethod.verifyOtpAndUnbook(unBookModel);
      Navigator.pop(context);
      if(response.isNotEmpty){
        StaticMethod.showDialogMessage(context, response, appState, 'Unbook Response', FirstParentContext: widget.model['bottomSheetContext']);
        //popPage(widget.model['BookedHostleDetailPageContext']);
      }
    }
  }
  void popPage(context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    return SingleChildScrollView(
              child:Container(
              //height: MediaQuery.of(context).size.height * 0.3,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding:
              EdgeInsets.only(bottom: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom, top: 15),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))
              ),
              child: Column(
                children: [
                  //------------------------------------------------------------heading
                  Container(
                    child: Center(
                      child:Text(widget.model['heading'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
                    ),
                  ),
                  //------------------------------------------------------------GENERATE OTP BUTTON CONTAINER
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () {
                        print('generate otp pressed');
                        _sendOtp(context, appState);
                      },
                      child: widget.model['forWhich'] == "userVerification"
                          ? const Text('Generate Otp')
                          : const Text('send otp to the owner email'),
                    ),
                  ),
                  //------------------------------------------------------------FORM CONTAINER, OTP FIELD, VERIFY BUTTON, COUNTER TIME
                  Container(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty || value.length != 6) {
                                  return 'please enter only valid otp';
                                }
                                return null;
                              },
                              controller: _otpController,
                              focusNode: _otpFocusNode,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'otp',
                                hintText: 'enter otp',
                              ),
                            ),
                            Text(
                              remainingTime,
                              style: const TextStyle(fontSize: 24),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _submitOtp(context, appState);
                                    //print('submit successful');
                                  }
                                },
                                child: widget.model['forWhich'] ==
                                    "userVerification"
                                    ? const Text('verify otp')
                                    : const Text('verify otp & book')
                            ),
                          ],
                        ),
                      )),
                ],
              )
          ));
}}
