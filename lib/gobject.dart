library gjs_integration.gobject;

import 'gjs_integration.dart';

import 'dart:js';
import 'dart:async';

final ImportWrapper _glib = () {
  return new ImportWrapper(['gi', 'GLib']);
}();
final ImportWrapper _gobject = () {
  return new ImportWrapper(['gi', 'GObject']);
}();

class GObjectBase extends GjsObject {
  final Klass _klass;
  GObjectBase.fromNative(internal, this._klass) : super(internal) {
    internal['_DART_'] = this;
  }
}

class GObject extends GObjectBase {
  static final Klass klass = () {
    return new Klass.fromNativeCtor(_glib['GObject']);
  }();

  GObject.fromNative(internal, klass) : super.fromNative(internal, klass);

  StreamController streamControllerFromNativeZeroArg(String connectedSignal) {
    int signalConnection;
    StreamController controller;
    controller = new StreamController(onListen: () {
      signalConnection = connect(connectedSignal, () {
        controller.add(null);
      });
    }, onCancel: () {
      disconnect(signalConnection);
    });
    return controller;
  }

  StreamController<
      InterruptibleEvent> streamControllerFromNativeOneArgSynchronous(
      String connectedSignal, InterruptibleEvent mapFunc(result)) {
    int signalConnection;
    StreamController controller;
    controller = new StreamController(onListen: () {
      signalConnection = connect(connectedSignal, (_self, result) {
        var event = mapFunc(result);
        controller.add(event);
        return event.propagationIsStopped;
      });
    }, onCancel: () {
      disconnect(signalConnection);
    }, sync: true);
    return controller;
  }

  int connect(String name, Function function) => _connect(name, function);
  _connect(String name, JsFunction function) =>
      (internal as JsObject).callMethod('connect', [name, function]);

  void disconnect(int connectionId) =>
      (internal as JsObject).callMethod('disconnect', [connectionId]);
}

abstract class InterruptibleEvent {
  bool _stopPropagate = false;
  bool get propagationIsStopped => _stopPropagate;

  void stopPropagation() {
    _stopPropagate = true;
  }
}
