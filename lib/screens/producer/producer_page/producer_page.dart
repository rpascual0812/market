import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/screens/producer/producer_page/components/products_tab.dart';
import 'package:market/screens/producer/producer_page/components/profile_picture_section.dart';
// import 'package:market/screens/profile/components/profile_picture_section.dart';

import '../../../constants/remote.dart';

class ProducerPage extends StatefulWidget {
  const ProducerPage({
    super.key,
    required this.userPk,
  });

  final int userPk;

  @override
  State<ProducerPage> createState() => _ProducerPageState();
}

class _ProducerPageState extends State<ProducerPage> {
  Map<String, dynamic> user = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future fetch() async {
    try {
      var res = await Remote.get('users/${widget.userPk}', {});
      if (res.statusCode == 200) {
        setState(() {
          var userJson = jsonDecode(res.body);
          // print(userJson);
          user = userJson;
        });
      }
    } on Exception catch (exception) {
      log('exception $exception');
    } catch (error) {
      log('error $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    // print(widget.userPk);
    return Scaffold(
      appBar: const Appbar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Visibility(
              visible: user.isNotEmpty ? true : false,
              child: ProfilePictureSection(user: user),
            ),
            SizedBox(
              height: 1500,
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: AppColors.primary,
                      indicatorColor: AppColors.primary,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(
                          text: 'Products',
                        ),
                        Tab(
                          text: 'Future Crops',
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Scaffold(
                            body: ProductsTab(
                                type: 'product', userPk: widget.userPk),
                          ),
                          Scaffold(
                            body: ProductsTab(
                                type: 'future_crop', userPk: widget.userPk),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
