import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/ApiLinks.dart';
import '../config/StaticMethod.dart';
import '../provider/MyProvider.dart';
class UpdateDetailsPage extends StatefulWidget {
  const UpdateDetailsPage({Key? key}) : super(key: key);

  @override
  State<UpdateDetailsPage> createState() => _UpdateDetailsPageState();
}

class _UpdateDetailsPageState extends State<UpdateDetailsPage> {
  Map<String,dynamic>? userDetails;
  final _formKey = GlobalKey<FormState>();
  bool obscuredPass = true;
  final List<String> _hostleCategory = ['boys', 'girls'];
  String _selectedHostleCategory = '';
  TextEditingController _hostleNameController = TextEditingController();
  TextEditingController _totalBedController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _professionController = TextEditingController();
  TextEditingController _clgnameController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _addressLinkController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();


  final FocusNode _contactFocusNode = FocusNode();
  final FocusNode _professionFocusNode = FocusNode();
  final FocusNode _clgFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _pincodeFocusNode = FocusNode();
  final FocusNode _hostleFocusNode = FocusNode();
  final FocusNode _addressLinkFocusNode = FocusNode();
  final FocusNode _totalBedFocusNode = FocusNode();

  final String googleMapsUrl = "https://www.google.com/maps";
  //------------------------------------------------------------------------------SUBMIT DATA METHOD
  void _submitData(BuildContext context, appState) async{
    if (appState.userType == 'guest') {
      print('submit data called for guest');
      var userData = {
        "email":userDetails!['email'],
        "contactNo": int.parse(_contactController.text),
        "profession": _professionController.text,
        "clgName": _clgnameController.text,
        "city":_cityController.text,
        "address": _addressController.text,
        "mapAddressUrl":_addressLinkController.text,
        "pincode": int.parse(_pincodeController.text),
      };
      var url= Uri.parse(ApiLinks.updateGuestApi);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      final response = await StaticMethod.updateUser(userData, url);
      Navigator.pop(context);
      print(response.toString());
      if(response.isNotEmpty){
        StaticMethod.showDialogMessage(context, response, appState, 'Update Response');
      }
    } else {
      print('submit data called for owner');
      var userData = {
        "email":userDetails!['email'],
        "hostleName": _hostleNameController.text,
        "totalBed": int.parse(_totalBedController.text),
        "contactNo": int.parse(_contactController.text),
        "selectedHostleCategory": _selectedHostleCategory,
      };
      var url= Uri.parse(ApiLinks.updateOwnerApi);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      final response = await StaticMethod.updateUser(userData, url);
      print(response.toString());
      if(response.isNotEmpty){
        Navigator.pop(context);
        StaticMethod.showDialogMessage(context, response, appState, 'Update Response');
      }
    }
  }

  @override
  void initState() {
    final appState = Provider.of<MyProvider>(context, listen: false);
    userDetails = appState.userDetail['result'];
    _selectedHostleCategory= appState.userType=='owner' ? userDetails!['selectedHostleCategory'] : '';
    _hostleNameController.text = appState.userType=='owner' ? userDetails!['hostleName'] : '';
    _totalBedController.text = appState.userType=='owner' ? userDetails!['totalBed'].toString() : '';
    _contactController.text = userDetails!['contactNo'].toString();
    _professionController.text = appState.userType=='guest' ? userDetails!['profession'] : '';
    _clgnameController.text = appState.userType=='guest' ? userDetails!['clgName'] : '';
    _cityController.text = appState.userType=='guest' ? userDetails!['city'] : '';
    _addressController.text= appState.userType=='guest' ? userDetails!['address'] : '';
    _addressLinkController.text = appState.userType=='guest' ? userDetails!['mapAddressUrl'] : '';
    _pincodeController.text = appState.userType=='guest' ? userDetails!['pincode'].toString() : '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    print(appState.userType);
    return WillPopScope(
        onWillPop: ()async{
          Navigator.pop(context);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Update Details'),
          ),
          body:Container(
            height: MediaQuery.of(context).size.height,
            child:SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  //---------------------------------FORM CARD
                  Card(
                    color: Theme.of(context).primaryColorLight,
                    margin: const EdgeInsets.only(
                        left: 25, right: 25, top: 30, bottom: 30),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          //-------------------------------UPDATE HEADING
                          Container(
                            child:const Text(
                              'Update Your Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          //---------------------------------FORM CONTAINER
                          Container(
                            child:Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    //----------------------------------HOSTLE CATEGORY
                                    appState.userType == 'owner'
                                        ? Container(
                                        child:Row(
                                          children: [
                                            const Text(
                                                'select hostle category : '),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: DropdownButton(
                                                value: _selectedHostleCategory,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _selectedHostleCategory =
                                                    newValue!;
                                                  });
                                                  //print(_selectedHostleCategory);
                                                },
                                                items: _hostleCategory
                                                    .map((category) {
                                                  return DropdownMenuItem(
                                                    value: category,
                                                    child: Text(category),
                                                  );
                                                }).toList(),
                                              ),
                                            )
                                          ],
                                        )
                                    ): Container(),

                                    //--------------------------------------------------hostle name
                                    appState.userType == 'owner' ?
                                    Container(
                                        child:TextFormField(
                                          //focusNode: _hostleFocusNode,
                                          controller: _hostleNameController,
                                          validator: (value) {
                                            if (value!.isEmpty || value.length<5) {
                                              return 'hostle name should be valid';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                              labelText: 'hostle name',
                                              hintText: 'hostle name'),
                                        )
                                    ) : Container(),

                                    //--------------------------------------------------total bed

                                    appState.userType == 'owner'
                                        ? Container(child:
                                    TextFormField(
                                      //focusNode: _totalBedFocusNode,
                                      controller: _totalBedController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty || value==0) {
                                          return 'please enter valid number';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          labelText: 'total no. of bed',
                                          hintText: 'total bed'),
                                    )
                                    )
                                        : Container(),


                                    //-------------------------------------MOBILE NO.
                                    Container(child:
                                    TextFormField(
                                      //focusNode: _contactFocusNode,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value.length != 10) {
                                          return 'please enter valid phone number';
                                        }
                                        return null;
                                      },
                                      controller: _contactController,
                                      decoration: const InputDecoration(
                                        labelText: 'mobile no.',
                                        hintText: 'mobile no.',
                                      ),
                                    )),


                                    //-----------------------------------------PROFESSION.
                                    appState.userType == 'guest'
                                        ? Container(child: TextFormField(
                                      //focusNode: _professionFocusNode,
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value.length < 4) {
                                          return 'please enter valid profession';
                                        }
                                        return null;
                                      },
                                      controller: _professionController,
                                      decoration: const InputDecoration(
                                          labelText: 'profession',
                                          hintText: 'profession'),
                                    ))
                                        : Container(),

                                    //------------------------------COLLEGE OR OFFICE NAME
                                    appState.userType == 'guest'
                                        ? Container(child:TextFormField(
                                     // focusNode: _clgFocusNode,
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value.length < 4) {
                                          return 'please enter valid input';
                                        }
                                        return null;
                                      },
                                      controller: _clgnameController,
                                      decoration: const InputDecoration(
                                          labelText:
                                          'college or office name',
                                          hintText:
                                          'college or office name'),
                                    ))
                                        : Container(),

                                    //---------------------------------------CITY
                                    appState.userType=='guest'
                                    ?Container(child: TextFormField(
                                      //focusNode: _cityFocusNode,
                                      validator: (value) {
                                        if (value!.isEmpty || value.length < 4) {
                                          return 'please enter valid city';
                                        }
                                        return null;
                                      },
                                      controller: _cityController,
                                      decoration: const InputDecoration(
                                          labelText: 'city',
                                          hintText: 'city'),
                                    ),)
                                    : Container(),

                                    //------------------------------------------ADDRESS
                                    appState.userType=='guest'
                                    ? Container(child:TextFormField(
                                      //focusNode: _addressFocusNode,
                                      validator: (value) {
                                        if (value!.isEmpty || value.length < 4) {
                                          return 'please enter valid address';
                                        }
                                        return null;
                                      },
                                      controller: _addressController,
                                      minLines: 1,
                                      maxLines: 6,
                                      decoration: const InputDecoration(
                                          labelText: 'address',
                                          hintText: 'address'),
                                    ),)
                                    : Container(),

                                    //------------------------------------------Map Address Url
                                    appState.userType=='guest'
                                    ? Container(
                                      //width: MediaQuery.of(context).size.width,
                                      child:Row(
                                        //mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                              width:MediaQuery.of(context).size.width*0.55,
                                              child:TextFormField(
                                               // focusNode: _addressLinkFocusNode,
                                                controller: _addressLinkController,
                                                minLines: 1,
                                                maxLines: 6,
                                                decoration: const InputDecoration(
                                                  labelText: 'copy and paste address link from map',
                                                  hintText: 'copy and paste address link from google map',

                                                ),
                                              )),

                                          TextButton(
                                              onPressed: (){
                                                StaticMethod.openGoogleMap(mapAddress: googleMapsUrl);
                                              },
                                              child: Text('open map')
                                          )
                                        ],
                                      ),
                                    )
                                    : Container(),


                                    //------------------------------------------PINCODE
                                    appState.userType=='guest'
                                    ? Container(
                                      child:TextFormField(
                                       // focusNode: _pincodeFocusNode,
                                        validator: (value) {
                                          if (value!.isEmpty || value.length <= 5) {
                                            return 'please enter valid pincode';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                        controller: _pincodeController,
                                        decoration: const InputDecoration(
                                            labelText: 'pincode',
                                            hintText: 'pincode'),
                                      ),
                                    )
                                        : Container()
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                  //--------------------------------REGISTRATION BUTTON
                  Container(
                    width: 300,
                    alignment: Alignment.bottomCenter,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Theme.of(context).primaryColorDark,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _submitData(context, appState);
                        }
                        //print('function called');
                      },
                      child: const Text('update now'),
                    ),
                  ),
                  TextButton(onPressed: (){}, child: Text('change password'))
                ],
              ),
            ),
          ) ,
        )
    );
  }
}
