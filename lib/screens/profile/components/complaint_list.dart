import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:infinite_scroll/infinite_scroll_list.dart';
import 'package:market/components/appbar.dart';
import 'package:market/constants/index.dart';
import 'package:http/http.dart' as http;
import 'package:market/screens/profile/components/complaint_bubble.dart';
import 'package:market/screens/profile/components/complaint_new.dart';

class ComplaintList extends StatefulWidget {
  const ComplaintList({
    Key? key,
    required this.token,
  }) : super(key: key);

  final String token;

  @override
  State<ComplaintList> createState() => _ComplaintListState();
}

class _ComplaintListState extends State<ComplaintList> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  List complaints = [];

  bool everyThingLoaded = false;
  int page = 0;
  int skip = 0;
  int take = 5;

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

    loadInitialData();
  }

  @override
  void dispose() {
    // MarketDatabase.instance.close();

    super.dispose();
  }

  Future fetch() async {
    try {
      final params = {
        'user': 'true',
        'skip': skip.toString(),
        'take': take.toString(),
      };
      final url = Uri.parse('${dotenv.get('API')}/complaints')
          .replace(queryParameters: params);
      final headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      };
      var res = await http.get(url, headers: headers);

      if (res.statusCode == 200) {
        var dataJson = jsonDecode(res.body);
        var data = [];
        for (var i = 0; i < dataJson['data'].length; i++) {
          data.add(dataJson['data'][i]);
        }

        if (data.length <= take) {
          everyThingLoaded = true;
        }

        return data;
      } else if (res.statusCode == 401) {
        if (!mounted) return;
        AppDefaults.logout(context);
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
    setState(() => isLoading = false);
  }

  Future<void> loadInitialData() async {
    complaints = await getNextPageData(page);
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
      complaints += newData;
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
      appBar: const Appbar(),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    //
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          // height: AppDefaults.height,
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ComplaintNew(token: widget.token),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(AppDefaults.radius),
                                ),
                              ),
                              child: const Text('File new complaint'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            // const SizedBox(height: 50),
            complaints.isNotEmpty
                ? InfiniteScrollList(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    onLoadingStart: (page) async {},
                    everythingLoaded: everyThingLoaded,
                    children: complaints
                        .map(
                          (complaint) => ListItem(
                            token: widget.token,
                            complaint: complaint,
                          ),
                        )
                        .toList(),
                  )
                : const Text('')
          ],
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String token;
  final Map<String, dynamic> complaint;
  const ListItem({
    Key? key,
    required this.token,
    required this.complaint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ComplaintBubble(complaint: complaint, token: token)));
      },
      child: ListTile(
        title: Text(complaint['subject']),
        tileColor: Colors.white,
      ),
    );
  }
}
