import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../provider/MyProvider.dart';

class ManageTransactionForGuest extends StatefulWidget {
  final Map<String,dynamic> bookedHostleDetails;
  const ManageTransactionForGuest({Key? key, required this.bookedHostleDetails}) : super(key: key);

  @override
  State<ManageTransactionForGuest> createState() => _ManageTransactionForGuestState();
}

class _ManageTransactionForGuestState extends State<ManageTransactionForGuest> {
  bool isPaid=false;
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context,listen: false);
    print('inside the manage transaction');
    print(appState.paymentRecord);
    //print(widget.guestDetail);
    DateTime currentDate = DateTime.now();
    List<DateTime> monthsInRange = [];
    DateTime joinedDate = DateTime.parse(appState.userDetail['result']['joinedDate']);
    DateTime tempDate = DateTime(joinedDate.year, joinedDate.month);
    while (tempDate.isBefore(currentDate) || tempDate == currentDate) {
      monthsInRange.add(tempDate);
      tempDate = DateTime(tempDate.year, tempDate.month + 1);
    }
    return RefreshIndicator(child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Transaction'),
        ),
        body: Column(
          children: [
            Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 214, 223, 232),
                ),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Hostle Name: ${widget.bookedHostleDetails['hostleName']}'),
                    Text('Joinded Date: ${joinedDate.day}-${joinedDate.month}-${joinedDate.year}')
                  ],
                )
            ),
            Expanded(
                child: ListView.builder(
                  itemCount: monthsInRange.length,
                  itemBuilder: (context, index) {
                    DateTime month = monthsInRange[index];

                    if(appState.paymentRecord!=null){
                      for (var guest in appState.paymentRecord!['guests']) {
                        if (guest['guestEmail'] == appState.userDetail['result']['email']) {
                          print(guest['guestEmail']);
                          for (var yearData in guest['years']) {
                            if (yearData['year'] == month.year.toString()) {
                              print(yearData['year']);
                              for (var monthData in yearData['months']) {
                                if (monthData['month'] == DateFormat('MMMM').format(month)) {
                                  print(monthData['month'].toString());
                                  isPaid = monthData['paid'];
                                  break;
                                }else{
                                  isPaid=false;
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                    return Container(
                        width: MediaQuery.of(context).size.width*0.9,
                        height: MediaQuery.of(context).size.height*0.05,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width:MediaQuery.of(context).size.width*0.3,
                                child:Text('${DateFormat('MMMM').format(month)}-${month.year}')
                            ),

                            appState.paymentRecord==null || isPaid!=true
                                ? Container(
                                width:MediaQuery.of(context).size.width*0.3,
                                child:const Text('unpaid',style: TextStyle(color: Colors.red),)
                            )
                                : Container(
                                width:MediaQuery.of(context).size.width*0.3,
                                child:const Text('paid', style: TextStyle(color: Colors.green),)
                            ),

                            /*
                            isPaid==false
                                ? Container(
                                width:MediaQuery.of(context).size.width*0.3,
                                child:TextButton(
                                    onPressed: (){
                                      _showBottomSheetForSubmitTransaction(context, appState, appState.userDetail['result'], month);
                                    },
                                    child: const Text('marked as paid')
                                )
                            )
                                : Container(width:MediaQuery.of(context).size.width*0.3,)

                             */
                          ],
                        )
                    );
                  },
                )
            )
          ],
        )
    ), onRefresh: ()async{
      await Future.delayed(const Duration(seconds: 1));
      appState.fetchPaymentRecord(appState,appState.userDetail['result']);
      setState(() {
      });
    }
    );
  }
}
