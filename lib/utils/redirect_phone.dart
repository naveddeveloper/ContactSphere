import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Call a phone number using the tel: scheme
Future<void> callPhone(String phoneNumber) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    debugPrint("Could not launch phone dialer");
  }
}

// Send a message using the sms: scheme
Future<void> sendMessage(String phoneNumber) async {
  final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
  if (await canLaunchUrl(smsUri)) {
    await launchUrl(smsUri);
  } else {
    debugPrint("Could not launch SMS");
  }
}

// Send an email using the mailto: scheme
Future<void> sendEmail(String email) async {
  final Uri emailUri = Uri(scheme: 'mailto', path: email);
  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    debugPrint("Could not launch email client");
  }
}

Future<void> openInGoogleMaps(String address) async {
  String encodedAddress = Uri.encodeComponent(address);
  String googleMapsAppUrl = "geo:0,0?q=$encodedAddress";
  Uri uri = Uri.parse(googleMapsAppUrl);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    // Fallback to browser if Google Maps is not installed
    String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$encodedAddress";
    Uri fallbackUri = Uri.parse(googleMapsUrl);
    if (await canLaunchUrl(fallbackUri)) {
      await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not launch Google Maps";
    }
  }
}

Future<void> openUrlInBrowser(String url) async {
  var newurl = "https://$url";

  final Uri uri = Uri.parse(newurl);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw "Could not launch $url";
  }
}
