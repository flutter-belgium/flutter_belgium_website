import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import '../data/models/team_member.dart';

class TeamSection extends StatelessComponent {
  const TeamSection({required this.members, super.key});

  final List<TeamMember> members;

  @override
  Component build(BuildContext context) {
    return section(classes: 'team', [
      div(classes: 'team-inner container', [
        const p(classes: 'section-label', [Component.text('Team')]),
        const h2(
            classes: 'section-title',
            [Component.text('The people behind Flutter Belgium')]),
        div(classes: 'team-grid', [
          for (final member in members) _MemberCard(member: member),
        ]),
      ]),
    ]);
  }
}

class _MemberCard extends StatelessComponent {
  const _MemberCard({required this.member});
  final TeamMember member;

  @override
  Component build(BuildContext context) {
    return div(classes: 'team-card', [
      img(
        src: member.avatarUrl,
        alt: member.name,
        classes: 'team-avatar',
      ),
      h3(classes: 'team-name', [Component.text(member.name)]),
      p(classes: 'team-role', [Component.text(member.role)]),
      if (member.linkedinUrl != null || member.githubUrl != null)
        div(classes: 'team-links', [
          if (member.linkedinUrl != null)
            a(
              [
                img(
                    src: '/assets/icons/linkedin.svg',
                    alt: 'LinkedIn',
                    classes: 'team-link-icon')
              ],
              href: member.linkedinUrl!,
              classes: 'team-link',
              attributes: {
                'target': '_blank',
                'rel': 'noopener noreferrer',
                'aria-label': 'LinkedIn'
              },
            ),
          if (member.githubUrl != null)
            a(
              [
                img(
                    src: '/assets/icons/github.svg',
                    alt: 'GitHub',
                    classes: 'team-link-icon')
              ],
              href: member.githubUrl!,
              classes: 'team-link',
              attributes: {
                'target': '_blank',
                'rel': 'noopener noreferrer',
                'aria-label': 'GitHub'
              },
            ),
        ]),
    ]);
  }
}
