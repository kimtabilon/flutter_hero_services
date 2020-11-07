import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/auth_controller.dart';
import 'package:heroservices/controllers/navigation_controller.dart';
import 'package:load/load.dart';

class AccountSignupWidget extends GetWidget<AuthController> {
  final TextEditingController fnameCtrl = TextEditingController();
  final TextEditingController lnameCtrl = TextEditingController();
  final TextEditingController mobileCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController cpasswordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Create an account!', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
          Text('And start hiring Heroes.', style: TextStyle(fontSize: 20),),
          SizedBox(height: 20,),
          TextFormField(
            decoration: InputDecoration(labelText: 'First Name'),
            controller: fnameCtrl,
          ),
          SizedBox(height: 10,),
          TextFormField(
            decoration: InputDecoration(labelText: 'Last Name'),
            controller: lnameCtrl,
          ),
          SizedBox(height: 10,),
          TextFormField(
            decoration: InputDecoration(labelText: 'Mobile Number'),
            controller: mobileCtrl,
          ),
          SizedBox(height: 50,),
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            controller: emailCtrl,
          ),
          SizedBox(height: 10,),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            controller: passwordCtrl,
            obscureText: true,
          ),
          SizedBox(height: 10,),
          TextFormField(
            decoration: InputDecoration(labelText: 'Confirm Password'),
            controller: cpasswordCtrl,
            obscureText: true,
          ),
          SizedBox(height: 40,),
          MaterialButton(
            onPressed: () {
              showLoadingDialog();
              if(passwordCtrl.text != cpasswordCtrl.text) {
                Get.find<NavigationController>().alert('Validation', 'Confirm password do not matched.');
              } else if(fnameCtrl.text == '' || lnameCtrl.text == '' || mobileCtrl.text == '') {
                Get.find<NavigationController>().alert('Required field', 'Firstname, Lastname, Mobile Number');
              } else {
                Get.find<AuthController>().createUser(
                  fnameCtrl.text,
                  lnameCtrl.text,
                  mobileCtrl.text,
                  emailCtrl.text,
                  passwordCtrl.text,
                  cpasswordCtrl.text,
                );
                if(Get.find<AuthController>().user != null) {
                  Get.back();
                }
              }
              hideLoadingDialog();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('SIGN UP', style: TextStyle(fontSize: 20, color: Colors.white, letterSpacing: 5),),
            ),
            color: Color(0xff13869F),
            minWidth: double.infinity,
          ),
          SizedBox(height: 10,),
          Center(
            child: RawMaterialButton(
              onPressed: () {
                Get.back();
              },
              child: Text('CLOSE'),
            ),
          ),
        ],
      ),
    );
  }
}
