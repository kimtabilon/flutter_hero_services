import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/navigation_controller.dart';
import 'package:heroservices/models/booking_model.dart';
import 'package:heroservices/services/booking_service.dart';
import 'package:heroservices/ui/views/chat_view.dart';
import 'package:heroservices/ui/widgets/booking/view_booking_widget.dart';
import 'package:heroservices/ui/widgets/shared/rating_widget.dart';
import 'package:heroservices/ui/widgets/shared/three_bounce_spinkit_shared_widget.dart';
import 'package:intl/intl.dart';

class BookingTileWidget extends StatelessWidget {
  final BookingModel booking;

  BookingTileWidget({this.booking});
  @override
  Widget build(BuildContext context) {
    switch(booking.queue) {
      case 'for_quotation':
        return ExpansionTile(
          title: Text(booking.serviceOption),
          subtitle: Text(booking.queue.replaceAll('_', ' ').toUpperCase() + ' • ' + DateFormat('yyyy.MM.dd | HH:mm a').format(DateTime.parse(booking.schedule)).toString()),
          children: [
            SizedBox(height: 10,),
            StreamBuilder(
              stream: BookingService(bookingId: booking.bookingId).bookingQuotes,
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
                      //hideLoadingDialog();
                      return Center(child: Text('No response from heroes'));
                    }
                    //hideLoadingDialog();
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.hasData ? snapshot.data.length : 0,
                      itemBuilder: (context, i) {
                        QuoteModel quote = snapshot.data[i];
                        Map bookingGroups = Get.find<NavigationController>().bookingGroups;
                        Map _bookings = bookingGroups[booking.groupId]['bookings'];

                        for(var h=0; h<_bookings.length; h++) {
                          BookingModel b = _bookings[h];
                          if(b.heroId == quote.heroId && b.queue!='for_quotation') {
                            return ListTile(
                              title: Text(quote.heroName),
                              subtitle: Text(b.queue.replaceAll('_', ' ').toUpperCase()),
                              trailing: Text((booking.total!='0' ? booking.total : quote.rate)+'.00 PHP'),
                              leading: ovalButton(b.queue, b, null),
                            );
                          }
                        }
                        return ListTile(
                          title: Text(quote.heroName),
                          subtitle: RatingWidget(),
                          trailing: Text((booking.total!='0' ? booking.total : quote.rate)+'.00 PHP'),
                          leading: ovalButton('for_quotation', null, quote),
                        );
                      },
                    );
                }
              },
            ),
            SizedBox(height: 20,),
            actionButtons(context),
            SizedBox(height: 20,),
          ],
        );
        break;
      default:
        Map bookingGroups = Get.find<NavigationController>().bookingGroups;
        Map _bookings = bookingGroups[booking.groupId]['bookings'];
        int groupHasQuote = 0;
        for(var i=0; i<_bookings.length; i++) {
          BookingModel bb = _bookings[i];
          if(bb.queue=='for_quotation') {
            groupHasQuote++;
          }
        }

        if(bookingGroups[booking.groupId]['bookingId'] == booking.bookingId && groupHasQuote==0) {
          if(bookingGroups[booking.groupId]['count']>1) {
            return ExpansionTile(
              title: Text(booking.serviceOption),
              subtitle: Text(DateFormat('yyyy.MM.dd | HH:mm a').format(DateTime.parse(booking.schedule)).toString()),
              trailing: Text(bookingGroups[booking.groupId]['total'].toString()+'.00 PHP'),
              children: [
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _bookings.length,
                  itemBuilder: (context, index) {
                    BookingModel b = _bookings[index];

                    return ListTile(
                      title: Text(b.heroName),
                      subtitle: Text(b.queue.replaceAll('_', ' ').toUpperCase()),
                      trailing: Text((int.parse(b.heroRate) * int.parse(booking.timeline)).toString()+'.00 PHP'),
                      leading: ovalButton(b.queue, b, null),
                    );
                  },
                ),
                actionButtons(context),
                SizedBox(height: 20,),
              ],
            );
          }
          return ExpansionTile(
            title: Text(booking.serviceOption),
            subtitle: Text(booking.queue.replaceAll('_', ' ').toUpperCase() + ' • ' + DateFormat('yyyy.MM.dd | HH:mm a').format(DateTime.parse(booking.schedule)).toString()),
            trailing: Text(booking.total+'.00 PHP'),
            children: [
              SizedBox(height: 20,),
              actionButtons(context),
              SizedBox(height: 20,),
            ],
          );
        }
        return SizedBox.shrink();
        break;
    }
  }

  Widget ovalButton(String queue, BookingModel _booking, QuoteModel quote) {
    switch(queue) {
      case 'for_confirmation':
        return ClipOval(
          child: Material(
            color: Colors.red[300], // button color
            child: InkWell(
              splashColor: Color(0xff93CA68), // inkwell color
              child: SizedBox(width: 30, height: 30, child: Icon(Icons.close, color: Colors.white,)),
              onLongPress: () {
                BookingService().changeQueue(_booking.bookingId, 'cancelled');
              },
              onTap: () {
                Get.find<NavigationController>().alert('Confirm your action', 'Long press to cancel this Hero.');
              },
            ),
          ),
        );
        break;
      case 'active':
        return ClipOval(
          child: Material(
            color: Colors.grey[400], // button color
            child: InkWell(
              splashColor: Color(0xff93CA68), // inkwell color
              child: SizedBox(width: 30, height: 30, child: Icon(Icons.chat, color: Colors.white, size: 20,)),
              onLongPress: () {
                //BookingService().changeQueue(bookingId, 'cancelled');
              },
              onTap: () {
                Get.to(ChatView(booking: _booking,));
                //Get.find<NavigationController>().alert('Message', 'Chat feature is not yet available.');
              },
            ),
          ),
        );
        break;
      case 'for_quotation':
        return ClipOval(
          child: Material(
            color: Colors.grey[400], // button color
            child: InkWell(
              splashColor: Color(0xff93CA68), // inkwell color
              child: SizedBox(width: 30, height: 30, child: Icon(Icons.add, color: Colors.white,)),
              onLongPress: () {
                BookingService().bookService(
                    booking.groupId,
                    booking.serviceOptionId,
                    booking.serviceOption,

                    quote.heroId,
                    quote.heroName,
                    quote.heroAddress,
                    quote.rate,

                    booking.customerId,
                    booking.customerName,
                    booking.customerAddress,
                    booking.schedule,
                    booking.timelineType,
                    booking.timeline,
                    booking.formValues,
                    booking.promoCode,
                    booking.promoAmount,
                    booking.total!='0' ? booking.total : quote.rate,
                    booking.tax,
                    'for_confirmation'
                );
              },
              onTap: () {
                Get.find<NavigationController>().alert('Confirm your action', 'Long press to select a quote.');
              },
            ),
          ),
        );
        break;
      default:
        return null;
        break;
    }
  }

  Widget actionButtons(context) {
    Map bookingGroups = Get.find<NavigationController>().bookingGroups;
    Map _bookingsInGroup = bookingGroups[booking.groupId]['bookings'];

    switch(booking.queue) {
      case 'for_quotation':
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlineButton(
              onLongPress: () {
                BookingService().changeQueue(booking.bookingId, 'closed');
              },
              onPressed: (){
                Get.find<NavigationController>().alert('Confirm your action', 'Long press to close quotation.');
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('CLOSE QUOTATION',style: TextStyle(color: Colors.grey[800]),),
              ),
            ),
            viewDetailsButton(context),
          ],
        );
        break;

      case 'for_confirmation':
        if(_bookingsInGroup.length==1) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlineButton(
                onLongPress: () {
                  BookingService().changeQueue(booking.bookingId, 'cancelled');
                },
                onPressed: (){
                  Get.find<NavigationController>().alert('Confirm your action', 'Long press to cancel booking.');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('CANCEL BOOKING',style: TextStyle(color: Colors.grey[800]),),
                ),
              ),
              viewDetailsButton(context),
            ],
          );
        }
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            viewDetailsButton(context),
          ],
        );
        break;

      case 'active':
        if(_bookingsInGroup.length==1) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlineButton(
                onPressed: (){
                  Get.to(ChatView(booking: _bookingsInGroup[0],));
                  //Get.find<NavigationController>().alert('Message', 'Chat feature is not yet available.');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('OPEN CHAT',style: TextStyle(color: Colors.grey[800]),),
                ),
              ),
              viewDetailsButton(context),
            ],
          );
        }
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            viewDetailsButton(context),
          ],
        );
        break;

      default:
        return Text('Something went wrong, booking status not set.');
        break;
    }
  }

  Widget viewDetailsButton(context) {
    return MaterialButton(
      color: Colors.blue,
      elevation: 0,
      onPressed: (){
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Container(
                    width: double.maxFinite,
                    child: ViewBookingWidget(booking: booking,)
                ),
              );
            }
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('VIEW DETAILS',style: TextStyle(color: Colors.white),),
      ),
    );
  }
}
