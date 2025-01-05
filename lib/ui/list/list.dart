import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/product.dart';
import 'package:nike/data/repo/product_repository.dart';
import 'package:nike/ui/list/bloc/product_list_bloc.dart';
import 'package:nike/ui/product/product.dart';

class ProductListScreen extends StatefulWidget {
  final int sort;
  final String searchTerm;

   const ProductListScreen({super.key, required this.sort}):searchTerm="";

    const ProductListScreen.search({super.key, required this.searchTerm}):sort=ProductSort.popular;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

enum ViewType{
  grid,
  list
}

class _ProductListScreenState extends State<ProductListScreen> {
  ProductListBloc? bloc;
  ViewType viewType = ViewType.grid; 

  @override
  void dispose() {
    bloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.searchTerm.isEmpty?"کفش های ورزشی":"نتایج جستجو ${widget.searchTerm}"),
      ),
      body: BlocProvider<ProductListBloc>(
        create: (context) {
          bloc =  ProductListBloc(productRepository)..add(ProductListStarted(widget.sort, widget.searchTerm));
          return bloc!;
        },
        child: BlocBuilder<ProductListBloc, ProductListState>(
          builder: (context, state) {
            if (state is ProductListSuccess){
              final products = state.products;
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(blurRadius: 20,
                      color: Colors.black.withOpacity(0.2))
                    ],
                    border: Border.all(color: Theme.of(context).dividerColor, width: 1)
                  ),
                  height: 56,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8),
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                          ),
                          context: context, builder: (context) {
                            return Container(
                              height: 300,
                              child: Column(
                                children: [
                                  if (widget.searchTerm.isEmpty)
                                  Text('انتخاب مرتب سازی', style: Theme.of(context).textTheme.titleLarge,),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: state.sortNames.length,
                                      itemBuilder: (context, index) {
                                      final seletedSortIndex = state.sort;
                                      return InkWell(
                                        onTap: () {
                                          bloc!.add(ProductListStarted(index, widget.searchTerm));
                                          Navigator.of(context).pop();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                          child: SizedBox(
                                            height: 32,
                                            child: Row(
                                              children: [
                                                Text(state.sortNames[index]),
                                                SizedBox(width: 8,),
                                                if (index == seletedSortIndex)
                                                  Icon(CupertinoIcons.check_mark_circled_solid, color: Theme.of(context).colorScheme.primary,)
                                                
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },),
                                  )
                                ],
                              ),
                            );
                        },);
                      },
                      child: Row(
                        children: [
                          Expanded(child: 
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                            IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.sort_down)),
                      
                            Column( 
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('مرتب سازی'),
                              Text(ProductSort.names[state.sort], style: Theme.of(context).textTheme.bodySmall,)
                            ],
                          ),
                          ],)),
                            
                      
                          Container(
                            width: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: IconButton(onPressed: (){
                              setState(() {
                               viewType =  viewType == ViewType.grid ? ViewType.list : ViewType.grid;
                              });
                            }, icon: const Icon(CupertinoIcons.square_grid_2x2)),
                          ),
                      
                          
                        ],
                      ),
                    ),
                  ),  
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.65,
                    crossAxisCount: viewType ==  ViewType.grid?2:1),
                  
                   itemBuilder: (context, index) {
                    final product = state.products[index];
                    return ProductItem(product: product, borderRadius: 0);
                  },),
                ),
              ],
            );
                }else if(state is ProductListEmpty){
                  return Center(
                    child: Text(state.message),
                  );
                }
                
                else {
                  return Center(child: CupertinoActivityIndicator(),);
                }
          },
        ),
      ),
    );
  }
}
