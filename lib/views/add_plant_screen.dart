import 'package:bloomix_mobile_app/core/app_colors.dart';
import 'package:bloomix_mobile_app/providers/plant_provider.dart';
import 'package:bloomix_mobile_app/widgets/custom_text_field.dart';
import 'package:bloomix_mobile_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AddPlantScreen extends ConsumerStatefulWidget {
  const AddPlantScreen({super.key});

  @override
  ConsumerState<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends ConsumerState<AddPlantScreen> {
  final _nameController = TextEditingController();
  final _frequencyController = TextEditingController(text: '3');

  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate == null) return;

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _addPlant() async {
    final name = _nameController.text.trim();
    final frequency = int.tryParse(_frequencyController.text.trim());

    if (name.isEmpty || frequency == null || frequency <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid plant data'),
        ),
      );
      return;
    }
    await ref
        .read(plantsProvider.notifier)
        .addPlant(
          name: _nameController.text.trim(),
          wateringFrequency: int.parse(_frequencyController.text.trim()),
          lastWateredDate: _selectedDate,
        );

    if (!mounted) return;

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd.MM.yyyy.').format(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: const Text(
          'Add New Plant',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Plant Name'),
            const SizedBox(height: 10),
            CustomTextField(
              hintText: 'e.g., Snake Plant',
              controller: _nameController,
            ),

            const SizedBox(height: 22),

            const Text('Watering Frequency (days)'),
            const SizedBox(height: 10),
            CustomTextField(
              hintText: '3',
              controller: _frequencyController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 22),
            const Text('Last Watered Date'),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.textGrey,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 35),
            PrimaryButton(
              text: 'Add Plant',
              onPressed: _addPlant,
            ),
          ],
        ),
      ),
    );
  }
}
