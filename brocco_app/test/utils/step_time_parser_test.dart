import 'package:flutter_test/flutter_test.dart';
import 'package:brocco_app/features/game/utils/step_time_parser.dart';

void main() {
  group('parseStepDuration', () {
    test('zwraca null gdy tekst nie zawiera żadnego czasu', () {
      expect(parseStepDuration('Chop onion into small pieces.'), isNull);
    });
    test('parsuje kombinację godzin i minut na łączną liczbę minut', () {
      final duration = parseStepDuration('Cook for 1 hour 30 minutes');
      expect(duration, isNotNull);
      expect(duration!.inMinutes, 90);
    });

    test('parsuje skróconą formę "min"', () {
      final duration = parseStepDuration('Cook for 10 min');
      expect(duration, isNotNull);
      expect(duration!.inMinutes, 10);
    });
  });
}
