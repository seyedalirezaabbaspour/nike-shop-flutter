import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/repo/cart_repository.dart';
import 'package:nike/data/repo/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ICartRepository cartRepository;

  ProductBloc(this.cartRepository) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async{
      if (event is CartAddButtonClicked){
        try {
        emit(ProductAddToCartButtonLoading());

        final result =await cartRepository.add(event.productId);

        await cartRepository.count();

        emit(ProductAddToCartSuccess());
        } catch (e) {
          emit(ProductAddToCartError(AppException()));
        }
      }
    });
  }
}
