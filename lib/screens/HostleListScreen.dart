
import 'package:findpg/config/StaticMethod.dart';
import 'package:findpg/provider/MyProvider.dart';
import 'package:findpg/widget/DashboardWidget.dart';
import 'package:findpg/widget/HostleDetailWidget.dart';
import 'package:findpg/widget/HostleListWidget.dart';
import 'package:findpg/widget/LoginWidget.dart';
import 'package:findpg/widget/RegistrationWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HostleListScreen extends StatefulWidget {
  const HostleListScreen({Key? key}) : super(key: key);

  @override
  State<HostleListScreen> createState() => _HostleListScreenState();
}

class _HostleListScreenState extends State<HostleListScreen> {
  @override
  void initState() {
    final appState = Provider.of<MyProvider>(context, listen: false);
    StaticMethod.fetchHostleList(appState,setTheState: setTheState);
    clearFilter(appState);
    StaticMethod.initialFetch(appState);
    setTheState();
    print('app restarted');
    super.initState();
  }
  void clearFilter(appState){
    appState.cities = ['no filter'];
    appState.hostleCategory = ['no filter'];
    appState.filteredHostleDataList = [];
    appState.setFilterVariable();
  }
  void setTheState(){
    //print('set the state called');
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    //------------------------------------LOGOUT FUNCTION-----------------------
    void logout() async {
      appState.deleteToken(appState.userType);
      await Future.delayed(
          const Duration(milliseconds: 100)); // Add a small delay (100 milliseconds)

      appState.deleteUserType();
      await Future.delayed(const Duration(milliseconds: 100));

      appState.userDetail = {};
      appState.userDetail.clear();
      await Future.delayed(const Duration(milliseconds: 100));

      await appState.fetchUserType();
      Future.delayed(const Duration(milliseconds: 100));

      appState.fetchToken(appState.userType);
      Future.delayed(const Duration(milliseconds: 100));

      appState.activeWidget = 'hostleListWidget';
      appState.currentState = 0;
    }

    //--------------------------------REFRESH METHOD----------------------------
    void refresh(){
      appState.errorExceptionHostleFetch=null;
      appState.filteredHostleDataList = [];
      appState.cities = ['no filter'];
      appState.hostleCategory = ['no filter'];
      StaticMethod.fetchHostleList(appState,setTheState: setTheState);
      appState.setFilterVariable();
      appState.applyFilter();
      setState(() {
        print('state changed');
      });
    }
    //--------------------------------HANDLING WIDGET NAVIGATION----------------
    Widget appBarAction = Container();
    String secondBtmContent = 'login';
    IconData iconData = appState.token != "" ? Icons.person : Icons.login;
    Widget widgetContent = const HostleListWidget();
    String appBarContent = 'Hostle List';
    if (appState.activeWidget == 'hostleListWidget') {
      widgetContent = const HostleListWidget();
      appBarContent = 'Hostle List';
      if (appState.token == "" || appState.token == "") {
        secondBtmContent = 'login';
        iconData = Icons.login;
      } else {
        secondBtmContent = 'profile';
        iconData = Icons.person;
      }
      appBarAction=IconButton(onPressed: (){refresh();}, icon: const Icon(Icons.refresh));
    }
    else if (appState.activeWidget == 'loginWidget') {
      widgetContent = const LoginWidget();
      secondBtmContent = 'login';
      iconData = Icons.login;
      appBarContent = 'Login';
    }
    else if (appState.activeWidget == 'registrationWidget') {
      widgetContent = const RegistrationWidget();
      secondBtmContent = 'registration';
      iconData = Icons.person_add;
      appBarContent = 'Registration';
    }
    else if (appState.activeWidget == 'dashboardWidget') {
      widgetContent = const DashboardWidget();
      secondBtmContent = 'profile';
      iconData = Icons.person;
      appBarContent = 'Dashboard';
      appBarAction = IconButton(
          onPressed: () {
            logout();
          },
          icon: const Icon(Icons.logout));
    }
    else if (appState.activeWidget == 'hostleDetailWidget') {
      widgetContent = const HostleDetailWidget();
      appBarContent = 'Hostle Details';
      if (appState.token == "" || appState.token == "") {
        secondBtmContent = 'login';
        iconData = Icons.login;
      } else {
        secondBtmContent = 'profile';
        iconData = Icons.person;
      }
    }

    //---------------------------------GETTING TOKEN STATUS---------------------
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarContent),
        actions: [appBarAction],
      ),
      body: widgetContent,
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 20,
        selectedIconTheme: const IconThemeData(size: 30,),
        selectedFontSize: 15,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: appState.currentState,
        onTap: (index) async {
          //setState(() {
          appState.currentState = index;
          if (index == 1) {
            if (appState.token.isNotEmpty && appState.userType.isNotEmpty) {
              appState.activeWidget = 'dashboardWidget';
            } else {
              appState.activeWidget = 'loginWidget';
            }
          } else {
            appState.activeWidget = 'hostleListWidget';
          }
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Hostels',
          ),
          BottomNavigationBarItem(
            icon: Icon(iconData),
            label: secondBtmContent,
          ),
        ],
      ),
    );

  }
}
