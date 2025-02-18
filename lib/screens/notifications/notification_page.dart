import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll/infinite_scroll_list.dart';
import 'package:market/components/appbar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:market/screens/notifications/notification_page_tile.dart';

import 'package:http/http.dart' as http;

import '../../main.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  List notifications = [];
  Map<Object, dynamic> dataJson = {};
  int intialIndex = 0;

  bool everyThingLoaded = false;
  int page = 0;
  int skip = 0;
  int take = 5;

  String? token = '';

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        skip += take;
        _next();
      }
    });

    getStorage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getStorage() async {
    token = await storage.read(key: 'jwt');
    loadInitialData();
  }

  Future fetch() async {
    // print(token);
    try {
      final url = Uri.parse('${dotenv.get('API')}/notifications');
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var res = await http.get(url, headers: headers);

      if (res.statusCode == 200) {
        dataJson = jsonDecode(res.body);
        var data = [];
        for (var i = 0; i < dataJson['data'].length; i++) {
          data.add(dataJson['data'][i]);
        }

        if (notifications.length >= skip) {
          everyThingLoaded = true;
        }

        return data;
      } else if (res.statusCode == 401) {
        if (!mounted) return;
        // AppDefaults.logout(context);
      }
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
    // setState(() => isLoading = false);
  }

  Future<void> loadInitialData() async {
    notifications = await getNextPageData(page) ?? [];
    setState(() {});
  }

  Future getNextPageData(int page) async {
    return await fetch();
  }

  _next() async {
    // print('next');
    var newData = await getNextPageData(page++);
    setState(() {
      notifications += newData;
      if (newData.isEmpty) {
        skip -= take;
        skip = skip < 0 ? 0 : skip;
        everyThingLoaded = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Appbar(),
            Visibility(
              visible: notifications.isNotEmpty ? true : false,
              child: InfiniteScrollList(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                onLoadingStart: (page) async {},
                everythingLoaded: everyThingLoaded,
                children: notifications
                    .map(
                      (notification) => ListItem(notification: notification),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final Map<String, dynamic> notification;
  const ListItem({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationPageTile(notification: notification);
  }
}
