
import 'package:findpg/config/StaticMethod.dart';
import 'package:findpg/pages/ManageTransaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/MyProvider.dart';
class BookedGuestDetailPage extends StatefulWidget {
  final Map<String,dynamic> guestDetail;
  final BuildContext guestListContext;
  const BookedGuestDetailPage({Key? key, required this.guestDetail, required this.guestListContext}) : super(key: key);

  @override
  State<BookedGuestDetailPage> createState() => _BookedGuestDetailPageState();
}

class _BookedGuestDetailPageState extends State<BookedGuestDetailPage> {
  @override
  void initState() {
    final appState = Provider.of<MyProvider>(context,listen: false);
    appState.fetchPaymentRecord(appState, widget.guestDetail);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    return SafeArea(
        child:WillPopScope(
          onWillPop: ()async{
            Navigator.pop(context);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('Guest Details'),
            ),
            body:SingleChildScrollView(child:Column(
              children: [
                //--------------------------------------------------------------FULLNAME
                Container(
                  width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16,vertical: 4),
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
                                'full name',
                                style: TextStyle(
                                    color: Color.fromARGB(
                                        255, 36, 38, 38)),
                              ),
                              Text(
                                '${widget.guestDetail['fname']} ${widget.guestDetail['lname']}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )
                            ],
                          ),
                        ))),
                //--------------------------------------------------------------CONTACT
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16,vertical: 4),
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
                                'contact no.',
                                style: TextStyle(
                                    color: Color.fromARGB(
                                        255, 36, 38, 38)),
                              ),
                              Text(
                                '${widget.guestDetail['contactNo']}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )
                            ],
                          ),
                        ))),
                //--------------------------------------------------------------ADHAR NO.
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16,vertical: 4),
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
                                'adhar no.',
                                style: TextStyle(
                                    color: Color.fromARGB(
                                        255, 36, 38, 38)),
                              ),
                              Text(
                                '${widget.guestDetail['adharNo']}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )
                            ],
                          ),
                        ))),
                //--------------------------------------------------------------PROFESSION
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16,vertical: 4),
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
                                '${widget.guestDetail['profession']}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )
                            ],
                          ),
                        ))),
                //--------------------------------------------------------------college/office name
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16,vertical: 4),
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
                                'college/office name',
                                style: TextStyle(
                                    color: Color.fromARGB(
                                        255, 36, 38, 38)),
                              ),
                              Text(
                                '${widget.guestDetail['clgName']}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )
                            ],
                          ),
                        ))),
                //--------------------------------------------------------------CITY
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16,vertical: 4),
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
                                '${widget.guestDetail['city']}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )
                            ],
                          ),
                        ))),
                //--------------------------------------------------------------ADDRESS
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16,vertical: 4),
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
                                '${widget.guestDetail['address']}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )
                            ],
                          ),
                        ))),
                //--------------------------------------------------------------PINCODE
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16,vertical: 4),
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
                                '${widget.guestDetail['pincode']}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )
                            ],
                          ),
                        ))),
                //--------------------------------------------------------------joined date
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16,vertical: 4),
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
                                'joined date',
                                style: TextStyle(
                                    color: Color.fromARGB(
                                        255, 36, 38, 38)),
                              ),
                              Text(
                                '${widget.guestDetail['joinedDate']}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )
                            ],
                          ),
                        ))),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //--------------------------------------------------------------MANAGE TRANSACTION PAGE BTN
                    Container(
                      //width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16,vertical: 4),
                        child: TextButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ManageTransactionPage(guestDetail: widget.guestDetail,)));
                            },
                            child: Text('Manage Transaction')
                        )
                    ),

                    //--------------------------------------------------------------UNBOOK GUEST BTN
                    Container(
                      //width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16,vertical: 4),
                        child: TextButton(
                            onPressed: ()async{
                              var unBookModel = {
                                "ownerEmail": appState.userDetail['result']['email'],
                                "bookedHostleName":appState.userDetail['result']['hostleName'],
                                "guestEmail":widget.guestDetail['email'],
                                "bookedStatus":false,
                              };
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (dialogContext) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                              final response = await StaticMethod.unbookGuestForOwner(unBookModel);
                              if (response.isNotEmpty) {
                                Navigator.pop(context);
                                StaticMethod.showDialogMessage(
                                  context,
                                  response,
                                  appState,
                                  'Unbook Response For Owner',
                                  FirstParentContext: widget.guestListContext
                                );
                              }
                            },
                            child: Text('Unbook Guest')
                        )
                    ),
                  ],
                )
              ],
            ),
          ),
        )
    ));
  }
}
