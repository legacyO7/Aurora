import 'package:aurora/utility/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncher{
  static Future launchArUrl({String? subPath}) async {
    var url = Uri.parse(Constants.kAuroraGitUrl+(subPath??''));
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "error launching $url";
    }
  }
}