import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market/screens/profile/components/following_list_tile.dart';

import '../../../constants/index.dart';

class FollowingList extends StatefulWidget {
  const FollowingList({Key? key, required this.userPk, required this.token})
      : super(key: key);

  final int userPk;
  final String token;

  @override
  State<StatefulWidget> createState() => FollowingListState();
}

class FollowingListState extends State<FollowingList>
    with SingleTickerProviderStateMixin {
  static const IconData close = IconData(0xe16a, fontFamily: 'MaterialIcons');
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  List followings = [];

  @override
  void initState() {
    super.initState();

    fetch();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();
  }

  Future fetch() async {
    try {
      final user = AppDefaults.jwtDecode(widget.token);
      var res = await Remote.get('users/${widget.userPk}/followings',
          {'account_pk': user != null ? user['sub'].toString() : '0'});
      if (res.statusCode == 200) {
        setState(() {
          var dataJson = json.decode(res.body);
          for (var i = 0; i < dataJson['data'].length; i++) {
            followings.add(dataJson['data'][i]);
          }
        });
      }
      // if (res.statusCode == 200) return res.body;
      return null;
    } on Exception {
      return null;
    }
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
            color: AppColors.fourth,
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
                            following: followings[index],
                            onTap: () {},
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
