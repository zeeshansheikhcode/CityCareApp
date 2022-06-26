import 'package:city_care_app/pages/my_incidents_page.dart';
import 'package:city_care_app/utils/constants.dart';
import 'package:city_care_app/view_models/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  LoginViewModel? _loginVM; 
  void _login(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;
    bool isLoggedIn = await _loginVM!.login(email, password);
    print(isLoggedIn);
    if(isLoggedIn) 
      {
       Navigator.pop(context, true); 
      }
  }

  @override
  Widget build(BuildContext context) {
    
    _loginVM = Provider.of<LoginViewModel>(context);

    return WillPopScope(
          onWillPop: () {
            Navigator.pop(context, false); 
            return Future<bool>.value(false); 
          } ,
          child: Scaffold(
          appBar: AppBar(title:const Text("Login")),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                  child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CircleAvatar(
                          maxRadius: 150,
                          backgroundImage:
                              AssetImage(Constants.LOGIN_PAGE_HERO_IMAGE)),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Email is required!";
                          }
                          return null;
                        },
                        decoration:const InputDecoration(hintText: "Email"),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password is required!";
                          }
                          return null;
                        },
                        decoration:const InputDecoration(hintText: "Password"),
                      ),
                      FlatButton(
                          child:
                             const Text("Login", style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            _login(context);
                          },
                          color: Colors.blue),
                      Text(_loginVM!.message)
                    ],
                  )),
            ),
          )),
    );
  }
}
