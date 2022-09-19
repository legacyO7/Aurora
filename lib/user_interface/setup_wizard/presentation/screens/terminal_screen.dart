
import 'package:aurora/user_interface/home/presentation/state/home_cubit.dart';
import 'package:aurora/user_interface/home/presentation/state/home_state.dart';
import 'package:aurora/user_interface/terminal/presentation/state/terminal_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {

  late ScrollController terminalViewController;
  late FocusNode tvFocus;
  late TextEditingController _command;


  @override
  initState() {
    super.initState();
    _command = TextEditingController();
    terminalViewController = ScrollController();
    tvFocus = FocusNode();
  }

  @override
  dispose() {
    super.dispose();
    tvFocus.dispose();
    terminalViewController.dispose();
    _command.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<HomeCubit,HomeState>(
        builder: (BuildContext context, state) {
          if(state is AccessGranted ) {
            var c = state.terminalOut.reversed.toList(growable: false);
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      controller: terminalViewController,
                      reverse: true,
                      itemBuilder: (ctx, i) {
                        return Text(c[i].text,style: TextStyle(color: c[i].color));
                      },
                      separatorBuilder: (_, __) => const Divider(),
                      itemCount: state.terminalOut.length),
                ),
                const Divider(color: Colors.red,),
                Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          maxLines: 1,
                          focusNode: tvFocus,
                          controller: _command,
                          onFieldSubmitted: (value) {
                            context.read<HomeCubit>().execute(value);
                            _command.clear();
                            tvFocus.requestFocus();
                          },
                        ),
                      ),
                        !state.inProgress?const Text('idle'):
                        IconButton(onPressed: () {
                          context.read<TerminalCubit>().killProcess();
                        }, icon: const Icon(Icons.close))
                    ])
              ],
            );
          }
          else {
            context.read<HomeCubit>().execute("echo hello world");
            return Container();
          }
        },

      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}