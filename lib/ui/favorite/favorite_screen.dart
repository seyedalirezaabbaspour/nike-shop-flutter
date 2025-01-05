import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/favorite_manager.dart';
import 'package:nike/data/product.dart';
import 'package:nike/theme.dart';
import 'package:nike/ui/product/details.dart';
import 'package:nike/ui/widgets/image.dart';

class FavoriteListScreen extends StatelessWidget{
  const FavoriteListScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("لیست علاقه مندی ها"),),
      body: ValueListenableBuilder<Box<ProductEntity>>(
        valueListenable: favoriteManager.listenable,
        builder: (context, box, child) {
          final products = box.values.toList();
          return ListView.builder( 
          padding: EdgeInsets.only(top: 8, bottom: 100),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product),));
              },
              onLongPress: () {
                favoriteManager.delete(product);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 110,
                      height: 110,
                      child: ImageLoadingService(imageUrl: product.imageUrl, borderRadius: 8)),
              
                      Expanded(child: Padding(padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.title, style: Theme.of(context).textTheme.titleMedium!.apply(color: LightThemeColors.primaryTextColor),),
                          SizedBox(height: 24,),
                          Text(product.previousPrice.withPriceLabel, style: Theme.of(context).textTheme.bodySmall!.apply(decoration: TextDecoration.lineThrough),),
                          Text(product.price.withPriceLabel)
                        ],
                      ),))
                  ],
                ),
              ),
            );
        },);
        },
      ),
    );
  }
}