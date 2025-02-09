import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:market/components/appbar.dart';
import 'package:market/screens/buyer/components/looking_for_list.dart';
import 'package:market/screens/buyer/components/profile_picture_section.dart';

import '../../constants/index.dart';

class BuyerPage extends StatefulWidget {
  const BuyerPage({
    super.key,
    required this.userPk,
  });

  final int userPk;

  @override
  State<BuyerPage> createState() => _BuyerPageState();
}

class _BuyerPageState extends State<BuyerPage> {
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
                length: 1,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: AppColors.primary,
                      indicatorColor: AppColors.primary,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(
                          text: 'Looking For',
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Scaffold(
                            body: LookingForList(
                                type: 'looking_for', userPk: widget.userPk),
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
