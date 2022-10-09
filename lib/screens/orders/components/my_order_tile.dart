import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

import '../../../constants/index.dart';
import '../../../components/network_image.dart';

class MyOrderTile extends StatefulWidget {
  const MyOrderTile({
    Key? key,
    required this.pk,
    required this.uuid,
    required this.name,
    required this.user,
    required this.productDocument,
    required this.userDocument,
    required this.quantity,
    required this.description,
    required this.location,
    required this.type,
    required this.date,
  }) : super(key: key);

  final int pk;
  final String uuid;
  final String name;
  final List user;
  final List productDocument;
  final List userDocument;
  final double quantity;
  final String description;
  final String location;
  final String type; // looking for, future crop, already available
  final DateTime date;

  @override
  State<MyOrderTile> createState() => _MyOrderTileState();
}

class _MyOrderTileState extends State<MyOrderTile> {
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
                                SizedBox(
                                  height: 25,
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Stack(
                                          children: [
                                            const Positioned(
                                              left: 0,
                                              child: Icon(
                                                Icons.store,
                                                color: Colors.grey,
                                                size: 14,
                                              ),
                                            ),
                                            Positioned(
                                              left: 15,
                                              child: Text(
                                                widget.user[0]['first_name'],
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: AppColors.defaultBlack,
                                                ),
                                              ),
                                            ),
                                            const Positioned(
                                              right: 0,
                                              child: Text(
                                                'Delivered',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: AppDefaults.margin / 10),
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
                                                    userImage, true),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 5,
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
                                                      widget.name,
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
                                                const SizedBox(height: 10),
                                                const Text(
                                                  '₱300 x2',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors.primary,
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
                                                height: 70.0,
                                                padding: EdgeInsets.zero,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: const [
                                                    // Text(
                                                    //   'Delivered',
                                                    //   style: TextStyle(
                                                    //     fontSize: 12,
                                                    //     color:
                                                    //         AppColors.primary,
                                                    //     fontWeight:
                                                    //         FontWeight.bold,
                                                    //   ),
                                                    // ),
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
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 25,
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Order created: ${DateFormat.yMMMd().format(widget.date)}',
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
                                                  'Received',
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
