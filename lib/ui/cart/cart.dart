import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/ui/auth/auth.dart';
import 'package:nike/ui/cart/bloc/cart_bloc.dart';
import 'package:nike/ui/cart/cart_item.dart';
import 'package:nike/ui/cart/price_info.dart';
import 'package:nike/ui/shipping/shipping.dart';
import 'package:nike/ui/widgets/empty_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc? cartBloc;
  StreamSubscription? stateStreamSubscription;
  bool stateIsSucces = false;

  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener,);
  }

  @override
  void dispose() {
    super.dispose();
    stateStreamSubscription?.cancel();
    AuthRepository.authChangeNotifier.removeListener(authChangeNotifierListener);
    cartBloc?.close();
  }

  void authChangeNotifierListener(){
    cartBloc?.add(CartAuthInfoChanged(AuthRepository.authChangeNotifier.value));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: stateIsSucces,
        child: Container(
          margin: EdgeInsets.only(left: 48, right: 48),
          width: MediaQuery.of(context).size.width,
          child: FloatingActionButton.extended(onPressed: (){

            final state = cartBloc!.state;

            if (state is CartSuccess){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
             ShippingScreen(payablePrice: state.cartResponse.payablePrice,
             totalPrice: state.cartResponse.totalPrice,
             shippingCost: state.cartResponse.shippingCost,),));
            }

          }, label: Text('پرداخت'))),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: const Color(0xfff5f5f5),
        appBar: AppBar(
          centerTitle: true,
          title: const Text("سبد خرید"),
        ),
        body: BlocProvider<CartBloc>(
          create: (context) {
            final bloc = CartBloc(cartRepository);
            stateStreamSubscription = bloc.stream.listen((state) {
              
                setState(() {
                  stateIsSucces = state is CartSuccess;
                });

              if(_refreshController.isRefresh){
                if (state is CartSuccess){
                  _refreshController.refreshCompleted();
                }else if(state is CartError){
                  _refreshController.refreshFailed();
                }
              }
            },);
            cartBloc = bloc;
            bloc.add(CartStarted(AuthRepository.authChangeNotifier.value));
            return bloc;
          },
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is CartError) {
                return Center(
                  child: Text(state.exception.message),
                );
              } else if (state is CartSuccess) {
                return SmartRefresher(
                  header: const ClassicHeader(
                    completeText: 'با موفقیت انجام شد',
                    refreshingText: 'در حال بروزرسانی',
                    idleText: 'برای بروزرسانی پایین بکشید',
                    releaseText: 'رها کنید',
                    failedText: 'خطای نامشخص',
                    spacing: 2,
                  ),
                  onRefresh: () {
                    cartBloc?.add(CartStarted(AuthRepository.authChangeNotifier.value, isRefreshing: true));
                  },
                  controller: _refreshController,
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 80),
                    itemCount: state.cartResponse.cartItems.length+1,
                    itemBuilder: (context, index) {

                      if (index < state.cartResponse.cartItems.length){

                      final data = state.cartResponse.cartItems[index];
                  
                      return CartItem(data: data, onDeleteButtonClicked: () {
                        cartBloc?.add(CartDeleteButtonClicked(data.id));
                      },
                      onIncreaseButtonClicked: () {
                        cartBloc?.add(CartIncreaseCountButtonClicked(data.id));
                      },
                      onDecreaseButtonClicked: () {
                        if (data.count > 1){
                        cartBloc?.add(CartDecreaseCountButtonClicked(data.id));
                        }
                      },
                      );
                      }else{
                        return PriceInfo(payablePrice: state.cartResponse.payablePrice,
                        totalPrice: state.cartResponse.totalPrice,
                        shippingCost: state.cartResponse.shippingCost,);
                      }
                    },
                  ),
                );
              } else if (state is CartAuthRequired){
                return EmptyView(message: "برای مشاهده ی سبد خرید ابتدا وارد حساب کاربری خود شوید",
                 callToAction: ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AuthScreen(),));
                 }, child: const Text("ورود به حساب کاربری")),
                  image: SvgPicture.asset("assets/img/auth_required.svg", width: 140,));
                
              }else if (state is CartEmpty){
                return EmptyView(message: "تا کنون هیچ محصولی به سبد خرید خود اضافه نکرده اید",
                  image: SvgPicture.asset("assets/img/empty_cart.svg", width: 200,));
              }
              else{
                throw Exception("current state is not valid...");
              }
            },
          ),
        )

        // ValueListenableBuilder<AuthInfo?>(
        //   valueListenable: AuthRepository.authChangeNotifier,
        //   builder: (context, authState, child) {
        //     final bool isAuthenticated = authState!=null && authState.accessToken.isNotEmpty;
        //     return SizedBox(
        //       width: MediaQuery.of(context).size.width,
        //       child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         Text(isAuthenticated?"خوش آمدید":"لطفا وارد حساب کاربری خود شوید"),

        //         (!isAuthenticated) ?
        //           ElevatedButton(onPressed: (){
        //           Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => AuthScreen(),));
        //         }, child: Text('ورود'))
        //         : ElevatedButton(onPressed: (){
        //           authRepository.signOut();
        //         }, child: Text('خروج از حساب کاربری'))

        //       ],
        //               ),
        //     );
        //   },
        // ),
        );
  }
}

