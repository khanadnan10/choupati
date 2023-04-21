class Review {
  Review({
    required this.username,
    required this.datePublished,
    required this.review,
    required this.uid,
  });

  String username;
  String datePublished;
  String review;
  String uid;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        username: json["username"],
        datePublished: json["datePublished"],
        review: json["review"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "datePublished": datePublished,
        "review": review,
        "uid": uid,
      };
}
