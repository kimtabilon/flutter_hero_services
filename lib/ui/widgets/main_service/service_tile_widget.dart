import 'package:flutter/material.dart';
import 'package:heroservices/controllers/main_service_controller.dart';
import 'package:heroservices/models/main_service_model.dart';
import 'package:get/get.dart';
import 'package:heroservices/ui/views/service_option_view.dart';

class ServiceTileWidget extends StatelessWidget {
  final ServiceModel service;

  ServiceTileWidget({this.service});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.put<MainServiceController>(MainServiceController())
            .setSelectedService(service);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Container(
                  width: double.maxFinite,
                  child: ServiceOptionView()
                ),
              );
            }
        );
      },
      child: ListTile(
        title: Text(service.name),
        subtitle: Text(service.description),
        leading: Icon(IconData(service.icon, fontFamily: 'MaterialIcons')),
      ),
    );
  }
}
