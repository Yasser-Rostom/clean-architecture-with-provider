import 'package:clean_architecture_provider_fetching_images/core/error/failures.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/domain/entities/photo.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/domain/usecases/get_photos.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/presentation/providers/photo_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'photo_provider_test.mocks.dart';

@GenerateMocks([GetPhotosUseCase])
void main() {
  late PhotoProvider provider;
  late MockGetPhotosUseCase mockGetPhotosUseCase;

  setUp(() {
    mockGetPhotosUseCase = MockGetPhotosUseCase();
    provider = PhotoProvider(getPhotosUseCase: mockGetPhotosUseCase);
  });

  final photoList = [
    Photo(id: 1, title: 'Test Photo', url: 'https://via.placeholder.com/600/92c952', thumbnailUrl: 'https://via.placeholder.com/150/92c952'),
  ];

  test('should set photos when data is fetched successfully', () async {
    // Arrange
    when(mockGetPhotosUseCase()).thenAnswer((_) async => Right(photoList));

    // Act
    await provider.fetchPhotos();

    // Assert
    expect(provider.photos, photoList);
    expect(provider.errorMessage, isNull);
    expect(provider.isLoading, false);
    verify(mockGetPhotosUseCase());
  });

  test('should set error message when fetching data fails', () async {
    // Arrange
    when(mockGetPhotosUseCase()).thenAnswer((_) async => Left(ServerFailure(message: 'Server error', statusCode: '500')));

    // Act
    await provider.fetchPhotos();

    // Assert
    expect(provider.photos, isEmpty);
    expect(provider.errorMessage, '500: Server error');
    expect(provider.isLoading, false);
    verify(mockGetPhotosUseCase());
  });

  test('should set error message when fetching cache data fails', () async {
    // Arrange
    when(mockGetPhotosUseCase()).thenAnswer((_) async => Left(CacheFailure(message: 'Cache error', statusCode: '500')));

    // Act
    await provider.fetchPhotos();

    // Assert
    expect(provider.photos, isEmpty);
    expect(provider.errorMessage, '500: Cache error');
    expect(provider.isLoading, false);
    verify(mockGetPhotosUseCase());
  });
}