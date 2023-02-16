import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market/constants/index.dart';

class HomeSliderSlide extends StatelessWidget {
  const HomeSliderSlide({
    Key? key,
    required this.pk,
    required this.type,
    required this.title,
    required this.details,
    required this.userPk,
    required this.sliderDocument,
  }) : super(key: key);

  final int? pk;
  final String type;
  final String title;
  final String details;
  final int userPk;
  final List sliderDocument;

  @override
  Widget build(BuildContext context) {
    var background = '${dotenv.get('API')}/assets/images/no-image.jpg';
    var icon = '${dotenv.get('API')}/assets/images/user.png';

    for (var i = 0; i < sliderDocument.length; i++) {
      if (sliderDocument[i]['document']['path'] != null) {
        if (sliderDocument[i]['type'] == 'icon') {
          icon =
              '${dotenv.get('API')}/${sliderDocument[i]['document']['path']}';
        } else if (sliderDocument[i]['type'] == 'background') {
          background =
              '${dotenv.get('API')}/${sliderDocument[i]['document']['path']}';
        }
      }
    }

    // print('${dotenv.get('API')}/${sliderDocument[1]['path']}');
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(background),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            // height: 120,
            height: 340,
            decoration: const BoxDecoration(
              color: Colors.black45,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 20.0,
                  child: Text(
                    ' ',
                    style: TextStyle(color: Colors.white, fontSize: 45),
                  ),
                ),
                const SizedBox(height: AppDefaults.margin),
                Visibility(
                  visible: sliderDocument.asMap().containsKey(1),
                  child: SizedBox(
                    height: 120.0,
                    child: SizedBox(
                      child: Image.network(
                        icon,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: !sliderDocument.asMap().containsKey(1),
                    child: const SizedBox(height: 120)),
                const SizedBox(height: AppDefaults.margin),
                SizedBox(
                  height: AppDefaults.fontSize + 18,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      '${title.substring(0, min(title.toString().length, 18))} ${title.toString().length > 18 ? '...' : ''}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: AppDefaults.fontSize + 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDefaults.margin),
                SizedBox(
                  height: 90.0,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    '${details.substring(0, min(details.toString().length, 355))} ${details.toString().length > 355 ? '...' : ''}',
                    style: const TextStyle(
                        color: Colors.white, fontSize: AppDefaults.fontSize),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
