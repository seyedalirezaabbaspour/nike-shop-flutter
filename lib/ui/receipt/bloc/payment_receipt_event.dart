part of 'payment_receipt_bloc.dart';

sealed class PaymentReceiptEvent extends Equatable {
  const PaymentReceiptEvent();

  @override
  List<Object> get props => [];
}


class PaymentReceiptStarted extends PaymentReceiptEvent{
  final int orderId;

  const PaymentReceiptStarted(this.orderId);

  @override
  // TODO: implement props
  List<Object> get props => [orderId];
}