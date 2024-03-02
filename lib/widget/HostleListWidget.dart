
import 'package:findpg/config/ApiLinks.dart';
import 'package:findpg/config/StaticMethod.dart';
import 'package:findpg/provider/MyProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HostleListWidget extends StatefulWidget {
  const HostleListWidget({Key? key}) : super(key: key);

  @override
  State<HostleListWidget> createState() => _HostleListWidgetState();
}

class _HostleListWidgetState extends State<HostleListWidget> {

 void showCircularDialog(appState){
   showDialog(
     context: context,
     barrierDismissible: false,
     builder: (dialogContext) => const Center(
       child: CircularProgressIndicator(),
     ),
   );
 }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    List<dynamic> hostleDataList = appState.filteredHostleDataList;
    print(appState.fetchedHostleMapData['success']);
    print(appState.filteredHostleDataList);
    print(appState.userType);
    print(appState.userDetail);
    Widget hostleListContent;
    Widget filterContent= Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          //--------------------------------------------------------------------CITY FILTER
          const Text(
            'city',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(
            width: 5,
          ),
          Container(
            width: 125,
            padding: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
                color: const Color.fromARGB(150, 186, 190, 238),
                borderRadius: BorderRadius.circular(10)),

            // dropdown below..
            child: DropdownButton<String>(
              value: appState.selectedCity,
              onChanged: (String? newValue) => setState(() {
                appState.filteredHostleDataList = [];
                appState.selectedCity = newValue!;
                appState.applyFilter();
              }),
              items: appState.cities
                  .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ))
                  .toList(),

              // add extra sugar..
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 25,
              underline: const SizedBox(),
            ),
          ),

//------------------------------------------------------------------------------HOSTLE TYPE FILTER
          const SizedBox(
            width: 5,
          ),
          const Text('hostle type',
              style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(
            width: 5,
          ),
          Container(
            width: 125,
            padding: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
                color: const Color.fromARGB(150, 186, 190, 238),
                borderRadius: BorderRadius.circular(10)),

            // dropdown below..
            child: DropdownButton<String>(
              value: appState.selectedHostleCategory,
              onChanged: (String? newValue) => setState(() {
                appState.filteredHostleDataList = [];
                appState.selectedHostleCategory = newValue!;
                appState.applyFilter();
              }),
              items: appState.hostleCategory
                  .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ))
                  .toList(),

              // add extra sugar..
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 25,
              underline: const SizedBox(),
            ),
          ),
        ],
      ),
    );


    if(appState.fetchedHostleMapData.isNotEmpty){
      if (appState.fetchedHostleMapData['success'] == true) {
        if (hostleDataList.isNotEmpty && hostleDataList.length > 0) {
          hostleListContent = Expanded(child: Container(
            child: Consumer<MyProvider>(
              builder: (context, appState, _) {
                return ListView.builder(
                  itemCount: hostleDataList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        //setState(() {
                        appState.hostleDetail = hostleDataList[index];
                        //});
                        appState.activeWidget = 'hostleDetailWidget';
                      },
                      //------------------------------------------------------ROOT CONTAINER
                      child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 19, vertical: 4),
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.13,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                          ),
                          child: Row(
                            children: [
                              //------------------------------------------------IMAGE CONTAINER
                              Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.13,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.15,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                    color: Color.fromARGB(255, 1, 13, 64)),
                                child: hostleDataList[index]['ownerHostlePic']
                                    .isNotEmpty
                                    ? Image.network(
                                    '${ApiLinks
                                        .accessHostleImages}/${hostleDataList[index]['ownerHostlePic'][0]}?timestamp=${DateTime
                                        .now()
                                        .millisecondsSinceEpoch}')
                                    : Image.asset('assets/images/bed.png'),
                              ),

                              //------------------------------------------------DETAILS CONTAINER
                              Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.13,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.75,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    color: Color.fromARGB(255, 206, 206, 236)),
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${hostleDataList[index]['hostleName']}',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'City: ${hostleDataList[index]['city']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Category: ${hostleDataList[index]['selectedHostleCategory']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Available Bed: ${hostleDataList[index]['availableBed']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: hostleDataList[index]['availableBed']>0 ? Colors.green : Colors.red
                                          ),
                                        ),
                                        hostleDataList[index]['averageRating'] >
                                            3.5
                                            ? Row(
                                          children: [
                                            Text(
                                              '${hostleDataList[index]['averageRating']}',
                                              style: const TextStyle(
                                                  color: Colors.green),),
                                            const Icon(Icons.star, size: 15,
                                              color: Colors.green,)
                                          ],
                                        ) : Container(),
                                        hostleDataList[index]['averageRating'] >
                                            2 &&
                                            hostleDataList[index]['averageRating'] <=
                                                3.5
                                            ? Row(
                                            children: [
                                              Text(
                                                '${hostleDataList[index]['averageRating']}',
                                                style: const TextStyle(
                                                    color: Colors
                                                        .orangeAccent),),
                                              const Icon(Icons.star, size: 15,
                                                color: Colors.orangeAccent,)
                                            ]) : Container(),

                                        hostleDataList[index]['averageRating'] >
                                            0 &&
                                            hostleDataList[index]['averageRating'] <=
                                                2
                                            ? Row(
                                          children: [
                                            Text(
                                              '${hostleDataList[index]['averageRating']}',
                                              style: const TextStyle(
                                                  color: Colors.red),),
                                            const Icon(Icons.star, size: 15,
                                              color: Colors.red,)
                                          ],
                                        ) : Container(),
                                      ],
                                    )),
                              ),
                            ],
                          )),

                    );
                  },
                );
              },
            ),
          ));
          setState(() {});
        }
        else {
          hostleListContent = Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.7,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('no hostle found'),
                    TextButton(onPressed: () {
                      appState.cities = ['no filter'];
                      appState.hostleCategory = ['no filter'];
                      appState.filteredHostleDataList = [];
                      appState.setFilterVariable();
                      setState(() {
                        appState.applyFilter();
                      });
                    }, child: const Text('refresh'))
                  ],
                ),
              ));
        }
      } else {
        hostleListContent = Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.7,
            child: Center(
                child: Column(children: [
                  Text(appState.fetchedHostleMapData['message'],
                    style: const TextStyle(color: Colors.red),),
                  TextButton(onPressed: () {
                    setState(() {
                      appState.errorExceptionHostleFetch = null;
                      appState.cities = ['no filter'];
                      appState.hostleCategory = ['no filter'];
                      appState.filteredHostleDataList = [];
                      StaticMethod.fetchHostleList(appState);
                      appState.setFilterVariable();

                      appState.applyFilter();
                    });
                  }, child: const Text('refresh'))
                ],)
            ));
      }
    }else{
      hostleListContent = Center(child:CircularProgressIndicator());
    }




    return RefreshIndicator(
        onRefresh: () async {

          await Future.delayed(const Duration(seconds: 1));
          StaticMethod.fetchHostleList(appState);
          setState(() {
          appState.cities = ['no filter'];
          appState.hostleCategory = ['no filter'];
          appState.filteredHostleDataList = [];
          appState.setFilterVariable();

            appState.applyFilter();
          });

        },
        child: Column(
          children: [
            //----------------------------------------------------FILTER SECTION
             filterContent,
            //----------------------------------------------------WIDGET CONTENT
            const Divider(
              color: Colors.black,
              thickness: 1.0,
            ),
            hostleListContent
          ],
        ));
  }
}
