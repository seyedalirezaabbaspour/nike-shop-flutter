import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/product.dart';
import 'package:nike/data/repo/product_repository.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final IproductRepository repository;

  ProductListBloc(this.repository) : super(ProductListLoading()) {
    on<ProductListEvent>((event, emit) async{
      if (event is ProductListStarted){
        emit(ProductListLoading());
        try {
          final products =event.searchTerm.isEmpty? await repository.getAll(event.sort):await repository.search(event.searchTerm);
          if (products.isNotEmpty){
          emit(ProductListSuccess(products, event.sort, ProductSort.names));
          }else{
            emit(ProductListEmpty("محصولی یافت نشد"));
          }
        } catch (e) {
          emit(ProductListError(AppException()));
        }
      }
    });
  }
}
