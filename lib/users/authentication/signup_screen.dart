
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shifa_clothe_app/users/authentication/login_screen.dart';
import 'package:http/http.dart' as http;

import '../../api_connection/api_connection.dart';
import '../model/user.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  validateUserEmail() async {
    try {
      var response = await http.post(
        Uri.parse(API.validateEmail),
        body: {
          'user_email': emailController.text.trim(),
        }
      );
      if(response.statusCode == 200) {
        var resBody = jsonDecode(response.body);
        if(resBody['emailFound'] == true) {
          Fluttertoast.showToast(msg: 'Email is already in someone else use. Try another email.');
        }
        else {
          // register & save user record to database
          registerSaveUserRecord();
        }
      }
    }
    catch(e) {
      if (kDebugMode) {
        print("***************************************");
        print(e.toString());
        print("***************************************");

      }
      Fluttertoast.showToast(msg: '$e',backgroundColor: Colors.deepOrangeAccent);
    }
  }

  registerSaveUserRecord() async {
    User userModer = User(
      1,
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim()
    );

    try {
      var response = await http.post(Uri.parse(API.signUp), body: userModer.toJson(),);
      if(response.statusCode == 200) {
        var resBodyOfSignUp = jsonDecode(response.body);
        if(resBodyOfSignUp['success'] == true) {
          Fluttertoast.showToast(msg: 'Congratulations, you are SignUp Successfully.');
          setState(() {
            nameController.clear();
            emailController.clear();
            passwordController.clear();
          });
          Get.off(const LoginScreen());
        }
        else {
          Fluttertoast.showToast(msg: 'Error Occurred, Try Again.');
        }
      }
    }
    catch(e) {
      if (kDebugMode) {
        print(e.toString());
      }
      Fluttertoast.showToast(msg: '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, cons) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: cons.maxHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //SignUp Screen Header
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 285,
                    child: Image.asset("images/registered.jpg"),
                  ),

                  //SingUp screen sign-up form
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.all(Radius.circular(60)),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 8,
                                color: Colors.black26,
                                offset: Offset(0, -3)
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 8.0),
                        child: Column(
                          children: [
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: nameController,
                                    validator: (val) => val!.isEmpty ? "Please write you name" : null,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.person, color: Colors.black),
                                      hintText: "user name...",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                          borderSide: BorderSide(
                                              color: Colors.white70
                                          )
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                          borderSide: BorderSide(
                                              color: Colors.white70
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                          borderSide: BorderSide(
                                              color: Colors.white70
                                          )
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                          borderSide: BorderSide(
                                              color: Colors.white70
                                          )
                                      ),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                  ),// user name Field
                                  const SizedBox(height: 18.0),
                                  TextFormField(
                                    controller: emailController,
                                    validator: (val) => val!.isEmpty ? "Please write email" : null,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.email, color: Colors.black),
                                      hintText: "email...",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                          borderSide: BorderSide(
                                              color: Colors.white70
                                          )
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                          borderSide: BorderSide(
                                              color: Colors.white70
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                          borderSide: BorderSide(
                                              color: Colors.white70
                                          )
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                          borderSide: BorderSide(
                                              color: Colors.white70
                                          )
                                      ),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                  ), //---user name field email
                                  const SizedBox(height: 18.0),
                                  Obx(() {
                                    return TextFormField(
                                      controller: passwordController,
                                      validator: (val) => val!.isEmpty ? "Please write password" : null,
                                      obscureText: isObsecure.value,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.vpn_key_sharp, color: Colors.black),
                                        suffixIcon: Obx(() {
                                          return GestureDetector(
                                              onTap: () {
                                                isObsecure.value = !isObsecure.value;
                                              },
                                              child: Icon(isObsecure.value ? Icons.visibility_off : Icons.visibility, color: Colors.black)
                                          );
                                        }),
                                        hintText: "Password",
                                        border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                            borderSide: BorderSide(
                                                color: Colors.white70
                                            )
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                            borderSide: BorderSide(
                                                color: Colors.white70
                                            )
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                            borderSide: BorderSide(
                                                color: Colors.white70
                                            )
                                        ),
                                        disabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                            borderSide: BorderSide(
                                                color: Colors.white70
                                            )
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                        fillColor: Colors.white,
                                        filled: true,
                                      ),
                                    );
                                  }), //---Password field
                                  const SizedBox(height: 18.0),
                                  //---- login button
                                  Material(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: InkWell(
                                      onTap: () async {
                                        if(formKey.currentState!.validate()) {
                                          //validate the email
                                          await validateUserEmail();
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 28.0),
                                        child: Text("Sign Up", style: TextStyle(color: Colors.white,fontSize: 16.0)),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ), //email-password-login btn
                            const SizedBox(height: 18.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Already have an Account!", style: TextStyle(color: Colors.grey),),
                                // SizedBox(width: 10.0,),
                                TextButton(
                                  onPressed: () {
                                    Get.to(const  LoginScreen());
                                  },
                                  child: const Text("Log In Here", style: TextStyle(color: Colors.purpleAccent,fontSize: 16)),
                                )

                              ],
                            ),// have account button - buton

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
