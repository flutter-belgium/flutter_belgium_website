class TeamMember {
  const TeamMember({
    required this.name,
    required this.role,
    required this.avatarUrl,
    this.linkedinUrl,
    this.githubUrl,
  });
  final String name;
  final String role;
  final String avatarUrl;
  final String? linkedinUrl;
  final String? githubUrl;
}
