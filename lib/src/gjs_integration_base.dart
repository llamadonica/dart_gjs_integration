// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// TODO: Put public facing types in this file.

library gjs_integration.base;

import 'dart:js';

final JsFunction _ImportWrapper = () {
  return context['ImportWrapper'];
}();
final JsFunction _KlassWrapper = () {
  return context['KlassWrapper'];
}();
final JsFunction wrapGjsCall = () {
  return context['wrapCall'];
}();
final JsFunction _gjsPrint = () {
  return context['print'];
}();

void gjsPrint(String message) {
  _gjsPrint.apply([message]);
}

final Lang lang = () {
  return new Lang(['lang']);
}();

class GjsObject {
  final internal;
  GjsObject(this.internal);
}

abstract class GjsCtor {
  JsObject ctor(List args);
  JsObject get _wrapped;
}

class ImportWrapper extends GjsObject implements GjsCtor {
  final List path;
  ImportWrapper._(internal, this.path) : super(internal);
  factory ImportWrapper(List path) => new ImportWrapper._(
      new JsObject(_ImportWrapper, new JsArray.from([path])), path);
  ImportWrapper operator [](String name) {
    var innerPath = new List.from(path);
    innerPath.add(name);
    return new ImportWrapper(innerPath);
  }

  JsObject ctor(List args) => internal.callMethod('ctor', args);
  JsObject get _wrapped => internal;
  func(List args) => internal.callMethod('func', args);
  getValue() => internal.callMethod('getValue');
}

class LangClassWrapper extends GjsObject implements GjsCtor {
  LangClassWrapper._(internal) : super(internal);
  factory LangClassWrapper(JsFunction ctor) => new LangClassWrapper._(
      new JsObject(_KlassWrapper, new JsArray.from([ctor])));
  JsObject ctor(List args) => internal.callMethod('ctor', args);
  void installProperty(String name, {JsFunction get, JsFunction set}) =>
      internal.callMethod('installProperty', [name, get, set]);
  JsObject get _wrapped => internal;
}

class Klass {
  final GjsCtor internal;
  Klass.fromNativeCtor(this.internal);
  JsObject ctor(args) => internal.ctor(args);
  void installProperty(String name, {JsFunction get, JsFunction set}) {
    assert (internal is LangClassWrapper);
    (internal as LangClassWrapper).installProperty(name, get: get, set: set);
  }
}

class Lang extends ImportWrapper {
  static final JsFunction _newLangClass = () {
    return context['newLangClass'];
  }();

  Lang._(internal, path) : super._(internal, path);
  factory Lang(List path) =>
      new Lang._(new JsObject(_ImportWrapper, new JsArray.from([path])), path);

  Klass newClass(String name,
      {List<JsObject> properties, Klass extend, Map options}) {
    options['Name'] = name;
    if (extend != null) {
      options['Extends'] = extend.internal._wrapped;
    }
    if (properties != null) {
      options['Properties'] = new JsArray.from(properties);
    }
    return _newClass(options);
  }

  Klass _newClass(Map options) {
    return new Klass.fromNativeCtor(new LangClassWrapper(
        _newLangClass.apply([new JsObject.jsify(options)])));
  }
}
