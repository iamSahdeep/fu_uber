class ProjectLog {
  static void logIt(String className, String heading, dynamic data) {
    print(className + " with " + heading + " : ${data}");
  }
}
