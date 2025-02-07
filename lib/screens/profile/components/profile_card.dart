import 'package:flutter/material.dart';

import '../../../components/icon_with_background.dart';
import '../../../constants/index.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
    required this.producerPk,
    required this.iconData,
    required this.iconBackground,
    required this.iconColor,
    required this.statusName,
    required this.status,
    required this.onTap,
  }) : super(key: key);

  final String producerPk;
  final String iconData;
  final Color iconBackground;
  final Color iconColor;
  final String statusName;
  final String status;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Material(
        color: Colors.white,
        borderRadius: AppDefaults.borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppDefaults.borderRadius,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: statusName == 'My Products' && producerPk == '0'
                  ? Colors.black12
                  : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            padding: const EdgeInsets.all(AppDefaults.padding),
            width: MediaQuery.of(context).size.width * 0.45,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconWithBackground(
                  iconData: iconData,
                  color: iconBackground,
                  iconColor: iconColor,
                  size: 50,
                ),
                const SizedBox(height: 5),
                Text(
                  statusName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: statusName == 'My Products' && producerPk == '0'
                          ? Colors.black12
                          : Colors.black54),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
