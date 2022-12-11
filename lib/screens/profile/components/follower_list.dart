import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll/infinite_scroll_list.dart';
import 'package:market/screens/profile/components/follower_list_tile.dart';

import '../../../constants/index.dart';

class FollowerList extends StatefulWidget {
  const FollowerList({Key? key, required this.userPk, required this.token})
      : super(key: key);

  final int userPk;
  final String token;

  @override
  State<StatefulWidget> createState() => FollowerListState();
}

class FollowerListState extends State<FollowerList>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  static const IconData close = IconData(0xe16a, fontFamily: 'MaterialIcons');
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  List followers = [];

  bool everyThingLoaded = false;
  int page = 0;
  int skip = 0;
  int take = 10;

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

    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        skip += take;
        _next();
      }
    });

    loadInitialData();
  }

  Future fetch() async {
    try {
      final user = AppDefaults.jwtDecode(widget.token);
      var res = await Remote.get('users/${widget.userPk}/followers', {
        'account_pk': user != null ? user['sub'].toString() : '0',
        'skip': skip.toString(),
        'take': take.toString(),
      });
      if (res.statusCode == 200) {
        Map<Object, dynamic> dataJson = jsonDecode(res.body);
        var data = [];
        for (var i = 0; i < dataJson['data'].length; i++) {
          data.add(dataJson['data'][i]);
        }

        if (data.length <= take) {
          everyThingLoaded = true;
        }

        return data;
      }
      // if (res.statusCode == 200) return res.body;
      return null;
    } on Exception {
      return null;
    }
  }

  Future<void> loadInitialData() async {
    followers = await getNextPageData(page);
    // print('load initial data $products');
    setState(() {});
  }

  Future getNextPageData(int page) async {
    return await fetch();
  }

  _next() async {
    // print('next');
    var newData = await getNextPageData(page++);
    setState(() {
      followers += newData;
      if (newData.isEmpty) {
        skip -= take;
        skip = skip < 0 ? 0 : skip;
        everyThingLoaded = true;
      }
    });
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
                      'Followers',
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
              Container(
                height: 615,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: <Widget>[
                      followers.isEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                SizedBox(height: 100),
                                Text(
                                  'No followers found',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                )
                              ],
                            )
                          : InfiniteScrollList(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              onLoadingStart: (page) async {},
                              everythingLoaded: everyThingLoaded,
                              children: followers
                                  .map(
                                    (follower) => ListItem(
                                      follower: follower,
                                      refresh: () {
                                        _next();
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                      // ListView.builder(
                      //   itemCount: followers.length,
                      //   shrinkWrap: true,
                      //   padding: const EdgeInsets.only(top: 16),
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   itemBuilder: (context, index) {
                      //     return FollowerListTile(
                      //       follower: followers[index],
                      //       onTap: () {},
                      //     );
                      //   },
                      // ),
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

class ListItem extends StatelessWidget {
  final Map<String, dynamic> follower;
  final void Function()? refresh;

  const ListItem({
    Key? key,
    required this.follower,
    this.refresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FollowerListTile(
      follower: follower,
      onTap: () {},
    );
  }
}
