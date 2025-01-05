import 'package:dio/dio.dart';
import 'package:nike/data/banner.dart';
import 'package:nike/data/common/api_token.dart';
import 'package:nike/data/common/respone_validator.dart';


abstract class IBannerDataSource{

  Future<List<BannerEntity>> getAll();

}

class BannerRemoteDataSource with HttpResponeValidator  implements IBannerDataSource{
  final Dio httpclient;

  BannerRemoteDataSource(this.httpclient);
  
  @override
  Future<List<BannerEntity>> getAll() async{
    final response = await httpclient.get('banner/slider',
    options: Options(headers:{"Authorization":"Bearer $token"},)
    );

    validateRespone(response);

    final banners = <BannerEntity>[];

    (response.data as List).forEach((json) {
      banners.add(BannerEntity.fromJson(json));
    },);

    return banners;
  }


}