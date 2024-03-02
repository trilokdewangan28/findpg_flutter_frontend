import 'dart:convert';
import 'package:findpg/config/ApiLinks.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StaticMethod {
  //----------------------------------------------------------------------------FETCH HOSTLE LIST INITIALLY
  static void fetchHostleList(appState, {setTheState}) {
    appState.fetchHostleList(setTheState:setTheState);
  }

  //----------------------------------------------------------------------------FETCH USER DETAIL BY TOKEN
  static Future<void> fetchUserDetail(appState) async {
    print('static method fetchuserdetail called');
    await appState.getDataByToken(appState.token, appState.userType);
    await Future.delayed(const Duration(milliseconds: 100));
  }

  //------------------------------------------------------------INITIAL FETCH METHOD THAT CALL BY HOSTLElISTSCREEN
  static void initialFetch(appState) async {
    await appState.fetchUserType();
    await Future.delayed(const Duration(milliseconds: 100));

    await appState.fetchToken(appState.userType);
    await Future.delayed(const Duration(milliseconds: 100));

    appState.setFilterVariable();
    appState.applyFilter();

    if (appState.userType.length > 0 &&
        appState.token.length > 0 &&
        appState.userDetail.isEmpty) {
      //print('inside the initial fetch method getDataByTokenCalled');
      await appState.getDataByToken(appState.token, appState.userType);
    }
    print('-------------------------------------------------------------------------------------------------------------');
  }

  //----------------------------------------------------------------------------REMOVE UPLOADED IMAGE
  static Future<Map<String, dynamic>> removeUploadedImage(data, Uri url) async {
    print('remove profile picture method called');
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

      final res = await http.delete(url,
          body: jsonEncode(data), headers: requestHeaders);
      if (res.statusCode == 200) {
        print('uploaded image deleted successfully');
        var response = jsonDecode(res.body);
        return response;
      } else {
        print('uploaded image not deleted');
        var errResponse = jsonDecode(res.body);
        return errResponse;
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred during profile picture removing',
        'error': '$e',
      };
    }
  }

  //----------------------------------------------------------------------------SUBMIT RATINGS
  static Future<Map<String,dynamic>> submitRating(dataModel)async{
    var response;
    try{
      var url = Uri.parse(ApiLinks.rateTheOwnerApi);
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(dataModel), headers: requestHeaders);
      if(res.statusCode==200){
        response = jsonDecode(res.body);
        return response;
      }else{
        response = jsonDecode(res.body);
        return response;
      }
    }catch(e){
      print(e.toString());
      print('an error occured while rating during requesting');
      return {
        "success":false,
        "message":"something went wrong while requesting"
      };
    }
  }

  //----------------------------------------------------------------------------REGISTRATION FUNCTION
  static Future<Map<String, dynamic>> registerUser(userData, Uri url) async {
    var response;
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(userData), headers: requestHeaders);
      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete registration api');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while registering due to request'
      };
    }
  }

  //----------------------------------------------------------------------------UPDATE FUNCTION
  static Future<Map<String, dynamic>> updateUser(userData, Uri url) async {
    print('update method called');
    var response;
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.put(url,
          body: jsonEncode(userData), headers: requestHeaders);
      if (res.statusCode == 200) {
        response = jsonDecode(res.body);
        return response;
      } else {
        response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete update api');
      print(e.toString());
      return {
        "success": false,
        "message": 'An error occured while updating due to request'
      };
    }
  }

  //----------------------------------------------------------------------------LOGIN FUNCTION
  static Future<Map<String, dynamic>> loginUser(userLoginCred, Uri url) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final res = await http.post(url,
          body: jsonEncode(userLoginCred), headers: requestHeaders);

      if (res.statusCode == 200) {
        var response = jsonDecode(res.body);
        return response;
      } else {
        var response = jsonDecode(res.body);
        return response;
      }
    } catch (e) {
      print('failed to complete login api');
      print(e.toString());
      return {'success': false, 'message': 'failed to login while requesting'};
    }
  }


  //----------------------------------------------------------------------------INITIALIZE BOOKED HOSTLE DETAILS
  static void initializeBookedHostleDetails(bookedHostleEmail,appState){
    print(bookedHostleEmail);
    appState.fetchedHostleData.forEach(
        (item){
          if(item['email']==bookedHostleEmail){
            appState.bookedHostleDetails=item;
          }
        }
    );
    print(appState.bookedHostleDetails);
  }

  //----------------------------------------------------------------------------BOOK HOSTLE
   static Future<Map<String,dynamic>> verifyOtpAndBook(bookModel)async{
      var url=Uri.parse(ApiLinks.verifyOtpAndBook);
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      try{
        final res = await http.post(url,body: jsonEncode(bookModel),headers: requestHeaders);
        if (res.statusCode == 200) {
          var response = jsonDecode(res.body);
          return response;
        } else {
          var response = jsonDecode(res.body);
          return response;
        }
      }catch(err){
        print('failed to complete bookhostle api');
        print(err.toString());
        return {'success': false, 'message': 'failed to book hostle while requesting'};
      }
   }

  //----------------------------------------------------------------------------UNBOOK HOSTLE
  static Future<Map<String,dynamic>> verifyOtpAndUnbook(unBookModel)async{
    print('unbook method called');
    print(unBookModel);
    var url=Uri.parse(ApiLinks.verifyOtpAndUnbookApi);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    try{
      final res = await http.post(url,body: jsonEncode(unBookModel),headers: requestHeaders);
      if (res.statusCode == 200) {
        var response = jsonDecode(res.body);
        return response;
      } else {
        var response = jsonDecode(res.body);
        return response;
      }
    }catch(err){
      print('failed to complete unBookhostle api');
      print(err.toString());
      return {'success': false, 'message': 'failed to unbook hostle while requesting'};
    }
  }

  //----------------------------------------------------------------------------UNBOOK HOSTLE FOR OWNER
  static Future<Map<String,dynamic>> unbookGuestForOwner(unBookModel)async{
    var url = Uri.parse(ApiLinks.unbookGuestForOwner);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    try{
      final res = await http.post(url,body: jsonEncode(unBookModel),headers: requestHeaders);
      if (res.statusCode == 200) {
        var response = jsonDecode(res.body);
        return response;
      } else {
        var response = jsonDecode(res.body);
        return response;
      }
    }catch(err){
      print('failed to complete unBookhostle api');
      print(err.toString());
      return {'success': false, 'message': 'failed to unbook hostle while requesting'};
    }

  }

  //----------------------------------------------------------------------------SEND OTP METHODS
  static Future<Map<String,dynamic>> sendOtp(sendOtpModel,appState)async{
    print('sendVerification method called');
    print(sendOtpModel);
    var url;
    if(sendOtpModel['forWhich']=="bookHostle"){
      url = Uri.parse(ApiLinks.sendOtpForBookApi);
      print('url assigned for book hostle send otp');
    }else if(sendOtpModel['forWhich']=="unBookHostle"){
      url = Uri.parse(ApiLinks.sendOtpForUnbookApi);
      print('url assigned for unbook hostle send otp');
    }
    else if(sendOtpModel['forWhich']=="userVerification"){
      if(appState.userType=='owner'){
        url = Uri.parse(ApiLinks.sendVerificationMailForOwner);
        print('url assigned for owner verification send otp');
      }else if(appState.userType=='guest'){
        url = Uri.parse(ApiLinks.sendVerificationMailForGuest);
        print('url assigned for guest verification send otp');
      }
    }else if(sendOtpModel['forWhich']=="accountTransaction"){
      url = Uri.parse(ApiLinks.sendOtpForAccountTransaction);
    }else if(sendOtpModel['forWhich']=="forgotPassword"){
      if(sendOtpModel['userCategory']=='owner'){
        url = Uri.parse(ApiLinks.sendOtpForgotPasswordForOwner);
      }else if(sendOtpModel['userCategory']=='guest'){
        url = Uri.parse(ApiLinks.sendOtpForgotPasswordForGuest);
      }
    }
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    try{
      final res = await http.post(url,body: jsonEncode(sendOtpModel),headers: requestHeaders);
      if(res.statusCode==200){
        var response = jsonDecode(res.body);
        print(response);
        return response;
      }else{
        var response = jsonDecode(res.body);
        print(response);
        return response;
      }
    }catch(err){
      print('failed to send otp mail while requesting api');
      print(err.toString());
      return {'success': false, 'message': 'failed to send otp mail while requesting'};
    }
  }

  //----------------------------------------------------------------------------VERIFY OTP And USER
  static Future<Map<String,dynamic>> verifyOtpAndUser(model,appState)async{
    var url;
    if(appState.userType=='owner'){
      url = Uri.parse(ApiLinks.verifyOtpForOwner);
    }else if(appState.userType=='guest'){
      url = Uri.parse(ApiLinks.verifyOtpForGuest);
    }
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    try{
      final res = await http.post(url,body: jsonEncode(model),headers: requestHeaders);
      if(res.statusCode==200){
        var response = jsonDecode(res.body);
        print(response);
        return response;
      }else{
        var response = jsonDecode(res.body);
        print(response);
        return response;
      }
    }catch(err){
      print('failed to send verificatin mail while requesting api');
      print(err.toString());
      return {'success': false, 'message': 'failed to send otp to verify'};
    }

  }

  //----------------------------------------------------------------------------FETCH BOOKED GUEST DETAILS
  static Future<Map<String,dynamic>> fetchBookedGuestDetails(model)async{
    var url=Uri.parse(ApiLinks.fetchBookedGuestDetailsApi);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    try{
      final res = await http.post(url,body: jsonEncode(model),headers: requestHeaders);
      if (res.statusCode == 200) {
        var response = jsonDecode(res.body);
       // print(response);
        return response;
      } else {
        var response = jsonDecode(res.body);
        //print(response);
        return response;
      }
    }catch(err){
      print('failed to complete unBookhostle api');
      print(err.toString());
      return {'success': false, 'message': 'failed to unbook hostle while requesting'};
    }

  }

  //----------------------------------------------------------------------------FETCH PAYMENT RECORD
  static Future<Map<String,dynamic>> fetchPaymentRecord(model)async{
    print('fetchpayment record method called in staticmethod class');
    var url = Uri.parse(ApiLinks.fetchPaymentRecord);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    try{
      final res = await http.post(url,body: jsonEncode(model),headers: requestHeaders);
      if (res.statusCode == 200) {
        var response = jsonDecode(res.body);
        // print(response);
        return response;
      } else {
        var response = jsonDecode(res.body);
        //print(response);
        return response;
      }
    }catch(err){
      print('failed to complete unBookhostle api');
      print(err.toString());
      return {'success': false, 'message': 'failed to unbook hostle while requesting'};
    }


  }

  //----------------------------------------------------------------------------Marked as paid
  static Future<Map<String,dynamic>> markedAsPaid(model)async{
    var url = Uri.parse(ApiLinks.markedAsPaid);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    try{
      final res = await http.post(url,body: jsonEncode(model),headers: requestHeaders);
      if (res.statusCode == 200) {
        var response = jsonDecode(res.body);
        // print(response);
        return response;
      } else {
        var response = jsonDecode(res.body);
        //print(response);
        return response;
      }
    }catch(err){
      print('failed to complete marked as paid api');
      print(err.toString());
      return {'success': false, 'message': 'failed to mark as paid'};
    }
  }

  //----------------------------------------------------------------------------open google map
  static void openGoogleMap({mapAddress}) async {

     var url = Uri.parse(mapAddress);

    if (!await launchUrl(url)) {
      throw Exception('Could not launch googlemap');
    }
  }

  //----------------------------------------------------------------------------FORGOT THE PASSWORD
  static Future<Map<String,dynamic>> verifyAndUpdatePassword(forgotPasswordModel)async{
    var url;
    var response;
    if(forgotPasswordModel['userCategory']=='owner'){
      url = Uri.parse(ApiLinks.verifyOtpAndUpdatePasswordForOwner);
    }else if(forgotPasswordModel['userCategory']=='guest'){
      url = Uri.parse(ApiLinks.verifyOtpAndUpdatePasswordForGuest);
    }

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    try{
      final res = await http.post(url,body: jsonEncode(forgotPasswordModel),headers: requestHeaders);
      if (res.statusCode == 200) {
         response = jsonDecode(res.body);
        // print(response);
        return response;
      } else {
        response = jsonDecode(res.body);
        //print(response);
        return response;
      }
    }catch(err){
      print('failed to complete marked as paid api');
      print(err.toString());
      return {'success': false, 'message': 'failed to update password'};
    }

  }


//----------------------------------------------------------SHOW DIALOG FOR REGISTRATION AND LOGIN
  static void showDialogMessage(BuildContext context, response, appState, String heading, {String? userType, BuildContext? FirstParentContext, BuildContext? hostleDetailContext}) {
    print(' showdialong2 method called');
    print(response);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            heading,
            style: TextStyle(color: Theme.of(context).primaryColorDark),
          ),
          content: response['success'] == true
              ? Text(
                  '${response['message']}',
                  style: TextStyle(color: Colors.green),
                )
              : Text(
                  '${response['message']}',
                  style: const TextStyle(color: Colors.red),
                ),
          actions: [
            TextButton(
              onPressed: () async {
                print('onpressed called');
                if(response['success']==true){
                  if (heading == 'Upload Response') {
                    print('response is upload response');
                    fetchUserDetail(appState);
                    if (appState.userType == 'owner') {
                      fetchHostleList(appState);
                    }
                    appState.imageFile = null;
                    Navigator.pop(dialogContext);
                    popPage(context);
                  }

                  if (heading == 'Registration Response') {
                    print('response is registration response');
                    fetchHostleList(appState);
                    appState.activeWidget = 'loginWidget';
                    Navigator.pop(dialogContext);
                  }
                  if(heading=='Update Response'){
                    fetchHostleList(appState);
                    fetchUserDetail(appState);
                    Navigator.pop(dialogContext);
                    popPage(context);
                  }

                  if (heading == 'Login Response') {
                    print('response is login response');
                    appState.storeUserType(userType);
                    await Future.delayed(const Duration(milliseconds: 100));

                    appState.fetchUserType();
                    await Future.delayed(const Duration(milliseconds: 100));

                    appState.storeToken(response['token'], appState.userType);
                    await Future.delayed(const Duration(milliseconds: 100));

                    appState.fetchToken(appState.userType);
                    await Future.delayed(const Duration(milliseconds: 100));

                    StaticMethod.fetchUserDetail(appState);

                    appState.activeWidget = 'dashboardWidget';
                    Navigator.pop(dialogContext);
                  }

                  if(heading=='Book Response'){
                    print('response is Book response');
                    fetchHostleList(appState);
                    fetchUserDetail(appState);
                    //appState.activeWidget='hostleListWidget';
                    Navigator.pop(dialogContext);
                    popPage(context);
                  }

                  if(heading=='Unbook Response'){
                    print('response is Book response');
                    fetchHostleList(appState);
                    fetchUserDetail(appState);
                    //appState.activeWidget='hostleListWidget';
                    Navigator.pop(dialogContext);
                    popPage(context, ContextOfParent: FirstParentContext);
                  }

                  if(heading=='Booked Guest Detail Response'){
                    Navigator.pop(context);
                  }

                  if(heading=='Deletion Response'){
                    fetchUserDetail(appState);
                    Navigator.pop(dialogContext);
                    popPage(context);
                  }

                  if(heading=="Send Otp Response"){
                    Navigator.pop(dialogContext);
                  }

                  if(heading=="User Verification Response"){
                    fetchUserDetail(appState);
                    fetchHostleList(appState);
                    Navigator.pop(dialogContext);
                    popPage(context);
                  }

                  if(heading=='Forgot Password Response'){
                    Navigator.pop(dialogContext);
                    popPage(context);
                  }

                  if(heading=='Rating Response'){
                    fetchHostleList(appState);
                    appState.activeWidget='hostleListWidget';
                    Navigator.pop(dialogContext);
                    popPage(context,ContextOfParent: hostleDetailContext);
                  }

                  if(heading=='Transaction Response'){
                    Navigator.pop(dialogContext);
                    popPage(context);
                  }

                  if(heading=='Unbook Response For Owner'){
                    fetchHostleList(appState);
                    fetchUserDetail(appState);
                    Navigator.pop(dialogContext);
                    popPage(context,ContextOfParent: FirstParentContext);
                  }
                }else{
                  Navigator.pop(context);
                  if(heading=='Unbook Response'){
                    popPage(context,ContextOfParent: FirstParentContext);
                  }
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void popPage(context, {BuildContext? ContextOfParent}) {
    Navigator.of(context).pop();
    popPage2(ContextOfParent);
  }
  static void popPage2(ContextOfParent) {
    Navigator.of(ContextOfParent).pop();
  }
}
