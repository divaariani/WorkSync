class SessionManager {
  static final SessionManager _instance = SessionManager._internal();

  factory SessionManager() {
    return _instance;
  }

  SessionManager._internal();

  String? userId;
  String? namaUser;
  String? deptFullName;
  String? deptInisial;
  String? noAbsen;

  void saveUserInfo(Map<String, dynamic> userData) {
    userId = userData['user_id'];
    namaUser = userData['Nama_User'];
    deptFullName = userData['DeptFullName'];
    deptInisial = userData['DeptInisial'];
    noAbsen = userData['NoAbsen'];
  }

  bool isLoggedIn() {
    return userId != null;
  }

  void logout() {
    userId = null;
    namaUser = null;
    deptFullName = null;
    deptInisial = null;
    noAbsen = null;
  }
}