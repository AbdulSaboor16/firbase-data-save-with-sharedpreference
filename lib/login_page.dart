import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pratice/home_view.dart';
import 'package:pratice/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return SafeArea(
      child: Scaffold(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () async {
                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);

                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('email', emailController.text);
                    prefs
                        .setString('password', passwordController.text)
                        .then((value) => Get.offAll(HomeView()));
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) => AlertDialog(
                                title:
                                    Text("The password provided is too weak."),
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
                child: const Text("login"),
              ),
              ElevatedButton(
                onPressed: () {
                  Get.to(const RegisterPage());
                },
                child: const Text("Register"),
              )
            ],
          )
        ],
      )),
    );
  }
}
