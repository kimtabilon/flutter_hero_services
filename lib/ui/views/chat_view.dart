import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:heroservices/models/booking_model.dart';
import 'package:heroservices/models/chat_model.dart';
import 'package:heroservices/services/chat_service.dart';
import 'package:heroservices/ui/widgets/shared/three_bounce_spinkit_shared_widget.dart';

// ignore: must_be_immutable
class ChatView extends StatelessWidget {
  BookingModel booking;

  ChatView({this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        //brightness: Brightness.dark,
        centerTitle: true,
        title: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                  text: booking.heroName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  )),
              TextSpan(text: '\n'),
              TextSpan(
                text: booking.serviceOption+' • '+DateFormat('yyyy.MM.dd | HH:mm a').format(DateTime.parse(booking.schedule)).toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              )

            ],
          ),
        ),
        actions: [
          OutlineButton(
            child: Text('${booking.total}.00 PHP\n${booking.timeline} ${booking.timelineType}', textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
            onPressed: (){},
          )
        ],
        /*leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),*/
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: ChatService(booking: booking).chats,
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
                          child: Center(child: Text('Start Chating.')),
                        );
                      }
                      return ListView.builder(
                        reverse: true,
                        itemCount: snapshot.hasData ? snapshot.data.length : 0,
                        itemBuilder: (context, index) {
                          return _chatBubble(context, snapshot.data[index]);
                          //return BookingTileWidget(booking: snapshot.data[index],);
                        },
                      );
                  }

                },
              ),
            ),
            _sendMessageArea(context),
          ],
        ),
      ),
    );
  }

  _chatBubble(context, ChatModel chat) {
      Alignment align = Alignment.topLeft;
      Color bgColor = Colors.white;
      Color textColor = Colors.black54;

      if(chat.from=='client') {
        align = Alignment.topRight;
        bgColor = Colors.blue;
        textColor = Colors.white;
      }

      return Column(
        children: <Widget>[
          Container(
            alignment: align,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[200],
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                chat.message,
                style: TextStyle(
                  color: textColor,
                ),
              ),
            ),
          ),

        ],
      );

  }

  _sendMessageArea(context) {
    TextEditingController messageCtrl  = TextEditingController();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: messageCtrl,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Send a message..',
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(20.0),
                  borderSide: new BorderSide(),
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Colors.blue,
            onPressed: () {
              ChatService().sendChat(
                  booking.heroId,
                  booking.heroName,
                  booking.customerId,
                  booking.customerName,
                  booking.serviceOptionId,
                  booking.serviceOption,
                  messageCtrl.text
              );
              messageCtrl.clear();
            },
          ),
        ],
      ),
    );
  }


}