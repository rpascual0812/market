import 'package:flutter/material.dart';

class InfoHeader extends StatelessWidget {
  const InfoHeader({
    super.key,
    required this.name,
    required this.product,
    required this.quantity,
    required this.date,
  });

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
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            product,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            quantity,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            date,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
