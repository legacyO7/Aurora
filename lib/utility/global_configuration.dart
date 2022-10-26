class GlobalConfig {

  //version
   String? arVersion = '-';
   String? arFlavour = 'stable';

  //paths
   String? kExecFaustusPath = '';
   String? kExecBatteryManagerPath = '';
   String? kWorkingDirectory = '/tmp';

  //url
   String? kAuroraGitRawYaml;
   String? kAuroraGitRawChangelog;
   String? kFaustusGitUrl;


   //misc
   bool? kSecureBootEnabled = false;


  GlobalConfig({
    this.arVersion,
    this.arFlavour,
    this.kExecFaustusPath,
    this.kExecBatteryManagerPath,
    this.kWorkingDirectory,
    this.kAuroraGitRawYaml,
    this.kAuroraGitRawChangelog,
    this.kSecureBootEnabled,
    this.kFaustusGitUrl
  });

  setInstance({
    arVersion,
    arFlavour,
    kExecFaustusPath,
    kExecBatteryManagerPath,
    kWorkingDirectory,
    kAuroraGitRawYaml,
    kAuroraGitRawChangelog,
    kSecureBootEnabled,
    kFaustusGitUrl
  }){

    this.arFlavour= arFlavour??this.arFlavour;
    this.arVersion=  arVersion??this.arVersion;
    this.kAuroraGitRawChangelog= kAuroraGitRawChangelog?? "https://raw.githubusercontent.com/legacyO7/Aurora/${arFlavour??this.arFlavour}/changelog.txt";
    this.kAuroraGitRawYaml= kAuroraGitRawYaml?? "https://raw.githubusercontent.com/legacyO7/Aurora/${arFlavour??this.arFlavour}/pubspec.yaml";
    this.kExecBatteryManagerPath=kExecBatteryManagerPath??this.kExecBatteryManagerPath;
    this.kExecFaustusPath= kExecFaustusPath??this.kExecFaustusPath;
    this.kSecureBootEnabled= kSecureBootEnabled??this.kSecureBootEnabled;
    this.kWorkingDirectory= kWorkingDirectory??this.kWorkingDirectory;
    this.kFaustusGitUrl=kFaustusGitUrl??'https://github.com/legacyO7/faustus.git';

  }
}
