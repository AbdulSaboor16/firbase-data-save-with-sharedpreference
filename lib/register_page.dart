import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pratice/home_view.dart';
import 'package:pratice/login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("register"),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: "Enter your name",
                      labelText: "Enter your name")),
              TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: "Enter your password",
                      labelText: "Enter your password")),
              Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Get.to(const LoginPage());
                      },
                      child: const Text("sign up")),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text);

                          Get.offAll(LoginPage());
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text(
                                          "The password provided is too weak."),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Ok"))
                                      ],
                                    ));
                          } else if (e.code == 'email-already-in-use') {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(
                                    "The account already exists for that email."),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Ok"))
                                ],
                              ),
                            );
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: const Text("register")),
                ],
              )
            ],
          )),
    );
  }
}
