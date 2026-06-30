/// Application-wide string constants. UI strings should eventually be
/// extracted to ARB files for localization.
abstract final class AppStrings {
  static const String appName = 'MirrorTube';

  // Auth
  static const String login = '로그인';
  static const String register = '회원가입';
  static const String logout = '로그아웃';
  static const String email = '이메일';
  static const String password = '비밀번호';
  static const String confirmPassword = '비밀번호 확인';
  static const String forgotPassword = '비밀번호 재설정';
  static const String googleSignIn = 'Google로 계속하기';
  static const String alreadyHaveAccount = '이미 계정이 있으신가요?';
  static const String noAccount = '계정이 없으신가요?';
  static const String resetEmailSent = '비밀번호 재설정 이메일이 발송되었습니다.';
  static const String deleteAccount = '계정 삭제';
  static const String deleteAccountConfirm = '정말로 계정을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';

  // Navigation
  static const String home = '홈';
  static const String search = '검색';
  static const String upload = '업로드';
  static const String notifications = '알림';
  static const String profile = '프로필';

  // Profile
  static const String editProfile = '프로필 수정';
  static const String nickname = '닉네임';
  static const String bio = '자기소개';
  static const String joinDate = '가입일';
  static const String subscribers = '구독자';
  static const String subscriptions = '구독 중';
  static const String videos = '동영상';
  static const String changeProfilePhoto = '프로필 사진 변경';

  // Settings
  static const String settings = '설정';
  static const String darkMode = '다크 모드';
  static const String appVersion = '앱 버전';

  // Common
  static const String save = '저장';
  static const String cancel = '취소';
  static const String confirm = '확인';
  static const String error = '오류';
  static const String retry = '다시 시도';
  static const String loading = '불러오는 중...';
  static const String unknownError = '알 수 없는 오류가 발생했습니다.';

  // Search
  static const String searchHint = '영상, 채널 검색';
  static const String searchEmpty = '검색 결과가 없습니다.';

  // Notification
  static const String notificationEmpty = '알림이 없습니다.';

  // Upload placeholder
  static const String uploadComingSoon = '업로드 기능은 다음 버전에서 제공됩니다.';
}
