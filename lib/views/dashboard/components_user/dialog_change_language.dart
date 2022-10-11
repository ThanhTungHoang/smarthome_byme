import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smarthome_byme/BLoC/change_language_cubit/change_language_cubit.dart';
import 'package:smarthome_byme/generated/l10n.dart';

class DialogChangeLanguage extends StatefulWidget {
  const DialogChangeLanguage({super.key});

  @override
  State<DialogChangeLanguage> createState() => _DialogChangeLanguageState();
}

class _DialogChangeLanguageState extends State<DialogChangeLanguage> {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).change_language,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              context
                  .read<ChangeLanguageCubit>()
                  .changeLanguage(languageCode: "en", countryCode: "US");
            },
            child: Text("Tieng anh"),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<ChangeLanguageCubit>()
                  .changeLanguage(languageCode: "vi", countryCode: "VN");
            },
            child: Text("Tieng viet"),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text("Thay đổi"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Thoát"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
