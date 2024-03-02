import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../config/StaticMethod.dart';
import '../provider/MyProvider.dart';
import 'BtmSheetForTransaction.dart';
class ManageTransactionPage extends StatefulWidget {
  final Map<String,dynamic> guestDetail;
  const ManageTransactionPage({Key? key, required this.guestDetail}) : super(key: key);

  @override
  State<ManageTransactionPage> createState() => _ManageTransactionPageState();
}

class _ManageTransactionPageState extends State<ManageTransactionPage> {
  bool isPaid=false;
  // //-----------------------------------------------------------PAYMENT RECORD DATA HANDILING
  // Map<String,dynamic>? paymentRecord;
  // //============================================================================FETCH PAYMENT RECORD
  // void fetchPaymentRecord(appState,guestDetail)async{
  //   var model = {
  //     "ownerEmail":appState.userDetail['result']['email'],
  //     "guestEmail":guestDetail['email']
  //   };
  //   final response = await StaticMethod.fetchPaymentRecord(model);
  //   paymentRecord=response['result'];
  //   setState(() {
  //   });
  // }

  // @override
  // void initState(){
  //   final appState = Provider.of<MyProvider>(context, listen: false);
  //   fetchPaymentRecord(appState,widget.guestDetail);
  //   super.initState();
  // }

  //============================================================================SHOW BOTTOM SHEET FOR TRANSACTION
  void _showBottomSheetForSubmitTransaction(BuildContext context, appState, guestDetail, DateTime month) {
    print(guestDetail);
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (BuildContext context)=>StatefulBuilder(
            builder: (context,setState)=>BottomSheetContent(guestDetail: guestDetail,month: month,)
        )
        );

  }



  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context,listen: false);
    print('inside the manage transaction');
    print(appState.paymentRecord);
    //print(widget.guestDetail);
    DateTime currentDate = DateTime.now();
    List<DateTime> monthsInRange = [];
    DateTime joinedDate = DateTime.parse(widget.guestDetail['joinedDate']);
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
                    Text('Guest Name: ${widget.guestDetail['fname']} ${widget.guestDetail['lname']}'),
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
                        if (guest['guestEmail'] == widget.guestDetail['email']) {
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

                            isPaid==false
                                ? Container(
                                width:MediaQuery.of(context).size.width*0.3,
                                child:TextButton(
                                onPressed: (){
                                  _showBottomSheetForSubmitTransaction(context, appState, widget.guestDetail, month);
                                },
                                child: const Text('marked as paid')
                            )
                            )
                                : Container(width:MediaQuery.of(context).size.width*0.3,)
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
      appState.fetchPaymentRecord(appState,widget.guestDetail);
      setState(() {
      });
    }
    );
  }
}


//
// ListTile(
// title: Text("${month.year}-${month.month}"),
// trailing: Checkbox(
// value: isChecked,
// onChanged: (newValue) {
// // Update the checked state for the month
// checkedMonths[month] = newValue!;
// selectedDate=month;
// paid = newValue;
// print("Month: ${selectedDate.year}-${selectedDate.month}, Checked: $paid");
// },
// ),
// );