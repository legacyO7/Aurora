import '../../../utility/terminal_text.dart';

abstract class HomeState{}

class HomeStateInit extends HomeState{}

class HomeStateAccessGranted extends HomeState{
  List<TerminalText> terminalOp;
  bool inProgress;
  HomeStateAccessGranted({required this.terminalOp,required this.inProgress});
}