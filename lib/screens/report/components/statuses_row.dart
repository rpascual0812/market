import 'package:flutter/material.dart';

import '../../../constants/index.dart';
import 'status_card.dart';

class StatusesRow extends StatelessWidget {
  const StatusesRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          StatusCard(
            iconData: Icons.shopping_bag_rounded,
            iconBackground: AppColors.primary.withValues(alpha: 0.1),
            iconColor: AppColors.primary,
            statusName: 'Progress order',
            status: '10+',
            onTap: () {},
          ),
          StatusCard(
            iconData: Icons.add_shopping_cart,
            iconBackground: Colors.blue.withValues(alpha: 0.1),
            iconColor: Colors.blue,
            statusName: 'Promocodes',
            status: '5',
            onTap: () {},
          ),
          StatusCard(
            iconData: Icons.star,
            iconBackground: Colors.yellow.withValues(alpha: 0.1),
            iconColor: Colors.yellow,
            statusName: 'Reviews',
            status: '4.5K',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
