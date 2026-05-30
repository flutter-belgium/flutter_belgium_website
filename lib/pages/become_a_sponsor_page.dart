import 'package:jaspr/jaspr.dart';

import 'package:flutter_belgium_data/flutter_belgium_data.dart';
import 'package:flutter_belgium_website/pages/legal_page.dart';

class BecomeASponsorPage extends StatelessComponent {
  const BecomeASponsorPage({required this.communityLinks, super.key});

  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return LegalPage(
      communityLinks: communityLinks,
      title: 'Become a sponsor',
      sections: const [
        LegalSection(
          heading: 'Why sponsor Flutter Belgium?',
          paragraphs: [
            'Flutter Belgium is the Belgian Flutter community. Every two to three months we host a meetup at a Belgian company, with talks recorded and published on YouTube. Our Slack community keeps the conversation going between events.',
            'Sponsoring Flutter Belgium puts your company in front of motivated Flutter developers who are actively building products with the framework. These are engineers, tech leads, and decision-makers you want to reach.',
          ],
        ),
        LegalSection(
          heading: 'What do sponsors get?',
          paragraphs: [
            'A dedicated slide at the start of every meetup — your company is introduced to the room before the talks begin. Open job openings can be added to the slide as well, putting your vacancies in front of the right audience.',
            'Your company logo on the Flutter Belgium website in the sponsors section, visible to every visitor.',
          ],
        ),
        LegalSection(
          heading: 'What does sponsorship cover?',
          paragraphs: [
            'Sponsorship funds the professional livestream and recording setup used at every meetup. This ensures every talk is captured in high quality and available to rewatch, even for those who could not attend in person.',
            'Flutter Belgium is run entirely by volunteers. Sponsorship money goes directly to the community, not to any individual.',
          ],
        ),
        LegalSection(
          heading: 'How to get in touch?',
          paragraphs: [
            'Send us an email at administration@impaktfull.com with the subject "Sponsorship Flutter Belgium" and we will get back to you with the details.',
          ],
        ),
      ],
    );
  }
}
