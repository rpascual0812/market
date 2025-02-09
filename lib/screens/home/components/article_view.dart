import 'package:flutter/material.dart';
import 'package:market/constants/index.dart';

class ArticleView extends StatefulWidget {
  const ArticleView({
    super.key,
    required this.article,
    required this.callback,
  });

  final Map<String, dynamic> article;
  final void Function() callback;

  @override
  State<StatefulWidget> createState() => ArticleViewState();
}

class ArticleViewState extends State<ArticleView>
    with SingleTickerProviderStateMixin {
  static const IconData close = IconData(0xe16a, fontFamily: 'MaterialIcons');
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController(text: '');

  var body = {'message': ''};

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
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.3),
      child: Scaffold(
        backgroundColor: Colors.black.withValues(alpha: 0.3),
        body: SingleChildScrollView(
          child: Container(
            margin:
                const EdgeInsets.only(top: 100, right: 20, bottom: 0, left: 20),
            // padding: const EdgeInsets.all(15.0),
            height: 400.0,
            decoration: ShapeDecoration(
              // color: const Color.fromRGBO(41, 167, 77, 10),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
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
                        '',
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
                  height: 278,
                  child: Padding(
                    // padding: const EdgeInsets.only(
                    //     top: 10, right: 10, bottom: 0, left: 10),
                    padding: const EdgeInsets.all(30),
                    child: Form(
                      key: _key,
                      child: Column(
                        children: [
                          Wrap(
                            //Vertical || Horizontal
                            children: <Widget>[
                              Text(
                                widget.article['title'],
                                style: const TextStyle(fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: true,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.article['description'],
                              overflow: TextOverflow.fade,
                              maxLines: 10,
                              softWrap: true,
                            ),
                            // child: Text(
                            //   widget.article['description'],
                            // ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  width: double.infinity,
                  height: 62,
                  decoration: BoxDecoration(
                    color: const Color(0xffeaeaea),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    border: Border.all(
                      color: const Color(0xffeaeaea),
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.loose,
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 60,
                            padding: const EdgeInsets.all(0),
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: InkWell(
                                    onTap: widget.callback,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        // color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(12),
                                          topLeft: Radius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        "Read Article",
                                        style: TextStyle(
                                          color: AppColors.secondary,
                                          fontSize: AppDefaults.fontSize + 5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop('dialog');
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        // color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(12),
                                          topLeft: Radius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        "Close",
                                        style: TextStyle(
                                          color: AppColors.secondary,
                                          fontSize: AppDefaults.fontSize + 5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
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
