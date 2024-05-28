import 'package:clean_architecture_provider_fetching_images/core/error/failures.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/domain/entities/photo.dart';
import 'package:dartz/dartz.dart';

abstract class PhotoRepository {
  Future<Either<Failure, List<Photo>>> getPhotos();
}
