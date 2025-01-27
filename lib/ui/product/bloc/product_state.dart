part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();
  
  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

class ProductAddToCartButtonLoading extends ProductState{}

class ProductAddToCartSuccess extends ProductState{}

class ProductAddToCartError extends ProductState{
  final AppException exception;

  ProductAddToCartError(this.exception);
  
  @override
  List<Object> get props => [exception];
}