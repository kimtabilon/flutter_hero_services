import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/auth_controller.dart';
import 'package:heroservices/ui/widgets/account/account_reset_password_widget.dart';
import 'package:heroservices/ui/widgets/account/account_signup_widget.dart';
import 'package:heroservices/ui/widgets/shared/bottom_navigation_shared_widget.dart';
import 'package:load/load.dart';

class AccountLoginWidget extends GetWidget<AuthController> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SIGN IN', style: TextStyle(letterSpacing: 5),), centerTitle: true,),
      bottomNavigationBar: BottomNavigationSharedWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Login to your account!', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              Text('And start hiring Heroes.', style: TextStyle(fontSize: 20),),
              SizedBox(height: 40,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                ),
                controller: emailCtrl,
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                ),
                controller: passwordCtrl,
                obscureText: true,
              ),
              FlatButton(
                onPressed: () {
                  Get.to(AccountResetPasswordWidget());
                },
                child: Text(
                  "Reset Password",
                ),
              ),
              SizedBox(height: 20,),
              MaterialButton(
                onPressed: () {
                  showLoadingDialog();
                  controller.login(emailCtrl.text, passwordCtrl.text);
                  hideLoadingDialog();
                },
                color: Color(0xff13869F),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('LOGIN', style: TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 5),),
                ),
                minWidth: double.infinity,
              ),
              SizedBox(height: 20,),
              OutlineButton(
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Container(width: double.maxFinite, child: AccountSignupWidget()),
                        );
                      }
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('CREATE ACCOUNT', style: TextStyle(color: Color(0xff13869F), fontSize: 15),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
