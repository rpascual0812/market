import 'package:flutter/material.dart';
import 'package:infinite_scroll/infinite_scroll.dart';

class GridExample extends StatefulWidget {
  const GridExample({Key? key}) : super(key: key);

  @override
  State<GridExample> createState() => _GridExampleState();
}

class _GridExampleState extends State<GridExample> {
  final ScrollController _scrollController = ScrollController();
  int page = 0;

  Future<List<String>> getNextPageData(int page) async {
    await Future.delayed(const Duration(seconds: 2));
    // if (page == 3) return [];
    final items = List<String>.generate(20, (i) => "Item $i Page $page");
    return items;
  }

  List<String> data = [];
  bool everyThingLoaded = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        _next();
      }
    });

    loadInitialData();
  }

  _next() async {
    print('next');
    List<String> newData = await getNextPageData(page++);
    setState(() {
      data += newData;
      if (newData.isEmpty) {
        everyThingLoaded = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            InfiniteScrollGrid(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              onLoadingStart: (page) async {
                // print(page);
                // _next();
              },
              everythingLoaded: everyThingLoaded,
              crossAxisCount: 2,
              children: data
                  .map(
                    (e) => GridItem(text: e),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadInitialData() async {
    data = await getNextPageData(page);
    setState(() {});
  }
}

class GridItem extends StatelessWidget {
  final String text;
  const GridItem({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(.3),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const CircleAvatar(
              child: Icon(Icons.image),
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }
}
