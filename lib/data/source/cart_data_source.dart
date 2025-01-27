

import 'package:dio/dio.dart';
import 'package:nike/data/cart_item.dart';
import 'package:nike/data/add_to_cart_response.dart';
import 'package:nike/data/cart_response.dart';
import 'package:nike/data/repo/cart_repository.dart';

abstract class ICartDataSource {

  Future<AddToCartResponse> add(int productId);
  Future<AddToCartResponse> changeCount(int cartItemId, int count);
  Future<void> delete(int cartItemId);

  Future<int> count();

  Future<CartResponse> getAll();
}


class CartRemoteDataSource implements ICartDataSource{
  final Dio httpclient;

  CartRemoteDataSource(this.httpclient);
  @override
  Future<AddToCartResponse> add(int productId) async{
    final response =await httpclient.post("cart/add", data: {
      "product_id":productId
    });

    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<AddToCartResponse> changeCount(int cartItemId, int count) async{
    final response = await httpclient.post("cart/changeCount", data: {
      "cart_item_id":cartItemId,
      "count":count});

    return AddToCartResponse.fromJson(response.data);
  }

  @override
  Future<int> count() async{
    final response =await  httpclient.get("cart/count");
    return response.data["count"];
  }

  @override
  Future<void> delete(int cartItemId) async{
    await httpclient.post("cart/remove", data: {
      "cart_item_id":cartItemId
    });
  }

  @override
  Future<CartResponse> getAll() async{
    final response = await httpclient.get("cart/list");

    return CartResponse.fromJson(response.data);
  }
}