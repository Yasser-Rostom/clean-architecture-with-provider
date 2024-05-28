import 'dart:convert';

import 'package:clean_architecture_provider_fetching_images/core/error/exceptions.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/data/datasources/photo_local_data_source.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/data/model/photo_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'photo_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late PhotoLocalDataSourceImpl photoLocalDataSourceImpl;
  final photoModelList = [
    PhotoModel(
      id: 1,
      title: 'Test Photo',
      url: 'https://via.placeholder.com/600/92c952',
      thumbnailUrl: 'https://via.placeholder.com/150/92c952',
    )
  ];

  const String cachedPhotosKey = 'cached_photos';
  final jsonString =
      jsonEncode(photoModelList.map((photo) => photo.toJson()).toList());
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    photoLocalDataSourceImpl =
        PhotoLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getPhotos', () {
    test("should throw CacheFailure", () async {
      when(mockSharedPreferences.getString(cachedPhotosKey)).thenThrow(
          (_) => const CacheException(message: 'No cached photos available'));

      expect(() => photoLocalDataSourceImpl.getCachedPhotos(),
          throwsA(isInstanceOf<CacheException>()));
      //to be used only with mocks objects
      verify(mockSharedPreferences.getString(cachedPhotosKey));
      verifyNoMoreInteractions(mockSharedPreferences);

    });
    test("should return Photomodel from the local db", () async {
      when(mockSharedPreferences.getString(cachedPhotosKey))
          .thenReturn(jsonString);

      expect(await photoLocalDataSourceImpl.getCachedPhotos(),
          equals(photoModelList));
    });
  });
  group('cachePhotos', () {
    test('should call SharedPreferences to cache the data', () async {
      // Arrange
      when(mockSharedPreferences.setString(cachedPhotosKey, jsonString))
          .thenAnswer((_) async => true);

      // Act
      await photoLocalDataSourceImpl.cachePhotos(photoModelList);

      // Assert
      verify(mockSharedPreferences.setString(
        cachedPhotosKey,
        jsonString,
      ));
    });
  });
}
