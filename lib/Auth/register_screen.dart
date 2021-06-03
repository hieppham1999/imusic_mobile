import 'package:flutter/material.dart';
import 'package:imusic_mobile/services/auth.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passConfirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _passConfirmController.dispose();
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
                  Colors.lightBlueAccent,
                  Colors.white,
                ])),
            padding: const EdgeInsets.all(20.0),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sign up",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      maxLines: 1,
                      decoration: InputDecoration(
                          icon: Icon(Icons.account_box_rounded),
                          hintText: 'Name'),
                      controller: _nameController,
                      validator: (value) =>
                          value!.isEmpty ? 'Name can\`t be empty' : null),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      maxLines: 1,
                      decoration: InputDecoration(
                          icon: Icon(Icons.email_rounded), hintText: 'Email'),
                      controller: _emailController,
                      validator: validateEmail),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      maxLines: 1,
                      decoration: InputDecoration(
                          icon: Icon(Icons.lock_outline_rounded),
                          hintText: 'Password'),
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password can\'t be empty';
                        }
                        if (value.length < 6) {
                          return 'Password\'s too short';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      maxLines: 1,
                      decoration: InputDecoration(
                          icon: Icon(Icons.lock_outline_rounded),
                          hintText: 'Confirm Password'),
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: true,
                      controller: _passConfirmController,
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Password confirm can\`t be empty';
                        if (value != _passwordController.text) {
                          return 'Password confirm do not match';
                        }
                        return null;
                      }),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.08,
                    child: TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side:
                                        BorderSide(color: Colors.transparent))),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Text(
                        'CREATE ACCOUNT',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff309CEE),
                        ),
                      ),
                      onPressed: () async {
                        Map creds = {
                          'email': _emailController.text,
                          'password': _passwordController.text,
                          'name': _nameController.text,
                          'password_confirmation': _passConfirmController.text
                        };
                        if (_formKey.currentState!.validate()) {
                          Provider.of<Auth>(context, listen: false)
                              .register(creds: creds)
                              .then((response) {
                            if (response! == 200) {
                              _showSuccessDialog(context: context);
                            } else {
                              _showFailedDialog(context: context);
                            }
                          });
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Have an account? "),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft),
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

  void _showSuccessDialog({required BuildContext context}) {
    final alert = AlertDialog(
      title: Text('Info'),
      content: Text('Account was created successfully!'),
      actions: [
        TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            })
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showFailedDialog({required BuildContext context}) {
    final alert = AlertDialog(
      title: Text('Alert'),
      content: Text('Failed to create account. Please try again!'),
      actions: [
        TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
