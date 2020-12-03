/*
 * Copyright (C) 2017, David PHAM-VAN <dev.nfet.net@gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General  License for more details.
 *
 * You should have received a copy of the GNU Lesser General
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

import 'package:meta/meta.dart';

import 'data_types.dart';
import 'document.dart';
import 'object.dart';

/// Graphic state
@immutable
class PdfGraphicState {
  /// Create a new graphic state
  const PdfGraphicState({this.opacity});

  /// The opacity to apply to this graphic state
  final double opacity;

  PdfDict output() {
    final params = PdfDict();

    if (opacity != null) {
      params['/CA'] = PdfNum(opacity);
      params['/ca'] = PdfNum(opacity);
    }

    return params;
  }

  @override
  bool operator ==(dynamic other) {
    if (!(other is PdfGraphicState)) {
      return false;
    }
    return other.opacity == opacity;
  }

  @override
  int get hashCode => opacity.hashCode;
}

/// Stores all the graphic states used in the document
class PdfGraphicStates extends PdfObject {
  /// Create a new Graphic States object
  PdfGraphicStates(PdfDocument pdfDocument) : super(pdfDocument);

  final List<PdfGraphicState> _states = <PdfGraphicState>[];

  static const String _prefix = '/a';

  /// Generate a name for a state object
  String stateName(PdfGraphicState state) {
    var index = _states.indexOf(state);
    if (index < 0) {
      index = _states.length;
      _states.add(state);
    }
    return '$_prefix$index';
  }

  @override
  void prepare() {
    super.prepare();

    for (var index = 0; index < _states.length; index++) {
      params['$_prefix$index'] = _states[index].output();
    }
  }
}
