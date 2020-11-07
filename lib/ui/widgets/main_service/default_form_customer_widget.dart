import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/form_controller.dart';

class DefaultFormCustomerWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20,),
          Text("Customer Information", style: TextStyle(fontSize: 20),),
          Text('Fillup form'),
          SizedBox(height: 20,),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  TextFormField(
                    decoration: new InputDecoration(
                      labelText: "Enter Fullname",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                      //fillColor: Colors.green
                    ),
                    onChanged: (val) {
                      Get.find<FormController>().addDefaultFieldValue('Customer Name', val);
                    },
                    keyboardType: TextInputType.text,
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  TextFormField(
                    decoration: new InputDecoration(
                      labelText: "Complete Address",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                      //fillColor: Colors.green
                    ),
                    onChanged: (val) {
                      Get.find<FormController>().addDefaultFieldValue('Customer Address', val);
                    },
                    keyboardType: TextInputType.text,
                    maxLines: 4,
                    maxLength: 1000,
                    style: new TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
