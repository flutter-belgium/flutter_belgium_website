import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

class MadeInCard extends StatelessComponent {
  const MadeInCard({
    required this.name,
    required this.localImagePath,
    required this.href,
    this.isLogo = false,
    super.key,
  });

  final String name;
  final String localImagePath;
  final String href;
  final bool isLogo;

  @override
  Component build(BuildContext context) {
    if (isLogo) {
      return a(
        [
          img(
              src: '/$localImagePath',
              alt: name,
              classes: 'made-in-card-logo-img')
        ],
        href: href,
        classes: 'made-in-card-logo',
      );
    }
    return a(
      [
        img(src: '/$localImagePath', alt: name, classes: 'made-in-card-img'),
        span(classes: 'made-in-card-name', [Component.text(name)]),
      ],
      href: href,
      classes: 'made-in-card',
    );
  }
}
