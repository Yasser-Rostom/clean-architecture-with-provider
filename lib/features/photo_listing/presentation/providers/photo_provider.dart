import 'package:clean_architecture_provider_fetching_images/core/error/failures.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/domain/entities/photo.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/domain/usecases/get_photos.dart';
import 'package:flutter/material.dart';

class PhotoProvider with ChangeNotifier {
  final GetPhotosUseCase getPhotosUseCase;

  List<Photo> _photos = [];
  List<Photo> get photos => _photos;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  PhotoProvider({required this.getPhotosUseCase});

  Future<void> fetchPhotos() async {
    _isLoading = true;
    notifyListeners();

    final result = await getPhotosUseCase();
    result.fold(
          (failure) {
        if (failure is ServerFailure) {
          _errorMessage = failure.errorMessage;
        } else if (failure is CacheFailure) {
          _errorMessage = failure.errorMessage;
        } else {
          _errorMessage = 'Unexpected error';
        }
        _photos = [];
      },
          (photos) {
        _photos = photos;
        _errorMessage = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }
}
