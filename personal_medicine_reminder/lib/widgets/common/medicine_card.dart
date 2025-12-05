import 'package:flutter/material.dart';

import '../../models/medicine_model.dart';
import '../../utils/helpers.dart';

/// Medicine Card Widget
/// 
/// Reusable card for displaying medicine information
class MedicineCard extends StatelessWidget {
  final MedicineModel medicine;
  final VoidCallback? onTap;

  const MedicineCard({
    super.key,
    required this.medicine,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Medicine Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    Helpers.getMedicineCategoryIcon(medicine.category),
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Medicine Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          medicine.dosage,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(medicine.category)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            medicine.category,
                            style: TextStyle(
                              fontSize: 10,
                              color: _getCategoryColor(medicine.category),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Status indicators
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (medicine.isLowStock)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Low Stock',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (medicine.alertEnabled)
                        Icon(
                          Icons.notifications_active,
                          size: 16,
                          color: Theme.of(context).primaryColor,
                        )
                      else
                        Icon(
                          Icons.notifications_off,
                          size: 16,
                          color: Theme.of(context).disabledColor,
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'tablet':
        return Colors.blue;
      case 'capsule':
        return Colors.purple;
      case 'syrup':
        return Colors.orange;
      case 'injection':
        return Colors.red;
      case 'insulin':
        return Colors.teal;
      case 'inhaler':
        return Colors.cyan;
      case 'drops':
        return Colors.indigo;
      case 'cream':
        return Colors.pink;
      case 'patch':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
}
