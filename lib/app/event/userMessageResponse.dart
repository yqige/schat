import 'package:event_bus/event_bus.dart';

EventBus eventBus = new EventBus();
class UserMessageResponse {

  String message;

  UserMessageResponse(message) {
    this.message = message;
  }
}
