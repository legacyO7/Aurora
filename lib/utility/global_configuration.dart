


import 'ar_widgets/ar_enums.dart';

class GlobalConfig {

  //version
   String? arVersion;
   String? arChannel;

  //paths
   String? kExecBatteryManagerPath;
   String? kWorkingDirectory;
   String? kTmpPath;
   String? kThresholdPath;

  //url
   String? kAuroraGitRawYaml;
   String? kAuroraGitRawChangelog;
   String? kFaustusGitUrl;


   //misc
   bool? kSecureBootEnabled = false;
   String deviceName;
   ARMODE arMode;


  GlobalConfig({
    this.arVersion,
    this.arChannel,
    this.kExecBatteryManagerPath,
    this.kWorkingDirectory,
    this.kAuroraGitRawYaml,
    this.kAuroraGitRawChangelog,
    this.kSecureBootEnabled,
    this.kFaustusGitUrl,
    this.kTmpPath,
    this.arMode=ARMODE.faustus,
    this.deviceName='',
    this.kThresholdPath
  });

  setInstance({
    arVersion,
    arChannel,
    kExecFaustusPath,
    kExecBatteryManagerPath,
    kWorkingDirectory,
    kAuroraGitRawYaml,
    kAuroraGitRawChangelog,
    kSecureBootEnabled,
    kFaustusGitUrl,
    arMode,
    kTmpPath,
    deviceName,
    kThresholdPath
  }){

    this.arChannel= arChannel??this.arChannel;
    this.arVersion=  arVersion??this.arVersion;
    this.kAuroraGitRawChangelog= kAuroraGitRawChangelog?? "https://raw.githubusercontent.com/legacyO7/Aurora/${arChannel??this.arChannel}/changelog.txt";
    this.kAuroraGitRawYaml= kAuroraGitRawYaml?? "https://raw.githubusercontent.com/legacyO7/Aurora/${arChannel??this.arChannel}/pubspec.yaml";
    this.kExecBatteryManagerPath=kExecBatteryManagerPath??this.kExecBatteryManagerPath;
    this.kSecureBootEnabled= kSecureBootEnabled??this.kSecureBootEnabled;
    this.kWorkingDirectory= kWorkingDirectory??this.kWorkingDirectory;
    this.kFaustusGitUrl=kFaustusGitUrl??'https://github.com/legacyO7/faustus.git';
    this.arMode=arMode??this.arMode;
    this.kTmpPath=kTmpPath??this.kTmpPath;
    this.deviceName=deviceName??this.deviceName;
    this.kThresholdPath=kThresholdPath??this.kThresholdPath;
  }

  
}
