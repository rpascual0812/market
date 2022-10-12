import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/constants/index.dart';
import 'package:market/models/product_document.dart';
import 'package:market/models/slider.dart';

import '../../../size_config.dart';
import '../dot_indicators.dart';
import 'components/product_slider_slide.dart';

class ProductSlider extends StatefulWidget {
  const ProductSlider({Key? key, required this.documents}) : super(key: key);

  final List documents;

  @override
  State<ProductSlider> createState() => _ProductSliderState();
}

class _ProductSliderState extends State<ProductSlider> {
  List<Sliders> sliders = [];
  List<ProductDocuments> productDocuments = [];
  Map<Object, dynamic> slidesJson = {};
  int intialIndex = 0;
  final storage = const FlutterSecureStorage();
  String token = '';

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < widget.documents.length; i++) {
      productDocuments.add(ProductDocuments(
        pk: widget.documents[i]['pk'],
        userPk: widget.documents[i]['user_pk'],
        productPk: widget.documents[i]['product_pk'],
        type: widget.documents[i]['type'],
        documentPk: widget.documents[i]['document_pk'],
        dateCreated: DateTime.parse(widget.documents[i]['date_created']),
        document: widget.documents[i]['document'],
      ));
      // print(slides['data'][i]);
    }

    getSlides();
    readStorage();
  }

  Future<void> readStorage() async {
    final all = await storage.read(key: 'jwt');

    setState(() {
      token = all ?? '';
      if (token != '') {}
    });
  }

  Future<void> getSlides() async {
    try {
      var res = await Remote.get('sliders', {});
      print('sliders $res');
      if (res.statusCode == 200) {
        setState(() {
          slidesJson = jsonDecode(res.body);
          for (var i = 0; i < slidesJson['data'].length; i++) {
            sliders.add(Sliders(
              pk: slidesJson['data'][i]['pk'],
              type: slidesJson['data'][i]['type'],
              title: slidesJson['data'][i]['title'],
              details: slidesJson['data'][i]['details'],
              userPk: slidesJson['data'][i]['user_pk'],
              sliderDocument: slidesJson['data'][i]['slider_document'],
            ));
            // print(slides['data'][i]);
          }
          // print('count ${slides['data'].length}');
          // print('slides ${slides['data']}');
          // slides = jsonDecode(json['data']);
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
    return AspectRatio(
      aspectRatio: 1.21,
      child: Stack(
        children: [
          PageView.builder(
            onPageChanged: (value) {
              setState(() {
                intialIndex = value;
              });
            },
            itemCount: widget.documents.length,
            itemBuilder: (context, index) {
              return ProductSliderSlide(
                pk: productDocuments[index].pk,
                userPk: productDocuments[index].userPk,
                productPk: productDocuments[index].productPk,
                type: productDocuments[index].type,
                documentPk: productDocuments[index].documentPk,
                dateCreated: productDocuments[index].dateCreated,
                document: productDocuments[index].document,
              );
            },
          ),
          Positioned(
            bottom: getProportionateScreenWidth(15),
            right: (MediaQuery.of(context).size.width / 2) -
                (15 * widget.documents.length),
            child: Row(
              children: List.generate(
                widget.documents.length,
                (index) => DotIndicator(
                  isActive: intialIndex == index,
                  activeColor: Colors.white,
                  inActiveColor: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
