import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/form_controller.dart';
import 'package:heroservices/controllers/main_service_controller.dart';
import 'package:heroservices/models/booking_model.dart';
import 'package:heroservices/models/main_service_model.dart';
import 'package:heroservices/services/booking_service.dart';
import 'package:heroservices/ui/widgets/shared/rating_widget.dart';
import 'package:heroservices/ui/widgets/shared/three_bounce_spinkit_shared_widget.dart';
import 'package:intl/intl.dart';

class HeroesSmartTile extends StatelessWidget {
  final HeroServiceModel heroService;

  HeroesSmartTile({this.heroService});

  @override
  Widget build(BuildContext context) {
    ServiceOptionModel serviceOption = Get.find<MainServiceController>().selectedServiceOption;
    Map<String, String> defaultFormValues = Get.find<FormController>().defaultFormValues;
    int rate = heroService.dailyRate;
    if(defaultFormValues['Timeline Type']=='Hours') {
      rate = heroService.hourlyRate;
    }
    return GetBuilder<FormController>(
      builder: (formCtrl) => ExpansionTile(
        title: Text(heroService.heroName, style: TextStyle(color: Color(0xff333333)),),
        subtitle: RatingWidget(),
        trailing: Text((rate * int.parse(formCtrl.defaultFormValues['Timeline'])).toString()+'.00 PHP'),
        leading: CircleAvatar(
          radius: 18,
          child: ClipOval(
            child: Image.network(
              heroService.heroPhoto,
            ),
          ),
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        initiallyExpanded: formCtrl.isHeroExpanded[heroService.heroId],
        onExpansionChanged: (_isOpen) {
          formCtrl.expandHeroTile(heroService.heroId, _isOpen);
          if(_isOpen) {
            formCtrl.setHeroLoading(heroService.heroId, true);
            //print(formCtrl.isHeroLoading.toString());
            BookingService(
                serviceOptionId: heroService.serviceOptionId,
                heroId: heroService.heroId
            )
                .heroBookings
                .listen((documents) {
              if(documents.length>0) {
                List bookingSchedules = List();
                //print('--------------------');
                //set booking schedules per hero
                for(var i=0; i<documents.length; i++) {
                  BookingModel booking = documents[i];
                  if(booking.timelineType=='Days') {
                    for(var d=0; d<int.parse(booking.timeline); d++) {
                      //print('booked dates : '+DateTime.parse(booking.schedule).add(Duration(days: d)).toString());
                      bookingSchedules.add(DateFormat('yyyy-MM-dd').format(DateTime.parse(booking.schedule).add(Duration(days: d))).toString());
                    }
                  } else {
                    bookingSchedules.add(DateFormat('yyyy-MM-dd').format(DateTime.parse(booking.schedule)).toString());
                  }
                }

                //check booking schedule if available
                if(defaultFormValues['Timeline Type']=='Days') {
                  for(var sc=0; sc<int.parse(defaultFormValues['Timeline']); sc++) {
                    //print('currentScheds per day : '+DateTime.parse(defaultFormValues['Schedule']).add(Duration(days: sc)).toString());
                    if(bookingSchedules.contains(DateFormat('yyyy-MM-dd').format(DateTime.parse(defaultFormValues['Schedule']).add(Duration(days: sc))).toString())) {
                      formCtrl.setHeroAvailable(heroService.heroId, false);
                    }
                  }
                } else {
                  if(bookingSchedules.contains(DateFormat('yyyy-MM-dd').format(DateTime.parse(defaultFormValues['Schedule'])).toString())) {
                    formCtrl.setHeroAvailable(heroService.heroId, false);
                  }
                }

              } else {
                formCtrl.setHeroLoading(heroService.heroId, false);
                formCtrl.setHeroAvailable(heroService.heroId, true);
              }
            });
          }
          formCtrl.setHeroLoading(heroService.heroId, false);
        },
        children: [
          SizedBox(height: 10,),
          formCtrl.isHeroLoading[heroService.heroId]
          ? SpinkitSharedWidget(type: 'ThreeBounce',)
          : Table(
            border: TableBorder.symmetric(outside: BorderSide(width: 0.4, color: Colors.grey[500])),
            children: [
              TableRow(children: [
                TableCell(child: Padding(padding: const EdgeInsets.all(8.0), child: Text('Address'))),
                TableCell(child: Padding(padding: const EdgeInsets.all(8.0), child: Text(heroService.heroAddress))),
              ]),
              TableRow(children: [
                TableCell(child: Padding(padding: const EdgeInsets.all(8.0), child: Text(serviceOption.serviceType.capitalizeFirst + ' Rate'))),
                TableCell(child: Padding(padding: const EdgeInsets.all(8.0), child: Text(rate.toString()+'.00 PHP'))),
              ]),
              TableRow(children: [
                TableCell(child: Padding(padding: const EdgeInsets.all(8.0), child: Text('Experience'))),
                TableCell(child: Padding(padding: const EdgeInsets.all(8.0), child: Text(heroService.heroExperience))),
              ]),
              TableRow( children: [
                TableCell(child: Padding(padding: const EdgeInsets.all(8.0), child: Text('Certification'))),
                TableCell(child: Padding(padding: const EdgeInsets.all(8.0), child: Text(heroService.heroCertification))),
              ]),
              TableRow( children: [
                TableCell(child: Padding(padding: const EdgeInsets.all(8.0), child: Text('Rate for this job'))),
                TableCell(child: Padding(padding: const EdgeInsets.all(8.0), child: Text(heroService.heroRate))),
              ]),

            ],
          ),
          SizedBox(height: 10,),
          chooseHeroButton(formCtrl.isHeroAvailable[heroService.heroId], formCtrl.formHeroes),
          SizedBox(height: 15,),
        ],
      ),
    );
  }

  Widget chooseHeroButton(bool availability, List formHeroes) {
    ServiceOptionModel serviceOption = Get.find<MainServiceController>().selectedServiceOption;
    if(availability) {

      if(formHeroes.length>0) {
        bool existHero = false;
        int heroIndex;
        for(var i=0; i<formHeroes.length; i++) {
          HeroServiceModel hs = formHeroes[i];
          if(hs.heroId == heroService.heroId) {
            existHero = true;
            heroIndex=i;
          }
        }
        if(existHero) {
          return Center(
            child: GetBuilder<FormController>(
              builder: (ctrl) => OutlineButton(
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
                onPressed: () {
                  /*ctrl.addDefaultFieldValue('heroId', '');
                  ctrl.addDefaultFieldValue('Hero Name', '');
                  ctrl.addDefaultFieldValue('Hero Address', '');
                  ctrl.addDefaultFieldValue('Hero Rate', '');*/
                  Get.find<FormController>().removeFormHeroes(heroIndex);
                  /*ctrl.addDefaultFieldValue('Hero', '');
                  ctrl.addDefaultFieldValue('Total', '0');*/
                  //Get.back();
                },
                child: Text('Cancel Selection',),
              ),
            ),
          );
        }

        if(serviceOption.multipleBooking) {
          return Center(
            child: GetBuilder<FormController>(
              builder: (ctrl) => MaterialButton(
                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
                onPressed: () {
                  /*ctrl.addDefaultFieldValue('heroId', heroService.heroId);
                ctrl.addDefaultFieldValue('Hero Name', heroService.heroName);
                ctrl.addDefaultFieldValue('Hero Address', heroService.heroAddress);
                ctrl.addDefaultFieldValue('Hero Rate', heroService.hourlyRate.toString());*/
                  Get.find<FormController>().addFormHeroes(heroService);
                  /*ctrl.addDefaultFieldValue('Hero', heroService.heroName);
                  ctrl.addDefaultFieldValue('Total', (heroService.hourlyRate * int.parse(ctrl.defaultFormValues['Timeline'])).toString());*/
                  //Get.back();
                },
                child: Text('Add Multiple Hero', style: TextStyle(color: Colors.white),),
                color: Color(0xff13869F),
              ),
            ),
          );
        }

      }
      return Center(
        child: GetBuilder<FormController>(
          builder: (ctrl) => MaterialButton(
            shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
            onPressed: () {
              Get.find<FormController>().resetFormHeroes();
              Get.find<FormController>().addFormHeroes(heroService);
              /*ctrl.addDefaultFieldValue('heroId', heroService.heroId);
              ctrl.addDefaultFieldValue('Hero Name', heroService.heroName);
              ctrl.addDefaultFieldValue('Hero Address', heroService.heroAddress);
              ctrl.addDefaultFieldValue('Hero Rate', heroService.hourlyRate.toString());*/
              /*ctrl.addDefaultFieldValue('Hero', heroService.heroName);
              ctrl.addDefaultFieldValue('Total', (heroService.hourlyRate * int.parse(ctrl.defaultFormValues['Timeline'])).toString());*/
              //Get.back();
            },
            child: Text('Choose Hero', style: TextStyle(color: Colors.white),),
            color: Color(0xff13869F),
          ),
        ),
      );
    }
    return Center(child: Text('Hero not available', style: TextStyle(color: Colors.red[400]),));
  }
}
