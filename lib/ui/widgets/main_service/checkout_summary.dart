import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/auth_controller.dart';
import 'package:heroservices/controllers/form_controller.dart';
import 'package:heroservices/controllers/main_service_controller.dart';
import 'package:heroservices/controllers/navigation_controller.dart';
import 'package:heroservices/models/main_service_model.dart';
import 'package:heroservices/services/booking_service.dart';
import 'package:heroservices/ui/views/booking_view.dart';
import 'package:heroservices/ui/widgets/shared/divider_shared_widget.dart';
import 'package:load/load.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class CheckoutSummary extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ServiceOptionModel serviceOption = Get.find<MainServiceController>().selectedServiceOption;
    Map<String, String> formValues = Get.find<FormController>().formValues;
    Map<String, String> defaultFormValues = Get.find<FormController>().defaultFormValues;
    List values = formValues.values.toList(growable: false);
    List keys = formValues.keys.toList(growable: false);

    String _address = defaultFormValues['Customer Street']
                      +', '+defaultFormValues['Customer Barangay']
                      +', '+defaultFormValues['Customer City']
                      +', '+defaultFormValues['Customer Province'];

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('BOOKING SUMMARY', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(serviceOption.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue),),
                      Text(DateFormat('yyyy.MM.dd | HH:mm a').format(DateTime.parse(defaultFormValues['Schedule'])).toString()),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(defaultFormValues['Total']+'.00 PHP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ],
              ),
              DividerSharedWidget(),
              ListTile(
                trailing: Text(defaultFormValues['Timeline'], style: TextStyle(fontWeight: FontWeight.bold),),
                title: Text("No. of "+defaultFormValues['Timeline Type'], style: TextStyle(fontSize: 13),),
              ),
              ListTile(
                trailing: Text(serviceOption.serviceType.toUpperCase()+' Basis', style: TextStyle(fontWeight: FontWeight.bold),),
                title: Text('Service Type', style: TextStyle(fontSize: 13),),
              ),
              DividerSharedWidget(),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: formValues.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    trailing: Text(values[i], style: TextStyle(fontWeight: FontWeight.bold),),
                    title: Text(keys[i], style: TextStyle(fontSize: 13),),
                  );
                },
              ),

              DividerSharedWidget(),

              Center(child: Text('CUSTOMER INFORMATION', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                child: Text('Name'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                child: Text(defaultFormValues['Customer Name'], style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                child: Text('Address'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                child: Text(_address, style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 10,),
              heroList(serviceOption, context),
              DividerSharedWidget(),
              submitButton(serviceOption, defaultFormValues, formValues),
            ],
          )
        ],
      ),
    );

  }

  Widget heroList(ServiceOptionModel serviceOption, context) {
    List heroes = Get.find<FormController>().formHeroes;
    Map<String, String> defaultFormValues = Get.find<FormController>().defaultFormValues;

    if(heroes.length>0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DividerSharedWidget(),
          Center(child: Text('HEROES', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),)),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: heroes.length,
            itemBuilder: (context, index) {
              HeroServiceModel heroService = heroes[index];
              return ListTile(
                title: Text(heroService.heroName),
                subtitle: Text(heroService.heroAddress),
                trailing: Text((defaultFormValues['Timeline Type']=='Hours' ? heroService.hourlyRate.toString() : heroService.dailyRate.toString())+'.00 PHP'),
              );
            },
          ),
        ],
      );
    }
    return SizedBox(height: 1,);
  }

  Widget submitButton(ServiceOptionModel serviceOption, Map<String, String> defaultFormValues, Map<String, String> formValues) {
    String _address = defaultFormValues['Customer Street']
        +', '+defaultFormValues['Customer Barangay']
        +', '+defaultFormValues['Customer City']
        +', '+defaultFormValues['Customer Province'];

    return Center(
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
        onPressed: () {
          showLoadingDialog();
          List heroes = Get.find<FormController>().formHeroes;
          var uuid = Uuid();
          String groupId = uuid.v4();

          switch(serviceOption.serviceType) {
            case'quotation':
              Get.find<NavigationController>().alert('Request Quotation', 'Please wait for heroes response');
              BookingService().bookService(
                groupId, //group_id
                serviceOption.serviceOptionId,
                serviceOption.name,
                serviceOption.multipleBooking,
                serviceOption.openPrice,

                '', //heroId
                '', //heroName
                '', //heroNumber
                '', //heroAddress
                '', //heroRate

                Get.find<AuthController>().user.uid,
                defaultFormValues['Customer Name'],
                _address,

                defaultFormValues['Schedule'],
                defaultFormValues['Timeline Type'],
                defaultFormValues['Timeline'],
                json.encode(formValues),

                '', //promo_code
                '', //promo_amount
                defaultFormValues['Total'], //total
                '', //tax

                'for_quotation', //quotation
              );

              break;
            default:
              Get.find<NavigationController>().alert('Booking successfully created', 'Please wait for heroes response');
              heroes.forEach((element) {
                HeroServiceModel hero = element;
                int rate = hero.dailyRate;
                if(defaultFormValues['Timeline Type']=='Hours') {
                  rate = hero.hourlyRate;
                }

                BookingService().bookService(
                  groupId, //group_id
                  serviceOption.serviceOptionId,
                  serviceOption.name,
                  serviceOption.multipleBooking,
                  serviceOption.openPrice,

                  hero.heroId, //heroId
                  hero.heroName, //heroFullname
                  hero.heroNumber, //heroCompleteAddress
                  hero.heroAddress, //heroCompleteAddress
                  rate.toString(), //heroRate

                  Get.find<AuthController>().user.uid,
                  defaultFormValues['Customer Name'],
                  _address,

                  defaultFormValues['Schedule'],
                  defaultFormValues['Timeline Type'],
                  defaultFormValues['Timeline'],
                  json.encode(formValues),

                  '', //promo_code
                  '', //promo_amount
                  (int.parse(defaultFormValues['Timeline']) * rate).toString(), //total
                  '', //tax

                  'for_confirmation', //quotation
                );
              });

              break;
          }
          Get.find<NavigationController>().setBottomNavCurrent(0);
          Get.offAll(BookingView());
          hideLoadingDialog();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          child: Text(serviceOption.serviceType=='quotation' ? 'Request a Quote':'Book Now', style: TextStyle(fontSize: 20),),
        ),
        color: Color(0xff13869F),
        textColor: Colors.white,
      ),
    );
  }
}
