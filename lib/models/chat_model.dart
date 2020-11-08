class ChatModel {
  final String chatId;
  final String from;

  final String serviceOptionId;
  final String heroId;
  final String customerId;

  final String serviceOption;
  final String heroName;
  final String customerName;

  final String message;
  final bool seen;
  final DateTime timestamp;

  ChatModel({
    this.chatId,
    this.from,

    this.serviceOptionId,
    this.heroId,
    this.customerId,

    this.serviceOption,
    this.heroName,
    this.customerName,

    this.message,
    this.seen,
    this.timestamp,
  });
}