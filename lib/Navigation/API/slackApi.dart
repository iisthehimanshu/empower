import 'dart:convert';
import 'package:http/http.dart' as http;

// Replace with your Slack webhook URL
const String slackWebhookUrl = 'https://hooks.slack.com/services/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';

void sendErrorToSlack(dynamic error, StackTrace? stackTrace) async {
  final message = {
    'text': error,
  };

  final response = await http.post(
    Uri.parse(slackWebhookUrl),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(message),
  );

  if (response.statusCode != 200) {
    print('Failed to send error to Slack: ${response.statusCode}');
  }
}

void performActionOnError(String error, StackTrace stackTrace) {
  sendErrorToSlack(error, stackTrace);
}
