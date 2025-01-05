import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/cart_item.dart';
import 'package:nike/theme.dart';
import 'package:nike/ui/widgets/image.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.data, required this.onDeleteButtonClicked, required this.onIncreaseButtonClicked, required this.onDecreaseButtonClicked,
  });

  final CartItemEntity data;
  final GestureTapCallback onDeleteButtonClicked;
  final GestureTapCallback onIncreaseButtonClicked;
  final GestureTapCallback onDecreaseButtonClicked;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10)
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                    width: 100,
                    height: 100,
                    child: ImageLoadingService(
                        imageUrl: data.product.imageUrl,
                        borderRadius: 4)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data.product.title,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('تعداد'),
                    Row(
                      children: [
                        IconButton(
                            onPressed: onIncreaseButtonClicked,
                            icon: const Icon(
                                CupertinoIcons.plus_rectangle)),
                        data.changeCountLoading?CupertinoActivityIndicator(color: Theme.of(context).colorScheme.onSurface,):Text(
                          data.count.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge,
                        ),
                        IconButton(
                            onPressed: onDecreaseButtonClicked,
                            icon: const Icon(CupertinoIcons
                                .minus_rectangle)),
                      ],
                    ),


                    
                  ],
                ),
              Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          data.product.previousPrice
                              .withPriceLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            color: LightThemeColors.secendaryTextColor,
                            decoration:
                                TextDecoration.lineThrough,
                          ),
                        ),
                        Text(data.product.price.withPriceLabel)
                      ],
                    )
              ],
            ),
          ),
          const Divider(
            height: 1,
            thickness: 0.3,
          ),
          data.deleteButtonLoading?SizedBox(
            height: 48,
            child: Center(child: CupertinoActivityIndicator(),)):TextButton(
              onPressed: onDeleteButtonClicked, child: const Text("حذف از سبد خرید"))
        ],
      ),
    );
  }
}
