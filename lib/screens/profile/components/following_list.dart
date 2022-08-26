import 'package:flutter/material.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/models/following.dart';
import 'package:market/screens/profile/components/following_list_tile.dart';

class FollowingList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FollowingListState();
}

class FollowingListState extends State<FollowingList>
    with SingleTickerProviderStateMixin {
  static const IconData close = IconData(0xe16a, fontFamily: 'MaterialIcons');
  AnimationController? controller;
  Animation<double>? scaleAnimation;
  List<Following> followings = [
    Following(
      pk: 1,
      firstName: 'Babylyn',
      lastName: 'Beanay',
      imageURL: "https://i.imgur.com/vavfJqu.gif",
      following: true,
    ),
    Following(
      pk: 2,
      firstName: 'Mia',
      lastName: 'Sue',
      imageURL: "https://i.imgur.com/jG0jrjW.gif",
      following: true,
    ),
    Following(
      pk: 3,
      firstName: 'Jonathan',
      lastName: 'Bernardo',
      imageURL: "https://i.imgur.com/VocmKXJ.gif",
      following: true,
    ),
    Following(
      pk: 4,
      firstName: 'Babylyn',
      lastName: 'Beanay',
      imageURL: "https://i.imgur.com/F1oP4Zh.gif",
      following: true,
    ),
    Following(
      pk: 5,
      firstName: 'Jay',
      lastName: 'Boni',
      imageURL: "https://i.imgur.com/D8hOYEu.gif",
      following: true,
    ),
    Following(
      pk: 6,
      firstName: 'Maria',
      lastName: 'Clare',
      imageURL: "https://i.imgur.com/BLz5n08.gif",
      following: true,
    ),
  ];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          margin: const EdgeInsets.all(20.0),
          // padding: const EdgeInsets.all(15.0),
          height: 700.0,
          decoration: ShapeDecoration(
            // color: const Color.fromRGBO(41, 167, 77, 10),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                width: double.infinity,
                height: 60,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.loose,
                  clipBehavior: Clip.hardEdge,
                  children: <Widget>[
                    const Text(
                      'Following',
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: const Icon(close),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 615,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                        itemCount: followings.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 16),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return FollowingListTile(
                            pk: followings[index].pk,
                            first_name: followings[index].firstName,
                            last_name: followings[index].lastName,
                            image: followings[index].imageURL,
                            following: followings[index].following,
                          );
                        },
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
