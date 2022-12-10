import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:intl/intl.dart';

import '../../../constants/index.dart';
import '../../../components/network_image.dart';

class SearchProducerTile extends StatefulWidget {
  const SearchProducerTile({
    Key? key,
    required this.user,
    this.onTap,
  }) : super(key: key);

  final Map<String, dynamic> user;
  final void Function()? onTap;

  @override
  State<SearchProducerTile> createState() => _SearchProducerTileState();
}

class _SearchProducerTileState extends State<SearchProducerTile> {
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);
  static const IconData chat =
      IconData(0xe804, fontFamily: 'Custom', fontPackage: null);

  @override
  Widget build(BuildContext context) {
    var userImage = '${dotenv.get('API')}/assets/images/user.png';
    if (widget.user['seller']['seller_document'] != null) {
      userImage = AppDefaults.userImage(widget.user['user_document']);
    }

    var sellerAddress = {};
    if (widget.user['seller']['seller_addresses'] != null) {
      for (var i = 0;
          i < widget.user['seller']['seller_addresses'].length;
          i++) {
        if (widget.user['seller']['seller_addresses'][i]['default']) {
          sellerAddress = widget.user['seller']['seller_addresses'][i];
        }
      }
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Material(
          // color: Colors.white,
          borderRadius: AppDefaults.borderRadius,
          child: InkWell(
            borderRadius: AppDefaults.borderRadius,
            child: Container(
              // margin: const EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              // padding: const EdgeInsets.all(AppDefaults.padding),
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: Center(
                child: Stack(
                  children: [
                    Column(
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
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
                                            height: 65,
                                            child: AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: NetworkImageWithLoader(
                                                  userImage, false),
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            left: 75,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    width: 200,
                                                    height: 18,
                                                    child: Text(
                                                      '${widget.user['first_name']} ${widget.user['last_name']}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    width: 200,
                                                    height: 16,
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          pin,
                                                          size: 12,
                                                          color: Colors.grey,
                                                        ),
                                                        Text(
                                                          sellerAddress[
                                                                      'city'] !=
                                                                  null
                                                              ? '${sellerAddress['address']}, ${sellerAddress['city']['name']} ${sellerAddress['province']['name']}'
                                                              : '',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.grey,
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
                                            top: 15,
                                            right: 0,
                                            child: Container(
                                              width: 30.0,
                                              height: 30.0,
                                              padding: EdgeInsets.zero,
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.18,
                                                height: 20,
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) {
                                                    //       return const Bubble();
                                                    //     },
                                                    //   ),
                                                    // );
                                                  },
                                                  style:
                                                      OutlinedButton.styleFrom(
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
                                                    size: AppDefaults.fontSize +
                                                        10,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppDefaults.margin / 10),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
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
