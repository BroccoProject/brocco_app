import 'package:flutter_test/flutter_test.dart';
import 'package:brocco_app/features/game/utils/step_time_parser.dart';

void main() {
  group('parseStepDuration', () {
    test('zwraca null gdy tekst nie zawiera czasu', () {
      expect(parseStepDuration('Pokrój cebulę na drobno.'), isNull);
    });

    test('parsuje minuty', () {
      final duration = parseStepDuration('Smaż przez 5 minutes');
      expect(duration, isNotNull);
      expect(duration!.inMinutes, 5);
    });

    test('parsuje sekundy', () {
      final duration = parseStepDuration('Mieszaj przez 30 seconds');
      expect(duration, isNotNull);
      expect(duration!.inSeconds, 30);
    });

    test('parsuje godziny', () {
      final duration = parseStepDuration('Gotuj przez 2 hours');
      expect(duration, isNotNull);
      expect(duration!.inHours, 2);
    });

    test('parsuje kombinację godzin i minut', () {
      final duration = parseStepDuration('Piecz przez 1 hour 30 minutes');
      expect(duration, isNotNull);
      expect(duration!.inMinutes, 90);
    });

    test('parsuje skróconą formę "min"', () {
      final duration = parseStepDuration('Odstaw na 10 min');
      expect(duration, isNotNull);
      expect(duration!.inMinutes, 10);
    });

    test('parsuje skróconą formę "sec"', () {
      final duration = parseStepDuration('Blenduj przez 20 sec');
      expect(duration, isNotNull);
      expect(duration!.inSeconds, 20);
    });

    test('parsuje tekst case-insensitive', () {
      final duration = parseStepDuration('Gotuj przez 3 MINUTES');
      expect(duration, isNotNull);
      expect(duration!.inMinutes, 3);
    });
  });
}
