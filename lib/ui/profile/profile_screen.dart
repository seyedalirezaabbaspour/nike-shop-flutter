import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike/data/auth_info.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/ui/auth/auth.dart';
import 'package:nike/ui/favorite/favorite_screen.dart';
import 'package:nike/ui/order/order_history_screen.dart';

class ProfileScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("پروفایل"),
      ),
      body: ValueListenableBuilder<AuthInfo?>(
        valueListenable: AuthRepository.authChangeNotifier,
        builder: (context, authInfo, child) {
          final isLogin = authInfo != null && authInfo.accessToken.isNotEmpty;
          return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Container(
              width: 65,
              height: 65,
              margin: EdgeInsets.only(top: 32, bottom: 8),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).dividerColor, width: 1)
              ),
              child: Image.asset("assets/img/nike_logo.png")),
              Text(isLogin? authInfo.email:"کاربر میهمان"),
              const SizedBox(height: 32,),
              Divider(height: 1, color: Theme.of(context).dividerColor,),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => FavoriteListScreen(),)); 
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  height: 56  ,
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.heart),
                      SizedBox(width: 16,),
                      Text("لیست علافه مندی ها")
                    ],
                  ),
                ),
              ),
        
              Divider(height: 1, color: Theme.of(context).dividerColor,),
        
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderHistoryScreen(),));
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  height: 56  ,
                  child: const Row(
                    children: [
                      Icon(CupertinoIcons.cart),
                      SizedBox(width: 16,),
                      Text("سوابق سفارش")
                    ],
                  ),
                ),
              ),
              Divider(height: 1, color: Theme.of(context).dividerColor,),
        
        
              InkWell(
                onTap: () {
                  if(isLogin) {
                    showDialog(
                    useRootNavigator: true,
                    context: context, builder: (context) {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: AlertDialog(
                        title: Text("خروج از حساب کاربری"),
                        content: Text("آیا می خواهید از حساب خود خارج شوید؟"),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                          }, child: Text("خیر")),
                          TextButton(onPressed: (){
                            Navigator.pop(context);
                            CartRepository.cartItemCountNotifier.value=0;
                            authRepository.signOut();
                          }, child: Text("بله")),
                        ],
                      ),
                    );
                  },);
                  }else{
                    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => AuthScreen(),));
                  }
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  height: 56  ,
                  child:  Row(
                    children: [
                      Icon(isLogin?CupertinoIcons.arrow_right_square:CupertinoIcons.arrow_left_square),
                      SizedBox(width: 16,),
                      Text(isLogin?"خروج از حساب کاربری":"ورود به حساب کاربری")
                    ],
                  ),
                ),
              ),
              Divider(height: 1, color: Theme.of(context).dividerColor,),
        
          ],),
        );
        },
      ),
    );
  }
}