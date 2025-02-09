import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:market/components/appbar.dart';
import 'package:market/components/network_image.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/models/ratings.dart';

class ProducerProfileRate extends StatefulWidget {
  const ProducerProfileRate({super.key});

  @override
  State<ProducerProfileRate> createState() => _ProducerProfileRateState();
}

class _ProducerProfileRateState extends State<ProducerProfileRate> {
  static const IconData pin =
      IconData(0xe800, fontFamily: 'Custom', fontPackage: null);

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
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
                            Colors.black.withValues(alpha: 0.4),
                            BlendMode.dstATop),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(50, 30),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      alignment: Alignment.centerLeft),
                                  child: const Text(
                                    'Back',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(50, 30),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      alignment: Alignment.centerLeft),
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Rate Seller',
                                style: TextStyle(
                                  color: Colors.white,
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
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                // color: Colors.white,
                margin: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    RatingBarIndicator(
                      rating: 4,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 35.0,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 360.0,
                      height: 180.0,
                      // color: AppColors.grey2,
                      padding: EdgeInsets.zero,
                      child: const TextField(
                        maxLines: 10, //or null
                        decoration: InputDecoration(
                          hintText:
                              "Share your experience with this seller? Share your experience and help others make better choices!",
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.teal),
                          // ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.grey2, width: 0.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      child: Row(
                        children: [
                          Text(
                            'Add 50 characters',
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (bool? value) {},
                        ),
                        const Text(
                          'Leave your review anonymously',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
