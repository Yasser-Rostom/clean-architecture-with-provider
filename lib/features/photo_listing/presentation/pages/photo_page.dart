import 'package:clean_architecture_provider_fetching_images/features/photo_listing/presentation/widgets/list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/photo_provider.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
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
                  return Container(
                    margin: const EdgeInsets.fromLTRB(10,5,10,5),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [BoxShadow(color: Colors.grey,
                        spreadRadius: 1,

                          blurRadius:1
                      )]
                    ),
                    child: ListItem(
                      title: photo.title,
                      image: photo.thumbnailUrl,
                      rating: "4.4",
                      subtitle: "$index review(s)",
                    )
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

  @override
  void initState() {
    super.initState();
   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
     context.read<PhotoProvider>().fetchPhotos();

   });

  }
}
