import 'package:simple_auth/simple_auth.dart' as simpleAuth;
import "package:http/http.dart" as http;
enum Category {
  all,
  accessories,
  clothing,
  home,
}
class User {
  String username;
  String password;
  http.Client _client;
  http.Client getClient(){
    if(_client == null){

    }
  }
  Future<bool> getUser(String email, String password) async {
    final simpleAuth.BasicAuthAuthenticator oAuthApi = new simpleAuth.BasicAuthAuthenticator(
        getClient(), "https://api.github.com/user");
    bool right = await oAuthApi.verifyCredentials(email, password);
      return right;
  }
}
