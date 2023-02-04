import 'package:aurora/user_interface/terminal/presentation/state/terminal_base_bloc.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_bloc.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_state.dart';
import 'package:aurora/utility/ar_widgets/arwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class TerminalScreen extends StatefulWidget {
  const TerminalScreen({Key? key}) : super(key: key);

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {

  late ScrollController terminalViewController;


  @override
  initState() {
    super.initState();
    terminalViewController = ScrollController();
  }

  @override
  dispose() {
    super.dispose();
    terminalViewController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness==Brightness.dark?ArColors.black:ArColors.white,
      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      height: MediaQuery.of(context).size.height,
      child: SizedBox(
        child: BlocBuilder<TerminalBloc,TerminalState>(
          builder: (BuildContext context, state) {
            if(state is TerminalStateLoaded ) {
              var c = state.terminalOut.reversed.toList(growable: false);
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        controller: terminalViewController,
                        reverse: true,
                        itemBuilder: (ctx, i) => arTerminal(context.read<TerminalBloc>().convertToTerminalText(line: c[i])),
                        itemCount: state.terminalOut.length),
                  ),
                ],
              );
            }
            else {
              context.read<TerminalBaseBloc>().clearTerminalOutput();
              return Container();
            }
          },
        ),
      ),
    );
  }
}