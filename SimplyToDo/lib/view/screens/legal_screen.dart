import 'package:flutter/material.dart';
import 'package:simply_todo/data/bloc/cubits/settings_cubit.dart';
import 'package:simply_todo/data/models/legal_packages.dart';

class LegalScreen extends StatelessWidget {
  final SettingsCubit settingsCubit;
  LegalScreen({required this.settingsCubit, super.key});

  @override
  Widget build(BuildContext context) {
    bool darkModeOn = settingsCubit.state.darkMode;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Legal", style: TextStyle(fontSize: 25)),
        backgroundColor: const Color(0xFF191818),
      ),
      backgroundColor: darkModeOn ? Color(0xFF191818) : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            const Text(
              "App Version: 1.0.0",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 20),
            const Text(
              "Legal Information:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 20),
            const Text(
              "Please Note:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              "This app was developed and is owned by\nEric S. Mullen of Las Vegas, NV, USA\n\n"
              "All data is stored locally.\n\n"
              "If you encounter any bugs throughout your use of this app, please use the \"Contact/Support\" option in "
              "the menu so it can get resolved.\n\n",
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            const Text(
              "Packages used in the app:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: packages.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${packages[index].name} (Version: ${packages[index].version})",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        packages[index].license,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
