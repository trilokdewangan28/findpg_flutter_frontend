import 'dart:convert';
import 'dart:io';
import 'package:findpg/config/ApiLinks.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import '../config/StaticMethod.dart';



class MyProvider extends ChangeNotifier {


  //------------------------------------------------STATE MANAGER FOR NAVIGATION
  int _currentState = 0;
  int get currentState => _currentState;
  set currentState(int value) {
    _currentState = value;
    notifyListeners();
  }

  bool _isFetchingData = false;
  bool get isFetchingData => _isFetchingData;

  setFetchingData(bool value) {
    _isFetchingData = value;
    notifyListeners();
  }


  String _activeWidget = 'hostleListWidget';
  String get activeWidget => _activeWidget;
  set activeWidget(String value) {
    _activeWidget = value;
    notifyListeners();
  }
  //--------------------------------------------------------------IMAGE VARIABLE
  File? _imageFile;
  File? get imageFile => _imageFile;
  set imageFile(File? value) {
    _imageFile = value;
    notifyListeners();
  }

  //-----------------------------------------------------------PAYMENT RECORD DATA HANDILING
  Map<String,dynamic>? paymentRecord;
  void fetchPaymentRecord(appState,guestDetail)async{
    var model = {
      "ownerEmail":appState.userDetail['result']['email'],
      "guestEmail":guestDetail['email']
    };
    final response = await StaticMethod.fetchPaymentRecord(model);
    paymentRecord=response['result'];
  }


  //-------------------------------------------------------------RATING VARIABLE
  List<String> ratings =['1','2','3','4','5'];
  //------------------------------------------------------BOOKED HOSTLE DETAILS
  Map<String, dynamic> bookedHostleDetails={};
  //-------------------------------------------------SETTING UP FILTER VARIABLE
  List<String> cities = ['no filter'];
  List<String> hostleCategory = ['no filter'];

  String selectedCity = 'no filter';
  String selectedHostleCategory = 'no filter';

  //----------------------------------------------------------------------------SET FILTER VARIABLE FUNCTION
  void setFilterVariable(){
    List<String> cityHelper=[];
    List<String> hostleCategoryHelper=[];
    if(fetchedHostleData.isNotEmpty){
      fetchedHostleData.forEach((element) {
        String ct=element['city'];
        String ctgr=element['selectedHostleCategory'];
        if(!cityHelper.contains(ct)){
          cityHelper.add(ct);
          cities.add(ct);
        }
        if(!hostleCategoryHelper.contains(ctgr)){
          hostleCategoryHelper.add(ctgr);
          hostleCategory.add(ctgr);
        }
      });
    }

  }

  //----------------------------------------------------------------------------APPLY FILTER METHOD
  List<dynamic> filteredHostleDataList=[];
  void applyFilter(){
    if(fetchedHostleData.isNotEmpty){
      //print('apply filter called');
      fetchedHostleData.forEach((item) {
        bool noFilterApply= selectedCity=='no filter' && selectedHostleCategory=='no filter';
        bool bothFilterApply= item['city'] == selectedCity && item['selectedHostleCategory'] == selectedHostleCategory;
        bool onlyCityFilterApply = selectedHostleCategory=='no filter' && item['city']==selectedCity;
        bool onlyHostleFilterApply = selectedCity=='no filter' && item['selectedHostleCategory']==selectedHostleCategory;

        if(bothFilterApply){
           filteredHostleDataList.add(item);
        }else if(noFilterApply){
          filteredHostleDataList.add(item);
        }else if(onlyCityFilterApply || onlyHostleFilterApply){
          filteredHostleDataList.add(item);
        }else{
          print('all condition failed');
        }
      });
      if (filteredHostleDataList.isEmpty) {
        print('filtered hostle data is empty');
        filteredHostleDataList = [];
      }
    }else{
      //print('fetched hostle data is empty');
    }
    //print('inside the applyFiltermethod');
    //print(filteredHostleDataList);
  }


//------------------------------------------------------------------------------FETCH HOSTLE LIST
  var errorExceptionHostleFetch;
  List<dynamic> fetchedHostleData=[];
  Map<String,dynamic>? hostleDetail;// for view the particuler hostle
  Map<String,dynamic> fetchedHostleMapData={}; // to store the list of hostle
  void fetchHostleList({setTheState}) async {
    _isFetchingData=true;
    var url = Uri.parse(ApiLinks.fetchHostleApi);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        //print(responseBody);
        fetchedHostleMapData = {
          "code":200,
          "success":true,
          "message":'hostle list fetched successfully',
          "result":responseBody['result']
        };
        fetchedHostleData=responseBody['result'];
        //print(fetchedHostleData);
        _isFetchingData=false;
        //setTheState();
       // return fetchedHostleMapData;
      } else {
        //print('500 error');
        var errorResponseBody= jsonDecode(response.body);
        fetchedHostleMapData = {
          "code":500,
          "success":false,
          "message":'internal server error',
          "result":[]
        };
        _isFetchingData=false;
        //setTheState();
        //return fetchedHostleMapData;
      }
    }catch(e){
      print(e.toString());
      fetchedHostleMapData = {
        "code":401,
        "success":false,
        "message":'Internal Server Error While Requesting',
        "result":[]
      };
      _isFetchingData=false;
      //setTheState();
      //return fetchedHostleMapData;
    }
    notifyListeners();
  }


//------------------------------------------------------------------------------FETCH OWNER DATA USING TOKEN
  //OwnerDataModel? ownerDetail;
  Map<String,dynamic> userDetail={};
  Future<void> getDataByToken(token,isGuest)async{
    //print('getDataByToken method called');
    //print(' ${userType}');
    //print('${token}');
    var url;
    if(userType=='guest'){
      url = Uri.parse(ApiLinks.guestProfileApi);
    }else if(userType=='owner'){
      url = Uri.parse(ApiLinks.ownerProfileApi);
    }else{
      return;
    }
    Map<String, String> requestHeaders = {
      'Authorization': 'Bearer $token',
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    try{
      final response = await http.get(url, headers: requestHeaders);
      if(response.statusCode==200){
        var responseData = json.decode(response.body);
        //ownerDetail = OwnerDataModel.fromJson(responseData);
        userDetail=responseData;
        //print('userData is:');
        //print(responseData);
      }else{
        var errData = json.decode(response.body);
        userDetail=errData;
        //print(userDetail);
      }

    }catch(err){
      //print(err);
    }
    notifyListeners();

  }


//------------------------------------------------------------------------------TOKEN MANAGER
  String token="";
  void fetchToken(String userType) async{
    token = await getToken(userType);
    //print('inside the fetchToken $token');
    notifyListeners();
  }

  void storeToken(String token, String userType) async {
    const storage =  FlutterSecureStorage();
    const Duration tokenDuration = Duration(days: 15);
    final DateTime now = DateTime.now();
    final DateTime expiration = now.add(tokenDuration);
    final String expirationString = expiration.toIso8601String();

    if (userType=='guest') {
      await storage.write(key: 'guestToken', value: token);
      await storage.write(key: 'guestTokenExpiration', value: expirationString);
      //print('guest token stored');
    } else {
      await storage.write(key: 'ownerToken', value: token);
      await storage.write(key: 'ownerTokenExpiration', value: expirationString);
      //print('owner token stored');
    }

    notifyListeners();
  }

  Future<String> getToken(String userType) async {
    const storage = FlutterSecureStorage();
    String? token;
    if (userType=='guest') {
      token = await storage.read(key: 'guestToken');
      //print('guest token called');
    } else if(userType=='owner'){
      token = await storage.read(key: 'ownerToken');
      //print('owner token called');
    }
    return token ?? "";
  }

  void deleteToken(String userType) async {
    const storage = FlutterSecureStorage();
    if (userType=='guest') {
      await storage.delete(key: 'guestToken');
      await storage.delete(key: 'guestTokenExpiration');
      //print('guest token deleted');
    } else {
      await storage.delete(key: 'ownerToken');
      await storage.delete(key: 'ownerTokenExpiration');
      //print('owner token deleted');
    }

    this.token = "";
    notifyListeners();
  }


  //----------------------------------------------------------------------------HANDLING USER TYPE
  String userType="";
  Future<void> fetchUserType() async{
    userType=await getUserType();
    //print('inside the fetchUserType $userType');
    notifyListeners();
  }

  void storeUserType(userType)async{
    const storage = FlutterSecureStorage();
    const Duration tokenDuration = Duration(days: 15);
    final DateTime now = DateTime.now();
    final DateTime expiration = now.add(tokenDuration);
    final String expirationString = expiration.toIso8601String();

    await storage.write(key: 'userType', value: userType);
    await storage.write(key: 'userTypeExpiration', value: expirationString);

    //print('inside the storeUserType $userType');
    notifyListeners();

  }

  Future<String> getUserType() async {
    const storage = FlutterSecureStorage();
    String? userType;
    userType = await storage.read(key: 'userType');
    return userType ?? "";

  }

  void deleteUserType() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'userType');
    await storage.delete(key: 'userTypeExpiration');
    this.userType = "";
    //print('inside the deleteUserType');
    notifyListeners();
  }


}