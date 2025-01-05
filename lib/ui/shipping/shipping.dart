import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/order.dart';
import 'package:nike/data/repo/order_repository.dart';
import 'package:nike/ui/cart/price_info.dart';
import 'package:nike/ui/payment_webview.dart';
import 'package:nike/ui/receipt/payment_receipt.dart';
import 'package:nike/ui/shipping/bloc/shipping_bloc.dart';

class ShippingScreen extends StatefulWidget {
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  ShippingScreen(
      {super.key,
      required this.payablePrice,
      required this.shippingCost,
      required this.totalPrice});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController phoneNumberController = TextEditingController();

  final TextEditingController postalCodeController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  StreamSubscription? subscription;

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("تحویل گیرنده"),
      ),
      body: BlocProvider<ShippingBloc>(
        create: (context) {
          final bloc = ShippingBloc(orderRepository);

          subscription = bloc.stream.listen(
            (event) {
              if (event is ShippingError) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(event.exception.message)));
              } else if (event is ShippingSuccess) {

                // if (event.result.bankGateWayUrl.isNotEmpty){
                //   // Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymetGatewayScreen(bankGateWayUrl: event.result.bankGateWayUrl),));
                // }else{

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PaymentReceiptScreen(orderId: event.result.orderId,),
                ));
                }
              // }
            },
          );

          return bloc;
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  label: Text("نام "),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  label: Text(" نام خانوادگی"),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: postalCodeController,
                decoration: InputDecoration(
                  label: Text("کد پستی"),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  label: Text("شماره تماس"),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  label: Text("آدرس"),
                ),
              ),
              PriceInfo(
                  payablePrice: widget.payablePrice,
                  shippingCost: widget.shippingCost,
                  totalPrice: widget.totalPrice),
              BlocBuilder<ShippingBloc, ShippingState>(
                builder: (context, state) {
                  return state is ShippingLoading?Center(child: CupertinoActivityIndicator()):Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            BlocProvider.of<ShippingBloc>(context).add(
                                ShippingCreateOrder(CreateOrderParams(
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    phoneNumber: phoneNumberController.text,
                                    address: addressController.text,
                                    postalCode: postalCodeController.text,
                                    paymentMethod:
                                        PaymentMethod.cashOnDelivery)));
                            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentReceiptScreen(orderId: ,),));
                          },
                          child: Text('پرداخت در محل')),
                      SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                          onPressed: () {
BlocProvider.of<ShippingBloc>(context).add(
                                ShippingCreateOrder(CreateOrderParams(
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    phoneNumber: phoneNumberController.text,
                                    address: addressController.text,
                                    postalCode: postalCodeController.text,
                                    paymentMethod:
                                        PaymentMethod.online)));

                          }, child: Text('پرداخت اینترنتی')),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
