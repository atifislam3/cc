import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/medicine_provider.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/journal_provider.dart';
import '../../config/routes.dart';
import '../../utils/helpers.dart';
import '../../widgets/common/medicine_card.dart';
import '../../widgets/common/appointment_card.dart';
import '../../widgets/common/streak_widget.dart';

/// Home Screen
/// 
/// Main dashboard showing overview of medicines, appointments, and streak
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user == null) return;

    final userId = authProvider.user!.id;
    
    await Future.wait([
      context.read<MedicineProvider>().loadMedicines(userId),
      context.read<AppointmentProvider>().loadAppointments(userId),
      context.read<JournalProvider>().loadJournalData(userId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final medicineProvider = context.watch<MedicineProvider>();
    final appointmentProvider = context.watch<AppointmentProvider>();
    final journalProvider = context.watch<JournalProvider>();

    final user = authProvider.user;
    final todayMedicines = medicineProvider.getMedicinesForDate(DateTime.now());
    final todayAppointments = appointmentProvider.todayAppointments;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 140,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            Helpers.getGreeting(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.fullName ?? 'User',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                  onPressed: () {
                    // TODO: Navigate to notifications
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.smart_toy_outlined, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.chatbot);
                  },
                ),
              ],
            ),

            // Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Streak Widget - SRS 2.8.3
                  StreakWidget(
                    currentStreak: journalProvider.currentStreak,
                    longestStreak: journalProvider.longestStreak,
                  ),
                  
                  const SizedBox(height: 24),

                  // Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.add_circle_outline,
                          label: 'Add Medicine',
                          color: Colors.blue,
                          onTap: () => Navigator.of(context).pushNamed(AppRoutes.addMedicine),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.event_note_outlined,
                          label: 'Add Appointment',
                          color: Colors.green,
                          onTap: () => Navigator.of(context).pushNamed(AppRoutes.addAppointment),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _QuickActionCard(
                          icon: Icons.analytics_outlined,
                          label: 'Analytics',
                          color: Colors.purple,
                          onTap: () => Navigator.of(context).pushNamed(AppRoutes.analytics),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Today's Medicines - SRS 2.4.2
                  _SectionHeader(
                    title: "Today's Medicines",
                    count: todayMedicines.length,
                    onSeeAll: () => Navigator.of(context).pushNamed(AppRoutes.schedule),
                  ),
                  const SizedBox(height: 12),
                  if (todayMedicines.isEmpty)
                    const _EmptyState(
                      icon: Icons.medication_outlined,
                      message: 'No medicines scheduled for today',
                    )
                  else
                    ...todayMedicines.take(3).map((medicine) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: MedicineCard(
                        medicine: medicine,
                        onTap: () => Navigator.of(context).pushNamed(
                          AppRoutes.medicineDetail,
                          arguments: {'medicineId': medicine.id},
                        ),
                      ),
                    )),

                  const SizedBox(height: 24),

                  // Today's Appointments
                  _SectionHeader(
                    title: "Today's Appointments",
                    count: todayAppointments.length,
                    onSeeAll: () => Navigator.of(context).pushNamed(AppRoutes.appointments),
                  ),
                  const SizedBox(height: 12),
                  if (todayAppointments.isEmpty)
                    const _EmptyState(
                      icon: Icons.event_outlined,
                      message: 'No appointments for today',
                    )
                  else
                    ...todayAppointments.take(3).map((appointment) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AppointmentCard(
                        appointment: appointment,
                        onTap: () => Navigator.of(context).pushNamed(
                          AppRoutes.appointmentDetail,
                          arguments: {'appointmentId': appointment.id},
                        ),
                      ),
                    )),

                  const SizedBox(height: 24),

                  // Low Stock Alert - SRS 2.6.3
                  if (medicineProvider.lowStockMedicines.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'Low Stock Alert',
                      count: medicineProvider.lowStockMedicines.length,
                      onSeeAll: () => Navigator.of(context).pushNamed(AppRoutes.inventory),
                      isWarning: true,
                    ),
                    const SizedBox(height: 12),
                    ...medicineProvider.lowStockMedicines.take(3).map((medicine) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _LowStockCard(medicine: medicine),
                    )),
                  ],

                  const SizedBox(height: 80),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed(AppRoutes.addMood),
        icon: const Icon(Icons.mood),
        label: const Text('Log Mood'),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback onSeeAll;
  final bool isWarning;

  const _SectionHeader({
    required this.title,
    required this.count,
    required this.onSeeAll,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (count > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isWarning 
                      ? Colors.orange.withOpacity(0.2)
                      : Theme.of(context).primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: isWarning 
                        ? Colors.orange 
                        : Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
        TextButton(
          onPressed: onSeeAll,
          child: const Text('See All'),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).disabledColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _LowStockCard extends StatelessWidget {
  final dynamic medicine;

  const _LowStockCard({required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${medicine.currentStock} left',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Navigate to stock update
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
