import 'package:nike/data/product.dart';

class CreateOrderResult{
  final int orderId;
  final String bankGateWayUrl;

  CreateOrderResult(this.orderId, this.bankGateWayUrl);

  CreateOrderResult.fromJson(Map<String, dynamic> json):
  orderId=json["order_id"],
  bankGateWayUrl=json["bank_gateway_url"];
}


class CreateOrderParams{
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String postalCode;
  final String address;
  final PaymentMethod paymentMethod;

  CreateOrderParams({required this.firstName,required this.lastName, required this.phoneNumber,required this.postalCode,
  required this.address,required this.paymentMethod});

}

class OrderEntity{
  final int id;
  final int payablePrice;
  final List<ProductEntity> items;

  OrderEntity(this.id, this.payablePrice, this.items);

  OrderEntity.fromJson(Map<String, dynamic> json):id=json["id"],
  payablePrice = json["payable"],
  items = (json["order_items"] as List).map((item) => ProductEntity.fromJson(item["product"]),).toList();

}

enum PaymentMethod{
  online, cashOnDelivery
}