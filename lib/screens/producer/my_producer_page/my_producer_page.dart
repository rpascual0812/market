import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:market/components/appbar.dart';
import 'package:market/components/network_image.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/models/ratings.dart';
import 'package:market/screens/producer/my_producer_page/components/my_products_tab.dart';

import '../../../constants/app_defaults.dart';
import '../../profile/components/follower_list.dart';
import '../../profile/components/following_list.dart';

class MyProducerPage extends StatefulWidget {
  const MyProducerPage({Key? key}) : super(key: key);

  @override
  State<MyProducerPage> createState() => _MyProducerPageState();
}

class _MyProducerPageState extends State<MyProducerPage> {
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  TextEditingController messageController = TextEditingController();

  List<Ratings> ratings = [
    Ratings(
      pk: 1,
      userId: 1,
      userFirstName: 'Ferdinand',
      userLastName: 'Dela Cruz',
      userImage: 'https://i.imgur.com/vavfJqu.gif',
      rating: 4,
      comment:
          'With the price I paid, it was worth it. What I ordered was perfect. Although delivery is late, ordered April 29th, received on the 3rd of May. Overall, I did not regret it.',
      dateCreated: DateTime(2022, 08, 12, 13, 25),
    ),
    Ratings(
      pk: 2,
      userId: 2,
      userFirstName: 'Mia',
      userLastName: 'Sue',
      userImage: 'https://i.imgur.com/jG0jrjW.gif',
      rating: 4,
      comment:
          'Seller was super accomodating! Appreciate her help so much \'cause she answered all my questions. Hopefully, she sells more!',
      dateCreated: DateTime(2022, 08, 12, 13, 25),
    ),
    Ratings(
      pk: 3,
      userId: 3,
      userFirstName: 'Jone',
      userLastName: 'Doe',
      userImage: 'https://i.imgur.com/VocmKXJ.gif',
      rating: 4,
      comment:
          'Supersatisfied with my order! The item was in great condition and I loved it. Thank you so much!',
      dateCreated: DateTime(2022, 08, 12, 13, 25),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(),
      body: SingleChildScrollView(
        child: Container(
          color: AppColors.grey1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.4), BlendMode.dstATop),
                        image: const NetworkImage(
                          'https://i.imgur.com/CwxDJj8.jpeg',
                        ),
                      ),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text(
                                  'Back',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 16.0, left: 10),
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      backgroundImage: CachedNetworkImageProvider(
                                          'https://i.imgur.com/8G2bg5J.jpeg'),
                                      radius: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0.0, vertical: 5.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        // color: Colors.white,
                                        child: InkWell(
                                          child: Container(
                                            color: Colors.transparent,
                                            padding: const EdgeInsets.all(
                                                AppDefaults.padding),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.63,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Raffier Lee',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    const Text(
                                                      'Following',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    const Text(
                                                      '100',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 5,
                                                      height: 15,
                                                      decoration:
                                                          const BoxDecoration(
                                                        border: Border(
                                                          right: BorderSide(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    const Text(
                                                      'Following',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    const Text(
                                                      '2',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                        height: 25,
                                                        child: ElevatedButton(
                                                          onPressed: () {},
                                                          style: TextButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.white,
                                                            minimumSize: Size
                                                                .zero, // Set this
                                                            padding: EdgeInsets
                                                                .zero, // and this
                                                          ),
                                                          child: const Text(
                                                            'View Shop',
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: AppColors
                                                                    .primary),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.20,
                                                        height: 25,
                                                        child: ElevatedButton(
                                                          onPressed: () {},
                                                          style: TextButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.white,
                                                            minimumSize: Size
                                                                .zero, // Set this
                                                            padding: EdgeInsets
                                                                .zero, // and this
                                                          ),
                                                          child: const Text(
                                                            'See Rating',
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: AppColors
                                                                    .primary),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: SizedBox(
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         TextButton(
              //           onPressed: () => Navigator.pop(context),
              //           style: TextButton.styleFrom(
              //               padding: EdgeInsets.zero,
              //               minimumSize: const Size(50, 30),
              //               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //               alignment: Alignment.centerLeft),
              //           child: const Text(
              //             'Back',
              //             style: TextStyle(
              //               color: Colors.grey,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 1500,
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: const [
                      TabBar(
                        labelColor: AppColors.primary,
                        indicatorColor: AppColors.primary,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(
                            text: 'Products',
                          ),
                          Tab(
                            text: 'Future Crops',
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            Scaffold(
                              body: MyProductsTab(),
                            ),
                            Scaffold(
                              body: MyProductsTab(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
