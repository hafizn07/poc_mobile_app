import 'dart:io';
import 'package:flutter/material.dart';
import 'package:poc_mobile_app/components/my_text_field.dart';
import 'package:poc_mobile_app/constants.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editing controllers
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneNumberController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> submitData() async {
    String? deviceId = await _getId();
    final body = {
      "username": userNameController.text,
      "password": passwordController.text,
      "phoneNumber": phoneNumberController.text,
      "email": emailController.text,
      "device_id": deviceId,
    };

    debugPrint('Body : $body');
    debugPrint('Device ID is : $deviceId');

    // try {
    //   const url = '$baseUrl/Register';
    //   final uri = Uri.parse(url);

    //   final response = await http.post(
    //     uri,
    //     headers: {
    //       "accept": "*/*",
    //       "Content-Type": "application/json",
    //     },
    //     body: jsonEncode(body),
    //   );

    //   if (response.statusCode == 200) {
    //     // saveRegisterStatus();
    //     Navigator.pushNamed(context, '/otp_verify_page');
    //     _showSnackbar(response.body);
    //   } else {
    //     _showSnackbar(response.body);
    //   }
    // } catch (e) {
    //   _showSnackbar("Failed to register!");
    // }
  }

  // Future<void> saveRegisterStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('isLoggedIn', true);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                const Icon(
                  Icons.lock,
                  size: 70,
                ),

                const SizedBox(height: 25.0),
                //welcome text
                Text(
                  "Let's create an account for you!",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25.0),
                //TextFields
                MyTextField(
                  controller: emailController,
                  hintText: "Email Address",
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.mail_outline,
                ),

                const SizedBox(height: 10.0),
                MyTextField(
                  controller: userNameController,
                  hintText: "Username",
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  icon: Icons.account_circle_outlined,
                ),

                const SizedBox(height: 10.0),
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  icon: Icons.lock_outline,
                ),

                const SizedBox(height: 10.0),
                MyTextField(
                  controller: phoneNumberController,
                  hintText: "Phone Number",
                  obscureText: false,
                  keyboardType: TextInputType.phone,
                  icon: Icons.phone,
                ),

                const SizedBox(height: 25.0),
                //signUp button
                GestureDetector(
                  onTap: submitData,
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.grey.shade200,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),
                //have ac? login now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade900,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
