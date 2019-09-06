import 'package:simple_auth/simple_auth.dart';
import 'package:http/http.dart' as http;
class InstanceProvider{
  static BasicAuthAuthenticator instance;

  static BasicAuthAuthenticator getAuthenticatorInstance(){
    if(instance == null){
      instance = new BasicAuthAuthenticator(
          new http.Client(), "http://bb:8888/app/login");
    }
    return instance;
  }
}
