// ignore_for_file: camel_case_types, library_private_types_in_public_api, prefer_const_constructors

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simply_todo/data/bloc/cubits/settings_cubit.dart';
import 'package:simply_todo/data/bloc/cubits/settings_cubit_state.dart';
import 'package:url_launcher/url_launcher.dart';

class kDrawer_Menu extends StatefulWidget {
  const kDrawer_Menu({super.key});

  @override
  _kDrawer_MenuState createState() => _kDrawer_MenuState();
}

class _kDrawer_MenuState extends State<kDrawer_Menu> {
  launchEmail(String toEmail, String subject, BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    String url = 'mailto:$toEmail?subject=${Uri.encodeComponent(subject)}';
    Uri uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text("UNKNOWN ERROR: Could not launch email application."),
        duration: Duration(milliseconds: 2000),
      ));
      log("ERROR CODE: $e");
    }
  }

  void _sendEmail(BuildContext context) {
    String toEmail = 'mulltechsoftware@gmail.com';
    String subject = 'SimplyToDo: Support Request';
    launchEmail(toEmail, subject, context);
  }

  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Container(
        color: const Color(0xFF191818),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF191818),
              ),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ExpansionTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Settings',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              children: [
// ************************** DARK MODE **************************
                BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, settingsState) {
                    return SwitchListTile(
                      title: const Text('Dark Mode',
                          style: TextStyle(color: Colors.white)),
                      value: settingsState.darkMode,
                      onChanged: (value) {
                        settingsCubit.setDarkMode(value);
                        log("Dark Mode: ${value ? 'ON' : 'OFF'}");
                      },
                    );
                  },
                ),
// ************************** DEFAULT ITEM CATEGORY **************************
                BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, settingsState) {
                    return ExpansionTile(
                      title: const Text('Default Item Tag',
                          style: TextStyle(color: Colors.white)),
                      children: [
                        RadioListTile(
                          title: const Text('Urgent',
                              style: TextStyle(color: Colors.white)),
                          value: 0,
                          activeColor: const Color(0xFFff6a06),
                          groupValue: settingsState.defaultCategory,
                          onChanged: (value) {
                            settingsCubit.setDefaultCategory(value!);
                            log("Default Item Category: Urgent $value");
                          },
                        ),
                        RadioListTile(
                          title: const Text('Important',
                              style: TextStyle(color: Colors.white)),
                          value: 1,
                          activeColor: const Color(0xFFff6a06),
                          groupValue: settingsState.defaultCategory,
                          onChanged: (value) {
                            settingsCubit.setDefaultCategory(value!);
                            log("Default Item Category: Important $value");
                          },
                        ),
                        RadioListTile(
                          title: const Text('Misc',
                              style: TextStyle(color: Colors.white)),
                          value: 2,
                          activeColor: const Color(0xFFff6a06),
                          groupValue: settingsState.defaultCategory,
                          onChanged: (value) {
                            settingsCubit.setDefaultCategory(value!);
                            log("Default Item Category: Misc $value");
                          },
                        ),
                        RadioListTile(
                          title: const Text('Shopping',
                              style: TextStyle(color: Colors.white)),
                          value: 3,
                          activeColor: const Color(0xFFff6a06),
                          groupValue: settingsState.defaultCategory,
                          onChanged: (value) {
                            settingsCubit.setDefaultCategory(value!);
                            log("Default Item Category: Shopping $value");
                          },
                        ),
                      ],
                    );
                  },
                ),
// ************************** ALL ITEMS FILTER **************************
                ExpansionTile(
                  title: const Text('All Items Filter',
                      style: TextStyle(color: Colors.white)),
                  children: [
                    BlocBuilder<SettingsCubit, SettingsState>(
                      builder: (context, settingsState) {
                        return Column(
                          children: [
                            CheckboxListTile(
                              title: const Text('Urgent',
                                  style: TextStyle(color: Colors.white)),
                              value: (settingsState.allItemsFilter & 8) == 8,
                              onChanged: (value) {
                                settingsCubit.setAllItemsFilter(
                                  value!
                                      ? (settingsState.allItemsFilter | 8)
                                      : (settingsState.allItemsFilter & ~8),
                                );
                                log("All Items Filter: Urgent ${value ? 'ON' : 'OFF'}");
                              },
                              activeColor: const Color(0xFFff6a06),
                              checkColor: Colors.white,
                            ),
                            CheckboxListTile(
                              title: const Text('Important',
                                  style: TextStyle(color: Colors.white)),
                              value: (settingsState.allItemsFilter & 4) == 4,
                              onChanged: (value) {
                                settingsCubit.setAllItemsFilter(
                                  value!
                                      ? (settingsState.allItemsFilter | 4)
                                      : (settingsState.allItemsFilter & ~4),
                                );
                                log("All Items Filter: Important ${value ? 'ON' : 'OFF'}");
                              },
                              activeColor: const Color(0xFFff6a06),
                              checkColor: Colors.white,
                            ),
                            CheckboxListTile(
                              title: const Text('Misc',
                                  style: TextStyle(color: Colors.white)),
                              value: (settingsState.allItemsFilter & 2) == 2,
                              onChanged: (value) {
                                settingsCubit.setAllItemsFilter(
                                  value!
                                      ? (settingsState.allItemsFilter | 2)
                                      : (settingsState.allItemsFilter & ~2),
                                );
                                log("All Items Filter: Misc ${value ? 'ON' : 'OFF'}");
                              },
                              activeColor: const Color(0xFFff6a06),
                              checkColor: Colors.white,
                            ),
                            CheckboxListTile(
                              title: const Text('Shopping',
                                  style: TextStyle(color: Colors.white)),
                              value: (settingsState.allItemsFilter & 1) == 1,
                              onChanged: (value) {
                                settingsCubit.setAllItemsFilter(
                                  value!
                                      ? (settingsState.allItemsFilter | 1)
                                      : (settingsState.allItemsFilter & ~1),
                                );
                                log("All Items Filter: Shopping ${value ? 'ON' : 'OFF'}");
                              },
                              activeColor: const Color(0xFFff6a06),
                              checkColor: Colors.white,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
// ************************** DELETE/EDIT HELP **************************
            ExpansionTile(
              leading: const Icon(Icons.question_mark, color: Colors.white),
              title: const Text('Delete/Edit Help',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              children: [
                const Text("To delete, slide the item to the right:",
                    style: TextStyle(color: Colors.white)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/delete_screenshot.png',
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const SizedBox(height: 25),
                const Text("To edit, slide the item to the left:",
                    style: TextStyle(color: Colors.white)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/edit_screenshot.png',
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.white),
              title: const Text('Contact/Support',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              onTap: () {
                _sendEmail(context);
                log("Contact/Support menu option selected.");
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.balance, color: Colors.white),
              title: const Text('Legal',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              onTap: () {
                log("Legal menu option selected.");
                Navigator.pushNamed(context, '/legal_screen',
                    arguments: settingsCubit);
              },
            ),
          ],
        ),
      ),
    );
  }
}