import 'package:equatable/equatable.dart';

class Photo extends Equatable {
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo(
      {required this.id,
      required this.title,
      required this.url,
      required this.thumbnailUrl});

  @override
  List<Object?> get props => [id, title, url, thumbnailUrl];
}
