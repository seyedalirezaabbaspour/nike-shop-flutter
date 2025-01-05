import 'package:flutter/cupertino.dart';
import 'package:nike/common/http_client.dart';
import 'package:nike/data/auth_info.dart';
import 'package:nike/data/source/auth_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';


final authRepository = AuthRepository(AuthRemoteDataSource(httpclient));


abstract class IAuthRepository{
    Future<void> login(String username, String password);
  Future<void> signUp(String username, String password);
  Future<void> refreshToken();
  Future<void> signOut();
}


class AuthRepository  implements IAuthRepository{
  static final ValueNotifier<AuthInfo?> authChangeNotifier = ValueNotifier(null);
  final IAuthDataSource dataSource;

  AuthRepository(this.dataSource);
  

  static bool isUserLoggedIn(){
    return authChangeNotifier.value != null && authChangeNotifier.value!.accessToken.isNotEmpty && 
    authChangeNotifier.value!.accessToken!= null;
  } 
  @override
  Future<void> login(String username, String password) async{
    final AuthInfo authInfo= await dataSource.login(username, password);
    _persistAuthToken(authInfo);
  }

  @override
  Future<void> refreshToken() async{
    if (authChangeNotifier.value != null){
    final AuthInfo authInfo= await dataSource.refreshToken(authChangeNotifier.value!.refreshToken);
    _persistAuthToken(authInfo);
    
    }
  }

  @override
  Future<void> signUp(String username, String password) async{
    final AuthInfo authInfo= await dataSource.signUp(username, password);

    _persistAuthToken(authInfo);
  }


  Future<void> _persistAuthToken(AuthInfo authInfo) async{
    final SharedPreferences sharedPreferences =await SharedPreferences.getInstance();

    sharedPreferences.setString("access_token", authInfo.accessToken);
    sharedPreferences.setString("refresh_token", authInfo.refreshToken);
    sharedPreferences.setString("email", authInfo.email);

    loadAuthInfo();
  } 

  Future<void> loadAuthInfo() async{
    final SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
      final String accessToken =  sharedPreferences.getString("access_token")??"";
    final String refreshToken =  sharedPreferences.getString("refresh_token")??"";
    final String email =  sharedPreferences.getString("email")??"";

    if (accessToken.isNotEmpty && refreshToken.isNotEmpty){

    authChangeNotifier.value  = AuthInfo(accessToken, refreshToken,email );
    } 
    

  }
  
  @override
  Future<void> signOut() async{
    final SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    sharedPreferences.clear();

    authChangeNotifier.value = null;
  }
}