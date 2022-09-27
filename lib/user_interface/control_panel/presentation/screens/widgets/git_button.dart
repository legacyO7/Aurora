import 'package:aurora/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget gitButton() => IconButton(
    onPressed: () async {
      var url = Uri.parse(Constants.kAuroraGitUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw "Could not launch $url";
      }
    },
    icon: const Icon(Icons.home));
