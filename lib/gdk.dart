library gjs_integration.gdk;

import 'gjs_integration.dart';
import 'gobject.dart';
import 'cairo.dart';

import 'dart:js';

final ImportWrapper _gdk = () {
  return new ImportWrapper(['gi', 'Gdk']);
}();

class EventConfigure extends GObjectBase with InterruptibleEvent {
  static final _nativeCtor = () {
    return _gdk['EventConfigure'];
  }();
  static final Klass klass = () {
    return new Klass.fromNativeCtor(_nativeCtor);
  }();

  EventConfigure.fromNative(internal, _klass)
      : super.fromNative(internal, _klass);

  Window get window {
    JsObject newInternal = (internal as JsObject)['window'];
    if (newInternal['_DART_'] == null) {
      newInternal['_DART_'] = new Window.fromNative(newInternal, Window.klass);
    }
    return newInternal['_DART_'];
  }
}

/// An example of a wrapped enum/flags
class EventMask {
  static final ImportWrapper _nativeCtor = () {
    return _gdk['EventMask'];
  }();

  final int value;
  const EventMask(int this.value);

  static final EventMask STRUCTURE_MASK = (() =>
      new EventMask(_nativeCtor['STRUCTURE_MASK'].getValue()))();
  operator ==(other) {
    if (other is! EventMask) return false;
    return this.value == other.value;
  }

  EventMask operator |(EventMask other) =>
      new EventMask(this.value | other.value);
}

class Display extends GObject {
  static final _nativeCtor = () {
    return _gdk['Display'];
  }();
  static final Klass klass = () {
    return new Klass.fromNativeCtor(_nativeCtor);
  }();

  Display.fromNative(internal, _klass) : super.fromNative(internal, _klass);

  bool supportsShapes() =>
      (internal as JsObject).callMethod('supports_shapes', []);
}

class Geometry extends GObjectBase {
  static final _nativeCtor = () {
    return _gdk['Geometry'];
  }();
  static final Klass klass = () {
    return new Klass.fromNativeCtor(_nativeCtor);
  }();

  Geometry.fromNative(internal, _klass) : super.fromNative(internal, _klass);
  Geometry(
      {int minWidth,
      int minHeight,
      int maxWidth,
      int maxHeight,
      int baseWidth,
      int baseHeight,
      int widthInc,
      int heightInc,
      double minAspect,
      double maxAspect,
      Gravity winGravity})
      : this.fromNative(
            klass.ctor([
              new JsObject.jsify({
                'min_width': minWidth,
                'min_height': minHeight,
                'max_width': maxWidth,
                'max_height': maxHeight,
                'base_width': baseWidth,
                'base_height': baseHeight,
                'width_inc': widthInc,
                'height_inc': heightInc,
                'min_aspect': minAspect,
                'max_aspect': maxAspect,
                'win_gravity': winGravity == null ? 1 : winGravity.value
              })
            ]),
            klass);
}

/// An example of a wrapped enum
class Gravity {
  static final ImportWrapper _nativeCtor = () {
    return _gdk['Gravity'];
  }();

  final int value;
  const Gravity(int this.value);

  static final Gravity SOUTH_EAST = (() =>
      new Gravity(_nativeCtor['SOUTH_EAST'].getValue()))();
  operator ==(other) {
    if (other is! Gravity) return false;
    return this.value == other.value;
  }
}

class Pixbuf extends GObjectBase {
  static final _nativeCtor = () {
    return _gdk['Pixbuf'];
  }();
  static final Klass klass = () {
    return new Klass.fromNativeCtor(_nativeCtor);
  }();

  Pixbuf.fromNative(internal, _klass) : super.fromNative(internal, _klass);

  static Pixbuf getFromSurface(
      Surface surface, int x, int y, int width, int height) {
    JsObject newInternal = _gdk['pixbuf_get_from_surface']
        .func(new JsArray.from([surface.internal, x, y, width, height]));
    if (newInternal['_DART_'] == null) {
      newInternal['_DART_'] = new Pixbuf.fromNative(newInternal, klass);
    }
    return newInternal['_DART_'];
  }
}

class Screen extends GObject {
  static final _nativeCtor = () {
    return _gdk['Screen'];
  }();
  static final Klass klass = () {
    return new Klass.fromNativeCtor(_nativeCtor);
  }();

  Screen.fromNative(internal, _klass) : super.fromNative(internal, _klass);

  Visual get rgbaVisual {
    JsObject newInternal =
        (internal as JsObject).callMethod('get_rgba_visual', []);
    if (newInternal == null) return null;
    if (newInternal['_DART_'] == null) {
      newInternal['_DART_'] = new Visual.fromNative(newInternal, Visual.klass);
    }
    return newInternal['_DART_'];
  }

  Visual get systemVisual {
    JsObject newInternal =
        (internal as JsObject).callMethod('get_system_visual', []);
    if (newInternal['_DART_'] == null) {
      newInternal['_DART_'] = new Visual.fromNative(newInternal, Visual.klass);
    }
    return newInternal['_DART_'];
  }
}

class Visual extends GObject {
  static final _nativeCtor = () {
    return _gdk['Visual'];
  }();
  static final Klass klass = () {
    return new Klass.fromNativeCtor(_nativeCtor);
  }();

  Visual.fromNative(internal, _klass) : super.fromNative(internal, _klass);
}

class Window extends GObject {
  static final _nativeCtor = () {
    return _gdk['Window'];
  }();
  static final Klass klass = () {
    return new Klass.fromNativeCtor(_nativeCtor);
  }();

  Window.fromNative(internal, _klass) : super.fromNative(internal, _klass);
}

/// An example of a wrapped enum
class WindowHints {
  static final ImportWrapper _nativeCtor = () {
    return _gdk['WindowHints'];
  }();

  final int value;
  const WindowHints(int this.value);

  static final WindowHints MIN_SIZE = (() =>
      new WindowHints(_nativeCtor['MIN_SIZE'].getValue()))();
  static final WindowHints MAX_SIZE = (() =>
      new WindowHints(_nativeCtor['MAX_SIZE'].getValue()))();
  static final WindowHints ASPECT = (() =>
      new WindowHints(_nativeCtor['ASPECT'].getValue()))();
  operator ==(other) {
    if (other is! WindowHints) return false;
    return this.value == other.value;
  }

  WindowHints operator |(WindowHints other) =>
      new WindowHints(this.value | other.value);
}
