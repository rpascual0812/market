import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:market/components/network_image.dart';

class ProducerRatingTile extends StatefulWidget {
  const ProducerRatingTile({
    super.key,
    required this.rating,
  });

  final Map<String, dynamic> rating;

  @override
  State<ProducerRatingTile> createState() => _ProducerRatingTileState();
}

class _ProducerRatingTileState extends State<ProducerRatingTile> {
  @override
  Widget build(BuildContext context) {
    var name =
        '${widget.rating['createdBy']['first_name']} ${widget.rating['createdBy']['last_name']}';
    var userImage = '${dotenv.get('S3')}/images/user.png';
    if (widget.rating['createdBy']['user_document'] != null) {
      for (var i = 0;
          i < widget.rating['createdBy']['user_document'].length;
          i++) {
        if (widget.rating['createdBy']['user_document'][i]['document']
                    ['path'] !=
                null &&
            widget.rating['createdBy']['user_document'][i]['type'] ==
                'profile_photo') {
          userImage =
              '${dotenv.get('API')}/${widget.rating['createdBy']['user_document'][i]['document']['path']}';
        }
      }
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
              child: NetworkImageWithLoader(userImage, true),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name),
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
                      child: Text(widget.rating['message']),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
