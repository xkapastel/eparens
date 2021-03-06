// This file is a part of Electric Parens.
// Copyright (C) 2019 Matthew Blount

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.

// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Affero General Public License for more details.

// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <https://www.gnu.org/licenses/.

import "dart:collection";
import "value.dart";
import "nil.dart";
import "pair.dart";
import "number.dart";
import "procedure.dart";
import "error.dart";
import "../read.dart";

class Environment extends Value {
  Environment parent;
  Map<String, dynamic> frame;

  Environment(Environment this.parent) {
    frame = new HashMap();
  }

  factory Environment.empty() => Environment(null);

  bool isDefined(dynamic key) {
    key = key.toString();
    if (frame.containsKey(key)) {
      return true;
    }
    if (parent != null) {
      return parent.isDefined(key);
    }
    return false;
  }

  dynamic operator [](dynamic key) {
    key = key.toString();
    if (frame.containsKey(key)) {
      return frame[key];
    }
    if (parent != null) {
      return parent[key];
    }
    // Isn't passing a continuation here and then rethrowing in Symbol kind of
    // weird? It makes sense to throw errors inside env, but it doesn't have
    // access to the continuation, so you "need" to rethrow.
    throw Undefined(key, (x) => x);
  }

  void operator []=(dynamic key, dynamic value) {
    key = key.toString();
    if (key == "_") {
      return;
    }
    if (frame.containsKey(key)) {
      throw Redefined(key, frame[key], value, (x) => x);
    }
    frame[key] = value;
  }

  Value evalString(String src) {
    var result = null;
    for (var value in read(src)) {
      result = value.eval(this, (x) => x);
    }
    return result;
  }

  double apply1d(Procedure proc, double value) {
    var args = Pair(Number(value), nil);
    var result = proc.call(args, this, (x) => x);
    acceptNumber(result);
    return result.value;
  }

  @override
  String toString() => "<env>";
}
