import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poc_mobile_app/components/my_text_field.dart';
import 'package:poc_mobile_app/constants.dart';
import 'package:http/http.dart' as http;

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final emailOtpController = TextEditingController();
  final phoneOtpController = TextEditingController();
  final phoneFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> verifyOtpHandler() async {
    final body = {
      "emailOtp": emailOtpController.text,
      "phoneOtp": phoneOtpController.text,
    };

    print(body);

    try {
      const url = '$baseUrl/VerifyOtp';
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
        Navigator.pushReplacementNamed(context, '/home_page');
      } else {
        _showSnackbar(response.body);
      }
    } catch (e) {
      _showSnackbar(e.toString());
    }
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
                const Text(
                  "OTP Verification!",
                  style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Play",
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //form one
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Verify your Email address.",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Play",
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Please verify your email address by entering the OTP send to your registered email.",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        MyTextField(
                          controller: emailOtpController,
                          hintText: "Enter OTP",
                          obscureText: false,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),

                    //form two
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Verify your Phone number.",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Play",
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Please verify your phone number by entering the OTP send to you via SMS!!",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        MyTextField(
                          controller: phoneOtpController,
                          hintText: "Enter OTP",
                          obscureText: false,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),

                    GestureDetector(
                      onTap: verifyOtpHandler,
                      child: Container(
                        padding: const EdgeInsets.all(22),
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Verify",
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
