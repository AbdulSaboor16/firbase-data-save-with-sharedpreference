import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isLoggedIn = false.obs;
  RxString name = ''.obs;
  RxString password = "".obs;

  @override
  void onInit() {
    super.onInit();
    autoLogIn();
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('username');
    final String? userIds = prefs.getString('pass');

    if (userId != null) {
      isLoggedIn.value = true;
      name.value = userId;
    }
    if (userIds != null) {
      isLoggedIn.value = true;
      password.value = userIds;
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username');

    name.value = '';
    isLoggedIn.value = false;

    password.value = '';
    isLoggedIn.value = false;
  }

  Future<void> loginUser() async {
    if (nameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your name and password');
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', nameController.text);
      prefs.setString('pass', passwordController.text);

      name.value = nameController.text;
      isLoggedIn.value = true;
      nameController.clear();
      password.value = passwordController.text;
      isLoggedIn.value = true;
      passwordController.clear();
    }
  }
}
