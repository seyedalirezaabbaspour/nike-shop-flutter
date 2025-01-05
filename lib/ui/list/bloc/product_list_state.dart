part of 'product_list_bloc.dart';

sealed class ProductListState extends Equatable {
  const ProductListState();
  
  @override
  List<Object> get props => [];
}

final class ProductListLoading extends ProductListState {}


class ProductListError extends ProductListState{
  final AppException exception;

  const ProductListError(this.exception);

  @override
  List<Object> get props => [exception];
}

class ProductListSuccess extends ProductListState{
  final List<ProductEntity> products;
  final int sort;
  final List<String> sortNames;

  const ProductListSuccess(this.products, this.sort, this.sortNames);
  @override
  List<Object> get props => [products, sort, sortNames];
}

class ProductListEmpty extends ProductListState{
  final String message;

  const ProductListEmpty(this.message);

  @override
  List<Object> get props => [message];
}