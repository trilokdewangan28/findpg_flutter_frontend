
import 'package:findpg/config/StaticMethod.dart';
import 'package:findpg/pages/VerificationPage.dart';
import 'package:findpg/pages/forOwner/ImageSlider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/MyProvider.dart';
import 'ManageTransactionForGuest.dart';
class BookedHostleDetailPage extends StatefulWidget {
  const BookedHostleDetailPage({Key? key}) : super(key:key);

  @override
  State<BookedHostleDetailPage> createState() => _BookedHostleDetailPageState();
}

class _BookedHostleDetailPageState extends State<BookedHostleDetailPage> {
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
                                              rateByGuest[index]['guestName'],
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
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

  //============================================================================SHOW BOTTOM SHEET FOR UNBOOK
  void _showBottomSheetForUnbook(model) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (BuildContext context){
          var unBookModel={
            "ownerEmail":model['ownerEmail'],
            "bookedHostleName":model['bookedHostleName'],
            "guestEmail":model['guestEmail'],
            "forWhich":model['forWhich'],
            "bookedStatus":model['bookedStatus'],
            "bottomSheetContext":context
          };

          return VerificationPage(model: model);
        }
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

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    final bookedHostleDetail = appState.bookedHostleDetails;
    Color lightColor = Theme.of(context).primaryColorLight;
    Color darkColor = Theme.of(context).primaryColorDark;
    Color starColor = Colors.black;
    if (bookedHostleDetail['averageRating'] == 0) {
      starColor = Colors.grey;
    } else if (bookedHostleDetail['averageRating'] > 0 &&
        bookedHostleDetail['averageRating'] <= 2) {
      starColor = Colors.red;
    } else if (bookedHostleDetail['averageRating'] > 2 &&
        bookedHostleDetail['averageRating'] <= 3.5) {
      starColor = Colors.orangeAccent;
    } else if (bookedHostleDetail['averageRating'] > 3.5) {
      starColor = Colors.green;
    }
    //print(appState.bookedHostleDetails);

    return WillPopScope(
        onWillPop: () async {
          appState.activeWidget = 'dashboardWidget';
          Navigator.pop(context);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Booked Hostle'),),
          body: SingleChildScrollView(child: Column(
            children: [
              //------------------------------------------------RATING CONTAINER
              Container(
                padding: const EdgeInsets.only(top: 16),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _showBottomSheetForFeedbackShow(
                            context, bookedHostleDetail['rateByGuest']);
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Text(
                              '${bookedHostleDetail['averageRating']}',
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
                    const SizedBox(width: 20,),
                    appState.userType == 'guest'
                        ? TextButton(
                        onPressed: () {
                          _showBottomSheetForSubmitRating(context, appState);
                        },
                        child: const Text('rate now'))
                        : Container()
                  ],
                ),
              ),
              //-----------------------------------------------------DETAIL CARD
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient:   LinearGradient(
                      colors: [darkColor, lightColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )),
                child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Hostle Name:  ${bookedHostleDetail['hostleName']}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          // or TextOverflow.ellipsis
                          softWrap: true,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Hostle Type: ${bookedHostleDetail['selectedHostleCategory']}',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Contact No: ${bookedHostleDetail['contactNo']}',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'City: ${bookedHostleDetail['city']}',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Full Address: ${bookedHostleDetail['address']}',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold),
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
                                  var mapAddress=bookedHostleDetail['mapAddressUrl'];
                                  StaticMethod.openGoogleMap(mapAddress: mapAddress);
                                },
                                child:Text(
                                  '${bookedHostleDetail['mapAddressUrl']}',
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
                          'Pincode: ${bookedHostleDetail['pincode']}',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ),
              const SizedBox(
                height: 8,
              ),
              //----------------------------------------------------IMAGE SLIDER
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20,),
                  child: bookedHostleDetail['ownerHostlePic'] != []
                      ? ImageSlider(
                    ownerData: bookedHostleDetail,
                    asFinder: true,
                  )
                      : Container(
                    height: 200,
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Colors.grey),
                    child: const Center(child: Text('no image found')),
                  )),
              //--------------------------------------------------------BOOK BTN
              appState.userType=='guest' ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColorDark, // Set the background color
                    onPrimary: Colors.white, // Set the text color
                  ),
                  onPressed: appState.userDetail['result']['bookedStatus']==true ? ()async{
                    var unBookModel={
                      "ownerEmail":bookedHostleDetail['email'],
                      "bookedHostleName":bookedHostleDetail['hostleName'],
                      "guestEmail":appState.userDetail['result']['email'],
                      "forWhich":"unBookHostle",
                      "bookedStatus":false,
                      "BookedHostleDetailPageContext":context
                    };
                    print('unBookModel is ');
                    print(unBookModel);
                    _showBottomSheetForUnbook(unBookModel);
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>VerificationPage(model: unBookModel)));
                  } : null,
                  child: const Text('unBook')
              ):Container(),

              //-----------------------------------------------------------SEE TRANSACTION PAGE
              Container(
                //width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16,vertical: 4),
                  child: TextButton(
                      onPressed: ()async{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageTransactionForGuest(bookedHostleDetails: bookedHostleDetail,)));
                      },
                      child: Text('SEE TRANSACTION')
                  )
              )
            ],
          ),
        ),

    ));
  }
}
