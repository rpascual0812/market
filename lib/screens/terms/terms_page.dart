// import 'dart:html';

import 'dart:convert';

import 'package:animations/animations.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:market/components/appbar.dart';
import 'package:flutter/material.dart';

import '../../constants/index.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({Key? key, required this.location}) : super(key: key);

  final String location;

  // final Widget? backButton;
  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  final _contentStyle = const TextStyle(
      color: Colors.black,
      fontSize: AppDefaults.fontSize,
      fontWeight: FontWeight.normal);
  final _loremIpsum =
      '''Lorem ipsum is typically a corrupted version of 'De finibus bonorum et malorum', a 1st century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin.''';

  Map<String, dynamic> disclaimer = {};
  Map<String, dynamic> legal = {};
  Map<String, dynamic> terms = {};

  @override
  void initState() {
    super.initState();

    fetch();
  }

  Future fetch() async {
    try {
      var res = await Remote.get('configuration', {
        'group': 'agreement',
      });

      if (res.statusCode == 200) {
        var dataJson = jsonDecode(res.body);

        setState(() {
          for (var i = 0; i < dataJson['data'].length; i++) {
            if (dataJson['data'][i]['name'] == 'disclaimer') {
              disclaimer = dataJson['data'][i];
            } else if (dataJson['data'][i]['name'] == 'legal') {
              legal = dataJson['data'][i];
            } else if (dataJson['data'][i]['name'] == 'terms') {
              terms = dataJson['data'][i];
            }
          }
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,

      /// Returns Page With Animation
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation, secondAnimation) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Appbar(),
                Visibility(
                  visible: disclaimer['value'] != '' ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: ExpansionTileCard(
                          expandedColor: Colors.white,
                          shadowColor: Colors.black,
                          title: const Text('Disclaimer'),
                          children: <Widget>[
                            const Divider(
                              thickness: 1.0,
                              height: 1.0,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Html(data: disclaimer['value'] ?? ''),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: legal['value'] != '' ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: ExpansionTileCard(
                          title: const Text('Legal Conditions'),
                          children: <Widget>[
                            const Divider(
                              thickness: 1.0,
                              height: 1.0,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Html(data: legal['value'] ?? ''),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: terms['value'] != '' ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: ExpansionTileCard(
                          title: const Text('Terms and Conditions'),
                          children: <Widget>[
                            const Divider(
                              thickness: 1.0,
                              height: 1.0,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: Html(data: terms['value'] ?? ''),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.location == 'settings' ? false : true,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: AppDefaults.height,
                    child: Padding(
                      padding: const EdgeInsets.all(1),
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDefaults.radius - 10),
                          ),
                        ),
                        child: const Text('I Agree!'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
