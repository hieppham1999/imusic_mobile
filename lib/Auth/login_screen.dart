import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imusic_mobile/services/auth.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();

  // device info
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late String? _deviceName;


  @override
  void initState() {
    // TODO: implement initState
    getDeviceName();
    super.initState();
  }

  void _togglePasswordVisible() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void getDeviceName () async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        _deviceName = androidInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        _deviceName = iosInfo.utsname.machine;
      }

    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                stops: [
                  0.01,
                  0.9
                ],
                colors: [
                  Colors.white,
                  Colors.lightBlue,
                ]
              )
            ),
            padding: const EdgeInsets.all(20.0),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Sign in",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500
                      ),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email_rounded)

                    ),
                    controller: _emailController,
                    validator: validateEmail,
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                      maxLines: 1,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock_outline_rounded),
                        suffix: IconButton(
                          icon: (_obscureText) ? Icon(Icons.visibility_rounded) : Icon(Icons.visibility_off_rounded),
                          onPressed: _togglePasswordVisible,
                        )
                      ),
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: _obscureText,
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty){
                          return 'Password can\'t be empty';
                        }
                        return null;
                      }
                  ),
                  SizedBox(height: 50,),
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.08,
                    child: TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.transparent)
                              )
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),

                      ),
                      child: Text(
                          'LOGIN',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff309CEE),
                        ),
                      ),
                      onPressed: () async {
                        Map creds = {
                          'email' : _emailController.text,
                          'password' : _passwordController.text,
                          'device_name' : _deviceName ?? 'unknown',
                        };
                        if (_formKey.currentState!.validate()) {
                          int statusCode = (await Provider.of<Auth>(context, listen: false).
                            login(creds: creds))!;
                          if (statusCode == 200) {
                            Navigator.of(context)
                                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                          }

                          }
                        },),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have a account? "),
                      TextButton(
                          onPressed: (){
                            Navigator.of(context).pushReplacementNamed('/register');
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft
                        ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value!) || value == null)
      return 'Enter a valid email address';
    else
      return null;
  }
}
