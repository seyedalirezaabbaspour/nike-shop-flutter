import 'package:dio/dio.dart';
import 'package:nike/common/exceptions.dart';

mixin HttpResponeValidator{

    validateRespone(Response response){

    if (response.statusCode != 200){
      throw AppException();
    }

  }
}