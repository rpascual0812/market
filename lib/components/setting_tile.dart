import 'package:flutter/material.dart';
import '../constants/index.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    Key? key,
    required this.name,
    required this.callback,
  }) : super(key: key);

  final String name;
  final void Function()? callback;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: callback,
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: AppDefaults.fontSize),
                ),
                const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
