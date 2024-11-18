class AppConfig {
  static String app_name = "Hotshi test app";
  static const bool HTTPS = true;
  //static const DOMAIN_PATH = "10.0.2.2:8000"; //localhost 10.0.2.2:8000
  static const DOMAIN_PATH = "test.elikkia.com"; //localhost 10.0.2.2:8000
  static const String API_ENDPATH = "api";
  static const String PROTOCOL = HTTPS ? "https://" : "http://";
  static const String RAW_BASE_URL = "$PROTOCOL$DOMAIN_PATH";
  static const String BASE_URL = "$RAW_BASE_URL/$API_ENDPATH";
  static const String PUSHER_API_KEY = "795caba0f475c8c06474";
  static const String PUSHER_API_CLUSTER = "eu";
}
