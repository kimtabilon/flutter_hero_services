import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/navigation_controller.dart';
import 'package:heroservices/models/booking_model.dart';

class BookingService {
  final String bookingId;
  final String heroId;
  final String customerId;
  final String serviceOptionId;

  BookingService({this.bookingId, this.heroId, this.customerId, this.serviceOptionId});

  final CollectionReference bookingCollection = Firestore.instance.collection('booking');

  List<BookingModel> _bookingListFromSnapshot(QuerySnapshot snapshot) {
    Get.find<NavigationController>().resetBookingGroups();
    return snapshot.documents.map((doc) {
      BookingModel booking = BookingModel(
        bookingId: doc.documentID,
        transactionNumber: doc.documentID,
        groupId: doc.data['group_id'],

        serviceOptionId: doc.data['service_option_id'] ?? '',
        serviceOption: doc.data['service_option'] ?? '',
        multipleBooking: doc.data['multiple_booking'] ?? false,
        openPrice: doc.data['open_price'] ?? true,

        heroId: doc.data['hero_id'] ?? '',
        heroName: doc.data['hero_name'] ?? '',
        heroAddress: doc.data['hero_address'] ?? '',
        heroNumber: doc.data['hero_number'] ?? '',
        heroRate: doc.data['hero_rate'] ?? '',

        customerId: doc.data['customer_id'] ?? '',
        customerName: doc.data['customer_name'] ?? '',
        customerAddress: doc.data['customer_address'] ?? '',

        schedule: doc.data['schedule'] ?? '',
        timeline: doc.data['timeline'] ?? '',
        timelineType: doc.data['timeline_type'] ?? '',
        formValues: doc.data['form_values'] ?? '',

        promoCode: doc.data['promo_code'] ?? '',
        promoAmount: doc.data['promo_amount'] ?? '',
        total: doc.data['total'] ?? '0',
        tax: doc.data['tax'] ?? '',

        queue: doc.data['queue'] ?? '',
      );
      Get.find<NavigationController>().addBookingGroups(booking);

      return booking;
    }).toList();
  }

  Stream<List<BookingModel>> get activeBookings {
    return bookingCollection
        .where('customer_id',isEqualTo: customerId)
        .where('queue',whereIn: ['for_quotation', 'for_confirmation', 'active'])
        .snapshots()
        .map(_bookingListFromSnapshot);
  }

  Stream<List<BookingModel>> get historyBookings {
    return bookingCollection
        .where('customer_id',isEqualTo: customerId)
        .where('queue',whereIn: ['completed', 'cancelled', 'denied', 'closed'])
        .snapshots()
        .map(_bookingListFromSnapshot);
  }

  Stream<List<BookingModel>> get heroBookings {

    return bookingCollection
        .where('hero_id',isEqualTo: heroId)
        .where('queue',whereIn: ['for_confirmation', 'active'])
        .snapshots()
        .map((snapshot) => snapshot.documents
        .map((document) => BookingModel.fromJson(document.data))
        .toList());
  }

  Future getHeroBookings() async {
    print('serviceOptionId : '+serviceOptionId);
    print('heroId : '+heroId);
    return await bookingCollection
      .where('service_option_id',isEqualTo: serviceOptionId)
      .where('hero_id',isEqualTo: heroId)
      .where('queue',whereIn: ['for_confirmation', 'active'])
      .getDocuments();
  }


  Future bookService(
      String groupId,
      String serviceOptionId,
      String serviceOption,
      bool multipleBooking,
      bool openBooking,

      String heroId,
      String heroName,
      String heroNumber,
      String heroAddress,
      String heroRate,

      String customerId,
      String customerName,
      String customerAddress,

      String schedule,
      String timelineType,
      String timeline,
      String formValues,

      String promoCode,
      String promoAmount,
      String total,
      String tax,

      String queue,
  )
  async {
        await bookingCollection.document().setData({
          'group_id':groupId,
          'service_option_id':serviceOptionId,
          'service_option':serviceOption,
          'multiple_booking':multipleBooking,
          'open_booking':openBooking,

          'hero_id':heroId,
          'hero_name':heroName,
          'hero_address':heroAddress,
          'hero_rate':heroRate,

          'customer_id':customerId,
          'customer_name':customerName,
          'customer_address':customerAddress,

          'schedule':schedule,
          'timeline_type':timelineType,
          'timeline':timeline,
          'form_values':formValues,

          'promo_code':promoCode,
          'promo_amount':promoAmount,
          'total':total,
          'tax':tax,

          'queue':queue,
        });

  }

  final CollectionReference quoteCollection = Firestore.instance.collection('quote');

  List<QuoteModel> _quoteListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return QuoteModel(
        quoteId: doc.documentID,
        bookingId: doc.data['hero_id'] ?? '',

        heroId: doc.data['hero_id'] ?? '',
        heroName: doc.data['hero_name'] ?? '',
        heroAddress: doc.data['hero_address'] ?? '',

        rate: doc.data['rate'] ?? '',
        notes: doc.data['notes'] ?? '',
      );
    }).toList();
  }

  Stream<List<QuoteModel>> get bookingQuotes {
    return quoteCollection
        .where('booking_id',isEqualTo: bookingId)
        .snapshots()
        .map(_quoteListFromSnapshot);
  }

  Future changeQueue(String bookingId, String queue) async {
    await bookingCollection.document(bookingId).updateData({'queue':queue});
  }

  Future addHero(
      String bookingId,
      String heroId,
      String heroName,
      String heroAddress,
      String heroRate,
      String total,
  )
  async {
    await bookingCollection
        .document(bookingId)
        .updateData({
          'hero_id':heroId,
          'hero_name':heroName,
          'hero_address':heroAddress,
          'hero_rate':heroRate,
          'total':total,
          'queue':'for_confirmation',
        });
  }
}