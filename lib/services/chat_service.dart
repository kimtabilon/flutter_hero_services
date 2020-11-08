import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heroservices/models/booking_model.dart';
import 'package:heroservices/models/chat_model.dart';

class ChatService {
  final BookingModel booking;

  ChatService({this.booking});

  final CollectionReference chatCollection = Firestore.instance.collection('chat');

  List<ChatModel> _chatListFromSnapshot(QuerySnapshot snapshot) {

    return snapshot.documents.map((doc) {
      ChatModel chats = ChatModel(
        chatId: doc.documentID,
        from: doc.data['from'],

        heroId: doc.data['hero_id'],
        customerId: doc.data['customer_id'],
        serviceOptionId: doc.data['service_option_id'],

        heroName: doc.data['hero_name'],
        customerName: doc.data['customer_name'],
        serviceOption: doc.data['service_option'],

        message: doc.data['message'],
        seen: doc.data['seen'],
      );

      return chats;
    }).toList();
  }

  Stream<List<ChatModel>> get chats {
    return chatCollection
        .where('customer_id',isEqualTo: booking.customerId)
        .where('hero_id',isEqualTo: booking.heroId)
        .where('service_option_id',isEqualTo: booking.serviceOptionId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(_chatListFromSnapshot);
  }

  Future sendChat(
      String heroId,
      String heroName,

      String customerId,
      String customerName,

      String serviceOptionId,
      String serviceOption,
      String message,
  )
  async {
    await chatCollection.document().setData({
      'from':'client',

      'service_option_id':serviceOptionId,
      'service_option':serviceOption,

      'hero_id':heroId,
      'hero_name':heroName,

      'customer_id':customerId,
      'customer_name':customerName,

      'message':message,
      'seen':false,
      'timestamp':DateTime.now(),
    });
  }
}