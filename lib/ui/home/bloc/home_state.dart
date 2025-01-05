part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

final class HomeLoading extends HomeState {}

class HomeError extends HomeState{

  final AppException exception;

  const HomeError({required this.exception});

  @override
  List<Object> get props => [exception];
}

class HomeSuccess extends HomeState{
  final List<BannerEntity> banners;
  final List<ProductEntity> latesProducts;
  final List<ProductEntity> popularProducts;

  HomeSuccess({required this.banners, required this.latesProducts, required this.popularProducts});

}


