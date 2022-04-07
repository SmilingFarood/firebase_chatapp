class SingleUser {
  final String fullName;
  final String email;
  final String? imageUrl;
  final String uid;
  SingleUser({
    required this.fullName,
    required this.email,
    required this.imageUrl,
    required this.uid,
  });
  @override
  String toString() {
    return """\n
    Full Name: $fullName,
    Email: $email,
    Image Url: $imageUrl,
    UID: $uid,
    """;
  }
}
