import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

class TbdTalkCard extends StatelessComponent {
  const TbdTalkCard({required this.slotNumber, super.key});

  final int slotNumber;

  @override
  Component build(BuildContext context) {
    return article(classes: 'talk-card talk-card--tbd', [
      div(classes: 'talk-card-slot', [Component.text('Talk $slotNumber')]),
      div(classes: 'talk-card-tbd-label', [
        b([const Component.text('TBD')]),
      ]),
    ]);
  }
}
