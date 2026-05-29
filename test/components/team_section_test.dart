import 'package:flutter_belgium_website/components/team_section.dart';
import 'package:flutter_belgium_website/data/models/team_member.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  const members = [
    TeamMember(
        name: 'Koen Van Looveren',
        role: 'Organiser',
        avatarUrl: 'https://i.pravatar.cc/150?u=koen'),
    TeamMember(
        name: 'Jens Gyselinck',
        role: 'Organiser',
        avatarUrl: 'https://i.pravatar.cc/150?u=jens'),
    TeamMember(
        name: 'Kris Pypen',
        role: 'Organiser',
        avatarUrl: 'https://i.pravatar.cc/150?u=kris'),
  ];

  testComponents('TeamSection renders label, title, and one card per member',
      (tester) async {
    tester.pumpComponent(const TeamSection(members: members));
    expect(find.tag('section'), findsOneComponent);
    expect(find.text('Team'), findsOneComponent);
    expect(find.text('The people behind Flutter Belgium'), findsOneComponent);
    expect(find.text('Koen Van Looveren'), findsOneComponent);
    expect(find.text('Jens Gyselinck'), findsOneComponent);
    expect(find.text('Kris Pypen'), findsOneComponent);
  });
}
