import 'package:bloomix_mobile_app/core/app_colors.dart';
import 'package:bloomix_mobile_app/providers/plant_provider.dart';
import 'package:bloomix_mobile_app/services/auth_service.dart';
import 'package:bloomix_mobile_app/views/add_plant_screen.dart';
import 'package:bloomix_mobile_app/views/authentication_screen.dart';
import 'package:bloomix_mobile_app/widgets/plant_card.dart';
import 'package:bloomix_mobile_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends ConsumerWidget {
  DashboardScreen({super.key});

  final user = AuthService().currentUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: 120,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Plants',
                    style: GoogleFonts.lato(
                      color: AppColors.white,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Hi, ${user?.displayName ?? 'User'}! Keep your plants healthy.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                      fontSize: 17,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService().logout();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const AuthenticationScreen(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.white,
              size: 28,
            ),
          ),
        ],
      ),
      body: ref
          .watch(plantsProvider)
          .when(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),

            error: (error, stackTrace) => Center(
              child: Text(error.toString()),
            ),

            data: (plants) {
              if (plants.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_florist_rounded,
                          size: 90,
                          color: AppColors.primaryGreen,
                        ),

                        const SizedBox(height: 25),

                        const Text(
                          'No plants yet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          'Add your first plant and start tracking watering reminders to keep your plants healthy and thriving.',
                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: AppColors.textGrey,
                          ),
                        ),

                        const SizedBox(height: 35),

                        PrimaryButton(
                          text: 'Add Plant',
                          icon: Icons.add,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const AddPlantScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                        top: 20,
                        bottom: 10,
                      ),

                      itemCount: plants.length,

                      itemBuilder: (context, index) {
                        final plant = plants[index];

                        final nextWateringDate = plant.lastWateredDate.add(
                          Duration(days: plant.wateringFrequency),
                        );

                        final overdueDays = DateTime.now()
                            .difference(nextWateringDate)
                            .inDays;

                        return PlantCard(
                          plantName: plant.name,
                          lastWateredDate: plant.lastWateredDate,
                          overdueDays: overdueDays > 0 ? overdueDays : 0,

                          onWater: () async {
                            await ref
                                .read(plantsProvider.notifier)
                                .waterPlant(plant);
                          },
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 25,
                    ),

                    child: PrimaryButton(
                      text: 'Add Plant',
                      icon: Icons.add,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AddPlantScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }
}
