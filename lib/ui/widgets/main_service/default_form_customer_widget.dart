import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/form_controller.dart';
import 'package:heroservices/ui/widgets/main_service/map_widget.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFormCustomerWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    InputDecoration decoration = InputDecoration(
      filled: true,
      fillColor: Color(0xffffffff),
      border: new OutlineInputBorder(
        borderRadius: new BorderRadius.circular(10.0),
        borderSide: BorderSide(),
      ),
    );

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20,),
          Text("Billing Information", style: TextStyle(fontSize: 20),),
          Text('Fillup form'),
          SizedBox(height: 20,),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    decoration: decoration.copyWith(labelText: 'Customer Name'),
                    onChanged: (val) {
                      Get.find<FormController>().addDefaultFieldValue('Customer Name', val);
                    },
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 25.0,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Complete Address', style: TextStyle(fontSize: 16),),
                      SizedBox(height: 10,),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        decoration: decoration.copyWith(labelText: 'Street'),
                        onChanged: (val) {
                          Get.find<FormController>().addDefaultFieldValue('Customer Street', val.toUpperCase());
                        },
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        decoration: decoration.copyWith(labelText: 'Barangay'),
                        onChanged: (val) {
                          Get.find<FormController>().addDefaultFieldValue('Customer Barangay', val.toUpperCase());
                        },
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        decoration: decoration.copyWith(labelText: 'City'),
                        onChanged: (val) {
                          Get.find<FormController>().addDefaultFieldValue('Customer City', val.toUpperCase());
                        },
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        decoration: decoration.copyWith(labelText: 'Province'),
                        onChanged: (val) {
                          Get.find<FormController>().addDefaultFieldValue('Customer Province', val.toUpperCase());
                        },
                        keyboardType: TextInputType.text,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          //! kIsWeb ? Flexible(child: MapWidget(),):SizedBox.shrink(),
          SizedBox(height: 100,),

        ],
      ),
    );
  }
}
