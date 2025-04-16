import 'package:appwrite/appwrite.dart';
import 'package:tesis_airbnb_web/utils/cons.dart';

class AppwriteApiClient {
  Client get _client {
    Client client = Client();

    client
        .setEndpoint(Constants.appWriteEndPoint)
        .setProject(Constants.appwriteProject);

    return client;
  }

  static Account get account => Account(_instance._client);

  static Storage get storage => Storage(_instance._client);

  static Databases get database => Databases(_instance._client);

  static Realtime get realtime => Realtime(_instance._client);

  static Functions get functions => Functions(_instance._client);

  static final AppwriteApiClient _instance = AppwriteApiClient._internal();

  AppwriteApiClient._internal();

  factory AppwriteApiClient() => _instance;
}
