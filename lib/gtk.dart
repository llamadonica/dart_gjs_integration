library gjs_integration.gtk;

import 'cairo.dart';
import 'gjs_integration.dart';
import 'gdk.dart';
import 'gobject.dart';

import 'dart:async';
import 'dart:js';

final ImportWrapper _gtk = () {
  return new ImportWrapper(['gi', 'Gtk']);
}();

void init({argv: null, argc:0}) {
  _gtk['init'].func([argv, argc]);
}
void main({argv: null, argc:0}) {
  _gtk['main'].func([]);
}

/// An example of a wrapped enum
class Align {
  static final ImportWrapper _nativeCtor = () {
    return _gtk['Align'];
  }();

  final int value;
  const Align(int this.value);

  static final Align START = (() =>
      new Align(_nativeCtor['START'].getValue()))();
  operator ==(other) {
    if (other is! Align) return false;
    return this.value == other.value;
  }
}

class Application extends GObject {
  static final klass = () {
    return new Klass.fromNativeCtor(_gtk['Application']);
  }();

  Application() : this.fromNative(klass.ctor([]), klass);
  Application.fromNative(internal, Klass _klass)
      : super.fromNative(internal, _klass);

  void run(List args) => wrapGjsCall.apply([
        internal,
        'run',
        new JsArray.from([args])
      ]);
  quitMainloop() => (internal as JsObject).callMethod('quit_mainloop', []);
}

class ApplicationWindow extends Window {
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
}

class DrawingArea extends Widget {
  static final klass = () {
    return new Klass.fromNativeCtor(_gtk['DrawingArea']);
  }();

  DrawingArea() : this.fromNative(klass.ctor([new JsObject.jsify({})]), klass);

  DrawingArea.fromNative(internal, Klass _klass)
      : super.fromNative(internal, _klass);
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

class Widget extends GObject {
  Widget.fromNative(internal, Klass _klass)
      : super.fromNative(internal, _klass);

  StreamController get _onConfigureEvent =>
      streamControllerFromNativeOneArgSynchronous('configure-event',
          (newInternal) {
        if (newInternal['_DART_'] == null) {
          newInternal['_DART_'] =
              new EventConfigure.fromNative(newInternal, EventConfigure.klass);
        }
        return newInternal['_DART_'];
      });
  Stream<EventConfigure> get onConfigureEvent => _onConfigureEvent.stream;
  StreamController get _onDestroy =>
      streamControllerFromNativeZeroArg('destroy');
  Stream get onDestroy => _onDestroy.stream;

  StreamController<DrawEvent> get _onDraw =>
      streamControllerFromNativeOneArgSynchronous('draw', (newInternal) {
        if (newInternal['_DART_'] == null) {
          newInternal['_DART_'] =
              new Context.fromNative(newInternal, Context.klass);
        }
        return new DrawEvent(newInternal['_DART_']);
      });

  Stream<DrawEvent> get onDraw => _onDraw.stream;

  bool get appPaintable => (internal as JsObject)['app_paintable'];
  set appPaintable(bool value) =>
      (internal as JsObject)['app_paintable'] = value;

  Display get display {
    JsObject newInternal = (internal as JsObject).callMethod('get_display', []);
    if (newInternal['_DART_'] == null) {
      newInternal['_DART_'] =
          new Display.fromNative(newInternal, Display.klass);
    }
    return newInternal['_DART_'];
  }

  Screen get screen {
    JsObject newInternal = (internal as JsObject).callMethod('get_screen', []);
    if (newInternal['_DART_'] == null) {
      newInternal['_DART_'] = new Screen.fromNative(newInternal, Screen.klass);
    }
    return newInternal['_DART_'];
  }

  Visual get visual {
    JsObject newInternal = (internal as JsObject).callMethod('get_visual', []);
    if (newInternal == null) return null;
    if (newInternal['_DART_'] == null) {
      newInternal['_DART_'] = new Visual.fromNative(newInternal, Visual.klass);
    }
    return newInternal['_DART_'];
  }

  set visual(Visual value) => (internal as JsObject)
      .callMethod('set_visual', [value == null ? null : value.internal]);
  set widthRequest(int value) =>
      (internal as JsObject)['width_request'] = value;
  int get widthRequest => (internal as JsObject)['width_request'];
  set heightRequest(int value) =>
      (internal as JsObject)['height_request'] = value;
  int get heightRequest => (internal as JsObject)['height_request'];
  set visible(bool value) => (internal as JsObject)['visible'] = value;
  bool get visible => (internal as JsObject)['visible'];
  set canFocus(bool value) => (internal as JsObject)['can_focus'] = value;
  bool get canFocus => (internal as JsObject)['can_focus'];
  set events(EventMask value) => (internal as JsObject)['events'] = value.value;
  EventMask get events => new EventMask((internal as JsObject)['events']);
  set halign(Align value) => (internal as JsObject)['halign'] = value.value;
  Align get halign => new Align((internal as JsObject)['halign']);

  void queueDraw() => (internal as JsObject).callMethod('queue_draw', []);
}

class Window extends Widget {
  static final klass = () {
    return new Klass.fromNativeCtor(_gtk['Window']);
  }();

  Window([WindowType type])
      : this.fromNative(
            klass.ctor([
              new JsObject.jsify({
                'type': type == null
                    ? WindowType.TOPLEVEL._windowType
                    : type._windowType
              })
            ]),
            klass);
  Window.fromNative(internal, Klass _klass)
      : super.fromNative(internal, _klass);
  setDefaultSize(int width, int height) =>
      (internal as JsObject).callMethod('set_default_size', [width, height]);
  add(GjsObject object) =>
      (internal as JsObject).callMethod('add', [object.internal]);
  showAll() => (internal as JsObject).callMethod('show_all', []);
  present() => (internal as JsObject).callMethod('present', []);
  stick() => (internal as JsObject).callMethod('stick', []);
  setKeepAbove(bool value) =>
      (internal as JsObject).callMethod('set_keep_above', [value]);
  setGeometryHints(
          Widget geometryWidget, Geometry geometry, WindowHints geomMask) =>
      (internal as JsObject).callMethod('set_geometry_hints', [
        geometryWidget == null ? null : geometryWidget.internal,
        geometry.internal,
        geomMask.value
      ]);
  bool getSkipPagerHint() =>
      (internal as JsObject).callMethod('get_skip_pager_hint', []);

  Gravity get gravity => new Gravity((internal as JsObject)['gravity']);
  set gravity(Gravity value) => (internal as JsObject)['gravity'] = value.value;
  String get title => (internal as JsObject)['title'];
  set title(String value) => (internal as JsObject)['title'] = value;
  double get opacity => (internal as JsObject)['opacity'];
  set opacity(double value) => (internal as JsObject)['opacity'] = value;
  int get defaultWidth => (internal as JsObject)['default_width'];
  set defaultWidth(int value) =>
      (internal as JsObject)['default_width'] = value;
  int get defaultHeight => (internal as JsObject)['default_height'];
  set defaultHeight(int value) =>
      (internal as JsObject)['default_height'] = value;
  bool get decorated => (internal as JsObject)['decorated'];
  set decorated(bool value) => (internal as JsObject)['decorated'] = value;
  String get role => (internal as JsObject)['role'];
  set role(String value) => (internal as JsObject)['role'] = value;
  bool get acceptFocus => (internal as JsObject)['accept_focus'];
  set acceptFocus(bool value) => (internal as JsObject)['accept_focus'] = value;
  bool get skipPagerHint => (internal as JsObject)['skip_pager_hint'];
  set skipPagerHint(bool value) =>
      (internal as JsObject)['skip_pager_hint'] = value;
  bool get skipTaskbarHint => (internal as JsObject)['skip_taskbar_hint'];
  set skipTaskbarHint(bool value) =>
      (internal as JsObject)['skip_taskbar_hint'] = value;
}

/// An example of a wrapped enum
class WindowType {
  static final ImportWrapper _nativeCtor = () {
    return _gtk['WindowType'];
  }();

  final int _windowType;
  const WindowType(int this._windowType);

  static final WindowType TOPLEVEL = (() =>
      new WindowType(_nativeCtor['TOPLEVEL'].getValue()))();
  static final WindowType POPUP = (() =>
      new WindowType(_nativeCtor['POPUP'].getValue()))();
}
