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
      label!=''?label:'Somethings went wrong',
      message!=''?message:'Undefined error',
      icon: Icon(Icons.notification_important, color: Colors.white,),
      shouldIconPulse: true,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xff333333),
      colorText: Color(0xffeeeeee),
      isDismissible: true,
      dismissDirection: SnackDismissDirection.HORIZONTAL,
      margin: EdgeInsets.only(bottom: 60, left: 10, right: 10),
    );
  }

  Map bookingGroups = {};
  addBookingGroups(BookingModel booking) {
    if(bookingGroups.containsKey(booking.groupId)) {

      bookingGroups[booking.groupId]['count']++;
      bookingGroups[booking.groupId]['total']+= booking.queue!='for_quotation' ? int.parse(booking.total) : 0;

      int countBookings = bookingGroups[booking.groupId]['bookings'].length;
      bookingGroups[booking.groupId]['bookings'][countBookings] = booking;
    } else {
      bookingGroups.addAll({
        booking.groupId: {
            'count':1,
            'total': booking.queue!='for_quotation' ? int.parse(booking.total) : 0,
            'bookingId':booking.bookingId,
            'bookings': { 0 : booking}
          }
        }
      );
    }
    update();
  }

  resetBookingGroups() {
    print('resetBookingGroups');
    bookingGroups = {};
    update();
  }
}