import 'package:nike/common/http_client.dart';
import 'package:nike/data/order.dart';
import 'package:nike/data/paymment_receipt.dart';
import 'package:nike/data/source/order_data_source.dart';


final OrderRepository orderRepository = OrderRepository(OrderRemoteDataSource(httpclient));

abstract class IOrderRepository extends IOrderDataSource{

}


class OrderRepository implements IOrderRepository{
  final IOrderDataSource dataSource;

  OrderRepository(this.dataSource);
  
  @override
  Future<CreateOrderResult> create(CreateOrderParams params) => dataSource.create(params);

  @override
  Future<PaymmentReceiptData> getPaymentReceipt(int orderId) => dataSource.getPaymentReceipt(orderId);
  
  @override
  Future<List<OrderEntity>> getOrders() => dataSource.getOrders();
}