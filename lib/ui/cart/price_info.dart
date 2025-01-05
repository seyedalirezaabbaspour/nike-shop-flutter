import 'package:flutter/material.dart';
import 'package:nike/common/utils.dart';

class PriceInfo extends StatelessWidget{

  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  const PriceInfo({super.key, required this.payablePrice, required this.shippingCost, required this.totalPrice});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 8, 0),
          child: Text('جزئیات خرید', style: Theme.of(context).textTheme.titleMedium,),
        ),
        Container(  
          margin: EdgeInsets.fromLTRB(8, 8, 8, 32),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(0.05)
            )]
          ),
        
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('مبلغ کل خرید'), 
                    RichText(text: TextSpan(
                      text: totalPrice.seperateByComma,
                      style: DefaultTextStyle.of(context).style.copyWith(fontSize: 17, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: " تومان",
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal)
                        )
                      ]
                    ))
                  ],
                ),
              ),
              Divider(height: 1,
              thickness: 0.3,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('هزینه ارسال'), 
                    Text(shippingCost.withPriceLabel),
                  ],
                ),
              ),
              Divider(height: 1,
              thickness: 0.3,),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('مبلغ قابل پرداخت'), 
                    RichText(text: TextSpan(
                      text: payablePrice.seperateByComma,
                      style: DefaultTextStyle.of(context).style.copyWith(fontSize: 17, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: " تومان",
                        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10)
                      )
                    ]
                    ),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}