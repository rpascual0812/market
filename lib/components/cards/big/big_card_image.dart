import 'package:flutter/material.dart';

class BigCardImage extends StatelessWidget {
  const BigCardImage({
    Key? key,
    required this.image,
  }) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // borderRadius: const BorderRadius.all(Radius.circular(12)),
        image: DecorationImage(
          // for newtowk image use NetworkImage()
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Expanded(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              SizedBox(
                height: 50.0,
                child: Text(
                  'Welcome',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              SizedBox(
                height: 100.0,
                width: 300,
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
    );
  }
}
