import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/form_controller.dart';
import 'package:heroservices/controllers/main_service_controller.dart';
import 'package:heroservices/controllers/navigation_controller.dart';
import 'package:heroservices/models/main_service_model.dart';
import 'package:heroservices/ui/widgets/main_service/service_heroes_widget.dart';
import 'package:intl/intl.dart';

class DefaultFormScheduleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ServiceOptionModel serviceOption = Get.find<MainServiceController>().selectedServiceOption;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20,),
          Text("Schedule", style: TextStyle(fontSize: 20),),
          Text('Set a schedule'),
          SizedBox(height: 20,),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  DateTimeField(
                    format: DateFormat("yyyy.MM.dd | HH:mm a"),
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now().add(Duration(days: 1)),
                          initialDate: currentValue ?? DateTime.now().add(Duration(days: 1)),
                          lastDate: DateTime.now().add(Duration(days: 50)));
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.parse('2020-10-24 08:00')),
                        );
                        return DateTimeField.combine(date, time);
                      } else {
                        return currentValue;
                      }
                    },
                    decoration: new InputDecoration(
                      labelText: "Schedule",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                      //fillColor: Colors.green
                    ),
                    onChanged: (val) {
                      Get.find<FormController>().addDefaultFieldValue('Schedule', val.toString());
                    },
                  ),
                  SizedBox(height: 20.0,),
                  GetBuilder<FormController>(
                    builder: (formCtrl) => TextFormField(
                      decoration: new InputDecoration(
                        labelText:  "How many "+formCtrl.defaultFormValues['Timeline Type']+"?",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                      ),
                      onChanged: (timeline) {
                        //set_days_or_hours
                        if(timeline.isNotEmpty) {
                          if(num.tryParse(timeline) != null) {
                            if(int.parse(timeline) >= serviceOption.minTimeline
                                && int.parse(timeline) <= serviceOption.maxTimeline ) {
                              formCtrl.addDefaultFieldValue('Timeline', timeline);
                            } else {
                              formCtrl.addDefaultFieldValue('Timeline', '');
                              Get.find<NavigationController>()
                                  .alert('Validation',
                                  'Min:'+serviceOption.minTimeline.toString()+', Max:'+serviceOption.maxTimeline.toString());
                            }
                          } else {
                            Get.find<NavigationController>().alert('Validation', 'Please input a number');
                          }
                        }

                      },
                      keyboardType: TextInputType.number,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),

                  serviceOption.serviceType!='quotation'
                  ? Container(
                    child: GetBuilder<FormController>(
                      builder: (ctrl) => ListTile(
                        title: Center(child: Text(
                            ctrl.formHeroes.length>0
                            ? ctrl.defaultFormValues['Hero']+' • '+ctrl.defaultFormValues['Total']+'.00 PHP'
                            : serviceOption.multipleBooking
                                ? 'You can select multiple hero'
                                : 'Select your hero')),
                        subtitle: Center(child: Text('FIND A HERO')),
                        onTap: () {
                          print(Get.find<FormController>().formHeroes.length);
                          if(ctrl.defaultFormValues['Schedule']!='' && ctrl.defaultFormValues['Timeline']!='') {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Container(
                                        width: double.maxFinite,
                                        child: ServiceHeroesWidget()
                                    ),
                                  );
                                }
                            );
                          } else {
                            Get.find<NavigationController>().alert('Required fields', 'Set schedule and timeline first.');
                          }

                        },
                      ),
                    ),
                    decoration: BoxDecoration(
                        border: new Border(
                            bottom: new BorderSide(color: Colors.black26,)
                        )
                    ),
                  )
                  : SizedBox(height: 1,),
                  SizedBox(height: 15,),
                  !serviceOption.openPrice&&serviceOption.serviceType=='quotation'
                  ? GetBuilder<FormController>(
                    builder: (formCtrl) => TextFormField(
                      decoration: new InputDecoration(
                        labelText:  "Set Price",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                      ),
                      onChanged: (price) {
                        if(price.isNotEmpty) {
                          if(num.tryParse(price) != null) {
                            formCtrl.addDefaultFieldValue('Price', price);
                            formCtrl.addDefaultFieldValue('Total', price);
                          } else {
                            Get.find<NavigationController>().alert('Validation', 'Please input a number');
                          }
                        }

                      },
                      keyboardType: TextInputType.number,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                  )
                  : SizedBox(height: 1,),
                ],
              ),
            ),
          ),
          SizedBox(height: 80,),
        ],
      ),
    );
  }
}
