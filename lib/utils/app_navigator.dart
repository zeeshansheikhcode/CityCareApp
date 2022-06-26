import 'package:city_care_app/pages/add_incidents_page.dart';
import 'package:city_care_app/pages/login_page.dart';
import 'package:city_care_app/pages/my_incidents_page.dart';
import 'package:city_care_app/pages/register_page.dart';
import 'package:city_care_app/view_models/add_incident_view_model.dart';
import 'package:city_care_app/view_models/login_view_model.dart';
import 'package:city_care_app/view_models/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class AppNavigator {

  static void navigateToMyIncidentsPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => MyIncidentsPage() 
    ));
  }

  static Future<bool> navigateToAddIncidentsPage(BuildContext context,[fullscreenDialog = true]) async {
    return await Navigator.push(context, MaterialPageRoute(
      builder: (context) => 
      ChangeNotifierProvider(
        create: (context) => AddIncidentViewModel(), 
        child: AddIncidentsPage()
      )

    , fullscreenDialog: fullscreenDialog));
  }

  static Future<bool> navigateToLoginPage(BuildContext context,[fullscreenDialog = true]) async {
    return await Navigator.push(context, MaterialPageRoute(
      builder: (context) => 
      ChangeNotifierProvider(
        create: (context) => LoginViewModel(), 
        child: LoginPage()
      ), fullscreenDialog: true,
    ));
  }

  static Future<bool> navigateToRegisterPage(BuildContext context) async {
    return await Navigator.push(context, MaterialPageRoute(
      builder: (context) => 
      ChangeNotifierProvider(
        create: (context) => RegisterViewModel(), 
        child: RegisterPage()
      ), fullscreenDialog: true
    ));
  }

}