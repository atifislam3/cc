import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/medicine_provider.dart';
import '../../providers/auth_provider.dart';
import '../../config/routes.dart';
import '../../widgets/common/medicine_card.dart';

/// Medicine List Screen
/// 
/// Implements SRS 2.3 - Medicine Management
/// Displays list of all medicines
class MedicineListScreen extends StatefulWidget {
  const MedicineListScreen({super.key});

  @override
  State<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final medicineProvider = context.watch<MedicineProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Medicines'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Active Medicines - SRS 2.5.2 (SRS-91)
          _MedicineList(
            medicines: medicineProvider.activeMedicines,
            emptyMessage: 'No active medicines',
          ),
          // Past Medicines - SRS 2.5.3 (SRS-93)
          _MedicineList(
            medicines: medicineProvider.pastMedicines,
            emptyMessage: 'No completed medicines',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.addMedicine),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _MedicineList extends StatelessWidget {
  final List<dynamic> medicines;
  final String emptyMessage;

  const _MedicineList({
    required this.medicines,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (medicines.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medication_outlined,
              size: 64,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).disabledColor,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: medicines.length,
      itemBuilder: (context, index) {
        final medicine = medicines[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: MedicineCard(
            medicine: medicine,
            onTap: () => Navigator.of(context).pushNamed(
              AppRoutes.medicineDetail,
              arguments: {'medicineId': medicine.id},
            ),
          ),
        );
      },
    );
  }
}
