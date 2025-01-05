

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/banner.dart';
import 'package:nike/data/product.dart';
import 'package:nike/data/repo/banner_repository.dart';
import 'package:nike/data/repo/product_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IBannerRepository bannerRepository;
  final IproductRepository productRepository;

  HomeBloc(this.bannerRepository, this.productRepository)
      : super(HomeLoading()) {
    on<HomeEvent>((event, emit) async{

       if (event is HomeStarted || event is HomeRefresh) {
        try {
          emit(HomeLoading());
          final banners = await bannerRepository.getAll();
          final latestProducts =
              await productRepository.getAll(ProductSort.lates);
          final popularProducts =
              await productRepository.getAll(ProductSort.popular);
          emit(HomeSuccess(
              banners: banners,
              latesProducts: latestProducts,
              popularProducts: popularProducts));
              
        } catch (e) {
          emit(HomeError(exception: e is AppException ? e : AppException()));
        }
        }
      }
    );
  }
}
