import 'package:aurora/shared/utility/init_aurora.dart';
import 'package:aurora/user_interface/disable_services/disable_services.dart';
import 'package:aurora/utility/ar_widgets/ar_widgets.dart';
import 'package:aurora/utility/global_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisableButton extends StatefulWidget with GlobalMixin {
  const DisableButton({super.key});

  @override
  State<DisableButton> createState() => _DisableButtonState();
}

class _DisableButtonState extends State<DisableButton> {

  late Bloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<DisableSettingsBloc>(context);
    _bloc.add(DisableEventInit());
    super.initState();
  }

  Widget _selectorWindow() {
    return BlocProvider.value(value: sl<DisableSettingsBloc>(),
      child: BlocBuilder<DisableSettingsBloc, DisableSettingsState>(
          builder: (BuildContext context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                ArCheckbox(
                    text: "Disable charging threshold",
                    isSelected: state.disableThreshold,
                    onChange: (_) => _bloc.add(DisableEventCheckDisableServices(disableThreshold: !state.disableThreshold))
                ),

                if(!widget.isMainLine() && !widget.isFallbackedWorkingDirectory())
                  ArCheckbox(
                      text: "Disable faustus module",
                      isSelected: state.disableFaustusModule,
                      onChange: (_) =>
                          _bloc.add(DisableEventCheckDisableServices(disableFaustusModule: !state.disableFaustusModule))
                  ),
                if(widget.isInstalledPackage() && !widget.isFallbackedWorkingDirectory())
                  ArCheckbox(
                      text: "Uninstall Aurora",
                      isSelected: state.uninstallAurora,
                      onChange: (_) =>
                          _bloc.add(DisableEventCheckDisableServices(uninstallAurora: !state.uninstallAurora))
                  ),
              ],
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ArButton(
      action: () async {
        await arDialog(
            title: "Disable Services",
            subject: "Select the services to be disabled",
            optionalWidget: _selectorWindow(),
            onConfirm: () {
              _bloc.add(DisableEventSubmitDisableServices());
            },
            onCancel: () {
              Navigator.pop(context);
            });
      },
      title: "Disable Features",
      animate: false,
    );
  }
}
