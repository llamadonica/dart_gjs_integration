library gjs_integration.gtk;

import 'gjs_integration.dart';
import 'gobject.dart';

import 'dart:js';

final ImportWrapper _gtk = () {
  return new ImportWrapper(['gi', 'Gtk']);
}();

class Application extends GObject {
  static final klass = () {
    return new Klass.fromNativeCtor(_gtk['Application']);
  }();

  Application() : this.fromNative(klass.ctor([]), klass);
  Application.fromNative(internal, Klass _klass)
      : super.fromNative(internal, _klass);

  void connect(String name, Function function) =>
      _connect(name, new JsFunction.withThis(function));
  _connect(String name, JsFunction function) =>
      (internal as JsObject).callMethod('connect', [name, function]);
  void run(List args) => wrapGjsCall.apply([
        internal,
        'run',
        new JsArray.from([args])
      ]);
}

class ApplicationWindow extends GObject {
  static final klass = () {
    return new Klass.fromNativeCtor(_gtk['ApplicationWindow']);
  }();

  ApplicationWindow({Application application, String title})
      : this.fromNative(
            klass.ctor([
              new JsObject.jsify({
                'application':
                    application == null ? null : application.internal,
                'title': title
              })
            ]),
            klass);
  ApplicationWindow.fromNative(internal, Klass _klass)
      : super.fromNative(internal, _klass);
  setDefaultSize(int width, int height) =>
      (internal as JsObject).callMethod('set_default_size', [width, height]);
  add(GjsObject object) =>
      (internal as JsObject).callMethod('add', [object.internal]);
  showAll() => (internal as JsObject).callMethod('show_all', []);
  present() => (internal as JsObject).callMethod('present', []);
}

class Label extends GObject {
  static final klass = () {
    return new Klass.fromNativeCtor(_gtk['Label']);
  }();

  Label({String label})
      : this.fromNative(
            klass.ctor([
              new JsObject.jsify({'label': label})
            ]),
            klass);
  Label.fromNative(internal, Klass _klass) : super.fromNative(internal, _klass);
}
