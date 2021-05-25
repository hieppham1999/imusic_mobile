import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                  Colors.blue,
                ]
            )
        ),
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign up",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    // prefixIcon: Icon(Icons.email_rounded),
                    labelText: 'Email',
                    focusColor: Colors.black,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black54,
                          width: 1.5
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black54,
                          width: 1.5
                      ),
                    ),

                  ),
                  controller: _emailController,
                  validator: (value) => value!.isEmpty ? 'Please enter valid email' : null
              ),
              SizedBox(height: 20,),
              TextFormField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    // prefixIcon: Icon(Icons.email_rounded),
                    labelText: 'Password',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black54,
                          width: 1.5
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black54,
                          width: 1.5
                      ),
                    ),

                  ),
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) => value!.isEmpty ? 'Please enter password' : null
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
                    'CREATE ACCOUNT',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff309CEE),
                    ),
                  ),
                  onPressed: () async {
                    // Map creds = {
                    //   'email' : _emailController.text,
                    //   'password' : _passwordController.text,
                    // };
                    // if (_formKey.currentState!.validate()) {
                    //   int statusCode = (await Provider.of<Auth>(context, listen: false).
                    //   login(creds: creds))!;
                    //   if (statusCode == 200) {
                    //     Navigator.pop(context);
                    //   }
                    //
                    // }
                  },),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have a account? "),
                  TextButton(
                    onPressed: (){},
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
    );
  }
}
