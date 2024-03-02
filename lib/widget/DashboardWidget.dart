import 'dart:async';

import 'package:findpg/config/ApiLinks.dart';
import 'package:findpg/config/StaticMethod.dart';
import 'package:findpg/pages/ImagePickerPage.dart';
import 'package:findpg/pages/UpdateDetailsPage.dart';
import 'package:findpg/pages/VerificationPage.dart';
import 'package:findpg/pages/forOwner/BookedGuestListPage.dart';
import 'package:findpg/provider/MyProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/forGuest/BookedHostleDetailPage.dart';
import '../pages/forOwner/ImageSlider.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({Key? key}) : super(key: key);

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  bool isLoading = true;

  //============================================================================SHOW BOTTOM SHEET FOR VERIFICATION
  void _showBottomSheetForUserVerification(model) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (BuildContext context)=>StatefulBuilder(
            builder:(context, setState){
              return VerificationPage(model: model);
            }
        )
        );
  }

  @override
  void initState() {
    super.initState();

    // Simulate an asynchronous operation

    fetchData().then((data) {
      setState(() {
        isLoading = false;
      });
    });

    // Set a timer to automatically trigger a rebuild after a specific duration
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> fetchData() async {
    // Simulate an asynchronous operation
    await Future.delayed(const Duration(microseconds: 1200));
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    //print('inside the dashboard content');
    //print('usertype is : ${appState.userType}');
    //print('userDetail is : ${appState.userDetail}');

    Color lightColor = Theme.of(context).primaryColorLight;
    Color darkColor = Theme.of(context).primaryColorDark;
    var userVerificationModel;
    if (appState.userDetail.containsKey('result')) {
      userVerificationModel = {
        "ownerEmail": appState.userDetail['result']['email'],
        "forWhich": "userVerification",
        "heading":"User Verification"
      };
    }

    //--------------------------------------------------------------------------GUEST DASHBAORD CONTENT
    Widget guestDashboardContent = appState.userType == 'guest' &&
            appState.userDetail.isNotEmpty
        ? RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 2));
              setState(() {
                StaticMethod.fetchHostleList(appState);
                StaticMethod.fetchUserDetail(appState);
              });
            },
            child: WillPopScope(
                onWillPop: () async {
                  appState.activeWidget = 'hostleListWidget';
                  appState.currentState = 0;
                  return false;
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        appState.userDetail['result']['verifiedEmail'] == false
                            ? Container(
                            padding: const EdgeInsets.only(top: 5,left: 16),
                            child: Row(
                              children: [
                                const Icon(Icons.error,color: Colors.red, size: 20,),
                                const Text(
                                  'unverified',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      _showBottomSheetForUserVerification(userVerificationModel);
                                    },
                                    child: const Text('verify now'))
                              ],
                            ))
                            : Container(
                            padding: const EdgeInsets.only(top: 15,left: 15),
                            child: const Row(
                              children:  [
                                Icon(
                                  Icons.verified,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                Text('verified',style: TextStyle(color: Colors.green),)

                              ],
                            )
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(right: 15),
                          child:TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateDetailsPage()));
                          }, child: Text('update details'))
                        )
                      ],
                    ),
                    //--------------------------------------------------------------GUEST PRIMARY PROFILE SECTION
                    Container(
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      height: 160,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [darkColor, lightColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //--------------------------------------------------------GUEST PRIMARY DETAILS
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${appState.userDetail['result']['fname']} ${appState.userDetail['result']['lname']}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                // or TextOverflow.ellipsis
                                softWrap: true,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                '${appState.userDetail['result']['email']}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                '${appState.userDetail['result']['contactNo']}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),

                          //--------------------------------------------------------GUEST PROFILE PIC AND CHANGE BTN
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                //--------------------------------------------------PROFILE PIC
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: appState.userDetail['result']
                                                  ['profilePic'] ==
                                              null
                                          ? const AssetImage(
                                              'assets/images/person.png')
                                          : NetworkImage(
                                                  '${ApiLinks.accessGuestProfilePicApi}/${appState.userDetail['result']['profilePic']}?timestamp=${DateTime.now().millisecondsSinceEpoch}')
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: const CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),

                                //--------------------------------------------------CHANGE BTN
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ImagePickerPage(
                                                    userData: appState
                                                        .userDetail['result'],
                                                    forWhich: 'profilePic',
                                                  )));
                                    },
                                    child: Text(
                                      'change profile pic',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                    )),
                                // TextButton(onPressed: (){},
                                //     child: Text('update details'))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    //--------------------------------------------------------------GUEST SECONDARY PROFILE SECTION
                    Expanded(
                        child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            alignment: Alignment.topLeft,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  //------------------------------------------------GUEST ADHAR NO.
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      constraints: const BoxConstraints(
                                        minHeight: 70,
                                      ),
                                      child: Card(
                                          color: const Color.fromARGB(
                                              255, 206, 206, 236),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'adhar number',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 36, 38, 38)),
                                                ),
                                                Text(
                                                  '${appState.userDetail['result']['adharNo']}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ))),

                                  //------------------------------------------------GUEST PROFESSION
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      constraints: const BoxConstraints(
                                        minHeight: 70,
                                      ),
                                      child: Card(
                                          color: const Color.fromARGB(
                                              255, 206, 206, 236),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'profession',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 36, 38, 38)),
                                                ),
                                                Text(
                                                  '${appState.userDetail['result']['profession']}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ))),

                                  //------------------------------------------------GUEST CLG/CMPNY NAME
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      constraints: const BoxConstraints(
                                        minHeight: 70,
                                      ),
                                      child: Card(
                                          color: const Color.fromARGB(
                                              255, 206, 206, 236),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'college/ company name',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 36, 38, 38)),
                                                ),
                                                Text(
                                                  '${appState.userDetail['result']['clgName']}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ))),

                                  //------------------------------------------------GUEST CITY
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      constraints: const BoxConstraints(
                                        minHeight: 70,
                                      ),
                                      child: Card(
                                          color: const Color.fromARGB(
                                              255, 206, 206, 236),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'city',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 36, 38, 38)),
                                                ),
                                                Text(
                                                  '${appState.userDetail['result']['city']} ',
                                                  maxLines: 4,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  // or TextOverflow.ellipsis
                                                  softWrap: true,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ))),

                                  //------------------------------------------------GUEST ADDRESS
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      constraints: const BoxConstraints(
                                        minHeight: 70,
                                      ),
                                      child: Card(
                                          color: const Color.fromARGB(
                                              255, 206, 206, 236),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'address',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 36, 38, 38)),
                                                ),
                                                Text(
                                                  '${appState.userDetail['result']['address']} ',
                                                  maxLines: 4,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  // or TextOverflow.ellipsis
                                                  softWrap: true,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ))),

                                  //------------------------------------------------OWNER ADDRESS link
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      constraints: const BoxConstraints(
                                        minHeight: 70,
                                      ),
                                      child: Card(
                                          color: const Color.fromARGB(
                                              255, 206, 206, 236),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'address link of google map',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 36, 38, 38)),
                                                ),
                                                InkWell(
                                                    onTap: (){
                                                      var mapAddress = appState.userDetail['result']['mapAddressUrl'];
                                                      StaticMethod.openGoogleMap(mapAddress: mapAddress);
                                                    },
                                                    child:Text(
                                                      '${appState.userDetail['result']['mapAddressUrl']}',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 48, 75, 225),
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 14),
                                                    )
                                                ),
                                              ],
                                            ),
                                          ))),

                                  //------------------------------------------------GUEST PINCODE
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      constraints: const BoxConstraints(
                                        minHeight: 70,
                                      ),
                                      child: Card(
                                          color: const Color.fromARGB(
                                              255, 206, 206, 236),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'pincode',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 36, 38, 38)),
                                                ),
                                                Text(
                                                  '${appState.userDetail['result']['pincode']}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ))),

                                  //------------------------------------------------GUEST BOOKED HOSTLE
                                  appState.userDetail['result']
                                              ['bookedStatus'] ==
                                          true
                                      ? InkWell(
                                          onTap: () {
                                            StaticMethod
                                                .initializeBookedHostleDetails(
                                                    appState.userDetail[
                                                        'result']['bookedTo'],
                                                    appState);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const BookedHostleDetailPage()));
                                          },
                                          child: Container(
                                              // --------------------------------Card 3
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16),
                                              constraints: const BoxConstraints(
                                                minHeight: 70,
                                              ),
                                              child: Card(
                                                  color: const Color.fromARGB(
                                                      255, 206, 206, 236),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8,
                                                        vertical: 8),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          'your booked hostle',
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      36,
                                                                      38,
                                                                      38)),
                                                        ),
                                                        Text(
                                                          '${appState.userDetail['result']['bookedHostleName']}',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16),
                                                        )
                                                      ],
                                                    ),
                                                  ))),
                                        )
                                      : Container()
                                ],
                              ),
                            )))
                  ],
                )))
        : const CircularProgressIndicator();

    //--------------------------------------------------------------------------OWNER DASHBOARD CONTENT
    Widget ownerDashboardContent = appState.userType == 'owner' &&
            appState.userDetail.isNotEmpty
        ? RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 2));
              setState(() {
                StaticMethod.fetchHostleList(appState);
                StaticMethod.fetchUserDetail(appState);
              });
            },
            child: WillPopScope(
                onWillPop: () async {
                  appState.activeWidget = 'hostleListWidget';
                  appState.currentState = 0;
                  return false;
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        appState.userDetail['result']['verifiedEmail'] == false
                            ? Container(
                            padding: const EdgeInsets.only(top: 5,left: 16),
                            child: Row(
                              children: [
                                const Icon(Icons.error,color: Colors.red, size: 20,),
                                const Text(
                                  'unverified',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      _showBottomSheetForUserVerification(userVerificationModel);
                                    },
                                    child: const Text('verify now'))
                              ],
                            ))
                            : Container(
                            padding: const EdgeInsets.only(top: 15,left: 15),
                            child: const Row(
                              children:  [
                                Icon(
                                  Icons.verified,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                Text('verified',style: TextStyle(color: Colors.green),)

                              ],
                            )
                        ),
                        Spacer(),
                        Container(
                            margin: EdgeInsets.only(right: 15),
                            child:TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateDetailsPage()));
                            }, child: Text('update details'))
                        )
                      ],
                    ),
                    //--------------------------------------------------------------OWNER PRIMARY PROFILE SECTION
                    Container(
                      margin:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      height: MediaQuery.of(context).size.width * 0.45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [darkColor, lightColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //--------------------------------------------------------OWNER PRIMARY DETAIL SECTION
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${appState.userDetail['result']['hostleName']}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                // or TextOverflow.ellipsis
                                softWrap: true,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                '${appState.userDetail['result']['email']}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                '${appState.userDetail['result']['contactNo']}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                          //--------------------------------------------------------PROFILE PIC AND BUTTON SECTION
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                //--------------------------------------------------PROFILE PIC CONTAINER
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: appState.userDetail['result']
                                                  ['profilePic'] ==
                                              null
                                          ? const AssetImage(
                                              'assets/images/person.png')
                                          : NetworkImage(
                                                  '${ApiLinks.accessOwnerProfilePicApi}/${appState.userDetail['result']['profilePic']}?timestamp=${DateTime.now().millisecondsSinceEpoch}')
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: const CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                                //--------------------------------------------------CHANGE PROFILE TEXT BUTTON
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ImagePickerPage(
                                                    userData: appState
                                                        .userDetail['result'],
                                                    forWhich: 'profilePic',
                                                  )));
                                    },
                                    child: Text(
                                      'change profile pic',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark),
                                    )),
                                //----------------------------------------------UPDATE DETAILS TEXT BUTTON
                                //TextButton(onPressed: (){}, child: Text('update details'))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //--------------------------------------------------------------OWNER SECONDARY DETAIL SECTION
                    Expanded(
                        child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            alignment: Alignment.topLeft,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  //--------------------------------------------OWNER EMAIL
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      constraints: const BoxConstraints(
                                        minHeight: 70,
                                      ),
                                      child: Card(
                                          color: const Color.fromARGB(
                                              255, 206, 206, 236),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'email',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    36,
                                                                    38,
                                                                    38)),
                                                      ),
                                                      Text(
                                                        '${appState.userDetail['result']['email']}',
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      )
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  appState.userDetail['result'][
                                                              'verifiedEmail'] ==
                                                          false
                                                      ? Container(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: TextButton(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          VerificationPage(
                                                                            model:
                                                                                userVerificationModel,
                                                                          )));
                                                            },
                                                            child: const Text(
                                                                'verify yourself'),
                                                          ),
                                                        )
                                                      : Container()
                                                ],
                                              )))),
                                  //------------------------------------------------OWNER HOSTLE CATEGORY
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      constraints: const BoxConstraints(
                                        minHeight: 70,
                                      ),
                                      child: Card(
                                          color: const Color.fromARGB(
                                              255, 206, 206, 236),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'hostle category',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 36, 38, 38)),
                                                ),
                                                Text(
                                                  '${appState.userDetail['result']['selectedHostleCategory']}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ))),

                                  //------------------------------------------------OWNER TOTAL NO.OF BED
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      constraints: const BoxConstraints(
                                        minHeight: 70,
                                      ),
                                      child: Card(
                                          color: const Color.fromARGB(
                                              255, 206, 206, 236),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'total no. of bed',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 36, 38, 38)),
                                                ),
                                                Text(
                                                  '${appState.userDetail['result']['totalBed']}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ))),

                                  //------------------------------------------------OWNER BOOKED BED
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      constraints: const BoxConstraints(
                                        minHeight: 70,
                                      ),
                                      child: Card(
                                          color: const Color.fromARGB(
                                              255, 206, 206, 236),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'booked bed',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 36, 38, 38)),
                                                ),
                                                Text(
                                                  '${appState.userDetail['result']['bookedCount']}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ))),

                                  //------------------------------------------------OWNER CITY
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      constraints: const BoxConstraints(
                                        minHeight: 70,
                                      ),
                                      child: Card(
                                          color: const Color.fromARGB(
                                              255, 206, 206, 236),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'city',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 36, 38, 38)),
                                                ),
                                                Text(
                                                  '${appState.userDetail['result']['city']}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ))),

                                  //------------------------------------------------OWNER ADDRESS
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      constraints: const BoxConstraints(
                                        minHeight: 70,
                                      ),
                                      child: Card(
                                          color: const Color.fromARGB(
                                              255, 206, 206, 236),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'address',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 36, 38, 38)),
                                                ),
                                                Text(
                                                  '${appState.userDetail['result']['address']}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ))),

                                  //------------------------------------------------OWNER ADDRESS link
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      constraints: const BoxConstraints(
                                        minHeight: 70,
                                      ),
                                      child: Card(
                                          color: const Color.fromARGB(
                                              255, 206, 206, 236),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'address link of google map',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 36, 38, 38)),
                                                ),
                                                InkWell(
                                                  onTap: (){
                                                    var mapAddress = appState.userDetail['result']['mapAddressUrl'];
                                                    StaticMethod.openGoogleMap(mapAddress: mapAddress);
                                                  },
                                                    child:Text(
                                                  '${appState.userDetail['result']['mapAddressUrl']}',
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 48, 75, 225),
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 14),
                                                )
                                                ),
                                              ],
                                            ),
                                          ))),

                                  //------------------------------------------------OWNER PINCODE
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      constraints: const BoxConstraints(
                                        minHeight: 70,
                                      ),
                                      child: Card(
                                          color: const Color.fromARGB(
                                              255, 206, 206, 236),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'pincode',
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 36, 38, 38)),
                                                ),
                                                Text(
                                                  '${appState.userDetail['result']['pincode']}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ))),

                                  //------------------------------------------------SEE BOOKED HOSTLE BUTTON
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(),
                                        onPressed:
                                            appState.userDetail['result']
                                                        ['bookedCount'] >
                                                    0
                                                ? () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                BookedGuestListPage(
                                                                    guestList: appState
                                                                            .userDetail['result']
                                                                        [
                                                                        'guestNameList'])));
                                                  }
                                                : null,
                                        child: const Text(
                                            'See All Guest Who Booked Hostle')),
                                  ),

                                  //------------------------------------------------HOSTLE IMAGE HEADING,TEXTBUTTON
                                  Center(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'hostle images',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ImagePickerPage(
                                                          userData: appState
                                                                  .userDetail[
                                                              'result'],
                                                          forWhich:
                                                              'ownerHostlePic',
                                                        )));
                                          },
                                          child:
                                              const Text('upload hostle image'))
                                    ],
                                  )),

                                  //------------------------------------------------HOSTLE IMAGES SLIDER WIDGET
                                  appState
                                              .userDetail['result']
                                                  ['ownerHostlePic']
                                              .length >
                                          0
                                      ? ImageSlider(
                                          ownerData:
                                              appState.userDetail['result'],
                                          asFinder: false,
                                        )
                                      : Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          height: 200,
                                          decoration: const BoxDecoration(
                                              color: Colors.grey),
                                          child: const Center(
                                              child: Text('no hostle images')),
                                        )
                                ],
                              ),
                            )))
                  ],
                )))
        : const CircularProgressIndicator();

    Widget userDashboardContent;
    if (appState.userType == 'guest' && appState.userDetail.isNotEmpty) {
      userDashboardContent = guestDashboardContent;
    } else if (appState.userType == 'owner' && appState.userDetail.isNotEmpty) {
      userDashboardContent = ownerDashboardContent;
    } else {
      userDashboardContent = Container(
          alignment: Alignment.center,
          child: const CircularProgressIndicator());
    }

    if (isLoading) {
      return Container(
          alignment: Alignment.center,
          child: const CircularProgressIndicator());
    } else {
      return userDashboardContent;
    }
  }
}
