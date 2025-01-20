class Repository {
  final int id;
  final String name;
  final String? description;
  final String ownerAvatarUrl;
  final int stargazersCount;
  final int forksCount;
  final bool isPrivate;
  final String htmlUrl;

  Repository({
    required this.id,
    required this.name,
    this.description,
    required this.ownerAvatarUrl,
    required this.stargazersCount,
    required this.forksCount,
    required this.isPrivate,
    required this.htmlUrl,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      ownerAvatarUrl: json['owner']['avatar_url'],
      stargazersCount: json['stargazers_count'],
      forksCount: json['forks_count'],
      isPrivate: json['private'] ?? false,
      htmlUrl: json['html_url'],
    );
  }
}