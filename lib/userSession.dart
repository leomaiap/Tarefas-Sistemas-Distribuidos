class UserSession {
  
  static int _id = -1;

  static void setID(int n) {
    _id = n;
  }

  static int getID() {
    return _id;
  }
}