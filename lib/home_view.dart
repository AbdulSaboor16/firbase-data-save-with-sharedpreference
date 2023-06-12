import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pratice/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> clearSharedPreferences() async {
    isLoading.value = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    isLoading.value = false;

    Get.to(const LoginPage());
  }
}

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        // automaticallyImplyLeading: false,
        title: const Text('Home'),
      ),

      drawer: Drawer(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              if (!controller.isLoading.value) {
                controller.clearSharedPreferences();
              }
            },
            child: Obx(() => controller.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Logout Page")),
          ),
        ),
      ),
      body: Center(
        child: Text("welcome to home screen"),
      ),
      // body: Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       if (!controller.isLoading.value) {
      //         controller.clearSharedPreferences();
      //       }
      //     },
      //     child: Obx(() => controller.isLoading.value
      //         ? const CircularProgressIndicator(color: Colors.white)
      //         : const Text("Logout Page")),
      //   ),
      // ),
    );
  }
}
