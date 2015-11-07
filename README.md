# gjs_integration

A library for writing Gtk programs in Dart

## Usage

A simple usage example:

import 'dart:async';
import 'dart:js';

import 'package:gjs_integration/gjs_integration.dart';
import 'package:gjs_integration/gobject.dart';
import 'package:gjs_integration/gtk.dart';

    @gObjectClass
    class App extends Application {

      ApplicationWindow _appWindow;

      @vfunc
      activate() {
        appWindow.showAll();
        appWindow.present();
      }

      ApplicationWindow get appWindow {
        if (_appWindow == null) {
          _appWindow =
              new ApplicationWindow(application: this, title: 'Hello World!');
          _appWindow.setDefaultSize(200, 200);
          _appWindow.add(new Label(label: 'Hello world'));
        }
        return _appWindow;
      }

      @exposeToGjs
      final bool x;
      App(this.x) : super() ;
    }

    void main(List args) {
      var app = new App(true);
      app.run(new JsArray.from(args));
    }

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme
