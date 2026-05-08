import 'package:flutter_driver/flutter_driver.dart';
import 'package:integration_test/integration_test_driver.dart' as driver;

Future<void> main() => driver.integrationDriver(
  responseDataCallback: (Map<String, dynamic>? data) async {
    final timeline = data?['my_performance_report'] as Map<String, dynamic>?;
    if (timeline == null) {
      return;
    }

    final summary = TimelineSummary.summarize(Timeline.fromJson(timeline));
    await driver.writeResponseData(
      summary.summaryJson,
      testOutputFilename: 'my_performance_report',
    );
  },
  writeResponseOnFailure: true,
);
