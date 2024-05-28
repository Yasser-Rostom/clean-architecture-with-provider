import 'package:clean_architecture_provider_fetching_images/core/error/exceptions.dart';
import 'package:clean_architecture_provider_fetching_images/core/error/failures.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/data/datasources/photo_local_data_source.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/data/datasources/photo_remote_data_source.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/domain/entities/photo.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/domain/repo/photo_repository.dart';
import 'package:dartz/dartz.dart';


class PhotoRepositoryImpl implements PhotoRepository {
  final PhotoRemoteDataSource remoteDataSource;
  final PhotoLocalDataSource localDataSource;

  PhotoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Photo>>> getPhotos() async {
    try {
      final remotePhotos = await remoteDataSource.getPhotos();
      await localDataSource.cachePhotos(remotePhotos);
      return Right(remotePhotos);
    } on ServerException catch (e) {
      try {
        final localPhotos = await localDataSource.getCachedPhotos();
        return Right(localPhotos);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
      }
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error', statusCode: '500'));
    }
  }
}
