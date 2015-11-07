// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Transfomer used for pub-serve and pub-deploy.
library gjs_integration.transformer;

import 'src/build/gjs_transformer.dart';
import 'src/build/common.dart';

import 'package:barback/barback.dart';



/// The Polymer transformer, which internally runs several phases that will:
///   * Extract inlined script tags into their separate files
///   * Apply the observable transformer on every Dart script.
///   * Inline imported html files
///   * Combine scripts from multiple files into a single script tag
///   * Inject extra polyfills needed to run on all browsers.
///
/// At the end of these phases, this tranformer produces a single entrypoint
/// HTML file with a single Dart script that can later be compiled with dart2js.
class GjsIntegrationTransformerGroup implements TransformerGroup {
  final Iterable<Iterable> phases;

  GjsIntegrationTransformerGroup(TransformOptions options)
      : phases = createDeployPhases(options);

  GjsIntegrationTransformerGroup.asPlugin(BarbackSettings settings)
      : this(_parseSettings(settings));
}

_readFileList(value) {
  if (value == null) return null;
  var files = [];
  bool error;
  if (value is List) {
    files = value;
    error = value.any((e) => e is! String);
  } else if (value is String) {
    files = [value];
    error = false;
  } else {
    error = true;
  }
  if (error) {
    print('Invalid value for "entry_points" in the polymer transformer.');
  }
  return files;
}

TransformOptions _parseSettings(BarbackSettings settings) {
  var args = settings.configuration;
  return new TransformOptions(
      entryPoints: _readFileList(args['entry_points']));
}
/// Create deploy phases for Polymer. Note that inlining HTML Imports
/// comes first (other than linter, if [options.linter] is enabled), which
/// allows the rest of the HTML-processing phases to operate only on HTML that
/// is actually imported.
List<List<Transformer>> createDeployPhases(TransformOptions options,
    {String sdkDir}) {
  // TODO(sigmund): this should be done differently. We should lint everything
  // that is reachable and have the option to lint the rest (similar to how
  // dart2js can analyze reachable code or entire libraries).
  var phases = [];
  phases.add(
    [
      new GObjectKlassTransformer(options)
    ]);
  return phases;
}

final RegExp _PACKAGE_PATH_REGEX = new RegExp(r'packages\/([^\/]+)\/(.*)');
