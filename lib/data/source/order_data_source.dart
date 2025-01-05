import 'package:dio/dio.dart';
import 'package:nike/data/order.dart';
import 'package:nike/data/paymment_receipt.dart';

abstract class IOrderDataSource{
  Future<CreateOrderResult> create(CreateOrderParams params);

  Future<PaymmentReceiptData> getPaymentReceipt(int orderId);

  Future<List<OrderEntity>> getOrders();
}


class OrderRemoteDataSource implements IOrderDataSource{

  final Dio httpclient;

  OrderRemoteDataSource(this.httpclient);
  @override
  Future<CreateOrderResult> create(CreateOrderParams params) async{
    final response =await httpclient.post("order/submit", data: {
      "first_name":params.firstName,
      "last_name":params.lastName,
      "postal_code":params.postalCode,
      "mobile":params.phoneNumber,
      "address":params.address,
      "payment_method":params.paymentMethod == PaymentMethod.cashOnDelivery ? "cash_on_delivery":"online"
    });

    return CreateOrderResult.fromJson(response.data);
  }
  
  @override
  Future<PaymmentReceiptData> getPaymentReceipt(int orderId) async{
    final response = await httpclient.get("order/checkout?order_id=$orderId");

    return PaymmentReceiptData.fromJson(response.data);

  }
  
  @override
  Future<List<OrderEntity>> getOrders() async{
    final response = await httpclient.get("order/list");
    return (response.data as List).map((item) => OrderEntity.fromJson(item),).toList();
  }


}