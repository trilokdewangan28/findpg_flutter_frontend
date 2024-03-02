
import 'package:findpg/config/StaticMethod.dart';
import 'package:findpg/pages/forOwner/BookedGuestDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/MyProvider.dart';

class BookedGuestListPage extends StatefulWidget {
  final List<dynamic> guestList;

  const BookedGuestListPage({Key? key, required this.guestList})
      : super(key: key);

  @override
  State<BookedGuestListPage> createState() => _BookedGuestListPageState();
}

class _BookedGuestListPageState extends State<BookedGuestListPage> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Guest List'),
          ),
          body: Container(
            child: ListView.builder(
              itemCount: widget.guestList.length,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () async {
                      String BookedGuestEmail = widget.guestList[index]['guestEmail'];
                      var model = {"guestEmail": BookedGuestEmail};
                      final response =
                          await StaticMethod.fetchBookedGuestDetails(model);
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (dialogContext) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                      Navigator.pop(context);
                      if (response.isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BookedGuestDetailPage(
                                  guestListContext: context,
                                    guestDetail: response['result'])));
                      }
                    },
                    child: Card(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        color: const Color.fromARGB(255, 206, 206, 236),
                        elevation: 3,
                        child: ListTile(
                          title: Text(widget.guestList[index]['guestFullName']),
                        )));
              },
            ),
          )),
    );
  }
}
