
import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_bloc.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_event.dart';
import 'package:aurora/user_interface/setup/presentation/state/setup_state.dart';
import 'package:aurora/utility/ar_widgets/arwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {

  List<StepperData> stepperData = [
    StepperData(
      title: "Acknowledge",
      subtitle: '',
    ),
    StepperData(
      title: "Install Packages",
      subtitle: '',
    ),
    StepperData(
      title: "Install Module",
      subtitle: '',
    ),
  ];

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: BlocBuilder<SetupBloc,SetupState>(
        builder: (BuildContext context, state) {

          if(state is SetupPermissionState){
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Aurora wants to configure your system"),
                ArButton(title: "Allow",
                    action: (){
                  context.read<SetupBloc>().add(SetupEventConfigure(allow: true));
                })
              ],
            );
          }

          if(state is SetupIncompatibleState){
            return  Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AnotherStepper(
                      titleTextStyle: const TextStyle(color: ArColors.white),
                      stepperList: stepperData,
                      stepperDirection: Axis.horizontal,
                      horizontalStepperHeight: 7,
                      activeBarColor: ArColors.purple,
                      activeIndex: state.stepValue,
                      barThickness: 5,
                      dotWidget: const Icon(Icons.flag,color: ArColors.purpleDark),
                      inActiveBarColor: ArColors.grey,
                      inverted: true,
                      gap: MediaQuery.of(context).size.width/7,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child:state.child??placeholder(),
                  ),
                  BlocBuilder<ArButtonCubit,bool>(
                    builder: (BuildContext context, isLoading) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ArButton(
                              isEnabled: state.isValid,
                              isLoading: isLoading,
                              isSelected: true,
                              title: "Install", action: ()async{
                               context.read<SetupBloc>().add(SetupEventOnInstall(stepValue: state.stepValue));
                          }),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ArButton(
                                isEnabled: state.isValid&&!isLoading,
                                title: state.stepValue>0?"Back":"Cancel", action: (){
                                  context.read<SetupBloc>().add(SetupEventOnCancel(stepValue: state.stepValue));
                            }),
                          ),
                        ],
                      );
                    },

                  ),
                ]);
          }else{
            return placeholder();
          }
        },
      ),
    );
  }
}