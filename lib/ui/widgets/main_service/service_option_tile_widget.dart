import 'package:flutter/material.dart';
import 'package:heroservices/models/main_service_model.dart';
import 'package:heroservices/ui/widgets/main_service/smart_buttons/service_option_smart_button.dart';

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
        Center(child: ServiceOptionSmartButton(serviceOption: serviceOption,)),
        SizedBox(height: 10,),
      ],
    );
  }
}
