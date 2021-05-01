import 'dart:io';
import 'package:device_info/device_info.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "iMusic",
                  style: TextStyle(
                    fontSize: 30
                  ),
              ),
              TextFormField(
                controller: _emailController,
                validator: (value) => value!.isEmpty ? 'Please enter valid email' : null
              ),
              TextFormField(
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) => value!.isEmpty ? 'Please enter password' : null
              ),
              TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: Text('Login'),
                  onPressed: (){
                    Map creds = {
                      'email' : _emailController.text,
                      'password' : _passwordController.text,
                      'device_name' : _deviceName ?? 'unknown',
                    };
                    if (_formKey.currentState!.validate()) {
                      Provider.of<Auth>(context, listen: false).
                        login(creds: creds);
                      Navigator.pop(context);
                    }
                  },)
            ],
          ),
        ),
      ),
    );
  }
}
