library gjs_integration.cairo;

import 'gjs_integration.dart';
import 'gobject.dart';

import 'dart:js';

final ImportWrapper _cairo = () {
  return new ImportWrapper(['cairo']);
}();

class Surface extends GObjectBase {
  Surface.fromNative(internal, _klass) : super.fromNative(internal, _klass);

  /* flush() => (internal as JsObject).callMethod('flush', []); */
}

class ImageSurface extends Surface {
  static final _nativeCtor = () {
    return _cairo['ImageSurface'];
  }();
  static final Klass klass = () {
    return new Klass.fromNativeCtor(_nativeCtor);
  }();

  ImageSurface.fromNative(internal, _klass)
      : super.fromNative(internal, _klass);
  ImageSurface(Format format, width, height)
      : this.fromNative(klass.ctor([format.value, width, height]), klass);
}

class DrawEvent extends InterruptibleEvent {
  final Context cr;
  DrawEvent(Context this.cr);
}

class Context extends GObjectBase {
  static final _nativeCtor = () {
    return _cairo['Context'];
  }();
  static final Klass klass = () {
    return new Klass.fromNativeCtor(_nativeCtor);
  }();

  Context.fromNative(internal, _klass) : super.fromNative(internal, _klass);
  Context(Surface surface)
      : this.fromNative(klass.ctor([surface.internal]), klass);

  arc(double xc, double yc, double r, double angle1, double angle2) =>
      (internal as JsObject).callMethod('arc', [xc, yc, r, angle1, angle2]);
  fill() => (internal as JsObject).callMethod('fill', []);
  lineTo(double x, double y) =>
      (internal as JsObject).callMethod('lineTo', [x, y]);
  moveTo(double x, double y) =>
      (internal as JsObject).callMethod('moveTo', [x, y]);
  paint() => (internal as JsObject).callMethod('paint', []);
  restore() => (internal as JsObject).callMethod('restore', []);
  rotate(double angle) => (internal as JsObject).callMethod('rotate', [angle]);
  save() => (internal as JsObject).callMethod('save', []);
  scale(double sx, double sy) =>
      (internal as JsObject).callMethod('scale', [sx, sy]);

  setLineCap(LineCap lineCap) =>
      (internal as JsObject).callMethod('setLineCap', [lineCap.value]);
  setLineWidth(double w) =>
      (internal as JsObject).callMethod('setLineWidth', [w]);
  setOperator(Operator operator) =>
      (internal as JsObject).callMethod('setOperator', [operator.value]);
  setSourceRGB(double r, double g, double b) =>
      (internal as JsObject).callMethod('setSourceRGB', [r, g, b]);
  setSourceRGBA(double r, double g, double b, double a) =>
      (internal as JsObject).callMethod('setSourceRGBA', [r, g, b, a]);
  setSourceSurface(Surface surface, double x, double y) => (internal
      as JsObject).callMethod(
      'setSourceSurface', [surface == null ? null : surface.internal, x, y]);
  stroke() => (internal as JsObject).callMethod('stroke', []);

  translate(double dx, double dy) =>
      (internal as JsObject).callMethod('translate', [dx, dy]);
}

/// An example of a wrapped enum
class Format {
  static final ImportWrapper _nativeCtor = () {
    return _cairo['Format'];
  }();

  final int value;
  const Format(int this.value);

  static final Format ARGB32 = (() =>
      new Format(_nativeCtor['ARGB32'].getValue()))();
  static final Format A1 = (() => new Format(_nativeCtor['A1'].getValue()))();
}

/// An example of a wrapped enum
class LineCap {
  static final ImportWrapper _nativeCtor = () {
    return _cairo['LineCap'];
  }();

  final int value;
  const LineCap(int this.value);

  static final LineCap ROUND = (() =>
      new LineCap(_nativeCtor['ROUND'].getValue()))();
}

/// An example of a wrapped enum
class Operator {
  static final ImportWrapper _nativeCtor = () {
    return _cairo['Operator'];
  }();

  final int value;
  const Operator(int this.value);

  static final Operator OVER = (() =>
      new Operator(_nativeCtor['OVER'].getValue()))();
  static final Operator SOURCE = (() =>
      new Operator(_nativeCtor['SOURCE'].getValue()))();
  operator ==(other) {
    if (other is! Operator) return false;
    return this.value == other.value;
  }
}
