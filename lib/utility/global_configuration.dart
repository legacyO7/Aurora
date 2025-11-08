
import 'ar_widgets/ar_enums.dart';

class GlobalConfig {

  //version
   String? arVersion;
   String? arChannel;

  //paths
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
   ArModeEnum arMode;

   //flags
   bool isLoggingEnabled;
   bool isFaustusEnforced;
   bool isBatteryManagerEnabled;
   bool isBacklightControllerEnabled;
   bool isBacklightControllerServiceEnabled;


   GlobalConfig({
    this.arVersion,
    this.arChannel,
    this.kWorkingDirectory,
    this.kAuroraGitRawYaml,
    this.kAuroraGitRawChangelog,
    this.kSecureBootEnabled,
    this.kFaustusGitUrl,
    this.kTmpPath,
    this.arMode=ArModeEnum.faustus,
    this.deviceName='',
    this.kThresholdPath,
    this.isLoggingEnabled=false,
    this.isFaustusEnforced =false,
    this.isBatteryManagerEnabled=false,
    this.isBacklightControllerEnabled=false,
    this.isBacklightControllerServiceEnabled=false
  });

  void setInstance({
    String? arVersion,
    String? arChannel,
    String? kExecFaustusPath,
    String? kExecBatteryManagerPath,
    String? kWorkingDirectory,
    String? kAuroraGitRawYaml,
    String? kAuroraGitRawChangelog,
    bool? kSecureBootEnabled,
    String? kFaustusGitUrl,
    ArModeEnum? arMode,
    String? kTmpPath,
    String? deviceName,
    String? kThresholdPath,
    bool? isLoggingEnabled,
    bool? isFaustusEnforced,
    bool? isBatteryManagerEnabled,
    bool? isBacklightControllerEnabled,
    bool? isBacklightControllerServiceEnabled
  }){

    this.arChannel= arChannel??this.arChannel;
    this.arVersion=  arVersion??this.arVersion;
    this.kAuroraGitRawChangelog= kAuroraGitRawChangelog?? "https://raw.githubusercontent.com/legacyO7/Aurora/${arChannel??this.arChannel}/changelog.txt";
    this.kAuroraGitRawYaml= kAuroraGitRawYaml?? "https://raw.githubusercontent.com/legacyO7/Aurora/${arChannel??this.arChannel}/pubspec.yaml";
    this.kSecureBootEnabled= kSecureBootEnabled??this.kSecureBootEnabled;
    this.kWorkingDirectory= kWorkingDirectory??this.kWorkingDirectory;
    this.kFaustusGitUrl=kFaustusGitUrl??'https://github.com/legacyO7/faustus.git';
    this.arMode=arMode??this.arMode;
    this.kTmpPath=kTmpPath??this.kTmpPath;
    this.deviceName=deviceName??this.deviceName;
    this.kThresholdPath=kThresholdPath??this.kThresholdPath;
    this.isLoggingEnabled=isLoggingEnabled??this.isLoggingEnabled;
    this.isFaustusEnforced=isFaustusEnforced??this.isFaustusEnforced;
    this.isBatteryManagerEnabled=isBatteryManagerEnabled??this.isBatteryManagerEnabled;
    this.isBacklightControllerEnabled=isBacklightControllerEnabled??this.isBacklightControllerEnabled;
    this.isBacklightControllerServiceEnabled=isBacklightControllerServiceEnabled??this.isBacklightControllerServiceEnabled;
  }

  
}
