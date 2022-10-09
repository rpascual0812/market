import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

import '../../../constants/index.dart';
import '../../../components/network_image.dart';

class MyProductTile extends StatefulWidget {
  const MyProductTile({
    Key? key,
    required this.pk,
    required this.uuid,
    required this.name,
    required this.user,
    required this.productDocument,
    required this.userDocument,
    required this.measurement,
    required this.quantity,
    required this.description,
    required this.location,
    required this.type,
    required this.dateCreated,
  }) : super(key: key);

  final int pk;
  final String uuid;
  final String name;
  final Map<String, dynamic> user;
  final List productDocument;
  final List userDocument;
  final Map<String, dynamic> measurement;
  final String quantity;
  final String description;
  final String location;
  final String type; // looking for, future crop, already available
  final DateTime dateCreated;

  @override
  State<MyProductTile> createState() => _MyProductTileState();
}

class _MyProductTileState extends State<MyProductTile> {
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
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
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
                      // mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.3),
                            //     spreadRadius: 5,
                            //     blurRadius: 7,
                            //     offset: const Offset(
                            //         0, 0), // changes position of shadow
                            //   ),
                            // ],
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
                                                    userImage, false),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 5,
                                            left: 75,
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
                                                    height: 25,
                                                    child: Text(
                                                      widget.name,
                                                      style: const TextStyle(
                                                        fontSize: 20,
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
                                                    height: 20,
                                                    child: const Text(
                                                      '₱300 x2',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            AppColors.primary,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Container(
                                                width: 120.0,
                                                height: 100.0,
                                                padding: EdgeInsets.zero,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: const [
                                                    Text(
                                                      'Delivered',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            AppColors.primary,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      'Order Total: ₱300',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            AppColors.primary,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppDefaults.margin / 5),
                                SizedBox(
                                  height: 25,
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Order created: ${DateFormat.yMMMd().format(widget.dateCreated)}',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: AppColors.defaultBlack,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: Row(
                                          children: [
                                            SizedBox(
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
                                                  'Fulfilled',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const VerticalDivider(),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.18,
                                              height: 20,
                                              child: ElevatedButton(
                                                onPressed: () {},
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.danger,
                                                  minimumSize:
                                                      Size.zero, // Set this
                                                  padding: EdgeInsets
                                                      .zero, // and this
                                                ),
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
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
