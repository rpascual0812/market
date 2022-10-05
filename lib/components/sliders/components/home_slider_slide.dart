import 'package:flutter/material.dart';
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
    print('document ${sliderDocument[0]['document']}');
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          decoration: const BoxDecoration(
              // borderRadius: const BorderRadius.all(Radius.circular(12)),
              // image: DecorationImage(
              //   // for newtowk image use NetworkImage()
              //   image: AssetImage(slides),
              //   fit: BoxFit.cover,
              // ),
              ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            // height: 120,
            height: 325,
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
                SizedBox(
                  height: 120.0,
                  child: SizedBox(
                    child: Image.asset(
                      'assets/images/farmer.png',
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: AppDefaults.margin),
                SizedBox(
                  height: 35.0,
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 35),
                  ),
                ),
                const SizedBox(height: AppDefaults.margin),
                SizedBox(
                  height: 85.0,
                  width: 360,
                  child: Text(
                    details,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
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
