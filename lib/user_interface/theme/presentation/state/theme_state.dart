import 'package:flutter/material.dart';

abstract class ThemeState{
  ThemeMode arTheme;
  ThemeState(this.arTheme);
}

class ThemeStateInit extends ThemeState{
  ThemeStateInit(super.arTheme);
}
class ThemeStateSwitch extends ThemeState{
  ThemeStateSwitch(super.arTheme);
}

class ThemeStateSet extends ThemeState{
  ThemeStateSet(super.arTheme);
}