class BookingModel {
  String bookingId;
  String transactionNumber;
  String groupId;

  String serviceOptionId;
  String serviceOption;
  bool multipleBooking;
  bool openPrice;

  String heroId;
  String heroName;
  String heroAddress;
  String heroRate;

  String customerId;
  String customerName;
  String customerAddress;
  String heroNumber;
  String customerCity;
  String customerProvince;

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
    this.multipleBooking,
    this.openPrice,

    this.heroId,
    this.heroName,
    this.heroAddress,
    this.heroNumber,
    this.heroRate,

    this.customerId,
    this.customerName,
    this.customerAddress,
    this.customerCity,
    this.customerProvince,

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
        multipleBooking = parsedJSON['multiple_booking'],
        openPrice = parsedJSON['open_price'],

        groupId = parsedJSON['group_id'],

        heroId = parsedJSON['hero_id'],
        heroName = parsedJSON['hero_name'],
        heroAddress = parsedJSON['hero_address'],
        heroNumber = parsedJSON['hero_number'],

        customerId = parsedJSON['customer_id'],
        customerName = parsedJSON['customer_name'],
        customerAddress = parsedJSON['customer_address'],
        customerCity = parsedJSON['customer_city'],
        customerProvince = parsedJSON['customer_province'],

        schedule = parsedJSON['schedule'],
        timeline = parsedJSON['timeline'],
        timelineType = parsedJSON['timeline_type'];
}

class QuoteModel {
  final String quoteId;
  final String bookingId;

  final String heroId;
  final String heroName;
  final String heroNumber;
  final String heroAddress;

  final String rate;
  final String notes;

  QuoteModel({
    this.quoteId,
    this.bookingId,

    this.heroId,
    this.heroName,
    this.heroNumber,
    this.heroAddress,

    this.rate,
    this.notes,
  });
}
