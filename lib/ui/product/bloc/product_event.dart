part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}


class CartAddButtonClicked extends ProductEvent{

  final int productId;

  const CartAddButtonClicked(this.productId);
}

