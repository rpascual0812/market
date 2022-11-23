import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:market/components/appbar.dart';
import 'package:market/components/network_image.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/models/ratings.dart';

class ProducerProfile extends StatefulWidget {
  const ProducerProfile({Key? key}) : super(key: key);

  @override
  State<ProducerProfile> createState() => _ProducerProfileState();
}

class _ProducerProfileState extends State<ProducerProfile> {
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
      appBar: const Appbar(),
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
                    height: 350,
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
                            const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://i.imgur.com/vavfJqu.gif"),
                              radius: 90,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Juan Dela Cruz',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            const Text(
                              'seller of Almonds',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  pin,
                                  size: 12,
                                  color: Colors.white,
                                ),
                                Text(
                                  'Imus, Cavite',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            RatingBarIndicator(
                              rating: 4,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 45.0,
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
              Container(
                // color: Colors.white,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListView.builder(
                  itemCount: ratings.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    // return Text('asdf');
                    return Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 5),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 45,
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: NetworkImageWithLoader(
                                  ratings[index].userImage, true),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ratings[index].userFirstName),
                              RatingBarIndicator(
                                rating: 4,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 15.0,
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                color: Colors.white,
                                width: 310,
                                child: Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(ratings[index].comment),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
