import 'package:jaspr/jaspr.dart';

import '../data/models/community_links.dart';
import 'legal_page.dart';

class PrivacyPolicyPage extends StatelessComponent {
  const PrivacyPolicyPage({required this.communityLinks, super.key});

  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return LegalPage(
      communityLinks: communityLinks,
      title: 'Privacy Policy',
      sections: const [
        LegalSection(
          heading: 'Who we are',
          paragraphs: [
            'Flutter Belgium is a non-profit community for Flutter developers in Belgium. This website is maintained by volunteers and is available at flutterbelgium.be.',
            'For any privacy-related questions, contact us at administration@impaktfull.com.',
          ],
        ),
        LegalSection(
          heading: 'What data we collect',
          paragraphs: [
            'This website does not collect personal data through forms or accounts. We do not use cookies for tracking or analytics purposes.',
            'If you join our Slack community or register for a meetup through third-party platforms, those platforms collect data according to their own privacy policies. We do not receive or store that data ourselves.',
          ],
        ),
        LegalSection(
          heading: 'Third-party services',
          paragraphs: [
            'Our website embeds content and links to the following third-party services: Slack (community chat), YouTube (talk recordings), Meetup.com (event registration), LinkedIn, and GitHub. Each of these services has its own privacy policy and data practices.',
            'YouTube embeds on this page are served by Google. When a video is loaded, Google may set cookies on your device. Please refer to Google\'s Privacy Policy for details.',
          ],
        ),
        LegalSection(
          heading: 'Your rights under GDPR',
          paragraphs: [
            'As a resident of the European Union or Belgium, you have the right to access, rectify, or delete any personal data we hold about you. Since we do not directly collect personal data through this website, any such requests should be directed to the relevant third-party platforms.',
            'For questions or requests, contact us at administration@impaktfull.com.',
          ],
        ),
        LegalSection(
          heading: 'Changes to this policy',
          paragraphs: [
            'We may update this privacy policy from time to time. Changes will be published on this page. Continued use of the website after changes constitutes acceptance of the updated policy.',
            'Last updated: May 2026.',
          ],
        ),
      ],
    );
  }
}
