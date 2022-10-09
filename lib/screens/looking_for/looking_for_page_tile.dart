import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../constants/index.dart';
import '../../components/network_image.dart';
import 'package:market/screens/chat/bubble.dart';

class LookingForPageTile extends StatefulWidget {
  static const IconData chat =
      IconData(0xe804, fontFamily: 'Custom', fontPackage: null);
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  const LookingForPageTile({
    Key? key,
    required this.pk,
    required this.uuid,
    required this.name,
    required this.productDocument,
    required this.quantity,
    required this.measurement,
    required this.description,
    required this.location,
    required this.type,
    this.imageURL = '',
    required this.user,
    required this.userDocument,
  }) : super(key: key);

  final int pk;
  final String uuid;
  final String name;
  final List productDocument;
  final double quantity;
  final List measurement;
  final String description;
  final String location;
  final String type; // looking for, future crop, already available
  final String imageURL;
  final List user;
  final List userDocument;

  @override
  State<LookingForPageTile> createState() => _LookingForPageTileState();
}

class _LookingForPageTileState extends State<LookingForPageTile> {
  static const IconData chat =
      IconData(0xe804, fontFamily: 'Custom', fontPackage: null);
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  @override
  Widget build(BuildContext context) {
    var userImage =
        '${dotenv.get('API')}/${widget.userDocument[0]['document']['path']}';
    print('aa $userImage');

    return GestureDetector(
      // no onTap event for now
      // onTap: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) {
      //         return const LoginPage();
      //       },
      //     ),
      //   );
      // },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Material(
          // color: Colors.white,
          borderRadius: AppDefaults.borderRadius,
          child: InkWell(
            borderRadius: AppDefaults.borderRadius,
            child: Container(
              width: MediaQuery.of(context).size.width,
              // padding: const EdgeInsets.all(AppDefaults.padding),
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Center(
                child: Stack(
                  children: [
                    Column(
                      // mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDefaults.margin,
                              vertical: AppDefaults.margin,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            height: 45,
                                            child: AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: Hero(
                                                tag: widget.pk,
                                                child: NetworkImageWithLoader(
                                                    userImage, true),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 5,
                                            left: 50,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    width: 150,
                                                    height: 20,
                                                    child: Text(
                                                      '${widget.user[0]['first_name']} ${widget.user[0]['last_name']}',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    width: 150,
                                                    height: 20,
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          pin,
                                                          size: 12,
                                                        ),
                                                        Text(
                                                          widget.location,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 10,
                                                            color: AppColors
                                                                .defaultBlack,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            child: Container(
                                              width: 35.0,
                                              height: 35.0,
                                              padding: EdgeInsets.zero,
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return const Bubble();
                                                      },
                                                    ),
                                                  );
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                    width: 1,
                                                    color: AppColors.primary,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                ),
                                                child: const Icon(
                                                  chat,
                                                  color: AppColors.primary,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppDefaults.margin / 2),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppDefaults.margin / 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Quantity: $widget.quantity',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: AppColors.defaultBlack,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppDefaults.margin / 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.description,
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: AppColors.defaultBlack,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppDefaults.margin / 10),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),

                    /// This will show only when hasFavourite parameter is true
                    // if (hasFavourite)
                    //   Positioned(
                    //     top: 8,
                    //     right: 8,
                    //     child: Container(
                    //       padding: const EdgeInsets.all(8.0),
                    //       decoration: const BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         color: Colors.white,
                    //       ),
                    //       child: Icon(
                    //         isFavourite ? IconlyBold.heart : IconlyLight.heart,
                    //         color: Colors.red,
                    //       ),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
