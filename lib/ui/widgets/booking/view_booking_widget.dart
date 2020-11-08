import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/navigation_controller.dart';
import 'package:heroservices/models/booking_model.dart';
import 'package:heroservices/ui/widgets/shared/divider_shared_widget.dart';
import 'package:intl/intl.dart';

class ViewBookingWidget extends StatelessWidget {

  final BookingModel booking;

  ViewBookingWidget({this.booking});

  @override
  Widget build(BuildContext context) {
    Map formValues = json.decode(booking.formValues);
    List values = formValues.values.toList(growable: false);
    List keys = formValues.keys.toList(growable: false);

    Map bookingGroups = Get.find<NavigationController>().bookingGroups;

    return SingleChildScrollView(
      child: Column(
        children: [
          Text('BOOKING', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      Text(booking.serviceOption, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue),),
                      Text(DateFormat('yyyy.MM.dd | HH:mm a').format(DateTime.parse(booking.schedule)).toString()),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(bookingGroups[booking.groupId]['total'].toString()+'.00 PHP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold),),
                    ],
                  ),
                ],
              ),
              Container(height: 0.4, width: double.infinity, color: Colors.grey, margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 20.0, bottom: 20.0),),

              ListTile(
                trailing: Text(booking.timeline, style: TextStyle(fontWeight: FontWeight.bold),),
                title: Text("No. of "+booking.timelineType, style: TextStyle(fontSize: 13),),
              ),
              ListTile(
                trailing: Text(booking.queue.replaceAll('_', ' ').toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold),),
                title: Text('Booking Status', style: TextStyle(fontSize: 13),),
              ),
              Container(height: 0.4, width: double.infinity, color: Colors.grey, margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 20.0, bottom: 20.0),),

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

              Container(height: 0.4, width: double.infinity, color: Colors.grey, margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 20.0, bottom: 20.0),),

              Center(child: Text('CUSTOMER INFORMATION', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                child: Text('Name'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                child: Text(booking.customerName, style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                child: Text('Address'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                child: Text(booking.customerAddress, style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 10,),
              heroesList(booking),
              Container(height: 0.4, width: double.infinity, color: Colors.grey, margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 20.0, bottom: 20.0),),
              Center(
                child: OutlineButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('CLOSE'),
                  ),
                  color: Color(0xff13869F),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget heroesList(BookingModel booking) {
    Map bookingGroups = Get.find<NavigationController>().bookingGroups;
    Map _bookings = bookingGroups[booking.groupId]['bookings'];
    //print('##############'+_bookings.toString());
    if(_bookings.length>0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DividerSharedWidget(),
          Center(child: Text('HEROES', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),)),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _bookings.length,
            itemBuilder: (context, index) {
              //print('####'+_bookings[index].toString());
              /*print('-----------------------------------------------');
              print('length####'+_bookings.length.toString());
              print('index####'+index.toString());*/
              BookingModel b = _bookings[index];
              if(b.queue!='for_quotation') {

                return ListTile(
                  title: Text(b.heroName),
                  subtitle: Text(b.heroAddress),
                  trailing: Text(b.total+'.00 PHP'),
                );
              }
              //print('##############'+_bookings[index].toString());
              return SizedBox.shrink();
            },
          ),
        ],
      );
    }
    return null;
  }
}
