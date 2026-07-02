import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';

const _apiUrl =
    'https://n8n.tools.flutterbelgium.be/webhook/community-stats';

class StatsPage extends StatelessComponent {
  const StatsPage({required this.communityLinks, super.key});

  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      section(classes: 'stats', [
        div(classes: 'stats-inner container', [
          const p(classes: 'section-label', [Component.text('Community')]),
          const h1(classes: 'section-title', [Component.text('Stats')]),
          const p(classes: 'section-body', [
            Component.text(
                'A live look at our community across all platforms.'),
          ]),
          div(
            classes: 'stats-grid',
            [
              _statCard('meetup_members', 'Meetup', '/assets/icons/meetup.svg', 'members'),
              _statCard('linkedin_followers', 'LinkedIn', '/assets/icons/linkedin.svg', 'followers'),
              _statCard('youtube_subscribers', 'YouTube', '/assets/icons/youtube.svg', 'subscribers'),
              _statCard('slack_members', 'Slack', '/assets/icons/slack.svg', 'members'),
              _statCard('instagram_followers', 'Instagram', '/assets/icons/instagram.svg', 'followers'),
              _statCard('github_followers', 'GitHub', '/assets/icons/github.svg', 'followers'),
            ],
          ),
        ]),
      ]),
      Footer(communityLinks: communityLinks),
      script(content: _fetchScript),
    ]);
  }
}

Component _statCard(
    String statId, String platform, String iconSrc, String label) {
  return div(classes: 'stat-card', [
    img(src: iconSrc, alt: platform, classes: 'stat-card-icon'),
    span(id: 'stat-$statId', classes: 'stat-card-value is-loading', [
      const Component.text('—'),
    ]),
    span(classes: 'stat-card-platform', [Component.text(platform)]),
    span(classes: 'stat-card-label', [Component.text(label)]),
  ]);
}

const _fetchScript = '''
(async () => {
  function drawSparkline(card, entries) {
    if (entries.length < 2) return;
    const W = 300, H = 120;
    const times = entries.map(e => new Date(e.date).getTime());
    const vals  = entries.map(e => e.value);
    const tMin = Math.min(...times), tMax = Math.max(...times);
    const tRange = tMax - tMin || 1;
    const vMin = Math.min(...vals), vMax = Math.max(...vals);
    const vRange = vMax - vMin || 1;
    const pts = entries.map(e => [
      ((new Date(e.date).getTime() - tMin) / tRange) * W,
      H - ((e.value - vMin) / vRange) * H * 0.6 - H * 0.15,
    ]);
    const lineD = pts.map((p, i) => (i === 0 ? 'M' : 'L') + p[0] + ',' + p[1]).join(' ');
    const areaD = 'M0,' + H + ' ' + pts.map(p => 'L' + p[0] + ',' + p[1]).join(' ') + ' L' + W + ',' + H + 'Z';
    const gid = 'sg' + card.querySelector('[id]').id;
    const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    svg.setAttribute('class', 'stat-card-graph');
    svg.setAttribute('viewBox', '0 0 ' + W + ' ' + H);
    svg.setAttribute('preserveAspectRatio', 'none');
    svg.setAttribute('aria-hidden', 'true');
    svg.innerHTML =
      '<defs><linearGradient id="' + gid + '" x1="0" y1="0" x2="0" y2="1">' +
      '<stop offset="0%" stop-color="currentColor" stop-opacity="0.18"/>' +
      '<stop offset="100%" stop-color="currentColor" stop-opacity="0"/>' +
      '</linearGradient></defs>' +
      '<path d="' + areaD + '" fill="url(#' + gid + ')"/>' +
      '<path d="' + lineD + '" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" stroke-opacity="0.3"/>';
    card.insertBefore(svg, card.firstChild);
  }

  try {
    const res = await fetch('$_apiUrl');
    if (!res.ok) throw new Error('HTTP ' + res.status);
    const { data } = await res.json();
    if (!data || !data.length) throw new Error('No data');
    const latest = data[data.length - 1];
    const fields = [
      'github_followers', 'meetup_members', 'youtube_subscribers',
      'linkedin_followers', 'instagram_followers', 'slack_members',
    ];
    for (const field of fields) {
      const el = document.getElementById('stat-' + field);
      if (!el) continue;
      if (latest[field] != null) {
        el.textContent = latest[field].toLocaleString();
      }
      el.classList.remove('is-loading');
      const card = el.closest('.stat-card');
      if (card) drawSparkline(card, data.map(r => ({ date: r.date || r.Date || r.createdAt, value: r[field] || 0 })));
    }
  } catch (e) {
    document.querySelectorAll('.stat-card-value.is-loading').forEach(el => {
      el.textContent = '—';
      el.classList.remove('is-loading');
    });
  }
})();
''';
