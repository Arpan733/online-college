import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_college/providers/sign_in_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneNumberController = TextEditingController();
  final otpController = TextEditingController();

  bool showSendOTP = false;
  bool showTimer = false;

  Timer? t;
  int seconds = 60;

  @override
  void dispose() {
    phoneNumberController.dispose();
    otpController.dispose();
    showSendOTP = false;
    showTimer = false;
    t?.cancel();
    seconds = 60;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
            ),
          ),
          child: Stack(
            children: [
              Consumer<SignInProvider>(
                builder: (context, signIn, _) => Column(
                  children: [
                    Container(
                      height: 250,
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 1,
                        padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello,',
                              style: GoogleFonts.rubik(
                                color: Colors.black54,
                                fontSize: 34,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Login to Continue',
                              style: GoogleFonts.rubik(
                                color: Colors.black54,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            TextFormField(
                              controller: phoneNumberController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value?.length != 10) {
                                  return 'Phone number should be 10 digit';
                                }

                                return null;
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              onChanged: (value) {
                                if (value.length == 10) {
                                  setState(() {
                                    showSendOTP = true;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.phone_outlined,
                                  color: Colors.black87,
                                  size: 25,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    if (!signIn.isLoading &&
                                        showSendOTP &&
                                        phoneNumberController.text.length == 10) {
                                      signIn.getOTP(
                                          context: context,
                                          phoneNumber: phoneNumberController.text);

                                      setState(() {
                                        showTimer = true;
                                      });

                                      FocusScope.of(context).unfocus();

                                      t = Timer.periodic(
                                        const Duration(seconds: 1),
                                        (timer) {
                                          setState(() {
                                            if (seconds > 0) {
                                              seconds--;
                                              showSendOTP = false;
                                            } else {
                                              if (mounted) {
                                                t?.cancel();
                                              }
                                              seconds = 60;
                                              showSendOTP = true;
                                            }
                                          });
                                        },
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    Icons.send_to_mobile_outlined,
                                    color: showSendOTP ? Colors.black87 : Colors.black38,
                                    size: 25,
                                  ),
                                ),
                                labelText: 'Mobile No',
                                labelStyle: GoogleFonts.rubik(
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                                hintText: 'Mobile No',
                                hintStyle: GoogleFonts.rubik(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                              ),
                              style: GoogleFonts.rubik(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                            showTimer
                                ? SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text(
                                      '00:${seconds < 10 ? '0$seconds' : '$seconds'}',
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.rubik(
                                        color: Colors.black87,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                : const SizedBox(
                                    height: 10,
                                  ),
                            TextFormField(
                              controller: otpController,
                              enabled: signIn.enableOTPField,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                              validator: (value) {
                                if (value?.length != 6) {
                                  return 'OTP should be 6 digit';
                                }

                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.password_outlined,
                                  color: signIn.enableOTPField ? Colors.black87 : Colors.black54,
                                  size: 25,
                                ),
                                labelText: 'OTP',
                                labelStyle: GoogleFonts.rubik(
                                  color: signIn.enableOTPField ? Colors.black87 : Colors.black54,
                                  fontSize: 16,
                                ),
                                hintText: 'OTP',
                                hintStyle: GoogleFonts.rubik(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                              ),
                              style: GoogleFonts.rubik(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (otpController.text.length == 6) {
                                    signIn.checkOTP(context: context, smsCode: otpController.text);
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF2855AE), Color(0xFF7292CF)],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                  ),
                                  child: signIn.isLoginLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            value: 20,
                                          ),
                                        )
                                      : Row(
                                          children: [
                                            const SizedBox(
                                              width: 35,
                                            ),
                                            Expanded(
                                              child: Text(
                                                'Sign In',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.rubik(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            const Icon(
                                              Icons.arrow_forward_outlined,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 75,
                left: (MediaQuery.of(context).size.width * 0.5) - 160,
                width: 300,
                height: 300,
                child: Hero(
                  tag: 'student 1',
                  child: Image.asset('assets/images/student 1.png'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
