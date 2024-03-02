
import 'package:findpg/config/StaticMethod.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/MyProvider.dart';

class RatingPage extends StatefulWidget {
  final BuildContext contextOfHostleDetails;
  const RatingPage({Key? key, required this.contextOfHostleDetails}) : super(key: key);

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {

  String _selectedRating = '3';
  final _feedbackController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    return SafeArea(
        child: WillPopScope(
            onWillPop: () async {
              Navigator.pop(context);
              return false;
            },
            child: Scaffold(
              appBar: AppBar(title: const Text('Rating Page')),
              body: Column(
                children: [
                  //--------------------------------------------RATING CONTAINER
                  Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.only(top: 8,left: 16,right: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Row(
                    children: [
                      const Text('select your rating : ',style: TextStyle(fontSize: 16),),
                      const SizedBox(width: 16,),
                      DropdownButton(
                        value: _selectedRating,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedRating = newValue!;
                          });
                          //print(_selectedUserCategory);
                        },
                        items: appState.ratings.map((category) {
                          return DropdownMenuItem(

                            value: category,
                            child: Text(category,style: const TextStyle(fontWeight: FontWeight.bold),),
                          );
                        }).toList(),
                      ),
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
                            borderRadius: BorderRadius.circular(25)
                        ),
                      ),
                    ),
                  ),
                  //--------------------------------------------------SUBMIT NOW
                  ElevatedButton(
                      onPressed: ()async{
                        var dataModel = {
                          "ownerEmail":appState.hostleDetail!['email'],
                          "guestEmail":appState.userDetail['result']['email'],
                          "feedback":_feedbackController.text,
                          "rate": int.parse(_selectedRating)
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
                      child: const Text('submit')
                  )
                ],
              ),
            )));
  }
}
