import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notifications/Agora/agora_home_screen.dart';
import 'package:notifications/appconstants/appconstants.dart';
import 'package:notifications/provider/user_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyOtpScreen extends ConsumerStatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

  // @override
  // void dispose() {
  //   _otpController.dispose();
  //   super.dispose();
  // }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 130.h),
                Image.asset(
                  'assets/login/verifyOTP.png',
                  height: 280.h,
                  width: 1.sw,
                ),
                Text(
                  "Enter valid 6 digit otp to verify",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20.h),
                PinCodeTextField(
                  controller: _otpController,
                  keyboardType: TextInputType.phone,
                  appContext: context,
                  length: 6,
                  cursorColor: Colors.black,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    fieldHeight: 50.h,
                    fieldWidth: 45.w,
                    borderRadius: BorderRadius.circular(10.r),
                    activeColor: AppConstants.primaryColor,
                    selectedColor: AppConstants.primaryColor,
                    inactiveColor: Colors.grey,
                  ),
                  validator: (value) {
                    if (value == null || value.length != 6) {
                      return "Enter valid 6 digit OTP";
                    }
                    return null;
                  },
                  enablePinAutofill: true,
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () async {
                    // Verify OTP
                    if (_key.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      final otp = _otpController.text.trim();
                      final verifyOTPProvider = ref.read(
                        authRepositoryProvider,
                      );
                      if (!mounted) return;
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await verifyOTPProvider.verifyOTP(otp);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => AgoraHomeScreen()),
                        );
                      } catch (e) {
                        if (!mounted) return;
                        setState(() {
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Error: $e")));
                      }
                    }
                  },
                  child: Center(
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Verify OTP",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19.sp,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
