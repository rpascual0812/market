import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll/infinite_scroll_list.dart';
import 'package:market/screens/looking_for/looking_for_list_tile.dart';
import 'package:market/screens/looking_for/looking_for_page.dart';

import '../../constants/index.dart';

class LookingForList extends StatefulWidget {
  const LookingForList({
    super.key,
    required this.token,
    required this.account,
  });

  final String token;
  final Map<String, dynamic> account;

  @override
  State<LookingForList> createState() => _LookingForListState();
}

class _LookingForListState extends State<LookingForList> {
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;
  List products = [];
  Map<Object, dynamic> dataJson = {};
  int intialIndex = 0;

  bool everyThingLoaded = false;
  int page = 0;
  int skip = 0;
  int take = 5;

  @override
  void initState() {
    isLoading = true;
    super.initState();

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

  @override
  void dispose() {
    super.dispose();
  }

  Future fetch() async {
    try {
      var res = await Remote.get('products', {
        'type': 'looking_for',
        'skip': skip.toString(),
        'take': take.toString(),
        'interest_user_pk': widget.account.isNotEmpty
            ? widget.account['user']['pk'].toString()
            : '',
      });

      if (res.statusCode == 200) {
        dataJson = jsonDecode(res.body);
        var data = [];
        for (var i = 0; i < dataJson['data'].length; i++) {
          data.add(dataJson['data'][i]);
        }

        return data;
      } else if (res.statusCode == 401) {
        if (!mounted) return;
        AppDefaults.logout(context);
      }
      isLoading = false;
      // if (res.statusCode == 200) return res.body;
      return;
    } on Exception catch (exception) {
      print('exception $exception');
    } catch (error) {
      print('error $error');
    }
  }

  Future refreshOrders() async {
    setState(() => isLoading = true);

    // orders = await HipposDatabase.instance.getAllOrders();
    setState(() => isLoading = false);
  }

  Future<void> loadInitialData() async {
    products = await getNextPageData(page) ?? [];
    setState(() {});
  }

  Future getNextPageData(int page) async {
    return await fetch();
  }

  _next() async {
    // print('next');
    var newData = await getNextPageData(page++);
    setState(() {
      products += newData;
      if (newData.isEmpty) {
        skip -= take;
        skip = skip < 0 ? 0 : skip;
        everyThingLoaded = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: buildOrders(),
          ),
        ),
      ],
    );
  }

  Widget buildOrders() => ListView(
        controller: _scrollController,
        // shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          products.isEmpty
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'No products found',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    )
                  ],
                )
              : InfiniteScrollList(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  onLoadingStart: (page) async {},
                  everythingLoaded: everyThingLoaded,
                  children: products
                      .map(
                        (product) => ListItem(
                          token: widget.token,
                          account: widget.account,
                          product: product,
                        ),
                      )
                      .toList(),
                )
        ],
      );
}

class ListItem extends StatelessWidget {
  final String token;
  final Map<String, dynamic> account;
  final Map<String, dynamic> product;
  const ListItem({
    super.key,
    required this.token,
    required this.account,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return LookingForListTile(
      token: token,
      account: account,
      product: product,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return LookingForPage(productPk: product['pk']);
            },
          ),
        );
      },
    );
  }
}
