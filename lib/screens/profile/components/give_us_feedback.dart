import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:market/constants/index.dart';

class GiveUsFeedback extends StatefulWidget {
  const GiveUsFeedback({
    super.key,
    required this.token,
  });

  final String token;

  @override
  State<StatefulWidget> createState() => GiveUsFeedbackState();
}

class GiveUsFeedbackState extends State<GiveUsFeedback>
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

  Future save() async {
    if (_key.currentState!.validate()) {
      try {
        body = {
          'message': messageController.text,
        };

        final url = Uri.parse('${dotenv.get('API')}/feedbacks');
        final headers = {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        };

        var res = await http.post(url, headers: headers, body: body);

        if (res.statusCode == 201) {
          if (!mounted) return;
          AppDefaults.toast(
            context,
            'success',
            AppMessage.getSuccess('FEEDBACK_SAVE'),
          );
          Navigator.pop(context);
        }
        return null;
      } on Exception {
        return null;
      }
    } else {
      AppDefaults.toast(context, 'error', AppMessage.getError('FORM_INVALID'));
    }
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
            height: 380.0,
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
                  height: 80,
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
                        'Give Us Feedback',
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
                  height: 238,
                  child: Padding(
                    // padding: const EdgeInsets.only(
                    //     top: 10, right: 10, bottom: 0, left: 10),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Form(
                      key: _key,
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                'Please let us know how to make Lambo Mag-uuma better for you!'),
                          ),
                          const SizedBox(
                            height: 0,
                          ),
                          TextFormField(
                            controller: messageController,
                            onTap: () async {},
                            maxLines: 8,
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Color(0xfff5f5f5),
                            ),
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
                                        "Cancel",
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
                                    onTap: () async {
                                      var data = await save();
                                      if (data != null) {}
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "Send",
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: AppDefaults.fontSize + 5,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
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
