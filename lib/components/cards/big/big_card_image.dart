import 'package:flutter/material.dart';

class BigCardImage extends StatelessWidget {
  const BigCardImage({
    Key? key,
    required this.image,
  }) : super(key: key);

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
            height: 120,
            decoration: const BoxDecoration(
              color: Colors.black45,
            ),
            child: Column(
              children: const [
                SizedBox(
                  height: 35.0,
                  child: Text(
                    'Welcome',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                SizedBox(
                  height: 85.0,
                  width: 360,
                  child: Text(
                    'Samdhana Community Market sit amet, consectuta adipising elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud execitation ullamco laboris',
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
