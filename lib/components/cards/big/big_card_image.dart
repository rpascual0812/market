import 'package:flutter/material.dart';
import 'package:market/constants/index.dart';

class BigCardImage extends StatelessWidget {
  const BigCardImage({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          decoration: BoxDecoration(
            // borderRadius: const BorderRadius.all(Radius.circular(12)),
            image: DecorationImage(
              // for newtowk image use NetworkImage()
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
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
                const SizedBox(
                  height: 35.0,
                  child: Text(
                    'Welcome',
                    style: TextStyle(color: Colors.white, fontSize: 35),
                  ),
                ),
                const SizedBox(height: AppDefaults.margin),
                const SizedBox(
                  height: 85.0,
                  width: 360,
                  child: Text(
                    'Lambo Mag-uuma sit amet, consectuta adipising elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud execitation ullamco laboris',
                    style: TextStyle(color: Colors.white, fontSize: 12),
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
