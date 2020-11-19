import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/models/main_service_model.dart';
import 'package:heroservices/ui/widgets/main_service/smart_buttons/service_option_smart_button.dart';
import 'package:heroservices/ui/widgets/shared/divider_shared_widget.dart';

class ServiceOptionTileWidget extends StatelessWidget {
  final ServiceOptionModel serviceOption;

  ServiceOptionTileWidget({this.serviceOption});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(serviceOption.name),
      subtitle: Text(serviceOption.description),
      leading: Icon(IconData(serviceOption.icon, fontFamily: 'MaterialIcons')),
      children: [
        Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 68, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Service Type • '+serviceOption.serviceType.toUpperCase()+' BASIS', style: TextStyle(fontSize: 14),),

                serviceOption.serviceType=='timeline'
                    ?Text('Switch Timeline • You can switch hours or days.', style: TextStyle(fontSize: 14),)
                    :SizedBox.shrink(),

                Text('Booking Type • '+(serviceOption.multipleBooking?'Multiple Booking':'Single Booking'), style: TextStyle(fontSize: 14),),

                serviceOption.serviceType=='quotation'
                    ?Text('Pricing • '+(serviceOption.openPrice?'Open Price. Hero will set price.':'You can set price for quotation.'), style: TextStyle(fontSize: 14),)
                    :SizedBox.shrink(),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlineButton(
                onPressed: () {
                  Get.bottomSheet(BottomSheet(
                      onClosing: () {},
                      builder: (context) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Text(serviceOption.name, style: TextStyle(fontSize: 18),),
                                DividerSharedWidget(),
                                Text(serviceOption.inclusions, style: TextStyle(fontSize: 16),),
                              ],
                            ),
                          ),
                        );
                      }));
                },
                child: Text('INCLUSIONS'),
              ),
              SizedBox(width: 10,),
              ServiceOptionSmartButton(serviceOption: serviceOption,),
            ],
          ),
        ),
        //Center(child: ServiceOptionSmartButton(serviceOption: serviceOption,)),
        SizedBox(height: 10,),
      ],
    );
  }
}
