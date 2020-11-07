import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/auth_controller.dart';
import 'package:heroservices/controllers/form_controller.dart';
import 'package:heroservices/controllers/main_service_controller.dart';
import 'package:heroservices/controllers/navigation_controller.dart';
import 'package:heroservices/models/main_service_model.dart';
import 'package:heroservices/ui/views/service_option_form_view.dart';

class ServiceOptionSmartButton extends GetWidget<AuthController> {
  final ServiceOptionModel serviceOption;
  ServiceOptionSmartButton({this.serviceOption});
  @override
  Widget build(BuildContext context) {
    if(controller.user?.uid != null) {

    }
    switch(serviceOption.serviceType) {
      case'quotation':
        return MaterialButton(
          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
          onPressed: () {
            Get.put<FormController>(FormController()).resetForm(serviceOption);
            if(controller.user?.uid != null) {
              Get.put<MainServiceController>(MainServiceController())
                  .setSelectedServiceOption(serviceOption);
              Get.to(ServiceOptionFormView());
            } else {
              Get.find<NavigationController>().alert('Required Login', 'Please login or create new account to proceed');
            }
          },
          child: Text('REQUEST QUOTE', style: TextStyle(color: Colors.white),),
          color: Color(0xff13869F),
        );
        break;
      default:
        return MaterialButton(
          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
          onPressed: () {
            Get.put<FormController>(FormController()).resetForm(serviceOption);
            if(controller.user?.uid != null) {
              Get.put<MainServiceController>(MainServiceController())
                  .setSelectedServiceOption(serviceOption);

              Get.to(ServiceOptionFormView());
            } else {
              Get.find<NavigationController>().alert('Required Login', 'Please login or create new account to proceed');
            }
          },
          child: Text('BOOK NOW', style: TextStyle(color: Colors.white),),
          color: Color(0xff13869F),
        );
        break;
    }

  }
}
