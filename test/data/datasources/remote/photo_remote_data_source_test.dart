import 'dart:convert';

import 'package:clean_architecture_provider_fetching_images/core/error/exceptions.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/data/datasources/photo_remote_data_source.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/data/model/photo_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'photo_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late PhotoRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = PhotoRemoteDataSourceImpl(client: mockHttpClient);
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

    test('should return a list of PhotoModel when the call is successful', () async {
      // Arrange
      when(mockHttpClient.get(Uri.parse("https://jsonplaceholder.typicode.com/photos")))
          .thenAnswer((_) async => http.Response(jsonEncode(photoModelList), 200));

      // Act
      final result = await dataSource.getPhotos();

      // Assert
      expect(result, equals(photoModelList));
    });

    test('should throw a ServerException when the response code is not 200', () {
      // Arrange
      when(mockHttpClient.get(Uri.parse("https://jsonplaceholder.typicode.com/photos")))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      // Act
      final call = dataSource.getPhotos;

      // Assert
      expect(() => call(), throwsA(isInstanceOf<ServerException>()));
    });
  });
}
