import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/auth_controller.dart';
import 'package:heroservices/ui/widgets/booking/active_booking_widget.dart';
import 'package:heroservices/ui/widgets/booking/booking_history_widget.dart';
import 'package:heroservices/ui/widgets/shared/bottom_navigation_shared_widget.dart';

class BookingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('BOOKINGS', style: TextStyle(letterSpacing: 5),),
          bottom: TabBar(
            unselectedLabelColor: Colors.white,
            labelColor: Color(0xff93CA68),
            indicatorColor: Color(0xff93CA68),
            onTap: (index) {
              // Tab index when user select it, it start from zero
            },
            tabs: [
              Tab(text: 'C U R R E N T',),
              Tab(text: 'H I S T O R Y',),
            ],
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomNavigationSharedWidget(),
        body: GetBuilder<AuthController>(
          builder: (ctrl) {
            if(ctrl.user?.uid != null) {
              return TabBarView(
                children: [
                  ActiveBookingWidget(),
                  BookingHistoryWidget(),
                ],
              );
            }

            return TabBarView(
              children: [
                Center(child: Text('Please login or create account to proceed')),
                Center(child: Text('Please login or create account to proceed'))
              ],
            );
          },
        ),
      ),
    );
  }
}
