import 'package:bloomix_mobile_app/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlantCard extends StatelessWidget {
  const PlantCard({
    super.key,
    required this.plantName,
    required this.lastWateredDate,
    required this.overdueDays,
    required this.onWater,
  });

  final String plantName;
  final DateTime lastWateredDate;
  final int overdueDays;
  final VoidCallback onWater;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF2DADA),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFE7F8EE),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.local_florist_rounded,
              color: AppColors.primaryGreen,
              size: 38,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plantName,

                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: AppColors.textGrey,
                    ),

                    const SizedBox(width: 8),

                    Text(
                      'Last: ${DateFormat('dd. MM. yyyy.').format(lastWateredDate)}',

                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.water_drop_outlined,
                      size: 18,
                      color: overdueDays < 0 ? Colors.red : Colors.blue,
                    ),

                    const SizedBox(width: 8),

                    Text(
                      overdueDays < 0
                          ? 'Overdue by ${overdueDays.abs()} days'
                          : 'Water due in $overdueDays days',

                      style: TextStyle(
                        fontSize: 15,
                        color: overdueDays < 0 ? Colors.red : Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: onWater,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 55,
              height: 55,
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.water_drop_outlined,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
