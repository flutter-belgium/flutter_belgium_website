import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

class MadeInAddCard extends StatelessComponent {
  const MadeInAddCard({
    required this.href,
    required this.label,
    this.isLogo = false,
    super.key,
  });

  final String href;
  final String label;
  final bool isLogo;

  @override
  Component build(BuildContext context) {
    if (isLogo) {
      return a(
        [
          div(classes: 'made-in-add-icon', [const Component.text('+')]),
          span(classes: 'made-in-add-label', [Component.text(label)]),
        ],
        href: href,
        classes: 'made-in-card-logo made-in-card-add',
        attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
      );
    }
    return a(
      [
        div(classes: 'made-in-add-placeholder', [
          div(classes: 'made-in-add-icon', [const Component.text('+')]),
        ]),
        span(classes: 'made-in-card-name', [Component.text(label)]),
      ],
      href: href,
      classes: 'made-in-card',
      attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
    );
  }
}
