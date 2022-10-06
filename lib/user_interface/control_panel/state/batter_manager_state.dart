import 'package:aurora/utility/constants.dart';
import 'package:equatable/equatable.dart';

 class BatteryManagerInit extends Equatable{
  final int batteryLevel;
  const BatteryManagerInit({
    this.batteryLevel=Constants.kMinimumChargeLevel
  });

  @override
  List<Object?> get props => [batteryLevel];
}


