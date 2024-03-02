
import 'package:findpg/pages/VerificationPage.dart';
import 'package:findpg/pages/forOwner/ImageSlider.dart';
import 'package:findpg/provider/MyProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../config/StaticMethod.dart';

class HostleDetailWidget extends StatefulWidget {
  const HostleDetailWidget({Key? key}) : super(key: key);

  @override
  State<HostleDetailWidget> createState() => _HostleDetailWidgetState();
}

class _HostleDetailWidgetState extends State<HostleDetailWidget> {
  //----------------------------------------------------------------------------DISPLAY FEEDBACK & RATING BTMST
  void _showBottomSheetForFeedbackShow(
      BuildContext context, List<dynamic>? rateByGuest) {
    print(rateByGuest);
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
            // Use ClipRRect to apply rounded corners
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  child: const Text(
                    'Feedback & Rating',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15.0),
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15))),
                    child: ListView.builder(
                        itemCount: rateByGuest!.length,
                        itemBuilder: (context, index) {
                          Color rateColor = Colors.grey;
                          if (rateByGuest[index]['rate'] == 0) {
                            rateColor = Colors.grey;
                          } else if (rateByGuest[index]['rate'] > 0 &&
                              rateByGuest[index]['rate'] <= 2) {
                            rateColor = Colors.red;
                          } else if (rateByGuest[index]['rate'] > 2 &&
                              rateByGuest[index]['rate'] <= 3.5) {
                            rateColor = Colors.orange;
                          } else if (rateByGuest[index]['rate'] > 3.5) {
                            rateColor = Colors.green;
                          }
                          return Card(
                              elevation: 1.0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              color: Theme.of(context).primaryColorLight,
                              child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                              rateByGuest[index]['guestName'], style: const TextStyle(fontWeight: FontWeight.bold),),
                                          const Spacer(),
                                          Text(
                                            '${rateByGuest[index]['rate']}',
                                            style: TextStyle(color: rateColor),
                                          ),
                                          Icon(
                                            Icons.star,
                                            size: 20,
                                            color: rateColor,
                                          )
                                        ],
                                      ),
                                      Text('${rateByGuest[index]['feedback']}')
                                    ],
                                  )));
                        }))
              ],
            ));
      },
    );
  }

  //----------------------------------------------------------------------------SUBMIT FEEDBACK & RATING BTMST
  void _showBottomSheetForSubmitRating(BuildContext context, appState) {
    final _feedbackController = TextEditingController();
    int rateValue = 0;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context)=>StatefulBuilder(
          builder: (context,setState){
            return SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding:
                  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'select your rating',
                        style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      //--------------------------------------------RATING CONTAINER
                      Container(
                          margin: const EdgeInsets.all(15),
                          padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      rateValue = 1;
                                    });
                                    print(rateValue);
                                  },
                                  icon: rateValue >= 1
                                      ? const Icon(
                                    Icons.star,
                                    color: Colors.green,
                                  )
                                      : const Icon(Icons.star_border_outlined)),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      rateValue = 2;
                                    });
                                    print(rateValue);
                                  },
                                  icon: rateValue >= 2
                                      ? const Icon(
                                    Icons.star,
                                    color: Colors.green,
                                  )
                                      : const Icon(Icons.star_border_outlined)),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      rateValue = 3;
                                    });
                                    print(rateValue);
                                  },
                                  icon: rateValue >= 3
                                      ? const Icon(
                                    Icons.star,
                                    color: Colors.green,
                                  )
                                      : const Icon(Icons.star_border_outlined)),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      rateValue = 4;
                                    });
                                    print(rateValue);
                                  },
                                  icon: rateValue >= 4
                                      ? const Icon(
                                    Icons.star,
                                    color: Colors.green,
                                  )
                                      : const Icon(Icons.star_border_outlined)),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      rateValue = 5;
                                    });
                                    print(rateValue);
                                  },
                                  icon: rateValue == 5
                                      ? const Icon(
                                    Icons.star,
                                    color: Colors.green,
                                  )
                                      : const Icon(Icons.star_border_outlined)),
                            ],
                          )),
                      //---------------------------------------FEEDBACK CONTAINER
                      Container(
                        margin: const EdgeInsets.all(15),
                        child: TextField(
                          controller: _feedbackController,
                          maxLines: null, // Allows an unlimited number of lines
                          decoration: InputDecoration(
                            labelText: 'Enter your feedback...',
                            hintText: 'Enter your feedback here...',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ),
                      //--------------------------------------------------SUBMIT NOW
                      ElevatedButton(
                          onPressed: () async {
                            var dataModel = {
                              "ownerEmail": appState.hostleDetail!['email'],
                              "guestEmail": appState.userDetail['result']['email'],
                              "guestName": appState.userDetail['result']['fname'],
                              "feedback": _feedbackController.text,
                              "rate": rateValue
                            };

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (dialogContext) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                            final response = await StaticMethod.submitRating(dataModel);
                            Navigator.pop(context);
                            if (response.isNotEmpty) {
                              StaticMethod.showDialogMessage(
                                context,
                                response,
                                appState,
                                'Rating Response',
                              );
                            }
                          },
                          child: const Text('submit'))
                    ],
                  ),
                ));
          }
      )
    );
  }

  //============================================================================SHOW BOTTOM SHEET FOR TRANSACTION
  void _showBottomSheetForBook(model) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (BuildContext context)=>StatefulBuilder(
            builder:(context,setState)=>VerificationPage(model: model)
        )
    );

  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    final hostleDetail = appState.hostleDetail;
    Color lightColor = Theme.of(context).primaryColorLight;
    Color darkColor = Theme.of(context).primaryColorDark;
    Color starColor = Colors.black;
    if (hostleDetail!['averageRating'] == 0) {
      starColor = Colors.grey;
    } else if (hostleDetail['averageRating'] > 0 &&
        hostleDetail['averageRating'] <= 2) {
      starColor = Colors.red;
    } else if (hostleDetail['averageRating'] > 2 &&
        hostleDetail['averageRating'] <= 3.5) {
      starColor = Colors.orangeAccent;
    } else if (hostleDetail['averageRating'] > 3.5) {
      starColor = Colors.green;
    }

    return WillPopScope(
        onWillPop: () async {
          appState.activeWidget = 'hostleListWidget';
          return false;
        },
        child: SingleChildScrollView(
            child: Column(
          children: [
            //-------------------------------------------------------DETAIL CARD
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [lightColor, darkColor],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  )),
              child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Hostle Name:  ${hostleDetail['hostleName']}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        // or TextOverflow.ellipsis
                        softWrap: true,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Hostle Type: ${hostleDetail['selectedHostleCategory']}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Contact No: ${hostleDetail['contactNo']}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'City: ${hostleDetail['city']}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Full Address: ${hostleDetail['address']}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),

                      Row(
                        children: [
                          Container(width:100,child:Text(
                              'Address Link',
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          )),
                          Container(width:200,child:InkWell(
                              onTap: (){
                                var mapAddress=hostleDetail['mapAddressUrl'];
                                StaticMethod.openGoogleMap(mapAddress: mapAddress);
                              },
                              child:Text(
                                '${hostleDetail['mapAddressUrl']}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.deepPurpleAccent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ))),
                        ],
                      ),

                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Pincode: ${hostleDetail['pincode']}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
            ),
            //--------------------------------------------------RATING CONTAINER
            Container(
              padding: const EdgeInsets.only(top: 16),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      _showBottomSheetForFeedbackShow(
                          context, hostleDetail['rateByGuest']);
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Text(
                            '${hostleDetail['averageRating']}',
                            style: TextStyle(color: starColor),
                          ),
                          Icon(
                            Icons.star,
                            size: 20,
                            color: starColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  appState.userType == 'guest'
                      ? TextButton(
                          onPressed: () {
                            _showBottomSheetForSubmitRating(context, appState);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => RatingPage(
                            //               contextOfHostleDetails: context,
                            //             )));
                          },
                          child: const Text('rate now'))
                      : Container()
                ],
              ),
            ),
            //------------------------------------------------------IMAGE SLIDER
            Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: hostleDetail['ownerHostlePic'].length != 0
                    ? ImageSlider(
                        ownerData: hostleDetail,
                        asFinder: true,
                      )
                    : Container(
                        height: 200,
                        width: double.infinity,
                        decoration: const BoxDecoration(color: Colors.grey),
                        child: const Center(child: Text('no image found')),
                      )
            ),
            //------------------------------------------------------BOOK BTN
            appState.userType == 'guest'
                ? ElevatedButton(
                    onPressed: appState.userDetail['result']['bookedStatus'] == false && hostleDetail['availableBed']>0
                        ? () async {
                            if (appState.userDetail['result']
                                    ['verifiedEmail'] ==
                                true) {
                              DateTime currentDate = DateTime.now();
                              print(DateFormat('MMMM').format(currentDate));
                              print(currentDate.year);
                              var bookModel = {
                                "ownerEmail": hostleDetail['email'],
                                "bookedHostleName": hostleDetail['hostleName'],
                                "guestEmail": appState.userDetail['result']['email'],
                                "year": currentDate.year.toString(),
                                "month":DateFormat('MMMM').format(currentDate).toString(),
                                "paidStatus":false,
                                "heading":"Book Hostel",
                                "forWhich": "bookHostle",
                                "bookedStatus": true
                              };
                              _showBottomSheetForBook(bookModel);
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      backgroundColor: Colors.white70,
                                      content: Center(
                                          child: Text(
                                        'you cant book hostle, because you are not verified',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ))));
                            }
                          }
                        : null,
                    child: const Text('book now'))
                : Container(),
          ],
        )));
  }
}
