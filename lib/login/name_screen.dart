import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:notifications/appconstants/appconstants.dart';

class UserNameScreen extends StatefulWidget {
  const UserNameScreen({super.key});

  @override
  State<UserNameScreen> createState() => _UserNameTypeScreenState();
}

class _UserNameTypeScreenState extends State<UserNameScreen> {
  final TextEditingController _nameController = TextEditingController();

  bool isLoading = false;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  // Save name
  Future<void> saveName() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({'userName': _nameController.text.trim()});
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error during updating user name ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 100.h),
              Image.asset(
                'assets/login/userdetails.png',
                height: 260.h,
                width: 1.sw,
              ),
              Text(
                "Enter your name",
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 25.h),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: "Enter Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),

              SizedBox(height: 20.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onPressed: () async {
                  // await saveUserData();
                },
                child: Center(
                  child: isLoading
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 19.sp,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
