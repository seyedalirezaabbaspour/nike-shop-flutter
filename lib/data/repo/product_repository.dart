import 'package:nike/common/http_client.dart';
import 'package:nike/data/product.dart';
import 'package:nike/data/source/product_data_source.dart';

final productRepository = ProductRepository(ProductRemoteDataSource(httpclient)) ;

abstract class IproductRepository{
  Future<List<ProductEntity>> getAll(int sort);
  Future<List<ProductEntity>> search(String searchTerm);
}


class ProductRepository implements IproductRepository{

  final IProductDataSource dataSource;

  ProductRepository(this.dataSource);

  @override
  Future<List<ProductEntity>> getAll(int sort) => dataSource.getAll(sort);

  @override
  Future<List<ProductEntity>> search(String searchTerm) => dataSource.search(searchTerm);


}