library gjs_integration.gobject;

import 'gjs_integration.dart';

import 'dart:js';

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
}
