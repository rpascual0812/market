import 'package:flutter/material.dart';

import '../../../constants/index.dart';
import 'info_row.dart';

class PeronalInformations extends StatelessWidget {
  const PeronalInformations({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Divider(),
          const InfoRow(field: 'Name:', value: 'Raffier Lee'),
          const InfoRow(field: 'Email:', value: 'raffier.lee@gmail.com'),
          const InfoRow(field: 'Location:', value: 'Calgary, Alberta'),
          const InfoRow(field: 'Zip Code:', value: '1800'),
          const InfoRow(field: 'Phone Number:', value: '(+1) 7643 3343 84'),
        ],
      ),
    );
  }
}
