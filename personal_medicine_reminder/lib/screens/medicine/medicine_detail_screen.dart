import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/medicine_provider.dart';
import '../../config/routes.dart';

/// Medicine Detail Screen
/// 
/// Implements SRS 2.3.2 - Update Medicine Details
class MedicineDetailScreen extends StatelessWidget {
  final String medicineId;

  const MedicineDetailScreen({super.key, required this.medicineId});

  @override
  Widget build(BuildContext context) {
    final medicineProvider = context.watch<MedicineProvider>();
    final medicine = medicineProvider.getMedicineById(medicineId);

    if (medicine == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Medicine')),
        body: const Center(child: Text('Medicine not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(medicine.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'disable',
                child: Text(medicine.alertEnabled ? 'Disable Alert' : 'Enable Alert'),
              ),
              PopupMenuItem(
                value: 'complete',
                child: Text(medicine.isActive ? 'Mark Completed' : 'Mark Active'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
            onSelected: (value) async {
              switch (value) {
                case 'disable':
                  if (medicine.alertEnabled) {
                    await medicineProvider.disableMedicineAlert(medicineId);
                  } else {
                    await medicineProvider.enableMedicineAlert(medicineId);
                  }
                  break;
                case 'complete':
                  await medicineProvider.markMedicineCompleted(medicineId);
                  break;
                case 'delete':
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Medicine'),
                      content: const Text('Are you sure you want to delete this medicine?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await medicineProvider.deleteMedicine(medicineId);
                    if (context.mounted) Navigator.pop(context);
                  }
                  break;
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Medicine Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.medication,
                          color: Theme.of(context).primaryColor,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              medicine.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              medicine.category,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  _InfoRow(label: 'Dosage', value: medicine.dosage),
                  if (medicine.description != null)
                    _InfoRow(label: 'Description', value: medicine.description!),
                  _InfoRow(
                    label: 'Stock',
                    value: '${medicine.currentStock}',
                    valueColor: medicine.isLowStock ? Colors.orange : null,
                  ),
                  _InfoRow(
                    label: 'Status',
                    value: medicine.isActive ? 'Active' : 'Completed',
                    valueColor: medicine.isActive ? Colors.green : Colors.grey,
                  ),
                  _InfoRow(
                    label: 'Alert',
                    value: medicine.alertEnabled ? 'Enabled' : 'Disabled',
                    valueColor: medicine.alertEnabled ? Colors.green : Colors.grey,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Reminders Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reminders',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  if (medicine.reminders.isEmpty)
                    const Text('No reminders set')
                  else
                    ...medicine.reminders.map((reminder) {
                      return ListTile(
                        leading: const Icon(Icons.alarm),
                        title: Text(reminder.formattedTime),
                        subtitle: Text(reminder.isEnabled ? 'Active' : 'Disabled'),
                        contentPadding: EdgeInsets.zero,
                      );
                    }),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Stock Management
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stock Management',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          await medicineProvider.updateStock(
                            medicineId,
                            medicine.currentStock + 1,
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add'),
                      ),
                      ElevatedButton.icon(
                        onPressed: medicine.currentStock > 0
                            ? () async {
                                await medicineProvider.updateStock(
                                  medicineId,
                                  medicine.currentStock - 1,
                                );
                              }
                            : null,
                        icon: const Icon(Icons.remove),
                        label: const Text('Remove'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
