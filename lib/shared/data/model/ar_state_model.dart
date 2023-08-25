
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'ar_state_model.g.dart';

@Embedded(inheritance: false)
class ArState extends Equatable{
  final bool? boot;
  final bool? awake;
  final bool? sleep;

  const ArState({this.boot=false, this.awake=true, this.sleep=false});


  ArState negateValue(){
    return ArState(
      awake: !awake!,
      sleep: !sleep!,
      boot: !boot!
    );
  }

  @override
  @ignore
  List<Object?> get props => [awake, sleep, boot];
}