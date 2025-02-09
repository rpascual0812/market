import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market/screens/home/components/article_view.dart';

import '../../../components/network_image.dart';
import '../../../constants/index.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({
    super.key,
    required this.article,
    required this.onTap,
  });

  final Map<String, dynamic> article;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    var articleImage = '${dotenv.get('API')}/assets/images/no-image.jpg';
    if (article['article_document'] != null) {
      articleImage =
          '${dotenv.get('API')}/${article['article_document']['document']['path']}';
    }
    // print(articleImage);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDefaults.margin / 2),
      child: Column(
        children: [
          Material(
            color: Colors.white,
            // borderRadius: AppDefaults.borderRadius,
            // shape: RoundedRectangleBorder(
            //   // side: const BorderSide(width: 1),
            //   borderRadius: AppDefaults.borderRadius,
            // ),
            child: InkWell(
              // onTap: onTap,
              // borderRadius: AppDefaults.borderRadius,
              child: Container(
                decoration: const BoxDecoration(
                  // borderRadius: AppDefaults.borderRadius,
                  color: Colors.white,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 0,
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArticleView(
                                    article: article,
                                    callback: () {
                                      onTap();
                                    }),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 110,
                            height: 230,
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: NetworkImageWithLoader(
                                articleImage,
                                true,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                    Positioned(
                      bottom: 10,
                      child: Container(
                        width: 110,
                        height: 25,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          color: Colors.black45,
                        ),
                        child: InkWell(
                          onTap: onTap,
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 25, right: 10, top: 5, bottom: 5),
                            child: const Text(
                              'Read Article',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppDefaults.fontSize,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDefaults.margin / 4),
          Text(
            '${article['title'].substring(0, min(article['title'].toString().length, 18))} ${article['title'].toString().length > 18 ? '...' : ''}',
            style: const TextStyle(
              fontSize: AppDefaults.fontSize,
              color: AppColors.primary,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
