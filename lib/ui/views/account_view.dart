import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/auth_controller.dart';
import 'package:heroservices/controllers/user_controller.dart';
import 'package:heroservices/ui/widgets/account/account_login_widget.dart';
import 'package:heroservices/ui/widgets/account/account_widget.dart';

class AccountView extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return GetX(
      initState: (_) async {
        Get.put<UserController>(UserController());
      },
      builder: (_) {
        if (controller.user?.uid != null) {
          return AccountWidget();
        } else {
          return AccountLoginWidget();
        }
      },
    );
  }
}
