
import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/state/setup_wizard_cubit.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/state/setup_wizard_state.dart';
import 'package:aurora/utility/button.dart';
import 'package:aurora/utility/placeholder.dart';
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
      title: "I came",
      subtitle: '',
    ),
    StepperData(
      title: "I saw",
      subtitle: '',
    ),
    StepperData(
      title: "I conquer",
      subtitle: '',
    ),
  ];

  @override
  initState() {
    context.read<SetupWizardCubit>().initSetup();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: BlocBuilder<SetupWizardCubit,SetupWizardState>(
        builder: (BuildContext context, state) {
          if(state is SetupWizardIncompatibleState){
            return  Column(
                children: [
                  Expanded(
                    child: AnotherStepper(
                      titleTextStyle: const TextStyle(color: Colors.white),
                      stepperList: stepperData,
                      stepperDirection: Axis.horizontal,
                      horizontalStepperHeight: 7,
                      activeBarColor: Colors.purple,
                      activeIndex: state.stepValue,
                      barThickness: 5,
                      dotWidget: const Icon(Icons.flag,color: Colors.purpleAccent),
                      inActiveBarColor: Colors.grey,
                      inverted: true,
                      gap: MediaQuery.of(context).size.width/7,
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child:SingleChildScrollView(
                      child: state.child,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      button(
                          isSelected: true,
                          title: "Install", action: (){
                        context.read<SetupWizardCubit>().installer();
                      }, context: context),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: button(title: "Cancel", action: (){

                        }, context: context),
                      ),
                    ],
                  )
                ]);
          }else{
            return placeholder();
          }
        },
      ),
    );
  }
}