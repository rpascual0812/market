import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/constants/index.dart';
import 'package:market/models/slider.dart';

import '../../../size_config.dart';
import '../dot_indicators.dart';
import 'components/home_slider_slide.dart';

class HomeSlider extends StatefulWidget {
  const HomeSlider({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  List<Sliders> sliders = [];
  Map<Object, dynamic> slidesJson = {};
  int intialIndex = 0;
  final storage = const FlutterSecureStorage();
  String token = '';

  @override
  void initState() {
    super.initState();
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
            itemCount:
                slidesJson['data'] != null ? slidesJson['data'].length : 0,
            itemBuilder: (context, index) {
              return HomeSliderSlide(
                pk: sliders[index].pk,
                type: sliders[index].type,
                title: sliders[index].title,
                details: sliders[index].details,
                userPk: sliders[index].userPk,
                sliderDocument: sliders[index].sliderDocument,
              );
            },
          ),
          Positioned(
            bottom: getProportionateScreenWidth(15),
            right: getProportionateScreenWidth(15),
            child: Row(
              children: List.generate(
                slidesJson['data'] != null ? slidesJson['data'].length : 0,
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
