import 'package:flutter/material.dart';

import '../../../constants/index.dart';
import 'color_shape.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Colors', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 10),
          Row(
            children: [
              ColorChooser(
                color: Colors.blue,
                isSelected: false,
                onTap: () {},
              ),
              ColorChooser(
                color: Colors.red,
                isSelected: true,
                onTap: () {},
              ),
              ColorChooser(
                color: Colors.cyan,
                isSelected: false,
                onTap: () {},
              ),
              ColorChooser(
                color: Colors.brown,
                isSelected: false,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
