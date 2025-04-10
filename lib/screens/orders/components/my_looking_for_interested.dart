import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll/infinite_scroll_list.dart';
import 'package:market/screens/orders/components/my_looking_for_interested_tile.dart';

import '../../../constants/index.dart';

class MyLookingForInterested extends StatefulWidget {
  const MyLookingForInterested(
      {super.key, required this.productPk, required this.token});

  final int productPk;
  final String token;

  @override
  State<StatefulWidget> createState() => MyLookingForInterestedState();
}

class MyLookingForInterestedState extends State<MyLookingForInterested>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  static const IconData close = IconData(0xe16a, fontFamily: 'MaterialIcons');
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  List interesteds = [];

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
      var res = await Remote.get('products/${widget.productPk}/interested', {
        'skip': skip.toString(),
        'take': take.toString(),
      });

      if (res.statusCode == 200) {
        Map<Object, dynamic> dataJson = jsonDecode(res.body);
        var data = [];
        for (var i = 0; i < dataJson['data'].length; i++) {
          data.add(dataJson['data'][i]);
        }

        setState(() {
          if (data.length <= take) {
            everyThingLoaded = true;
          }
        });

        return data;
      }
      // if (res.statusCode == 200) return res.body;
      return null;
    } on Exception {
      print('error');
      return null;
    }
  }

  Future<void> loadInitialData() async {
    interesteds = await getNextPageData(page);
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
      interesteds += newData;
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
                      'Interested Producers',
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
                  controller: _scrollController,
                  child: Column(
                    children: <Widget>[
                      interesteds.isEmpty
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 100),
                                Text(
                                  'No data found',
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
                              children: interesteds
                                  .map(
                                    (interested) => ListItem(
                                      token: widget.token,
                                      interested: interested,
                                      refresh: () {
                                        _next();
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                      // ListView.builder(
                      //   itemCount: interesteds.length,
                      //   shrinkWrap: true,
                      //   padding: const EdgeInsets.only(top: 16),
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   itemBuilder: (context, index) {
                      //     return MyLookingForInterestedTile(
                      //       following: interesteds[index],
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
  final String token;
  final Map<String, dynamic> interested;
  final void Function()? refresh;

  const ListItem({
    super.key,
    required this.token,
    required this.interested,
    this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return MyLookingForInterestedTile(
      token: token,
      interested: interested,
      onTap: () {},
    );
  }
}
