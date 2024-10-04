class Abbrev {
  final String pt;
  final String en;

  Abbrev({
    required this.pt,
    required this.en
  });

  factory Abbrev.fromJson(Map<String, dynamic> json) {
    return Abbrev(
      pt: json['pt'] as String ?? "",
      en: json['en'] as String ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pt'] = this.pt;
    data['en'] = this.en;
    return data;
  }
}