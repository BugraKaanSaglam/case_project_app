enum LanguageEnum {
  turkish(0, "Türkçe", "tr-TR"),
  english(1, "English", "en-US");

  const LanguageEnum(this.value, this.name, this.shortName);
  final int value;
  final String name;
  final String shortName;
  static LanguageEnum getLanguageFromValue(int? value) {
    switch (value) {
      case 0:
        return LanguageEnum.turkish;
      case 1:
        return LanguageEnum.english;
      default:
        return LanguageEnum.english;
    }
  }

  static LanguageEnum getLanguageFromString(String? value) {
    switch (value) {
      case 'tr':
        return LanguageEnum.turkish;
      case 'en':
        return LanguageEnum.english;
      default:
        return LanguageEnum.turkish;
    }
  }
}
