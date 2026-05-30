import 'package:jaspr/jaspr.dart';

import 'package:flutter_belgium_data/flutter_belgium_data.dart';
import 'package:flutter_belgium_website/pages/legal_page.dart';

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
            'Flutter Belgium is a non-profit community for Flutter developers in Belgium. This website and the Flutter Belgium mobile app are maintained by volunteers.',
            'For any privacy-related questions, contact us at administration@impaktfull.com.',
          ],
        ),
        LegalSection(
          heading: 'What data we collect',
          paragraphs: [
            'Website: We do not collect personal data through forms or accounts on this website. We do not use cookies for tracking or analytics purposes.',
            'Flutter Belgium app: The app uses Google Analytics 4 to collect anonymised usage data (page views, interactions, device information) for statistical analysis and improvements. No personally identifiable information is stored.',
            'Raffle game: When you participate in a raffle at a meetup, we collect your name and email address for entry authentication and prize distribution. This is done via Firebase Authentication with Google sign-in.',
            'If you join our Slack community or register for a meetup through third-party platforms, those platforms collect data according to their own privacy policies. We do not receive or store that data ourselves.',
          ],
        ),
        LegalSection(
          heading: 'How we use your information',
          paragraphs: [
            'We use the information collected to provide and improve our services, administer raffle games and distribute prizes, analyse usage patterns in the Flutter Belgium app, and meet any applicable legal requirements.',
            'We do not sell, trade, or rent your personal information to third parties.',
          ],
        ),
        LegalSection(
          heading: 'Third-party services',
          paragraphs: [
            'Website: We link to and embed content from Slack, YouTube, Meetup.com, LinkedIn, and GitHub. Each has its own privacy policy and data practices.',
            'App: The Flutter Belgium app uses Google Analytics 4 (Google) and Firebase (Google) for analytics and authentication. Please refer to Google\'s Privacy Policy for details.',
          ],
        ),
        LegalSection(
          heading: 'Your rights under GDPR',
          paragraphs: [
            'As a resident of the European Union or Belgium, you have the right to access, rectify, or delete any personal data we hold about you.',
            'For requests or questions, contact us at administration@impaktfull.com.',
          ],
        ),
        LegalSection(
          heading: 'Changes to this policy',
          paragraphs: [
            'We may update this privacy policy from time to time. Changes will be published on this page. Continued use of the website or app after changes constitutes acceptance of the updated policy.',
            'Last updated: May 2026.',
          ],
        ),
      ],
    );
  }
}
