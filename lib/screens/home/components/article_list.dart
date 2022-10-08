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
  List<Articles> articles = [];
  Map<Object, dynamic> articleJson = {};
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
          articleJson = jsonDecode(res.body);
          for (var i = 0; i < articleJson['data'].length; i++) {
            articles.add(Articles(
              pk: articleJson['data'][i]['pk'],
              title: articleJson['data'][i]['title'],
              description: articleJson['data'][i]['description'],
              articleDocument: articleJson['data'][i]['article_document'],
              userPk: articleJson['data'][i]['user_pk'],
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
              articleJson['data'] != null ? articleJson['data'].length : 0,
              (index) {
            return ArticleTile(
              title: articles[index].title,
              description: articles[index].description,
              articleDocument: articles[index].articleDocument,
              onTap: () {},
            );
          }),
        ),
        // children: const [
      ),
    );
  }
}
