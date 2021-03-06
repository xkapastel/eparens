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

import "value.dart";
import "error.dart" as error;

class Symbol extends Value {
  final String value;

  Symbol(String this.value);

  @override
  dynamic eval(dynamic env, Function rest) {
    try {
      var value = env[this];
      return rest(value);
    } on error.Undefined catch (err) {
      throw error.Undefined(err.symbol, rest);
    }
  }

  @override
  String toString() => value;
}
