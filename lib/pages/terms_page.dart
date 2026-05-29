import 'package:jaspr/jaspr.dart';

import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/pages/legal_page.dart';

class TermsPage extends StatelessComponent {
  const TermsPage({required this.communityLinks, super.key});

  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return LegalPage(
      communityLinks: communityLinks,
      title: 'Terms & Conditions',
      sections: const [
        LegalSection(
          heading: 'About Flutter Belgium',
          paragraphs: [
            'Flutter Belgium is a community-run, non-profit initiative for Flutter developers in Belgium. The website at flutterbelgium.be is provided free of charge for informational and community purposes.',
            'By using this website you agree to these terms. For questions, contact us at administration@impaktfull.com.',
          ],
        ),
        LegalSection(
          heading: 'Use of the website',
          paragraphs: [
            'You may use this website for personal, non-commercial purposes. You may not use it to distribute spam, engage in illegal activity, or misrepresent your affiliation with Flutter Belgium.',
            'We reserve the right to change, suspend, or discontinue the website or any part of it at any time without notice.',
          ],
        ),
        LegalSection(
          heading: 'Content',
          paragraphs: [
            'Talk recordings, logos, and other materials published on this website are owned by their respective creators. Flutter Belgium branding and original content are the property of the Flutter Belgium community.',
            'Speaker content shared at meetups is shared under the understanding that it may be recorded and published for community benefit unless a speaker explicitly opts out.',
          ],
        ),
        LegalSection(
          heading: 'Community conduct',
          paragraphs: [
            'Flutter Belgium is committed to providing a welcoming and inclusive environment for everyone, regardless of background, experience level, or identity. Harassment, discrimination, or disrespectful behaviour will not be tolerated in any community space, including our Slack, meetups, or online channels.',
            'Violations of our community guidelines may result in removal from community spaces at the discretion of the organisers.',
          ],
        ),
        LegalSection(
          heading: 'Third-party links',
          paragraphs: [
            'This website contains links to third-party services (Meetup.com, Slack, YouTube, LinkedIn, GitHub). Flutter Belgium is not responsible for the content or privacy practices of those services.',
          ],
        ),
        LegalSection(
          heading: 'Intellectual property',
          paragraphs: [
            'Content, design, and trademarks published by Flutter Belgium are protected by intellectual property laws. You may not reproduce or distribute them without express written consent.',
            'Users retain ownership of any content they submit to community spaces but grant Flutter Belgium a worldwide, non-exclusive, royalty-free licence to display and distribute that content for community purposes.',
          ],
        ),
        LegalSection(
          heading: 'Disclaimer',
          paragraphs: [
            'This website and the Flutter Belgium app are provided "as is" without warranties of any kind. Flutter Belgium does not guarantee the accuracy or completeness of any information and accepts no liability for any direct, indirect, incidental, or consequential damages resulting from use of our services.',
          ],
        ),
        LegalSection(
          heading: 'Termination',
          paragraphs: [
            'Flutter Belgium reserves the right to terminate or suspend access to any community space or service at any time, for any reason, without notice.',
          ],
        ),
        LegalSection(
          heading: 'Governing law',
          paragraphs: [
            'These terms are governed by Belgian law. Any disputes shall be subject to the exclusive jurisdiction of the courts of Belgium.',
            'Last updated: May 2026.',
          ],
        ),
      ],
    );
  }
}
