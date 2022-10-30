import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

import '../../../../constants/index.dart';
import '../../../../components/network_image.dart';

class MyProductTile extends StatefulWidget {
  const MyProductTile({
    Key? key,
    required this.product,
    this.onTap,
  }) : super(key: key);

  final Map<String, dynamic> product;
  final void Function()? onTap;

  @override
  State<MyProductTile> createState() => _MyProductTileState();
}

class _MyProductTileState extends State<MyProductTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userImage = '${dotenv.get('API')}/assets/images/user.png';
    if (widget.product['user'] != null) {
      userImage =
          AppDefaults.userImage(widget.product['user']['user_document'] ?? []);
    }

    DateTime date = DateTime.parse(widget.product['date_created'].toString());

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
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 65,
                                            child: AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: NetworkImageWithLoader(
                                                  userImage, false),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                width: 150,
                                                height: 18,
                                                child: Text(
                                                  widget.product['name'],
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Wrap(
                                                spacing:
                                                    100, // set spacing here
                                                children: <Widget>[
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: const [
                                                      Text(
                                                        '₱300',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              AppColors.primary,
                                                        ),
                                                      ),
                                                      Text(
                                                        '1kg',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              AppColors.primary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: const [
                                                      Text(
                                                        'Stocks: 168',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              AppColors.primary,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Category: Fruits',
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              AppColors.primary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
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
                                          'Product created: ${DateFormat.yMMMd().format(date)}',
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
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: AppColors.primary,
                                              ),
                                              width: 25.0,
                                              height: 25.0,
                                              padding: EdgeInsets.zero,
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
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                    width: 1,
                                                    color: AppColors.primary,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                ),
                                                child: const Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: AppColors.primary,
                                              ),
                                              width: 25.0,
                                              height: 25.0,
                                              padding: EdgeInsets.zero,
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
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                    width: 1,
                                                    color: AppColors.primary,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                ),
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                  size: 15,
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
