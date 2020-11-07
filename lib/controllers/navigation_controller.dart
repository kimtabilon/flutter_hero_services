import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:heroservices/models/booking_model.dart';

class NavigationController extends GetxController {
  int bottomNavCurrent = 1;

  setBottomNavCurrent(int i) {
    bottomNavCurrent = i;
    update();
  }

  void alert(String label, String message) {
    Get.snackbar(
      label!=''?label:'Error',
      message!=''?message:'Undefined error',
      icon: Icon(Icons.notification_important, color: Colors.white,),
      shouldIconPulse: true,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xff333333),
      colorText: Color(0xffeeeeee),
      isDismissible: true,
      dismissDirection: SnackDismissDirection.HORIZONTAL
    );
  }

  Map bookingGroups = {};
  addBookingGroups(BookingModel booking) {
    if(bookingGroups.containsKey(booking.groupId)) {

      bookingGroups[booking.groupId]['count']++;
      bookingGroups[booking.groupId]['total']+= booking.queue!='for_quotation' ? int.parse(booking.total) : 0;

      int countBookings = bookingGroups[booking.groupId]['bookings'].length;
      bookingGroups[booking.groupId]['bookings'][countBookings] = {
        'bookingId':booking.bookingId,
        'heroId':booking.heroId,
        'heroName':booking.heroName,
        'heroAddress':booking.heroAddress,
        'heroRate':booking.heroRate,
        'bookingTotal':booking.total,
        'queue':booking.queue,
      };
    } else {
      bookingGroups.addAll({
        booking.groupId: {
            'count':1,
            'total': booking.queue!='for_quotation' ? int.parse(booking.total) : 0,
            'bookingId':booking.bookingId,
            'bookings': { 0 : {
              'bookingId':booking.bookingId,
              'heroId':booking.heroId,
              'heroName':booking.heroName,
              'heroAddress':booking.heroAddress,
              'heroRate':booking.heroRate,
              'bookingTotal':booking.total,
              'queue':booking.queue,
            }}
          }
        }
      );
    }
    //print('##############: '+bookingGroups.toString());
    update();
  }

  resetBookingGroups() {
    print('resetBookingGroups');
    bookingGroups = {};
    update();
  }
}