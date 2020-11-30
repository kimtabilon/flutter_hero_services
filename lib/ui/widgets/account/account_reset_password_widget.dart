import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/auth_controller.dart';
import 'package:heroservices/ui/widgets/shared/bottom_navigation_shared_widget.dart';
import 'package:load/load.dart';

class AccountResetPasswordWidget extends GetWidget<AuthController> {
  final TextEditingController emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RESET PASSWORD',), centerTitle: true,),
      bottomNavigationBar: BottomNavigationSharedWidget(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                ),
                controller: emailCtrl,
              ),
              SizedBox(height: 40,),
              MaterialButton(
                onPressed: () {
                  showLoadingDialog();
                  controller.resetPassword(emailCtrl.text);
                  emailCtrl.clear();
                  hideLoadingDialog();
                },
                color: Color(0xff13869F),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('SEND REQUEST', style: TextStyle(color: Colors.white, fontSize: 20,),),
                ),
                minWidth: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
