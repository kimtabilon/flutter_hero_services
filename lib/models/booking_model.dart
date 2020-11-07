class BookingModel {
  String bookingId;
  String transactionNumber;
  String groupId;

  String serviceOptionId;
  String serviceOption;

  String heroId;
  String heroName;
  String heroAddress;
  String heroRate;

  String customerId;
  String customerName;
  String customerAddress;

  String schedule;
  String timeline;
  String timelineType;
  String formValues;

  String promoCode;
  String promoAmount;
  String total;
  String tax;

  String queue;
  //quotation, for_confirmation, pending, completed

  BookingModel({
    this.bookingId,
    this.transactionNumber,
    this.groupId,

    this.serviceOptionId,
    this.serviceOption,

    this.heroId,
    this.heroName,
    this.heroAddress,
    this.heroRate,

    this.customerId,
    this.customerName,
    this.customerAddress,

    this.schedule,
    this.timeline,
    this.timelineType,
    this.formValues,

    this.promoCode,
    this.promoAmount,
    this.total,
    this.tax,

    this.queue,
  });

  BookingModel.fromJson(Map<String, dynamic> parsedJSON)
      : serviceOptionId = parsedJSON['service_option_id'],
        serviceOption = parsedJSON['service_option'],

        groupId = parsedJSON['group_id'],

        heroId = parsedJSON['hero_id'],
        heroName = parsedJSON['hero_name'],
        heroAddress = parsedJSON['hero_address'],

        customerId = parsedJSON['customer_id'],
        customerName = parsedJSON['customer_name'],
        customerAddress = parsedJSON['customer_address'],


        schedule = parsedJSON['schedule'],
        timeline = parsedJSON['timeline'],
        timelineType = parsedJSON['timeline_type'];
}

class QuoteModel {
  final String quoteId;
  final String bookingId;

  final String heroId;
  final String heroName;
  final String heroAddress;

  final String rate;
  final String notes;

  QuoteModel({
    this.quoteId,
    this.bookingId,

    this.heroId,
    this.heroName,
    this.heroAddress,

    this.rate,
    this.notes,
  });
}
