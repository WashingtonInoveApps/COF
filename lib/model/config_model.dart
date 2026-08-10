class ConfigModel {
  final double maxWidth;
  final String appID;
  final String endpoint;
  final bool test;

  ConfigModel(
      {required this.appID,
      required this.endpoint,
      required this.test,
      required this.maxWidth});
}
