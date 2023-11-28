class Transaction {
  String? id;
  String? senderId;
  String? receiver;
  double? amount;
  String? currency;
  String? message;
  String? createdAt;
  String? updatedAt;

  Transaction(
      {this.id,
      this.senderId,
      this.receiver,
      this.amount,
      this.currency,
      this.message,
      this.createdAt,
      this.updatedAt});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    senderId = json['senderId'];
    receiver = json['receiver'];
    amount = json['amount'];
    currency = json['currency'];
    message = json['message'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['senderId'] = this.senderId;
    data['receiver'] = this.receiver;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['message'] = this.message;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
