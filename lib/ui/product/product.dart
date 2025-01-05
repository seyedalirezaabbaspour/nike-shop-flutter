import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/favorite_manager.dart';
import 'package:nike/data/product.dart';
import 'package:nike/ui/product/details.dart';
import 'package:nike/ui/widgets/image.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    super.key,
    required this.product, required this.borderRadius,  this.itemWidth=176,  this.itemHeight=189,
  });

  final ProductEntity product;
  final double borderRadius;
  final double itemWidth;
  final double itemHeight;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: widget.product,),));
        },
        child: SizedBox(
          width: widget.itemWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 0.93,
                    // width: itemWidth,
                    // height: itemHeight,
                    child: ImageLoadingService(imageUrl: widget.product.imageUrl, borderRadius: widget.borderRadius)),
          
                  Positioned(
                    right: 8,
                    top: 8,
                    child: InkWell(
                      onTap: () {
                        if(!favoriteManager.isFavorite(widget.product)) {
                          favoriteManager.addFavorite(widget.product);
                        }else{
                          favoriteManager.delete(widget.product);
                        }

                        setState(() {
                          
                        });
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white
                        ),  
                        child: Icon(favoriteManager.isFavorite(widget.product)?CupertinoIcons.heart_fill:CupertinoIcons.heart, size: 20,),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.product.title,
                 maxLines: 2,
                 overflow: TextOverflow.ellipsis,),
              ),
              
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: Text(widget.product.previousPrice.withPriceLabel,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(decoration: TextDecoration.lineThrough),
                ),
              ),
          
              Padding(
                padding: const EdgeInsets.only(right: 8, left: 8, top: 4),
                child: Text(widget.product.price.withPriceLabel),
              ),
          
            ],
          ),
        ),
      )
    );
  }
}
