import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/photo_provider.dart';

class PhotoPage extends StatelessWidget {
  const PhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photos'),
      ),
      body: Center(
        child: Consumer<PhotoProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) => ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.white,
                    ),
                    title: Container(
                      width: double.infinity,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    subtitle: Container(
                      width: double.infinity,
                      height: 10.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            } else if (provider.photos.isEmpty) {
              return const Text('No photos available');
            } else {
              return ListView.builder(
                itemCount: provider.photos.length,
                itemBuilder: (context, index) {
                  final photo = provider.photos[index];
                  return ListTile(
                    leading: CachedNetworkImage(
                      imageUrl: photo.thumbnailUrl,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    title: Text(photo.title),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<PhotoProvider>().fetchPhotos();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
