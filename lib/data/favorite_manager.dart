import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nike/data/product.dart';

final favoriteManager = FavoriteManager();

class FavoriteManager {
  static const _boxName = "favorites";
  final _box = Hive.box<ProductEntity>(_boxName);
  ValueListenable<Box<ProductEntity>> get listenable => Hive.box<ProductEntity>(_boxName).listenable(); 

  static init()async{
    await Hive.initFlutter();
    Hive.registerAdapter(ProductEntityAdapter());
    Hive.openBox<ProductEntity>(_boxName);
  }

  void addFavorite(ProductEntity product){
    _box.put(product.id, product);
  }

  void delete(ProductEntity product){
    _box.delete(product.id);
  }

  List<ProductEntity> get favorites => _box.values.toList();


  bool isFavorite(ProductEntity product){
    return _box.containsKey(product.id);
  }
}