import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/common/utils.dart';
import 'package:nike/data/product.dart';
import 'package:nike/data/repo/banner_repository.dart';
import 'package:nike/data/repo/product_repository.dart';
import 'package:nike/ui/home/bloc/home_bloc.dart';
import 'package:nike/ui/list/list.dart';
import 'package:nike/ui/product/product.dart';
import 'package:nike/ui/widgets/error.dart';
import 'package:nike/ui/widgets/slider.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final homeBloc = HomeBloc(bannerRepository, productRepository);
        homeBloc.add(HomeStarted());
        return homeBloc;
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeSuccess) {
                return ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Column(
                          children: [
                            Container(
                              height: 56,
                              alignment: Alignment.center,
                              child: Image.asset(
                                "assets/img/nike_logo.png",
                                height: 26,
                                fit: BoxFit.fitHeight,
                              ),
                            ),

                            Container(
                              height: 56,
                              margin: EdgeInsets.fromLTRB(12, 0, 12, 12),
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 1),
                                    borderRadius: BorderRadius.circular(28),  
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),
                                    borderRadius: BorderRadius.circular(28),  
                                  ),
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  
                                  label: Text("جستجو"),
                                  isCollapsed: false,
                                  prefixIcon: IconButton(onPressed: (){
                                    _search(context);
                                  },
                                   icon: Padding(
                                     padding: const EdgeInsets.only(right: 8),
                                     child: Icon(CupertinoIcons.search),
                                   ))
                                ),
                                onSubmitted: (value) {
                                  _search(context);
                                },
                                textInputAction: TextInputAction.search,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            )
                          ],
                        );

                      case 2:
                        return BannerSlider(
                          banners: state.banners,
                        );
                        
                      case 3:
                      return _HorizontalProductList(
                        title: 'جدیدترین',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                           ProductListScreen(sort: ProductSort.lates),));
                        },
                        products: state.latesProducts,
                      );


                      case 4:
                      return _HorizontalProductList(
                        title: 'پربازدید ترین',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                           ProductListScreen(sort: ProductSort.popular),));
                        },
                        products: state.popularProducts,
                      );

                      default:
                        return Container();
                    }
                  },
                );
              } else if (state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is HomeError) {
                return AppErrorWidget(exception: state.exception, onPressed: () {
                  BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                },);
              } else {
                throw Exception("state is not supported.......");
              }
            },
          ),
        ),
      ),
    );
  }
  void _search(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
     ProductListScreen.search(searchTerm: _searchController.text,)));
  }
}


class _HorizontalProductList extends StatelessWidget {
  final String title;
  final GestureTapCallback onTap;
  final List<ProductEntity> products;

  const _HorizontalProductList({
    super.key, required this.title, required this.onTap, required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium,),
              TextButton(onPressed: onTap,
               child: Text('مشاهده همه',
               style:TextStyle(fontFamily: "iranYekan",),))
            ],
          ),
        ),
    
        SizedBox(
          height: 290,
          child: ListView.builder(
            physics: defaultScrollPhysics,
            itemCount: products.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 8, right: 8),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductItem(product: product, borderRadius: 12,);
            },),
        )
      ],
    );
  }
}

