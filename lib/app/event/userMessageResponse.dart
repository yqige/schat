import 'package:event_bus/event_bus.dart';

EventBus eventBus = new EventBus();
class UserMessageResponse {
  String fromUser;
  String message;

  UserMessageResponse(message,fromUser) {
    this.message = message;
    this.fromUser = fromUser;
  }
}
