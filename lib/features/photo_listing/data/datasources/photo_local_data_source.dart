import 'dart:convert';

import 'package:clean_architecture_provider_fetching_images/core/error/exceptions.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/data/model/photo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PhotoLocalDataSource {
  Future<List<PhotoModel>> getCachedPhotos();

  Future<void> cachePhotos(List<PhotoModel> photos);
}

class PhotoLocalDataSourceImpl implements PhotoLocalDataSource {
  final SharedPreferences sharedPreferences;

  PhotoLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<PhotoModel>> getCachedPhotos() async {
    try {
      final jsonString = sharedPreferences.getString('cached_photos');
      if (jsonString != null) {
        final List<dynamic> jsonData = json.decode(jsonString);
        final List<PhotoModel> cachedPhotos =
            jsonData.map((json) => PhotoModel.fromJson(json)).toList();
        return cachedPhotos;
      } else {
        throw const CacheException(message: 'No cached photos available');
      }
    } catch (e) {
      throw CacheException(message: 'Failed to load cached photos: $e');
    }
  }

  @override
  Future<void> cachePhotos(List<PhotoModel> photos) async {
    try {
      final List<Map<String, dynamic>> jsonData =
          photos.map((photo) => photo.toJson()).toList();
      final jsonString = json.encode(jsonData);
      await sharedPreferences.setString('cached_photos', jsonString);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}
