
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  String title,subtitle,rating;
  String image;
  ListItem({required this.title,required this.image,required this.rating, required this.subtitle, super.key});
  final orangeColor = const Color(0xffFF8527);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CachedNetworkImage(
            imageUrl:image,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )),
      title: Text(title),
      subtitle: Row(
        children: [
          Icon(
            Icons.favorite,
            size: 15,
            color: orangeColor,
          ),
          Text(" $rating | "),
          Text(subtitle),
        ],
      ),
      trailing: const Column(
        children: [
          Icon(Icons.more_vert_outlined),
        ],
      ),
    );
  }
}
