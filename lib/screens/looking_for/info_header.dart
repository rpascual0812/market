import 'package:flutter/material.dart';

class InfoHeader extends StatelessWidget {
  const InfoHeader({
    Key? key,
    required this.name,
    required this.product,
    required this.quantity,
    required this.date,
  }) : super(key: key);

  final String name, product, quantity, date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            product,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            quantity,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            date,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
