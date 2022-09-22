import 'package:aurora/user_interface/home/presentation/state/home_cubit.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_cubit.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_state.dart';
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
      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      height: MediaQuery.of(context).size.height,
      color: Colors.black,
      child: SizedBox(
        child: BlocBuilder<TerminalCubit,TerminalState>(
          builder: (BuildContext context, state) {
            if(state is TerminalStateLoaded ) {
              var c = state.terminalOut.reversed.toList(growable: false);
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                        controller: terminalViewController,
                        reverse: true,
                        itemBuilder: (ctx, i) => Text(c[i].text,style: TextStyle(color: c[i].color)),
                        separatorBuilder: (_, __) => const Divider(),
                        itemCount: state.terminalOut.length),
                  ),
                ],
              );
            }
            else {
              context.read<HomeCubit>().execute("clear");
              return Container();
            }
          },
        ),
      ),
    );
  }
}