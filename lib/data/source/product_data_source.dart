import 'package:dio/dio.dart';
import 'package:nike/data/common/api_token.dart';
import 'package:nike/data/common/respone_validator.dart';
import 'package:nike/data/product.dart';


abstract class IProductDataSource {
  Future<List<ProductEntity>> getAll(int sort);
  Future<List<ProductEntity>> search(String searchTerm);
}

class ProductRemoteDataSource with HttpResponeValidator implements IProductDataSource{

  final Dio httpclient;

  ProductRemoteDataSource(this.httpclient);

  @override
  Future<List<ProductEntity>> getAll(int sort) async{
    final response = await httpclient.get('product/list?sort=$sort',
    options: Options(headers:{"Authorization":"Bearer $token"},)
    );
    validateRespone(response);
    final products = <ProductEntity>[];
    (response.data as List).forEach((json) {
      products.add(ProductEntity.fromJson(json));
    },);

    return products;
  }

  @override
  Future<List<ProductEntity>> search(String searchTerm) async{
    final response = await httpclient.get('product/search?q=$searchTerm',
    options: Options(headers:{"Authorization":"Bearer $token"},)
    );
    validateRespone(response);
    final products = <ProductEntity>[];
    (response.data  as List).forEach((json) {
      products.add(ProductEntity.fromJson(json));
    },);

    return products;
  }

}