
import 'package:findpg/config/ApiLinks.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

import '../config/StaticMethod.dart';
import '../provider/MyProvider.dart';


class RegistrationWidget extends StatefulWidget {
  const RegistrationWidget({Key? key}) : super(key: key);

  @override
  State<RegistrationWidget> createState() => _RegistrationWidgetState();
}

class _RegistrationWidgetState extends State<RegistrationWidget> {
  final _formKey = GlobalKey<FormState>();
  bool obscuredPass = true;
  final List<String> _userCategory = [
    'guest',
    'room owner',
  ];
  String _selectedUserCategory = 'guest'; // Option 2
  final List<String> _hostleCategory = ['boys', 'girls'];
  String _selectedHostleCategory = 'boys';

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _hostleNameController = TextEditingController();
  final _totalBedController = TextEditingController();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _contactController = TextEditingController();
  final _adharController = TextEditingController();
  final _professionController = TextEditingController();
  final _clgnameController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _addressLinkController = TextEditingController();
  final _pincodeController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _fnameFocusNode = FocusNode();
  final FocusNode _lnameFocusNode = FocusNode();
  final FocusNode _contactFocusNode = FocusNode();
  final FocusNode _adharFocusNode = FocusNode();
  final FocusNode _professionFocusNode = FocusNode();
  final FocusNode _clgFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _addressLinkFocusNode = FocusNode();
  final FocusNode _pincodeFocusNode = FocusNode();
  final FocusNode _hostleFocusNode = FocusNode();
  final FocusNode _totalBedFocusNode = FocusNode();

//------------------------------------------------------------------------------SUBMIT DATA METHOD
  void _submitData(BuildContext context, appState) async{
    if (_selectedUserCategory == 'guest') {
      var userData = {
        "email": _emailController.text,
        "password": _passwordController.text,
        "fname": _fnameController.text,
        "lname": _lnameController.text,
        "contactNo": int.parse(_contactController.text),
        "adharNo": int.parse(_adharController.text),
        "profession": _professionController.text,
        "clgName": _clgnameController.text,
        "city":_cityController.text,
        "address": _addressController.text,
        "mapAddressUrl":_addressLinkController.text,
        "pincode": int.parse(_pincodeController.text),
        "selectedUserCategory": _selectedUserCategory,
      };
      var url= Uri.parse(ApiLinks.registerGuestApi);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      final response = await StaticMethod.registerUser(userData, url);
      Navigator.pop(context);
      print(response.toString());
      if(response.isNotEmpty){
        StaticMethod.showDialogMessage(context, response, appState, 'Registration Response');
      }
    } else {
      var userData = {
        "email": _emailController.text,
        "password": _passwordController.text,
        "hostleName": _hostleNameController.text,
        "totalBed": int.parse(_totalBedController.text),
        "contactNo": int.parse(_contactController.text),
        "city":_cityController.text,
        "address": _addressController.text,
        "mapAddressUrl":_addressLinkController.text,
        "pincode": int.parse(_pincodeController.text),
        "selectedUserCategory": _selectedUserCategory,
        "selectedHostleCategory": _selectedHostleCategory,
      };
      var url= Uri.parse(ApiLinks.registerOwnerApi);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      final response = await StaticMethod.registerUser(userData, url);
      Navigator.pop(context);
      print(response.toString());
      if(response.isNotEmpty){
        StaticMethod.showDialogMessage(context, response, appState, 'Registration Response');
      }
    }
  }
  final String googleMapsUrl = "https://www.google.com/maps";

  //---------------------------WIDGET HERE----------------------------------------
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    print('registration widget called');
    return WillPopScope(
        onWillPop: ()async{
          appState.activeWidget='loginWidget';
          return false;
        },
        child: Container(
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
                    //-------------------------------REGISTRATION HEADING
                    Container(
                      child:const Text(
                        'Registration Here',
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
                              // ---------------------------------USER CATEGORY
                              Container(
                                child:Row(
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
                                          child: Text(
                                            category,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                              //----------------------------------HOSTLE CATEGORY
                              _selectedUserCategory == 'room owner'
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
                              // text field for --------------------------EMAIL
                              Container(
                                child:TextFormField(
                                  focusNode: _emailFocusNode,
                                  enableSuggestions: true,
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !value.contains('@gmail.com') ||
                                        value.length < 11) {
                                      return 'please enter valid email';
                                    }
                                    return null;
                                  },
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'email',
                                    hintText: 'email id',
                                  ),
                                ),
                              ),

                              // text field for---------------------------PASSWORD
                              Container(
                                child:TextFormField(
                                  focusNode: _passwordFocusNode,
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 8) {
                                      return 'password should be long by 8 character';
                                    }
                                    return null;
                                  },
                                  controller: _passwordController,
                                  keyboardType: TextInputType.text,
                                  obscureText: obscuredPass,
                                  decoration: InputDecoration(
                                    labelText: 'password',
                                    hintText: 'create password',
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
                              //--------------------------------------------------hostle name
                              _selectedUserCategory == 'room owner' ?
                              Container(
                                  child:TextFormField(
                                    focusNode: _hostleFocusNode,
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

                              _selectedUserCategory == 'room owner'
                                  ? Container(child:
                              TextFormField(
                                focusNode: _totalBedFocusNode,
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

                              //-------------------------------------------FNAME
                              _selectedUserCategory == 'guest'
                                  ? Container(
                                  child:TextFormField(
                                    focusNode: _fnameFocusNode,
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 4) {
                                        return 'please enter valid first name';
                                      }
                                      return null;
                                    },
                                    controller: _fnameController,
                                    decoration: const InputDecoration(
                                        labelText: 'first name',
                                        hintText: 'first name'),
                                  )
                              ) : Container(),

                              //-------------------------------------------LNAME
                              _selectedUserCategory == 'guest'
                                  ? Container(child: TextFormField(
                                focusNode: _lnameFocusNode,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      value.length < 4) {
                                    return 'please enter valid input';
                                  }
                                  return null;
                                },
                                controller: _lnameController,
                                decoration: const InputDecoration(
                                    labelText: 'last name',
                                    hintText: 'last name'),
                              ))
                                  : Container(),
                              //-------------------------------------MOBILE NO.
                              Container(child:
                              TextFormField(
                                focusNode: _contactFocusNode,
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

                              //-----------------------------------------ADHAR NO.
                              _selectedUserCategory == 'guest'
                                  ? Container(child: TextFormField(
                                focusNode: _adharFocusNode,
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      value.length < 10) {
                                    return 'please enter valid adhar no.';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                controller: _adharController,
                                decoration: const InputDecoration(
                                    labelText: 'adhar no.',
                                    hintText: 'adhar no.'),
                              ))
                                  : Container(),

                              //-----------------------------------------PROFESSION.
                              _selectedUserCategory == 'guest'
                                  ? Container(child: TextFormField(
                                focusNode: _professionFocusNode,
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
                              _selectedUserCategory == 'guest'
                                  ? Container(child:TextFormField(
                                focusNode: _clgFocusNode,
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
                              Container(child: TextFormField(
                                  focusNode: _cityFocusNode,
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
                                ),
                              ),

                              //------------------------------------------ADDRESS
                              Container(child:TextFormField(
                                  focusNode: _addressFocusNode,
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
                                ),
                              ),


                              //-----------------------------------------ADDRESS LINK ON MAP
                              Container(
                                //width: MediaQuery.of(context).size.width,
                                child:Row(
                                  //mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                        width:MediaQuery.of(context).size.width*0.55,
                                        child:TextFormField(
                                      focusNode: _addressLinkFocusNode,
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
                              ),

                              //------------------------------------------PINCODE
                              Container(
                                child:TextFormField(
                                  focusNode: _pincodeFocusNode,
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
                    //print('submit successful');
                  }
                  //print('function called');
                },
                child: const Text('register now'),
              ),
            ),
            //--------------------------------LOGIN BUTTON FOR ALREADY REGISTERED
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('already registered !'),
                //-----------------------------------LOGIN BTN
                TextButton(
                    onPressed: () {
                     appState.activeWidget='loginWidget';
                    },
                    child: const Text('login here'))
              ],
            )
          ],
        ),
      ),
    ));
  }
}
