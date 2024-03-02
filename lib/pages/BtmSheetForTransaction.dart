import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timer_builder/timer_builder.dart';

import '../config/StaticMethod.dart';
import '../provider/MyProvider.dart';
class BottomSheetContent extends StatefulWidget {
  final Map<String,dynamic> guestDetail;
  final DateTime month;
  const BottomSheetContent({super.key, required this.guestDetail, required this.month});

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
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

  //============================================================================GENERATE OTP
  void _generateOtp(guestDetail,appState,BuildContext context) async{
    print(guestDetail['email']);
    var sendOtpModel = {
      "email":guestDetail['email'],
      "forWhich":"accountTransaction"
    };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final response = await StaticMethod.sendOtp(sendOtpModel, appState);
    Navigator.pop(context);

    if(response.isNotEmpty){
      StaticMethod.showDialogMessage(context, response, appState, "Send Otp Response");
      startCountdownTimer();
    }
  }

  //============================================================================SUBMIT OTP
  void _submitOtp(_otpController,guestDetail,appState,month) async{
    var model = {
      "ownerEmail":appState.userDetail['result']['email'],
      "guestEmail":guestDetail['email'],
      "year":month.year,
      "month":DateFormat('MMMM').format(month),
      "paidStatus":true,
      "userEnteredOtp":_otpController.text
    };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    final response = await StaticMethod.markedAsPaid(model);
    Navigator.pop(context); // Hide the CircularProgressIndicator

    if (response.isNotEmpty) {
      StaticMethod.showDialogMessage(
          context,
          response,
          appState,
          'Transaction Response'
      );
      appState.fetchPaymentRecord(appState,widget.guestDetail);
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context,listen: false);
    Map<String,dynamic> guestDetail = widget.guestDetail;
    DateTime month = widget.month;
    return SingleChildScrollView(
        child: Container(
          //height: MediaQuery.of(context).size.height*0.3,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 15),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
          ),
          child:
            Column(
            children: [
              //------------------------------------------------------generate otp button container
              ElevatedButton(
                      onPressed: ()async{
                        _generateOtp(guestDetail, appState,context);
                      },
                      child:const Text('generate otp')

              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //--------------------------------------------------text field for otp
                      Container(
                        margin: const EdgeInsets.all(15),
                        child: TextFormField(
                          focusNode: _otpFocusNode,
                          keyboardType: TextInputType.number,
                          controller: _otpController,
                          maxLines: null, // Allows an unlimited number of lines
                          decoration: const InputDecoration(
                            labelText: 'Enter otp',
                            hintText: 'Enter otp',
                          ),
                          validator: (value){
                            if (value!.isEmpty || value.length != 6) {
                              return 'please enter only valid otp';
                            }
                            return null;
                          },
                        ),
                      ),
                      //--------------------------------------------------countdown timer
                      TimerBuilder.periodic(const Duration(seconds: 1), builder: (context) {
                        return Text('Countdown Timer: $_countdownTime seconds');
                      }),
                      //--------------------------------------------------verify and submit button
                      ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _submitOtp(_otpController,guestDetail,appState,month);
                            }
                          },
                          child: const Text('verify & submit'))
                    ],
                  ))
            ],
          ),
        ));
  }
}