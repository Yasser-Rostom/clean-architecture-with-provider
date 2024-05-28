import 'package:clean_architecture_provider_fetching_images/core/error/exceptions.dart';
import 'package:clean_architecture_provider_fetching_images/core/error/failures.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/data/datasources/photo_local_data_source.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/data/datasources/photo_remote_data_source.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/data/model/photo_model.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/data/repo/photo_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';

import 'photo_repository_impl_test.mocks.dart';

@GenerateMocks([PhotoRemoteDataSource, PhotoLocalDataSource])
void main() {
  late PhotoRepositoryImpl repository;
  late MockPhotoRemoteDataSource mockRemoteDataSource;
  late MockPhotoLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockPhotoRemoteDataSource();
    mockLocalDataSource = MockPhotoLocalDataSource();
    repository = PhotoRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('getPhotos', () {
    final photoModelList = [
      PhotoModel(
        id: 1,
        title: 'Test Photo',
        url: 'https://via.placeholder.com/600/92c952',
        thumbnailUrl: 'https://via.placeholder.com/150/92c952',
      )
    ];

    test('should return remote photos when the call is successful', () async {
      // Arrange
      when(mockRemoteDataSource.getPhotos()).thenAnswer((_) async => photoModelList);

      // Act
      final result = await repository.getPhotos();

      // Assert
      expect(result, Right(photoModelList));
      verify(mockRemoteDataSource.getPhotos());
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return local photos when remote call fails and cache is available', () async {
      // Arrange
      when(mockRemoteDataSource.getPhotos()).thenThrow(const ServerException(message: 'Server error', statusCode: '500'));
      when(mockLocalDataSource.getCachedPhotos()).thenAnswer((_) async => photoModelList);

      // Act
      final result = await repository.getPhotos();

      // Assert
      expect(result, Right(photoModelList));
      verify(mockRemoteDataSource.getPhotos());
      verify(mockLocalDataSource.getCachedPhotos());
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
    });

    test('should return cache failure when both remote and cache calls fail', () async {
      // Arrange
      when(mockRemoteDataSource.getPhotos()).thenThrow(const ServerException(message: 'Server error', statusCode: '500'));
      when(mockLocalDataSource.getCachedPhotos()).thenThrow(const CacheException(message: 'Failed to load cached photos', statusCode: 500));

      // Act
      final result = await repository.getPhotos();

      // Assert
      expect(result, Left(CacheFailure(message: 'Failed to load cached photos', statusCode: 500)));
      verify(mockRemoteDataSource.getPhotos());
      verify(mockLocalDataSource.getCachedPhotos());
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyNoMoreInteractions(mockLocalDataSource);
    });
  });
}