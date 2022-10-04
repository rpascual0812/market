import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market/components/sliders/components/home_slider_slide.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../size_config.dart';
import '../dot_indicators.dart';

class HomeSlider extends StatefulWidget {
  const HomeSlider({
    Key? key,
    required this.images,
  }) : super(key: key);

  final List images;

  @override
  State<HomeSlider> createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  int intialIndex = 0;
  final storage = const FlutterSecureStorage();
  String token = '';

  @override
  void initState() {
    super.initState();
    readStorage();
  }

  Future<void> readStorage() async {
    final all = await storage.read(key: 'jwt');

    setState(() {
      token = all!;

      if (token != '') {
        getSliders();
      }
    });
  }

  Future<void> getSliders() async {
    try {
      var body = json.decode(token);
      final url = Uri.parse('${dotenv.get('API')}/sliders');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${body['user']['access_token']}',
      };

      var res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        final result = json.decode(res.body);
        setState(() {
          print(result);
        });
      }
      // if (res.statusCode == 200) return res.body;
      return;
    } on Exception {
      return;
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
            itemCount: widget.images.length,
            itemBuilder: (context, index) =>
                HomeSliderSlide(image: widget.images[index]),
          ),
          Positioned(
            bottom: getProportionateScreenWidth(15),
            right: getProportionateScreenWidth(15),
            child: Row(
              children: List.generate(
                widget.images.length,
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
