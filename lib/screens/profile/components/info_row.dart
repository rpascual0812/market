import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({
    Key? key,
    required this.field,
    required this.value,
  }) : super(key: key);

  final String field, value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            field,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.black54),
          ),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
