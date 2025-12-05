import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../providers/medicine_provider.dart';
import '../../providers/appointment_provider.dart';
import '../../config/constants.dart';
import '../../config/routes.dart';
import '../../widgets/common/medicine_card.dart';
import '../../widgets/common/appointment_card.dart';

/// Schedule Screen
/// 
/// Implements SRS 2.4 - Schedule Management
/// SRS-85 to SRS-88
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final medicineProvider = context.watch<MedicineProvider>();
    final appointmentProvider = context.watch<AppointmentProvider>();

    // SRS-88: Date range limitation
    final now = DateTime.now();
    final firstDay = now.subtract(Duration(days: AppConstants.calendarPastDays));
    final lastDay = now.add(Duration(days: AppConstants.calendarFutureDays));

    final medicinesForDay = medicineProvider.getMedicinesForDate(_selectedDay);
    final appointmentsForDay = appointmentProvider.getAppointmentsForDate(_selectedDay);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = DateTime.now();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar - SRS 2.4.1 (SRS-85)
          TableCalendar(
            firstDay: firstDay,
            lastDay: lastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              // SRS 2.4.3 (SRS-87): View date schedule
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: (day) {
              final medicines = medicineProvider.getMedicinesForDate(day);
              final appointments = appointmentProvider.getAppointmentsForDate(day);
              return [...medicines, ...appointments];
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonDecoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          const Divider(),

          // SRS 2.4.2 (SRS-86): Daily schedule
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Date header
                Text(
                  _formatDateHeader(_selectedDay),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),

                // Medicines
                if (medicinesForDay.isNotEmpty) ...[
                  Text(
                    'Medicines (${medicinesForDay.length})',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  ...medicinesForDay.map((medicine) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: MedicineCard(
                      medicine: medicine,
                      onTap: () => Navigator.of(context).pushNamed(
                        AppRoutes.medicineDetail,
                        arguments: {'medicineId': medicine.id},
                      ),
                    ),
                  )),
                  const SizedBox(height: 16),
                ],

                // Appointments
                if (appointmentsForDay.isNotEmpty) ...[
                  Text(
                    'Appointments (${appointmentsForDay.length})',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  ...appointmentsForDay.map((appointment) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AppointmentCard(
                      appointment: appointment,
                      onTap: () => Navigator.of(context).pushNamed(
                        AppRoutes.appointmentDetail,
                        arguments: {'appointmentId': appointment.id},
                      ),
                    ),
                  )),
                ],

                // Empty state
                if (medicinesForDay.isEmpty && appointmentsForDay.isEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 32),
                        Icon(
                          Icons.event_available,
                          size: 48,
                          color: Theme.of(context).disabledColor,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No medicines or appointments',
                          style: TextStyle(
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(date.year, date.month, date.day);

    if (selectedDate == today) {
      return 'Today';
    } else if (selectedDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else if (selectedDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    }

    final weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    return '${weekdays[date.weekday % 7]}, ${months[date.month - 1]} ${date.day}';
  }
}
