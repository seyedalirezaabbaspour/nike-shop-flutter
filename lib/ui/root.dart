import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/ui/cart/cart.dart';
import 'package:nike/ui/home/home.dart';
import 'package:nike/ui/profile/profile_screen.dart';
import 'package:nike/ui/widgets/badge.dart';

const homeIndex = 0;
const cartIndex = 1;
const profileIndex = 2;

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int selectedScreenIndex = homeIndex;

  final List<int> _history = [];
  GlobalKey<NavigatorState> _homeKey = GlobalKey();
  GlobalKey<NavigatorState> _cartKey = GlobalKey();
  GlobalKey<NavigatorState> _profileKey = GlobalKey();

  late final map = {
    homeIndex: _homeKey,
    cartIndex: _cartKey,
    profileIndex: _profileKey
  };


  Future<bool> _onWillPop() async {
    final NavigatorState currentSelectedTabNavigatorState = map[selectedScreenIndex]!.currentState!;
    
    if (currentSelectedTabNavigatorState.canPop()){
      currentSelectedTabNavigatorState.pop();
      return false;
    }
    else if(_history.isNotEmpty){
      setState(() {
        selectedScreenIndex = _history.last;
        _history.removeLast();
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async{
      if (didPop) return;
      final navigator = Navigator.of(context);
      bool value = await _onWillPop();
      if (value) {
    navigator.pop(result);
          }
      },
        child: Scaffold(
      body: IndexedStack(
                index: selectedScreenIndex,
                children: [
                  _navigator(_homeKey, homeIndex,  HomeScreen()),
                  _navigator(_cartKey, cartIndex, const CartScreen()),
                  _navigator(_profileKey, profileIndex,  ProfileScreen(),)
                ],
              ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedScreenIndex,
        onTap: (selectedIndex) {
          setState(() {
          _history.remove(selectedScreenIndex);
          _history.add(selectedScreenIndex);

          selectedScreenIndex = selectedIndex;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: "خانه"),
          BottomNavigationBarItem(icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(CupertinoIcons.cart),
              Positioned(
                right: -10,
                child: ValueListenableBuilder<int>(
                  valueListenable: CartRepository.cartItemCountNotifier,
                  builder: (context, value, child) {
                    return BadgeCart(value: value);
                  })),
            ],
          ), label: "سبد خرید"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.person), label: "پروفایل"),
        ]),
    ));
  }


  Widget _navigator(GlobalKey key, int index, Widget child) {
    return key.currentState==null &&selectedScreenIndex != index?Container():Navigator(
                    key: key,
                    onGenerateRoute: (setting) => MaterialPageRoute(
                        builder: (context) => Offstage(
                          offstage: selectedScreenIndex != index,
                          child:child)));
  }

  @override
  void initState() {
    cartRepository.count();
    super.initState();
  }
}
