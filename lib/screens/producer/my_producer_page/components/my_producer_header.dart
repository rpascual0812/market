import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market/components/network_image.dart';
import 'package:market/screens/producer/producer_page/producer_page.dart';
import 'package:market/screens/producer/producer_ratings_page.dart';

import '../../../../constants/index.dart';

class MyProducerHeader extends StatefulWidget {
  const MyProducerHeader({
    Key? key,
    required this.user,
  }) : super(key: key);

  final Map<String, dynamic> user;

  @override
  State<MyProducerHeader> createState() => _MyProducerHeaderState();
}

class _MyProducerHeaderState extends State<MyProducerHeader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userImage = '${dotenv.get('API')}/assets/images/user.png';
    if (widget.user.isNotEmpty) {
      userImage = AppDefaults.userImage(widget.user['user_document']);
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
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
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
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
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: NetworkImageWithLoader(userImage, true),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 5.0),
                        child: Material(
                          color: Colors.transparent,
                          // color: Colors.white,
                          child: InkWell(
                            child: Container(
                              margin: const EdgeInsets.all(0),
                              color: Colors.transparent,
                              padding:
                                  const EdgeInsets.all(AppDefaults.padding),
                              width: MediaQuery.of(context).size.width * 0.63,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.user['first_name']} ${widget.user['last_name']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: AppDefaults.fontSize + 5,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Following',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: AppDefaults.fontSize,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        widget.user['following_count']
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: AppDefaults.fontSize,
                                        ),
                                      ),
                                      Container(
                                        width: 5,
                                        height: 15,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            right:
                                                BorderSide(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'Following',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: AppDefaults.fontSize,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        widget.user['follower_count']
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: AppDefaults.fontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.20,
                                          height: 25,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) {
                                                    return ProducerPage(
                                                        userPk:
                                                            widget.user['pk']);
                                                  },
                                                ),
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              minimumSize:
                                                  Size.zero, // Set this
                                              padding:
                                                  EdgeInsets.zero, // and this
                                            ),
                                            child: const Text(
                                              'View Shop',
                                              style: TextStyle(
                                                  fontSize:
                                                      AppDefaults.fontSize,
                                                  color: AppColors.primary),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.20,
                                          height: 25,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProducerRatingsPage(
                                                          user: widget.user),
                                                ),
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              minimumSize:
                                                  Size.zero, // Set this
                                              padding:
                                                  EdgeInsets.zero, // and this
                                            ),
                                            child: const Text(
                                              'See Rating',
                                              style: TextStyle(
                                                  fontSize:
                                                      AppDefaults.fontSize,
                                                  color: AppColors.primary),
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
    );
  }
}
