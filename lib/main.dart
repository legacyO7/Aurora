import 'package:aurora/user_interface/home/home_state/home_cubit.dart';
import 'package:aurora/user_interface/home/home_ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const Aurora());
}

class Aurora extends StatelessWidget {
  const Aurora({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
       BlocProvider(create: (context)=>HomeCubit())
      ],
      child: MaterialApp(
        title: 'Aurora',
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.dark,
        home: const HomeScreen(),
      ),
    );
  }
}
