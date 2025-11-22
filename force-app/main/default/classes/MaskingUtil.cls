public class MaskingUtil {

  public static String maskEmail(String email) {
    if (String.isBlank(email)) return email;
    if (email.toLowerCase().endsWith('sandbox@masked.invalid')) {
        return email;
    }
    Integer atIdx = email.indexOf('@');
    String username = atIdx > -1 ? email.substring(0, atIdx) : email;
    username = username.replaceAll('\\s', '').replaceAll('\\+', '');
    return username + '+sandbox@masked.invalid';
  }

  public static String maskPhone(String original) {
    if (String.isBlank(original)) return '9999999999';
    String lastTwo = '';
    for (Integer i = original.length()-1; i >= 0 && lastTwo.length() < 2; i--) {
      String ch = original.substring(i, i+1);
      if (ch >= '0' && ch <= '9') lastTwo = ch + lastTwo;
    }
    return (lastTwo.length() == 2) ? '99999999' + lastTwo : '9999999999';
  }

  public static String maskText(String original) {
    if (String.isBlank(original)) return original;
    return 'Masked';
  }

  public static String maskName(String original, Boolean isFirstName) {
    return isFirstName ? 'Test' : 'User';
  }

  public static Integer maskNumber(Object original) {
    return 0;
  }

  public static Object maskField(Object original, String type, Boolean isFirstName) {
    if (original == null) return null;
    switch on type {
      when 'Email' { return maskEmail(String.valueOf(original)); }
      when 'Phone' { return maskPhone(String.valueOf(original)); }
      when 'Text' { return maskText(String.valueOf(original)); }
      when 'Name' { return maskName(String.valueOf(original), isFirstName); }
      when 'Number' { return Integer.valueOf(maskNumber(original)); }
      when else { return original; }
    }
  }
}