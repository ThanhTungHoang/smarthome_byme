import 'dart:async';

import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarthome_byme/BLoC/change_language_cubit/change_language_cubit.dart';
import 'package:smarthome_byme/generated/l10n.dart';

class DialogChangeLanguage extends StatefulWidget {
  const DialogChangeLanguage({super.key});

  @override
  State<DialogChangeLanguage> createState() => _DialogChangeLanguageState();
}

class _DialogChangeLanguageState extends State<DialogChangeLanguage> {
  bool vi = false;
  bool en = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _getLanguage().whenComplete(() {
      setState(() {});
    });
  }

  _getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString('languageCode');
    if (langCode == "vi") {
      vi = true;
      en = false;
    } else {
      vi = false;
      en = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            S.of(context).language_selection,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Directionality(
            textDirection: TextDirection.rtl,
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  vi = true;
                  en = false;
                });
              },
              icon: vi
                  ? const Icon(
                      Icons.done,
                      color: Colors.green,
                    )
                  : const Icon(null),
              label: Text(
                S.of(context).vietnamese,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  en = true;
                  vi = false;
                });
              },
              icon: en
                  ? const Icon(
                      Icons.done,
                      color: Colors.green,
                    )
                  : const Icon(null),
              label: Text(
                S.of(context).english,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (vi == true) {
                    context
                        .read<ChangeLanguageCubit>()
                        .changeLanguage(languageCode: "vi", countryCode: "VN");
                  } else {
                    context
                        .read<ChangeLanguageCubit>()
                        .changeLanguage(languageCode: "en", countryCode: "US");
                  }
                  Navigator.pop(context);
                },
                child: Text(S.of(context).change),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(S.of(context).cancel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
