import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

class AboutSection extends StatelessComponent {
  const AboutSection({super.key});

  @override
  Component build(BuildContext context) {
    return const section(id: 'about', classes: 'about', [
      div(classes: 'about-inner', [
        p(classes: 'section-label', [Component.text('About us')]),
        h2(
            classes: 'section-title',
            [Component.text('Flutter developers, made in Belgium')]),
        p(classes: 'section-body', [
          Component.text(
            'Flutter Belgium is a community of Flutter developers across Belgium. '
            'Every two to three months we host a meetup at a Belgian company that '
            'uses Flutter in production. Talks are recorded and published on YouTube, '
            'and our Slack is where the conversation keeps going between events.',
          ),
        ]),
      ]),
    ]);
  }
}
