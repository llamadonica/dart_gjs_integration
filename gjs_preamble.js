// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Javascript preamble, that lets the output of dart2js run on JSShell.




(function(self) {
  // Location (Uri.base)
  const GLib = imports.gi.GLib;
  const Lang = imports.lang;

  var workingDirectory = GLib.getenv("PWD");

  // Global properties. "self" refers to the global object, so adding a
  // property to "self" defines a global variable.
  self.self = self;
  self.print = print;

  // Import misbehaves when dart tries to install wrapper methods.
  self.ImportWrapper = function (args) {
    var result = imports;
    for (var i = 0; i < args.o.length; i++) {
      result = result[args.o[i]];
    }
    this.wrapped = result;
  };
  self.ImportWrapper.prototype.ctor = function () {
    if (arguments.length === 0) {
      return new this.wrapped();
    }
    if (arguments.length === 1) {
      return new this.wrapped(arguments[0]);
    }
    if (arguments.length === 2) {
      return new this.wrapped(arguments[0], arguments[1]);
    }
    if (arguments.length === 3) {
      return new this.wrapped(arguments[0], arguments[1], arguments[2]);
    }
    throw("too many arguments");    
  };
  self.ImportWrapper.prototype.func = function () {
    if (arguments.length === 0) {
      return this.wrapped();
    }
    if (arguments.length === 1) {
      return this.wrapped(arguments[0]);
    }
    if (arguments.length === 2) {
      return this.wrapped(arguments[0], arguments[1]);
    }
    if (arguments.length === 3) {
      return this.wrapped(arguments[0], arguments[1], arguments[2]);
    }
    if (arguments.length === 4) {
      return this.wrapped(arguments[0], arguments[1], arguments[2], arguments[3]);
    }
    if (arguments.length === 5) {
      return this.wrapped(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4]);
    }
    throw("too many arguments");    
  };
  self.ImportWrapper.prototype.getValue = function () {
    return this.wrapped;
  };

  // Import misbehaves when dart tries to install wrapper methods.
  self.KlassWrapper = function (ctor) {
    this.wrapped = ctor;
  };
  self.KlassWrapper.prototype.ctor = function (args) {
    return new this.wrapped(args);
  };
  self.KlassWrapper.prototype.installProperty = function (name, get, set) {
    var options = new Object;
    if (get) {
      options.get = get;
    }
    if (set) {
      options.set = set;
    }
    Object.defineProperty(this, name, options);
  };
  self.wrapCall = function (target, method, args) {
    return target[method].apply(target, args);
  }
  self.newLangClass = function (options) {
    if (options.Properties) {
      for (let ix = 0; ix < options.Properties.length; ix++) {
        options.Properties[ix] = options.Properties[ix].wrapped;
      }
    }
    if (options.Extends) {
      options.Extends = options.Extends.wrapped;
    }
    return new Lang.Class(options);
  }

  self.location = { href: "file://" + workingDirectory + "/" };

   function computeCurrentScript() {
    try {
      throw new Error();
    } catch(e) {
      var stack = e.stack;
      print(stack);
      // The jsshell stack looks like:
      //   computeCurrentScript@...preambles/jsshell.js:23:13
      //   self.document.currentScript@...preambles/jsshell.js:53:37
      //   @/tmp/foo.js:308:1
      //   @/tmp/foo.js:303:1
      //   @/tmp/foo.js:5:1
      var re = new RegExp("^.*@(.*):[0-9]*$", "mg");
      var lastMatch = null;
      do {
        var match = re.exec(stack);
        if (match != null) lastMatch = match;
      } while (match != null);
      return lastMatch[1];
    }
  }

  // Adding a 'document' is dangerous since it invalidates the 'typeof document'
  // test to see if we are running in the browser. It means that the runtime
  // needs to do more precise checks.
  // Note that we can't run "currentScript" right away, since that would give
  // us the location of the preamble file. Instead we wait for the first access
  // which should happen just before invoking main. At this point we are in
  // the main file and setting the currentScript property is correct.
  // Note that we cannot use `thisFileName()`, since that would give us the
  // preamble and not the script file.
  var cachedCurrentScript = null;
  self.document = { get currentScript() {
      if (cachedCurrentScript == null) {
        cachedCurrentScript = {src: computeCurrentScript()};
      }
      return cachedCurrentScript;
    }
  };

  // Support for deferred loading.
  self.dartDeferredLibraryLoader = function(uri, successCallback, errorCallback) {
    try {
      load(uri);
      successCallback();
    } catch (error) {
      errorCallback(error);
    }
  };

  var timerIdCounter = 1;
  var timerIds = {};


  function addTimer(f, ms) {
    var id = timerIdCounter++;
    f.$timerId = id;
    var source = GLib.timeout_add(1, ms, function () {
      f();
      f.$timerId = undefined;
      delete timerIds[id];
    });
    timerIds[id] = f;
    return id;
  }
  function cancelTimer(id) {
    var f = timerIds[id];
    if (f == null) return;
    GLib.Source.remove(f.$timerId);
    f.$timerId = undefined;
    delete timerIds[id];
  }
  function addInterval(f, ms) {
    var id = timerIdCounter++;
    f.$timerId = id;
    var source = GLib.timeout_add(GLib.PRIORITY_DEFAULT, ms, function () {
      f();
      f.$timerId = undefined;
      delete timerIds[id];
      addInterval(f, ms);
    });
    timerIds[id] = f;
    return id;
  }
  function addTask(f) {
    GLib.idle_add(GLib.PRIORITY_HIGH_IDLE, f);
  }
  self.setTimeout = addTimer;
  self.clearTimeout = cancelTimer;
  self.setInterval = addInterval;
  self.clearInterval = cancelTimer;
  self.scheduleImmediate = addTask;
})(this)

var getKeys = function(obj){
   var keys = [];
   for(var key in obj){
      keys.push(key);
   }
   return keys;
};
