import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:market/components/appbar.dart';
import 'package:market/components/network_image.dart';
import 'package:market/constants/app_colors.dart';

class RatingsPage extends StatefulWidget {
  const RatingsPage({
    super.key,
    required this.product,
  });

  final Map<String, dynamic> product;

  @override
  State<RatingsPage> createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage> {
  @override
  Widget build(BuildContext context) {
    // print(' product ratings ${widget.product['product_ratings']}');
    return Scaffold(
      appBar: const Appbar(),
      body: Container(
        color: AppColors.grey1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.centerLeft),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Ratings',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 10,
                          height: 20,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(color: AppColors.defaultBlack),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.product['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    // const SizedBox(height: AppDefaults.height),
                  ],
                ),
              ),
            ),
            Visibility(
              visible:
                  widget.product['product_ratings'].length == 0 ? true : false,
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 5),
                width: MediaQuery.of(context).size.width,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('No Ratings found.')],
                ),
              ),
            ),
            Visibility(
              visible:
                  widget.product['product_ratings'].length == 0 ? false : true,
              child: Container(
                // color: Colors.white,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListView.builder(
                  itemCount: widget.product['product_ratings'].length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var image =
                        '${dotenv.get('API')}/assets/images/no-image.jpg';

                    for (var i = 0;
                        i <
                            widget
                                .product['product_ratings'][index]['user']
                                    ['user_document']
                                .length;
                        i++) {
                      // print(widget.product['product_ratings'][index]['user']['user_document'][i]['document']['path']);
                      if (widget.product['product_ratings'][index]['user']
                                  ['user_document'][i]['document']['path'] !=
                              null &&
                          widget.product['product_ratings'][index]['user']
                                  ['user_document'][i]['type'] ==
                              'profile_photo') {
                        image =
                            '${dotenv.get('API')}/${widget.product['product_ratings'][index]['user']['user_document'][i]['document']['path']}';
                      }
                    }

                    if (widget.product['product_ratings'][index]['anonymous']) {
                      image = '${dotenv.get('API')}/assets/images/user.png';
                    }

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
                              child: NetworkImageWithLoader(image, true),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.product['product_ratings'][index]
                                      ['anonymous']
                                  ? 'Anonymous User'
                                  : '${widget.product['product_ratings'][index]['user']['first_name']} ${widget.product['product_ratings'][index]['user']['last_name']}'),
                              RatingBarIndicator(
                                rating: double.parse(
                                    widget.product['product_ratings'][index]
                                        ['rating']),
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
                                      child: Text(
                                          widget.product['product_ratings']
                                                  [index]['message'] ??
                                              ''),
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
            ),
          ],
        ),
      ),
    );
  }
}
