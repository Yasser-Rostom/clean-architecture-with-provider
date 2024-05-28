import 'package:clean_architecture_provider_fetching_images/core/error/exceptions.dart';
import 'package:clean_architecture_provider_fetching_images/features/photo_listing/data/model/photo_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class PhotoRemoteDataSource {
  Future<List<PhotoModel>> getPhotos();
}

class PhotoRemoteDataSourceImpl implements PhotoRemoteDataSource {
  final http.Client client;

  PhotoRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PhotoModel>> getPhotos() async {
try{
  final response = await client.get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    final List<PhotoModel> photos = jsonData.map((json) => PhotoModel.fromJson(json)).toList();
    return photos;
  } else {
    throw  ServerException(message: 'Failed to load photos', statusCode: response.statusCode.toString() );
  }
}catch (e){
  throw  ServerException(message: e.toString(),
    statusCode: 'Unknown Error');
}
   
  }
}
