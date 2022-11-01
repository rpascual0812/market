import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';

import '../../../constants/index.dart';
import 'package:url_launcher/url_launcher.dart';
import 'article_tile.dart';

class ArticleList extends StatefulWidget {
  const ArticleList({
    Key? key,
  }) : super(key: key);

  @override
  State<ArticleList> createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  List articles = [];
  Map<Object, dynamic> dataJson = {};
  int intialIndex = 0;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    try {
      var res = await Remote.get('articles', {});
      // print('res $res');
      if (res.statusCode == 200) {
        setState(() {
          dataJson = jsonDecode(res.body);
          for (var i = 0; i < dataJson['data'].length; i++) {
            articles.add(dataJson['data'][i]);
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
          children: List.generate(articles.length, (index) {
            return articles.isNotEmpty
                ? ArticleTile(
                    article: articles[index],
                    onTap: () async {
                      ArtDialogResponse response = await ArtSweetAlert.show(
                          barrierDismissible: false,
                          context: context,
                          artDialogArgs: ArtDialogArgs(
                            denyButtonText: "Cancel",
                            title:
                                "You are about to leave Samdhana Community Market. Do you want to continue?",
                            confirmButtonText: "Continue",
                          ));

                      if (response.isTapConfirmButton) {
                        var url = Uri.parse(articles[index]['url']);
                        await launchUrl(url);
                        return;
                      }
                    },
                  )
                : const Text('No articles found');
          }),
        ),
        // children: const [
      ),
    );
  }
}
