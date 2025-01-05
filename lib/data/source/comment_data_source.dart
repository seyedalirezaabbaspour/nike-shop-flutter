import 'package:dio/dio.dart';
import 'package:nike/data/comments.dart';
import 'package:nike/data/common/respone_validator.dart';

abstract class ICommentDataSource{

  Future<List<CommentEntity>> getAll({required int productId});
  Future<CommentEntity> insert(String title, String content, int productId);

}

class CommentRemoteDataSource with HttpResponeValidator implements ICommentDataSource{
  final Dio httpclient;

  CommentRemoteDataSource(this.httpclient);
  @override
  Future<List<CommentEntity>> getAll({required int productId}) async{
    final List<CommentEntity> comments = [];
    final response = await httpclient.get("/comment/list?product_id=$productId");
    validateRespone(response);


    (response.data as List).forEach((json) {
      comments.add(CommentEntity.fromJson(json));

    },);

    return comments;
  }
  
  @override
  Future<CommentEntity> insert(String title, String content, int productId) async{
    final response = await httpclient.post("comment/add", data: {
      "title":title,
      "content":content,
      "product_id":productId
    });
    validateRespone(response);

    return CommentEntity.fromJson(response.data);
  } 
  
}