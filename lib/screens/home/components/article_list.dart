import 'package:flutter/material.dart';
import 'package:market/screens/home/components/article_tile.dart';

class ArticleList extends StatelessWidget {
  const ArticleList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ArticleTile(
              name: 'World Food Technology',
              coverImage: 'https://i.imgur.com/RY6EHiXl.jpg',
              onTap: () {},
            ),
            ArticleTile(
              name: 'Agriculture News',
              coverImage: 'https://i.imgur.com/XeWg4Ny.jpg',
              onTap: () {},
            ),
            ArticleTile(
              name: 'Successful Farmin',
              coverImage: 'https://i.imgur.com/9VtNpc9.jpg',
              onTap: () {},
            ),
            ArticleTile(
              name: 'Another Article',
              coverImage: 'https://i.imgur.com/Uvt6wsC.jpg',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
