import '../../../utility/terminal_text.dart';

abstract class HomeState{}

class HomeStateInit extends HomeState{}

class AccessGranted extends HomeState{
  List<TerminalText> terminalOp;
  bool inProgress;
  bool hasRootAccess;
  AccessGranted({required this.terminalOp,required this.inProgress,required this.hasRootAccess});
}