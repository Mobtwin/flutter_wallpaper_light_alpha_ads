import 'package:wallpapers/model/data.dart';
import 'package:flutter/material.dart';
import 'package:wallpapers/services/local_storage.dart';

class DataProvider extends ChangeNotifier {
  Data data = Data();
  int score = 0;
  List<String> favoriteList = [];

  void setData(Data data) {
    this.data = data;
    notifyListeners();
  }

  Data getData() {
    return data;
  }

  //save favorite wallpaper
  void saveFavorite(String image) async {
    List<String> favorite = [];
    List<String>? firstList = await LocalStorage.getfavorite();
    if (firstList != null) {
      favorite = firstList;
    }
    if (favorite.contains(image)) {
      return;
    }
    favorite.add(image);
    LocalStorage.savefavorite(favorite);
    favoriteList = favorite;
    notifyListeners();
  }

  //get favorite wallpaper
  Future getfavorite() async {
    List<String>? favorite = await LocalStorage.getfavorite();
    if (favorite != null) {
      favoriteList = favorite;
    }
    notifyListeners();
  }

  //remove favorite wallpaper
  void removeFavorite(String image) async {
    List<String> favorite = [];
    List<String>? firstList = await LocalStorage.getfavorite();
    if (firstList != null) {
      favorite = firstList;
    }
    favorite.remove(image);
    LocalStorage.savefavorite(favorite);
    favoriteList = favorite;
    notifyListeners();
  }
}
