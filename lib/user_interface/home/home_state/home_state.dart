import '../../../utility/terminal_text.dart';

abstract class HomeState{}

class HomeStateInit extends HomeState{}

class AccessGranted extends HomeState{
  List<TerminalText> terminalOut;
  bool inProgress;
  bool hasRootAccess;
  AccessGranted({required this.terminalOut,required this.inProgress,required this.hasRootAccess});
}