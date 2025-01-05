import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/comments.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/data/repo/comment_repository.dart';

part 'insert_comment_event.dart';
part 'insert_comment_state.dart';

class InsertCommentBloc extends Bloc<InsertCommentEvent, InsertCommentState> {
  final int productId;
  final ICommentRepository repository;
  InsertCommentBloc(this.repository, this.productId) : super(InsertCommentInitial()) {
    on<InsertCommentEvent>((event, emit) async{
      if (event is InsertCommentFormSubmit){

      if(!AuthRepository.isUserLoggedIn()){
        emit(InsertCommentError(AppException(message: "برای ثبت نظر باید وارد حساب کاربری خود شوید")));
      }else{

        if (event.title.isNotEmpty && event.content.isNotEmpty){
          emit(InsertCommentLoading());
          try {
            final comment = await repository.insert(event.title, event.content, productId);
            emit(InsertCommentSuccess(comment, 'نظر شما با موفقیت ثبت شد و پس از تایید منتشر خواهد شد' ));
          }  catch (e){
            emit(InsertCommentError(AppException()));
          }
        }else{
          emit(InsertCommentError(AppException(message: "لطفا تمامی فیلد ها را پر کنید")));
          }
      }
      }
    });
  }
}
