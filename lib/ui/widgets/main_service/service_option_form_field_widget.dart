import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/form_controller.dart';
import 'package:heroservices/models/main_service_model.dart';
import 'package:heroservices/ui/widgets/main_service/fields/multi_select_chip_field_widget.dart';

class ServiceOptionFormFieldWidget extends StatelessWidget {
  final ServiceOptionFormFieldModel serviceOptionFormField;

  ServiceOptionFormFieldWidget({this.serviceOptionFormField});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<FormController>(
      builder: (ctrl) {

        switch(serviceOptionFormField.type) {
          case 'SingleSelect':
            return ListTile(
                title: Center(child: Text(ctrl.formValues[serviceOptionFormField.label])),
                subtitle: Center(child: Text(serviceOptionFormField.label)),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    int index=0;
                    String currentValue = ctrl.formValues[serviceOptionFormField.label];
                    if(currentValue!='') {
                      index = serviceOptionFormField.values.indexOf(currentValue) + 1;
                    }
                    if(index < serviceOptionFormField.values.length) {
                      ctrl.addFieldValue(
                          serviceOptionFormField.label,
                          serviceOptionFormField.values[index]
                      );
                    }

                  },
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    int index=0;
                    String currentValue = ctrl.formValues[serviceOptionFormField.label];
                    if(currentValue!='') {
                      index = serviceOptionFormField.values.indexOf(currentValue) - 1;
                    }
                    if(index >= 0) {
                      ctrl.addFieldValue(
                          serviceOptionFormField.label,
                          serviceOptionFormField.values[index]
                      );
                    }
                  },
                ),
            );
            break;

          case 'MultiSelect':
            return ListTile(
              title: Center(child: Text(ctrl.formValues[serviceOptionFormField.label])),
              subtitle: Center(child: Text(serviceOptionFormField.label)),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      //Here we will build the content of the dialog
                      return AlertDialog(
                        title: Text(serviceOptionFormField.label),
                        content: MultiSelectChipFieldWidget(
                            serviceOptionFormField.values,
                            serviceOptionFormField.label
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("DONE"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    });
              },
            );
            break;

          default:
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextFormField(
                decoration: new InputDecoration(
                  labelText: serviceOptionFormField.label,
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),
                onChanged: (val) {
                  Get.find<FormController>().addFieldValue(serviceOptionFormField.label, val);
                },
                //keyboardType: TextInputType.emailAddress,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
            );
            break;
        }

      },
    );



  }
}
