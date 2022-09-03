import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

import '../../../constants/index.dart';
import '../../../components/network_image.dart';

class SearchProductTile extends StatefulWidget {
  const SearchProductTile({
    Key? key,
    required this.pk,
    required this.uuid,
    required this.title,
    required this.productImage,
    required this.quantity,
    required this.unit,
    required this.description,
    required this.location,
    required this.type,
    this.imageURL = '',
    required this.createdBy,
    required this.userImage,
    required this.userName,
    required this.dateCreated,
  }) : super(key: key);

  final int pk;
  final String uuid;
  final String title;
  final String productImage;
  final double quantity;
  final String unit;
  final String description;
  final String location;
  final String type; // looking for, future crop, already available
  final String imageURL;
  final int createdBy;
  final String userImage;
  final String userName;
  final DateTime dateCreated;

  @override
  State<SearchProductTile> createState() => _SearchProductTileState();
}

class _SearchProductTileState extends State<SearchProductTile> {
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  @override
  Widget build(BuildContext context) {
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
                                              child: Hero(
                                                tag: widget.pk,
                                                child: NetworkImageWithLoader(
                                                    widget.productImage, true),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 15,
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
                                                    width: 150,
                                                    height: 18,
                                                    child: Text(
                                                      widget.title,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
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
                                                    height: 16,
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          pin,
                                                          size: 12,
                                                          color: Colors.grey,
                                                        ),
                                                        Text(
                                                          widget.location,
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
                                              width: 100.0,
                                              height: 25.0,
                                              padding: EdgeInsets.zero,
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.18,
                                                height: 20,
                                                child: ElevatedButton(
                                                  onPressed: () {},
                                                  style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        AppColors.primary,
                                                    minimumSize:
                                                        Size.zero, // Set this
                                                    padding: EdgeInsets
                                                        .zero, // and this
                                                  ),
                                                  child: const Text(
                                                    '₱300.00',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white,
                                                    ),
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
