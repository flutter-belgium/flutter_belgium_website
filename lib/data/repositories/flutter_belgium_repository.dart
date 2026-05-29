import '../models/community_links.dart';
import '../models/company.dart';
import '../models/meetup.dart';
import '../models/sponsor.dart';
import '../models/talk.dart';
import '../models/team_member.dart';
import '../models/testimonial.dart';

abstract class FlutterBelgiumRepository {
  Future<Meetup?> getNextMeetup();
  Future<List<Meetup>> getPastMeetups();
  Future<List<Talk>> getAllTalks();
  Future<CommunityLinks> getCommunityLinks();
  Future<List<Company>> getHostingCompanies();
  Future<List<Testimonial>> getTestimonials();
  Future<List<TeamMember>> getTeamMembers();
  Future<List<Sponsor>> getSponsors();
}
