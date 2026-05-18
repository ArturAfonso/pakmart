

class FlatpakApp {
  final String application;
  final String name;
  final String version;
  final String branch;
  final String origin;
  final String installation;

  FlatpakApp({
    required this.application,
    required this.name,
    required this.version,
    required this.branch,
    required this.origin,
    required this.installation,
  });

  factory FlatpakApp.fromList(List<String> cols) {
    return FlatpakApp(
      application: cols[0],
      name: cols[1],
      version: cols[2],
      branch: cols[3],
      origin: cols[4],
      installation: cols[5],
    );
  }
}