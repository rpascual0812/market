import 'package:flutter/material.dart';
import 'package:market/constants/app_colors.dart';
import 'package:market/constants/app_defaults.dart';
import 'package:market/models/follower.dart';
import 'package:market/screens/profile/components/follower_list_tile.dart';

class Complaint extends StatefulWidget {
  const Complaint({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ComplaintState();
}

enum TypeOfComplain { product, transaction, producer }

class ComplaintState extends State<Complaint>
    with SingleTickerProviderStateMixin {
  static const IconData close = IconData(0xe16a, fontFamily: 'MaterialIcons');
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  TypeOfComplain? typeOfComplain = TypeOfComplain.product;

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
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          margin:
              const EdgeInsets.only(top: 20, right: 20, bottom: 0, left: 20),
          // padding: const EdgeInsets.all(15.0),
          height: 650.0,
          decoration: ShapeDecoration(
            // color: const Color.fromRGBO(41, 167, 77, 10),
            color: Colors.white,
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
                height: 570,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, right: 10, bottom: 0, left: 10),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text('Choose type of complain'),
                      ),
                      Column(
                        children: <Widget>[
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            visualDensity: const VisualDensity(vertical: 1),
                            title: Transform.translate(
                              offset: const Offset(-16, 0),
                              child: const Text('Product Concerns'),
                            ),
                            leading: Radio<TypeOfComplain>(
                              value: TypeOfComplain.product,
                              groupValue: typeOfComplain,
                              onChanged: (TypeOfComplain? value) {
                                setState(() {
                                  typeOfComplain = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            visualDensity: const VisualDensity(vertical: -3),
                            title: Transform.translate(
                              offset: const Offset(-16, 0),
                              child: const Text('Transaction Concerns'),
                            ),
                            leading: Radio<TypeOfComplain>(
                              value: TypeOfComplain.transaction,
                              groupValue: typeOfComplain,
                              onChanged: (TypeOfComplain? value) {
                                setState(() {
                                  typeOfComplain = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            visualDensity: const VisualDensity(vertical: -3),
                            title: Transform.translate(
                              offset: const Offset(-16, 0),
                              child: const Text('Producer Concerns'),
                            ),
                            leading: Radio<TypeOfComplain>(
                              value: TypeOfComplain.producer,
                              groupValue: typeOfComplain,
                              onChanged: (TypeOfComplain? value) {
                                setState(() {
                                  typeOfComplain = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'What\'s your complain?',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        onTap: () async {},
                        decoration: const InputDecoration(
                          // prefixIcon: IconWithBackground(iconData: IconlyBold.calendar),
                          // labelText: 'Birthday',
                          hintText: 'Subject',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        onTap: () async {},
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          // prefixIcon: IconWithBackground(iconData: IconlyBold.calendar),
                          // labelText: 'Birthday',
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                      const SizedBox(height: AppDefaults.margin),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Attach Product Photo',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('+ Add Photo'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pop('dialog');
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              side: const BorderSide(
                                width: 2,
                                color: Colors.grey,
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              side: const BorderSide(
                                width: 2,
                                color: Colors.grey,
                              ),
                            ),
                            child: const Text(
                              'Send',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
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
