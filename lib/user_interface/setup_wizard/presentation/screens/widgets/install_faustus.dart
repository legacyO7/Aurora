import 'package:aurora/user_interface/setup_wizard/presentation/state/setup_wizard_cubit.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/state/setup_wizard_event.dart';
import 'package:aurora/user_interface/setup_wizard/presentation/state/setup_wizard_state.dart';
import 'package:aurora/utility/constants.dart';
import 'package:aurora/utility/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FaustusInstaller extends StatefulWidget{
  const FaustusInstaller({super.key});
  @override
  State<FaustusInstaller> createState() => _FaustusInstallerState();
}

class _FaustusInstallerState extends State<FaustusInstaller>{

  late TextEditingController _controller;
  @override
  void initState() {
    _controller=TextEditingController();
    _controller.text=Constants.kFaustusGitUrl;
    context.read<SetupWizardCubit>().add(EventSWValidateRepo(url: _controller.text));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return BlocBuilder<SetupWizardCubit,SetupWizardState>(
     builder: (BuildContext context, state) {
       if(state is SetupWizardIncompatibleState){
         Color setColor()=> state.isValid? Colors.green:Colors.red;
         return Column(
           children: [
             const Text("install Faustus"),
             Container(
               decoration: BoxDecoration(
                 border: Border.all(
                     color: setColor(),
                     width: 3.0
                 ),
                 borderRadius: const BorderRadius.all(
                     Radius.circular(25.0)
                 ),
               ),
               margin: const EdgeInsets.all(30.0),
               padding: const EdgeInsets.only(right: 20),
               child: Row(
                 mainAxisSize: MainAxisSize.min,
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   Container(
                     decoration:  BoxDecoration(
                       color:setColor(),
                       border: Border.all(
                           color: setColor(),
                           width: 1.0
                       ),
                       borderRadius: const BorderRadius.only(
                         topLeft:Radius.circular(20),
                         bottomLeft: Radius.circular(20),
                       ),
                     ),
                     padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                     margin: const EdgeInsets.only(right: 10),
                     child: const Text("Faustus Repo"),

                   ),
                   Flexible(
                     child: TextFormField(
                       controller: _controller,
                       decoration: const InputDecoration(
                         border: InputBorder.none,
                       ),
                       onChanged: (value)=>context.read<SetupWizardCubit>().add(EventSWValidateRepo(url: value)),
                     ),
                   ),
                   Icon((state.isValid)?Icons.check:Icons.close,color:setColor())
                 ],
               ),
             )
           ],
         );
       }else{
         return placeholder();
       }

     }
   );
  }

}
