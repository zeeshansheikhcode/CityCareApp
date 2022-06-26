
// import 'package:city_care/pages/my_incidents_page.dart';
// import 'package:city_care/utils/app_navigator.dart';
// import 'package:city_care/view_models/incident_list_view_model.dart';
// import 'package:city_care/widgets/empty_or_no_items.dart';
// import 'package:city_care/widgets/incident_list.dart';
import 'package:city_care_app/utils/app_navigator.dart';
import 'package:city_care_app/view_models/incident_list_view_model.dart';
import 'package:city_care_app/widgets/empty_or_no_items.dart';
import 'package:city_care_app/widgets/incident_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'my_incidents_page.dart';

class IncidentListPage extends StatefulWidget {
  @override
  _IncidentListPage createState() => _IncidentListPage();
}

class _IncidentListPage extends State<IncidentListPage> {
  
  IncidentListViewModel _incidentListVM = IncidentListViewModel();
  // ignore: deprecated_member_use
  List<IncidentViewModel> _incidents = <IncidentViewModel>[];
  
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _subscribeToFirebaseAuthChanges(); 
    _populateAllIncidents();
  }

  void _subscribeToFirebaseAuthChanges() {

    FirebaseAuth.instance
      .authStateChanges()
      .listen((user) {
        if(user == null) {
          setState(() {
            _isSignedIn = false; 
          });
        } else {
          setState(() {
            _isSignedIn = true; 
          });
        }
       });

  }

  void _populateAllIncidents() async {

    final incidents = await _incidentListVM.getAllIncidents();
    setState(() {
      _incidents = incidents; 
    });

   // print(_incidents); 

  }

  void _navigateToRegisterPage(BuildContext context) async {
    final bool isRegistered =
        await AppNavigator.navigateToRegisterPage(context);
    if (isRegistered) {
      AppNavigator.navigateToLoginPage(context);
    }
  }

  void _navigateToLoginPage(BuildContext context) async {
    final bool isLoggedIn = await AppNavigator.navigateToLoginPage(context);
    if (isLoggedIn) {
      // go to the my incidents page
      AppNavigator.navigateToMyIncidentsPage(context);
    }
  }

  void _navigateToMyIncidentsPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyIncidentsPage()));
  }

  void _navigateToAddIncidentsPage(BuildContext context) async {
    bool incidentAdded = await AppNavigator.navigateToAddIncidentsPage(context);
    if(incidentAdded) {
      _populateAllIncidents(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:const Text("Latest Incidents")),
        drawer: Drawer(
            child: ListView(
          children: [
          const  DrawerHeader(child: Text("Menu")),
          const  ListTile(title: Text("Home")),
            _isSignedIn ? ListTile(
                title:const Text("My Incidents"),
                onTap: () async {
                  _navigateToMyIncidentsPage(context);
                }) :const SizedBox.shrink(),
            _isSignedIn ? ListTile(
              title:const Text("Add Incident"),
              onTap: () {
                _navigateToAddIncidentsPage(context);
              },
            ) : const SizedBox.shrink(),
            !_isSignedIn ? ListTile(
                title:const Text("Login"),
                onTap: () {
                  _navigateToLoginPage(context);
                }) :const SizedBox.shrink(),
            !_isSignedIn ? ListTile(
                title:const Text("Register"),
                onTap: () {
                  _navigateToRegisterPage(context);
                }) :const SizedBox.shrink(),
            _isSignedIn ? ListTile(title:const Text("Logout"), onTap: () async {
              // logout the user 
              await FirebaseAuth.instance.signOut();
            }) : const SizedBox.shrink()
          ],
        )),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _incidents.isNotEmpty ? IncidentList(_incidents) : EmptyOrNoItems(message: "No incidents found"),
        ));
  }
}
