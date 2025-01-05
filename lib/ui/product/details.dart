import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/product.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/theme.dart';
import 'package:nike/ui/product/bloc/product_bloc.dart';
import 'package:nike/ui/product/comment/comment_list.dart';
import 'package:nike/ui/product/comment/insert/insert_comment_dialog.dart';
import 'package:nike/ui/widgets/image.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductEntity product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {

  StreamSubscription<ProductState>? stateSubscription;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  

  @override
  void dispose() {
    stateSubscription?.cancel();
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<ProductBloc>(
        create: (context) {
          final bloc =  ProductBloc(cartRepository);
          stateSubscription = bloc.stream.listen((state) {
            if (state is ProductAddToCartSuccess){
              _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text('با موفقیت به سبد خرید شما اضافه شد')));
            }else if (state is ProductAddToCartError){
              _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(state.exception.message)));
            }

          },);

          return bloc;
        },
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
                width: MediaQuery.of(context).size.width - 48,
                child: BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    return FloatingActionButton.extended(
                        backgroundColor: LightThemeColors.secendayColor,
                        onPressed: () {
                          BlocProvider.of<ProductBloc>(context)
                              .add(CartAddButtonClicked(widget.product.id));
                        },
                        label: state is ProductAddToCartButtonLoading?CupertinoActivityIndicator(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ):Text('افزودن به سبد خرید'));
                  },
                )),
            body: CustomScrollView(
              physics: defaultScrollPhysics,
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width * 0.6,
                  flexibleSpace: ImageLoadingService(
                      imageUrl: widget.product.imageUrl, borderRadius: 0),
                  foregroundColor: LightThemeColors.primaryTextColor,
                  actions: [
                    IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.heart))
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              widget.product.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.product.previousPrice.withPriceLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          decoration: TextDecoration.lineThrough),
                                ),
                                Text(widget.product.price.withPriceLabel)
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Text(
                          "این کتونی شدیدا پیشنهاد می شود و برای دویدن و راه رفتن بسیار مناسب است و تقریبا هیچ فشاری به پای شما وارد نمی کند",
                          style: TextStyle(height: 1.4),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "نظرات کاربران",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            TextButton(onPressed: () {

                              showModalBottomSheet(context: context,
                              useRootNavigator: true,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                               builder: (context) => 
                               InsertCommentDialog(productId: widget.product.id,
                               scaffoldMessenger: _scaffoldKey.currentState,
                               ),);
                            }, child: Text("ثبت نظر"))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                CommentList(productId: widget.product.id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
