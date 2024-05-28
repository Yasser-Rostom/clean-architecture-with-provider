import 'package:clean_architecture_provider_fetching_images/core/error/failures.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/domain/entities/photo.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/domain/repo/photo_repository.dart';
import 'package:dartz/dartz.dart';


class GetPhotosUseCase {
  final PhotoRepository repository;

  GetPhotosUseCase(this.repository);

  Future<Either<Failure, List<Photo>>> call() async {
    return await repository.getPhotos();
  }
}
