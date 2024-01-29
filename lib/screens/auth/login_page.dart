import 'dart:convert';
import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:poc_mobile_app/components/my_text_field.dart';
import 'package:poc_mobile_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _initializeLogin(String username) async {
    try {
      const url = '$baseUrl/logininitialise';
      final uri = Uri.parse(url);
      final response = await http.post(
        uri,
        headers: {
          "accept": "*/*",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"username": username}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        // Check if "didindex" key exists in the response
        if (responseBody.containsKey("didindex")) {
          final List<int> randomIndexes =
              (responseBody["didindex"] as List<dynamic>).cast<int>();

          _checkDeviceIdAndLogin(username, randomIndexes);
        } else {
          _showSnackbar("Invalid response format: 'didindex' key not found.");
        }
      } else {
        _showSnackbar(response.body);
      }
    } catch (e) {
      _showSnackbar(e.toString());
    }
  }

  Future<String?> _getDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id;
    }
    return null;
  }

  Future<void> _checkDeviceIdAndLogin(
      String username, List<int> randomIndexes) async {
    final String? deviceId = await _getDeviceId();
    debugPrint('randomIndex inside _checkDeviceIdAndLogin  = $randomIndexes');

    if (deviceId != null) {
      final int deviceIndex = deviceId.hashCode % 5;

      if (randomIndexes.contains(deviceIndex)) {
        // Apply random index generation and masking here
        List<String> maskedValues = [];
        for (int i = 0; i < 5; i++) {
          maskedValues.add(_maskValue(deviceId[i], randomIndexes[i]));
        }

        // Modify the _userLogin method to pass the masked values
        _userLogin(username, maskedValues);
      } else {
        _showSnackbar(
            "Device ID mismatch. Please login from the registered device.");
      }
    } else {
      _showSnackbar("Failed to retrieve device ID. Please try again.");
    }
  }

  String _maskValue(String value, int randomIndex) {
    // Mask the value with 'X' characters based on the random index
    String maskPart = 'X' * randomIndex;
    return maskPart + value.substring(randomIndex);
  }

  Future<void> _userLogin(String username, List<String> maskedValues) async {
    final body = {
      "username": username,
      "password": passwordController.text,
      "email": null,
      "deviceId": maskedValues,
    };

    try {
      const url = '$baseUrl/userlogin';
      final uri = Uri.parse(url);
      final response = await http.post(
        uri,
        headers: {
          "accept": "*/*",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        saveLoginStatus();
        Navigator.pushNamed(context, '/home_page');
      } else {
        _showSnackbar(response.body);
      }
    } catch (e) {
      _showSnackbar(e.toString());
    }
  }

  Future<void> saveLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
  }

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
                const SizedBox(height: 25.0),
                const Icon(
                  Icons.lock,
                  size: 70,
                ),
                const SizedBox(height: 25.0),
                Text(
                  "Welcome back! You've been missed!",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25.0),
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
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Forgot Password?",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25.0),
                GestureDetector(
                  onTap: () => _initializeLogin(userNameController.text),
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Sign In",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Not a member?"),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register now",
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
