import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shifa_clothe_app/api_connection/api_connection.dart';
import 'package:shifa_clothe_app/users/authentication/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shifa_clothe_app/users/fragments/dashboard_of_fragments.dart';
import 'package:shifa_clothe_app/users/model/user.dart';
import 'package:shifa_clothe_app/users/userPreferences/user_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;


  loginUserNow() async {
    try {
      var response = await http.post(
          Uri.parse(API.login),
          body: {
            'user_email': emailController.text.trim(),
            'user_password': passwordController.text.trim(),
          }
      );
      if(response.statusCode == 200) {
        var resBody = jsonDecode(response.body);
        if(resBody['success'] == true) {
          Fluttertoast.showToast(msg: 'You are Logg-in Successfully.');
          User userInfo = User.fromJson(resBody["userData"]);
          //save user info to local Stroke.
          await RememberUserPrefs.storeUserInfo(userInfo);

          Future.delayed(const Duration(milliseconds: 2000),() {
            Get.to(DashboardScreen());
          });
        }
        else {
          Fluttertoast.showToast(msg: 'user & password are incorrect. pleas, Try again');
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
                  //LogIn Screen Header
                  SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: 285,
                    child: Image.asset("images/login.jpeg"),
                  ),

                  //Login screen sign-in form
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
                                  //---user name field email
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
                                  ),
                                  //---Password field
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
                                  }),
                                  const SizedBox(height: 18.0),
                                  //---- login button
                                  Material(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: InkWell(
                                      onTap: () async {
                                        if(formKey.currentState!.validate()) {
                                          //validate the email
                                          await loginUserNow();
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 28.0),
                                        child: Text("Login", style: TextStyle(color: Colors.white,fontSize: 16.0)),
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
                                const Text("Don't have an Account?", style: TextStyle(color: Colors.grey),),
                                // SizedBox(width: 10.0,),
                                TextButton(
                                  onPressed: () {
                                    Get.to(const SignUpScreen());
                                  },
                                  child: const Text("Register Here", style: TextStyle(color: Colors.purpleAccent,fontSize: 16)),
                                )
                                
                              ],
                            ),//don't have account button - buton
                            const Text("Or", style: TextStyle(color: Colors.grey,fontSize: 16)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Are you an Admin?", style: TextStyle(color: Colors.grey),),
                                // SizedBox(width: 10.0,),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text("Click Here", style: TextStyle(color: Colors.purpleAccent,fontSize: 16)),
                                )

                              ],
                            ),// are you admin - button
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
