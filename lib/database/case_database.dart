class CaseDatabase {
  final int ver;
  String loginEmail;
  String loginSifre;
  bool isRememberLogin;
  String language;

  CaseDatabase({required this.ver, required this.loginEmail, required this.loginSifre, required this.isRememberLogin, this.language = 'tr'});

  Map<String, dynamic> toMap() {
    return {'Ver': ver, 'LoginEmail': loginEmail, 'LoginSifre': loginSifre, 'IsRememberLogin': isRememberLogin ? 1 : 0, 'Language': language};
  }

  factory CaseDatabase.fromMap(Map<String, dynamic> json) {
    return CaseDatabase(ver: json['Ver'] as int, loginEmail: json['LoginEmail'] as String? ?? '', loginSifre: json['LoginSifre'] as String? ?? '', isRememberLogin: (json['IsRememberLogin'] ?? 0) == 1, language: json['Language'] as String? ?? 'tr');
  }

  @override
  String toString() {
    return 'CaseDatabase('
        'ver: $ver, '
        'loginEmail: $loginEmail, '
        'loginSifre: $loginSifre, '
        'isRememberLogin: $isRememberLogin, '
        'language: $language'
        ')';
  }
}
