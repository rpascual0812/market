import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market/models/article.dart';

import '../../../constants/index.dart';
import 'article_tile.dart';

class ArticleList extends StatefulWidget {
  const ArticleList({
    Key? key,
  }) : super(key: key);

  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  List<Articles> articleList = [];
  Map<Object, dynamic> articles = {};
  int intialIndex = 0;

  @override
  void initState() {
    super.initState();
    getArticles();
  }

  Future<void> getArticles() async {
    try {
      var res = await Remote.get('articles');
      // print('res $res');
      if (res.statusCode == 200) {
        setState(() {
          articles = jsonDecode(res.body);
          for (var i = 0; i < articles['data'].length; i++) {
            articleList.add(Articles(
              pk: articles['data'][i]['pk'],
              title: articles['data'][i]['title'],
              description: articles['data'][i]['description'],
              articleDocument: articles['data'][i]['article_document'],
              userPk: articles['data'][i]['user_pk'],
            ));
            // print('articles $articles');
          }
        });
      } else if (res.statusCode == 401) {
        if (!mounted) return;
        AppDefaults.logout(context);
      }
      // if (res.statusCode == 200) return res.body;
      return;
    } on Exception catch (exception) {
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
              articles['data'] != null ? articles['data'].length : 0, (index) {
            return ArticleTile(
              title: articleList[index].title,
              description: articleList[index].description,
              articleDocument: articleList[index].articleDocument,
              onTap: () {},
            );
          }),
        ),
        // children: const [

        //   // PageView.builder(
        //   //   onPageChanged: (value) {
        //   //     setState(() {
        //   //       intialIndex = value;
        //   //     });
        //   //   },
        //   //   itemCount: articles['data'] != null ? articles['data'].length : 0,
        //   //   itemBuilder: (context, index) {
        //   //     return ArticleTile(
        //   //       name: 'World Food Technology',
        //   //       coverImage: 'https://i.imgur.com/RY6EHiXl.jpg',
        //   //       onTap: () {},
        //   //     );
        //   //   },
        //   // ),
        //   // ArticleTile(
        //   //   name: 'World Food Technology',
        //   //   coverImage: 'https://i.imgur.com/RY6EHiXl.jpg',
        //   //   onTap: () {},
        //   // ),
        //   // ArticleTile(
        //   //   name: 'Agriculture News',
        //   //   coverImage: 'https://i.imgur.com/XeWg4Ny.jpg',
        //   //   onTap: () {},
        //   // ),
        //   // ArticleTile(
        //   //   name: 'Successful Farmin',
        //   //   coverImage: 'https://i.imgur.com/9VtNpc9.jpg',
        //   //   onTap: () {},
        //   // ),
        //   // ArticleTile(
        //   //   name: 'Another Article',
        //   //   coverImage: 'https://i.imgur.com/Uvt6wsC.jpg',
        //   //   onTap: () {},
        //   // ),
        // ],
        // ),
      ),
    );
  }
}
