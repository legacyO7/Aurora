import 'package:aurora/user_interface/preferences/presentation/state/preferences_bloc.dart';
import 'package:aurora/user_interface/terminal/presentation/screens/terminal_screen.dart';
import 'package:aurora/utility/ar_widgets/ar_button.dart';
import 'package:aurora/utility/ar_widgets/ar_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../utility/constants.dart';

class Preferences extends StatefulWidget {
  const Preferences({super.key});

  @override
  _PreferencesState createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  @override
  void initState() {
    context.read<PreferencesBloc>().add(PreferencesInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesBloc, PreferencesState>(
      builder: (context, state) {
        return Padding(
          padding:  EdgeInsets.symmetric(vertical: 5.h),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Set Preferences"),

              Column(
                children: [
                  ArCheckbox(text: "Enable Battery Manager", isSelected: state.isBatteryManagerEnabled, onChange: (_) {
                    context.read<PreferencesBloc>().add(PreferencesSetEvent(isBatteryManagerEnabled: !state.isBatteryManagerEnabled));
                  }),

                  ArCheckbox(text: "Enable Keyboard Backlight Controller", isSelected: state.isBacklightControllerEnabled, onChange: (_) {
                    context.read<PreferencesBloc>().add(PreferencesSetEvent(isBacklightControllerEnabled: !state.isBacklightControllerEnabled));
                  }),

                ],
              ),

              state.isLoading?
                  const Expanded(child: TerminalScreen()):
                  ArButton(
                      title: "Save Preference",
                      animate: false,
                      action: () {
                    context.read<PreferencesBloc>().add(PreferencesSaveEvent());
                  })

            ],
          ),
        );
      },
    );
  }
}

void showPreferencesDialog(){
  showDialog(
      barrierDismissible: false,
      context: Constants.kScaffoldKey.currentState!.context,
      builder: (BuildContext context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 2.h),
        padding:  EdgeInsets.symmetric(vertical: 4.h,horizontal: 3.w),
        child: Scaffold(
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: () async {
                    Navigator.pop(context);
                  },
                      icon: const Icon(Icons.close))
                ],),
              const Expanded(
                child: Preferences(),
              ),
            ],
          ),
        ),
      )
  );
}
