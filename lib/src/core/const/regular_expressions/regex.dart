class RegularExpressions {

  ///email
  //validator to check complete email
  static final RegExp emailRegex = RegExp(
      r'^(([^<>\(\)\[\]\\.,;\s@\"]+(\.[^<>\(\)\[\]\\.,;\s@\"]+)*)|(\"[^\"]+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  // input formatter to see what all charaters to allow
  static final RegExp emailInput=RegExp(r'[a-zA-Z0-9@._\-\+]');


  ///password
  // validator to check for strong pwd that includes 8-15 characters, mix of everything
  static final RegExp passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\da-zA-Z\s])[\S]{8,15}$'
  );

  ///username
  //validator to check username
  static final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9 ]{6,20}$');
  //input formatter to allow only aphanumeric char and not special chars
  static final RegExp usernameInput = RegExp(r'[a-zA-Z0-9 ]');


  //static final RegExp inputFormatterDateRegex = RegExp(r'[0-9]');
  //static final RegExp inputFormatterMonthRegex = RegExp(r'[a-zA-Z]');

}