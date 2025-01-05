import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/repo/order_repository.dart';
import 'package:nike/ui/order/bloc/order_history_bloc.dart';
import 'package:nike/ui/widgets/image.dart';

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderHistoryBloc>(
      create: (context) => OrderHistoryBloc(orderRepository)..add(OrderHistoryStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('سوابق سفارش'),
        ),
        body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistorySuccess) {
              final orders = state.orders;
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Container(
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Theme.of(context).dividerColor, width: 1)
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          height: 56,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('شناسه سفارش'),

                              Text(order.id.toString()),
                              
                            ],
                          ),
                        ),
                        Divider(height: 1,color: Theme.of(context).dividerColor,),
                        Container(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          height: 56,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('مبلغ سفارش'),

                              Text(order.payablePrice.withPriceLabel),
                              
                            ],
                          ),
                        ),
                        Divider(height: 1,color: Theme.of(context).dividerColor,),
                        SizedBox(
                          height: 132,
                          child: ListView.builder(
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            itemCount: order.items.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                            return Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(left: 4, right: 4),

                              child: ImageLoadingService(imageUrl: order.items[index].imageUrl, borderRadius: 8),
                            );
                          },),
                        )
                      ],
                    ),
                  );
                },
              );
            } else if (state is OrderHistoryError) {
              return Center(
                child: Text(state.exception.message),
              );
            } else {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
