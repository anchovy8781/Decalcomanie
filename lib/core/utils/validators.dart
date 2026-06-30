/// Input validation utilities. All methods return null on success,
/// or an error message string on failure.
abstract final class Validators {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '이메일을 입력해주세요.';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return '올바른 이메일 형식을 입력해주세요.';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }
    if (value.length < 8) {
      return '비밀번호는 최소 8자 이상이어야 합니다.';
    }
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
    final hasDigit = RegExp(r'[0-9]').hasMatch(value);
    if (!hasUppercase || !hasDigit) {
      return '비밀번호는 영문 대문자와 숫자를 포함해야 합니다.';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) {
      return '비밀번호 확인을 입력해주세요.';
    }
    if (value != original) {
      return '비밀번호가 일치하지 않습니다.';
    }
    return null;
  }

  static String? nickname(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '닉네임을 입력해주세요.';
    }
    if (value.trim().length < 2) {
      return '닉네임은 최소 2자 이상이어야 합니다.';
    }
    if (value.trim().length > 20) {
      return '닉네임은 최대 20자까지 입력 가능합니다.';
    }
    final nicknameRegex = RegExp(r'^[a-zA-Z0-9가-힣._-]+$');
    if (!nicknameRegex.hasMatch(value.trim())) {
      return '닉네임은 한글, 영문, 숫자, ., _, - 만 사용 가능합니다.';
    }
    return null;
  }

  static String? bio(String? value) {
    if (value != null && value.length > 150) {
      return '자기소개는 최대 150자까지 입력 가능합니다.';
    }
    return null;
  }
}
