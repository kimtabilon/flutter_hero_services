import 'package:flutter/material.dart';
import 'package:heroservices/controllers/main_service_controller.dart';
import 'package:heroservices/models/main_service_model.dart';
import 'package:get/get.dart';
import 'package:heroservices/ui/views/service_view.dart';

class ServiceCategoryTileWidget extends StatelessWidget {
  final ServiceCategoryModel serviceCategory;

  ServiceCategoryTileWidget({this.serviceCategory});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.put<MainServiceController>(MainServiceController())
            .setSelectedServiceCategory(serviceCategory);
        Get.bottomSheet(BottomSheet(
            onClosing: () {},
            builder: (context) {
              return ServiceView();
            }));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(IconData(serviceCategory.icon, fontFamily: 'MaterialIcons'), size: 50.0,),
                  ),
                  Flexible(child: Text(serviceCategory.name, textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87,),))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(serviceCategory.description, textAlign: TextAlign.right,),
              ),
            ],
          ),
        ),
        /*child: ListTile(
          title: Text(serviceCategory.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),),
          subtitle: Text(serviceCategory.description, ),
          leading: Icon(IconData(serviceCategory.icon, fontFamily: 'MaterialIcons'), size: 50.0,),

        ),*/
      ),
    );
  }
}


