enum ARMODE {normal, faustus, batterymanager}

class GlobalConfig {

  //version
   String? arVersion;
   String? arChannel;

  //paths
   String? kExecFaustusPath;
   String? kExecBatteryManagerPath;
   String? kWorkingDirectory;
   String? kExecPermissionChecker;

  //url
   String? kAuroraGitRawYaml;
   String? kAuroraGitRawChangelog;
   String? kFaustusGitUrl;


   //misc
   bool? kSecureBootEnabled = false;
   ARMODE arMode;


  GlobalConfig({
    this.arVersion,
    this.arChannel,
    this.kExecFaustusPath,
    this.kExecBatteryManagerPath,
    this.kWorkingDirectory,
    this.kAuroraGitRawYaml,
    this.kAuroraGitRawChangelog,
    this.kSecureBootEnabled,
    this.kFaustusGitUrl,
    this.kExecPermissionChecker,
    this.arMode=ARMODE.normal
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
    kExecPermissionChecker,
    arMode
  }){

    this.arChannel= arChannel??"stable";
    this.arVersion=  arVersion??this.arVersion;
    this.kAuroraGitRawChangelog= kAuroraGitRawChangelog?? "https://raw.githubusercontent.com/legacyO7/Aurora/${arChannel??this.arChannel}/changelog.txt";
    this.kAuroraGitRawYaml= kAuroraGitRawYaml?? "https://raw.githubusercontent.com/legacyO7/Aurora/${arChannel??this.arChannel}/pubspec.yaml";
    this.kExecBatteryManagerPath=kExecBatteryManagerPath??this.kExecBatteryManagerPath;
    this.kExecFaustusPath= kExecFaustusPath??this.kExecFaustusPath;
    this.kSecureBootEnabled= kSecureBootEnabled??this.kSecureBootEnabled;
    this.kWorkingDirectory= kWorkingDirectory??this.kWorkingDirectory;
    this.kFaustusGitUrl=kFaustusGitUrl??'https://github.com/legacyO7/faustus.git';
    this.kExecPermissionChecker=kExecPermissionChecker??this.kExecPermissionChecker;
    this.arMode=arMode??this.arMode;

  }
}
