library gjs_integration.rsvg;

import 'cairo.dart';
import 'gjs_integration.dart';
import 'gobject.dart';

import 'dart:async';
import 'dart:js';

final ImportWrapper _rsvg = () {
  return new ImportWrapper(['gi', 'Rsvg']);
}();

class Handle extends GObjectBase {
  static final ImportWrapper _nativeCtor = () {
    return _rsvg['Handle'];
  }();
  static final Klass klass = () {
    return new Klass.fromNativeCtor(_nativeCtor);
  }();

  Handle.fromNative(internal, _klass) : super.fromNative(internal, _klass);
  Handle.fromFile(String filename)
      : this.fromNative(_nativeCtor['new_from_file'].func([filename]), klass);

  int get height => (internal as JsObject)['height'];
  int get width => (internal as JsObject)['width'];

  bool render(Context cr) => (internal as JsObject)
      .callMethod('render_cairo', [cr == null ? null : cr.internal]);
}
