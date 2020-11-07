import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/auth_controller.dart';
import 'package:heroservices/models/booking_model.dart';
import 'package:heroservices/services/booking_service.dart';
import 'package:heroservices/ui/widgets/shared/three_bounce_spinkit_shared_widget.dart';
import 'package:intl/intl.dart';

class BookingHistoryWidget extends StatelessWidget {
  final String uid = Get.find<AuthController>().user.uid;
  @override
  Widget build(BuildContext context) {
    return uid!=null ? StreamBuilder(
      stream: BookingService(customerId: uid).historyBookings,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        switch(snapshot.connectionState) {
          case ConnectionState.waiting:
            return SpinkitSharedWidget(type: 'ThreeBounce',);
          default:
            if (snapshot.data.length == 0) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text('No records found.')),
              );
            }
            return ListView.builder(
              itemCount: snapshot.hasData ? snapshot.data.length : 0,
              itemBuilder: (context, index) {
                BookingModel booking = snapshot.data[index];
                return ListTile(
                  title: Text(booking.serviceOption),
                  subtitle: Text(booking.queue.replaceAll('_', ' ').toUpperCase() + ' • ' + DateFormat('yyyy.MM.dd | HH:mm a').format(DateTime.parse(booking.schedule)).toString()),
                  //leading: Icon(Icons.check),
                  trailing: Text(booking.total+'.00 PHP'),
                );
              },
            );
        }
      },
    ):SizedBox(height: 1,);
  }
}
