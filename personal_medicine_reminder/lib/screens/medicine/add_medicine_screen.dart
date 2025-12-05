import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/medicine_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/medicine_model.dart';
import '../../config/constants.dart';
import '../../utils/validators.dart';

/// Add Medicine Screen
/// 
/// Implements SRS 2.3.1 - Add Medicine
/// SRS-62 to SRS-68
class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController();
  
  String _selectedCategory = 'Tablet';
  ScheduleType _scheduleType = ScheduleType.daily;
  final List<ReminderSchedule> _reminders = [];
  List<int> _selectedWeekDays = [];
  int _intervalDays = 1;
  int _cycleDaysOn = 21;
  int _cycleDaysOff = 7;

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _addReminder() {
    showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    ).then((time) {
      if (time != null) {
        setState(() {
          _reminders.add(ReminderSchedule(
            id: const Uuid().v4(),
            time: time,
          ));
        });
      }
    });
  }

  void _removeReminder(int index) {
    setState(() {
      _reminders.removeAt(index);
    });
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final medicineProvider = context.read<MedicineProvider>();

    ScheduleConfig? scheduleConfig;
    switch (_scheduleType) {
      case ScheduleType.weekly:
        scheduleConfig = ScheduleConfig(weekDays: _selectedWeekDays);
        break;
      case ScheduleType.interval:
        scheduleConfig = ScheduleConfig(intervalDays: _intervalDays);
        break;
      case ScheduleType.cyclic:
        scheduleConfig = ScheduleConfig(
          cycleDaysOn: _cycleDaysOn,
          cycleDaysOff: _cycleDaysOff,
        );
        break;
      default:
        break;
    }

    final success = await medicineProvider.addMedicine(
      userId: authProvider.user!.id,
      name: _nameController.text.trim(),
      category: _selectedCategory,
      dosage: _dosageController.text.trim(),
      description: _descriptionController.text.trim(),
      initialStock: int.tryParse(_stockController.text) ?? 0,
      reminders: _reminders,
      scheduleType: _scheduleType,
      scheduleConfig: scheduleConfig,
      startDate: DateTime.now(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Medicine added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(medicineProvider.errorMessage ?? 'Failed to add medicine'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medicine'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Medicine Name - SRS-62
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Medicine Name',
                prefixIcon: Icon(Icons.medication_outlined),
              ),
              validator: Validators.validateMedicineName,
            ),
            const SizedBox(height: 16),

            // Category - SRS 2.3.5 (SRS-82)
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: AppConstants.medicineCategories.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value ?? 'Tablet';
                });
              },
            ),
            const SizedBox(height: 16),

            // Dosage - SRS-62
            TextFormField(
              controller: _dosageController,
              decoration: const InputDecoration(
                labelText: 'Dosage',
                hintText: 'e.g., 500mg, 10ml',
                prefixIcon: Icon(Icons.scale_outlined),
              ),
              validator: Validators.validateDosage,
            ),
            const SizedBox(height: 16),

            // Description (Optional)
            TextFormField(
              controller: _descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                prefixIcon: Icon(Icons.description_outlined),
              ),
            ),
            const SizedBox(height: 16),

            // Initial Stock - SRS-65
            TextFormField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Initial Stock (Optional)',
                prefixIcon: Icon(Icons.inventory_2_outlined),
              ),
              validator: Validators.validateStock,
            ),
            const SizedBox(height: 24),

            // Schedule Type - SRS-64
            Text('Schedule Type', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SegmentedButton<ScheduleType>(
              segments: const [
                ButtonSegment(value: ScheduleType.daily, label: Text('Daily')),
                ButtonSegment(value: ScheduleType.weekly, label: Text('Weekly')),
                ButtonSegment(value: ScheduleType.interval, label: Text('Interval')),
                ButtonSegment(value: ScheduleType.cyclic, label: Text('Cyclic')),
              ],
              selected: {_scheduleType},
              onSelectionChanged: (value) {
                setState(() {
                  _scheduleType = value.first;
                });
              },
            ),
            const SizedBox(height: 16),

            // Schedule Options
            if (_scheduleType == ScheduleType.weekly) _buildWeekDaySelector(),
            if (_scheduleType == ScheduleType.interval) _buildIntervalSelector(),
            if (_scheduleType == ScheduleType.cyclic) _buildCyclicSelector(),

            const SizedBox(height: 24),

            // Reminders - SRS-63
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Reminders', style: Theme.of(context).textTheme.titleMedium),
                TextButton.icon(
                  onPressed: _addReminder,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Time'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_reminders.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('No reminders set. Tap "Add Time" to add one.'),
              )
            else
              ..._reminders.asMap().entries.map((entry) {
                final index = entry.key;
                final reminder = entry.value;
                return ListTile(
                  leading: const Icon(Icons.alarm),
                  title: Text(reminder.formattedTime),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _removeReminder(index),
                  ),
                );
              }),

            const SizedBox(height: 32),

            // Save Button
            Consumer<MedicineProvider>(
              builder: (context, provider, child) {
                return ElevatedButton(
                  onPressed: provider.isLoading ? null : _handleSave,
                  child: provider.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Add Medicine'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekDaySelector() {
    final weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Wrap(
      spacing: 8,
      children: List.generate(7, (index) {
        final isSelected = _selectedWeekDays.contains(index);
        return FilterChip(
          label: Text(weekDays[index]),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedWeekDays.add(index);
              } else {
                _selectedWeekDays.remove(index);
              }
            });
          },
        );
      }),
    );
  }

  Widget _buildIntervalSelector() {
    return Row(
      children: [
        const Text('Every'),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: TextFormField(
            initialValue: _intervalDays.toString(),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            onChanged: (value) {
              _intervalDays = int.tryParse(value) ?? 1;
            },
          ),
        ),
        const SizedBox(width: 8),
        const Text('days'),
      ],
    );
  }

  Widget _buildCyclicSelector() {
    return Column(
      children: [
        Row(
          children: [
            const Text('Take for'),
            const SizedBox(width: 8),
            SizedBox(
              width: 60,
              child: TextFormField(
                initialValue: _cycleDaysOn.toString(),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  _cycleDaysOn = int.tryParse(value) ?? 21;
                },
              ),
            ),
            const SizedBox(width: 8),
            const Text('days'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Then pause for'),
            const SizedBox(width: 8),
            SizedBox(
              width: 60,
              child: TextFormField(
                initialValue: _cycleDaysOff.toString(),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  _cycleDaysOff = int.tryParse(value) ?? 7;
                },
              ),
            ),
            const SizedBox(width: 8),
            const Text('days'),
          ],
        ),
      ],
    );
  }
}
