


import 'ar_widgets/ar_enums.dart';

class GlobalConfig {

  //version
   String? arVersion;
   String? arChannel;

  //paths
   String? kExecFaustusPath;
   String? kExecMainlinePath;
   String? kExecBatteryManagerPath;
   String? kWorkingDirectory;
   String? kExecPermissionCheckerPath;
   String? kTmpPath;

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
    this.kExecFaustusPath,
    this.kExecMainlinePath,
    this.kExecBatteryManagerPath,
    this.kWorkingDirectory,
    this.kAuroraGitRawYaml,
    this.kAuroraGitRawChangelog,
    this.kSecureBootEnabled,
    this.kFaustusGitUrl,
    this.kExecPermissionCheckerPath,
    this.kTmpPath,
    this.arMode=ARMODE.normal,
    this.deviceName=''
  });

  setInstance({
    arVersion,
    arChannel,
    kExecFaustusPath,
    kExecMainlinePath,
    kExecBatteryManagerPath,
    kWorkingDirectory,
    kAuroraGitRawYaml,
    kAuroraGitRawChangelog,
    kSecureBootEnabled,
    kFaustusGitUrl,
    kExecPermissionCheckerPath,
    arMode,
    kTmpPath,
    deviceName
  }){

    this.arChannel= arChannel??this.arChannel;
    this.arVersion=  arVersion??this.arVersion;
    this.kAuroraGitRawChangelog= kAuroraGitRawChangelog?? "https://raw.githubusercontent.com/legacyO7/Aurora/${arChannel??this.arChannel}/changelog.txt";
    this.kAuroraGitRawYaml= kAuroraGitRawYaml?? "https://raw.githubusercontent.com/legacyO7/Aurora/${arChannel??this.arChannel}/pubspec.yaml";
    this.kExecBatteryManagerPath=kExecBatteryManagerPath??this.kExecBatteryManagerPath;
    this.kExecFaustusPath= kExecFaustusPath??this.kExecFaustusPath;
    this.kExecMainlinePath= kExecMainlinePath??this.kExecMainlinePath;
    this.kSecureBootEnabled= kSecureBootEnabled??this.kSecureBootEnabled;
    this.kWorkingDirectory= kWorkingDirectory??this.kWorkingDirectory;
    this.kFaustusGitUrl=kFaustusGitUrl??'https://github.com/legacyO7/faustus.git';
    this.kExecPermissionCheckerPath=kExecPermissionCheckerPath??this.kExecPermissionCheckerPath;
    this.arMode=arMode??this.arMode;
    this.kTmpPath=kTmpPath??this.kTmpPath;
    this.deviceName=deviceName??this.deviceName;
  }

  
}
