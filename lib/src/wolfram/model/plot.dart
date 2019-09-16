class Plot {
  Queryresult _queryresult;

  Plot({Queryresult queryresult}) {
    this._queryresult = queryresult;
  }

  Queryresult get queryresult => _queryresult;
  set queryresult(Queryresult queryresult) => _queryresult = queryresult;

  Plot.fromJson(Map<String, dynamic> json) {
    _queryresult = json['queryresult'] != null
        ? new Queryresult.fromJson(json['queryresult'])
        : null;
  }
  String getEncodedCoreUrl(from, to, exp) {
    var coreRequest = '';
    if (to == "" || from == "") {
      coreRequest = 'input=plot $exp';
    } else {
      coreRequest = 'input=plot $exp,x=$from..$to';
    }
    var encodedUrl = Uri.encodeFull(coreRequest);
    return encodedUrl;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._queryresult != null) {
      data['queryresult'] = this._queryresult.toJson();
    }
    return data;
  }
}

class Queryresult {
  bool _success;
  bool _error;
  int _numpods;
  String _datatypes;
  String _timedout;
  String _timedoutpods;
  double _timing;
  double _parsetiming;
  bool _parsetimedout;
  String _recalculate;
  String _id;
  String _host;
  String _server;
  String _related;
  String _version;
  List<Pods> _pods;

  Queryresult(
      {bool success,
      bool error,
      int numpods,
      String datatypes,
      String timedout,
      String timedoutpods,
      double timing,
      double parsetiming,
      bool parsetimedout,
      String recalculate,
      String id,
      String host,
      String server,
      String related,
      String version,
      List<Pods> pods}) {
    this._success = success;
    this._error = error;
    this._numpods = numpods;
    this._datatypes = datatypes;
    this._timedout = timedout;
    this._timedoutpods = timedoutpods;
    this._timing = timing;
    this._parsetiming = parsetiming;
    this._parsetimedout = parsetimedout;
    this._recalculate = recalculate;
    this._id = id;
    this._host = host;
    this._server = server;
    this._related = related;
    this._version = version;
    this._pods = pods;
  }

  bool get success => _success;
  set success(bool success) => _success = success;
  bool get error => _error;
  set error(bool error) => _error = error;
  int get numpods => _numpods;
  set numpods(int numpods) => _numpods = numpods;
  String get datatypes => _datatypes;
  set datatypes(String datatypes) => _datatypes = datatypes;
  String get timedout => _timedout;
  set timedout(String timedout) => _timedout = timedout;
  String get timedoutpods => _timedoutpods;
  set timedoutpods(String timedoutpods) => _timedoutpods = timedoutpods;
  double get timing => _timing;
  set timing(double timing) => _timing = timing;
  double get parsetiming => _parsetiming;
  set parsetiming(double parsetiming) => _parsetiming = parsetiming;
  bool get parsetimedout => _parsetimedout;
  set parsetimedout(bool parsetimedout) => _parsetimedout = parsetimedout;
  String get recalculate => _recalculate;
  set recalculate(String recalculate) => _recalculate = recalculate;
  String get id => _id;
  set id(String id) => _id = id;
  String get host => _host;
  set host(String host) => _host = host;
  String get server => _server;
  set server(String server) => _server = server;
  String get related => _related;
  set related(String related) => _related = related;
  String get version => _version;
  set version(String version) => _version = version;
  List<Pods> get pods => _pods;
  set pods(List<Pods> pods) => _pods = pods;

  Queryresult.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _error = json['error'];
    _numpods = json['numpods'];
    _datatypes = json['datatypes'];
    _timedout = json['timedout'];
    _timedoutpods = json['timedoutpods'];
    _timing = json['timing'];
    _parsetiming = json['parsetiming'];
    _parsetimedout = json['parsetimedout'];
    _recalculate = json['recalculate'];
    _id = json['id'];
    _host = json['host'];
    _server = json['server'];
    _related = json['related'];
    _version = json['version'];
    if (json['pods'] != null) {
      _pods = new List<Pods>();
      json['pods'].forEach((v) {
        _pods.add(new Pods.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this._success;
    data['error'] = this._error;
    data['numpods'] = this._numpods;
    data['datatypes'] = this._datatypes;
    data['timedout'] = this._timedout;
    data['timedoutpods'] = this._timedoutpods;
    data['timing'] = this._timing;
    data['parsetiming'] = this._parsetiming;
    data['parsetimedout'] = this._parsetimedout;
    data['recalculate'] = this._recalculate;
    data['id'] = this._id;
    data['host'] = this._host;
    data['server'] = this._server;
    data['related'] = this._related;
    data['version'] = this._version;
    if (this._pods != null) {
      data['pods'] = this._pods.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pods {
  String _title;
  String _scanner;
  String _id;
  int _position;
  bool _error;
  int _numsubpods;
  List<Subpods> _subpods;
  Expressiontypes _expressiontypes;

  Pods(
      {String title,
      String scanner,
      String id,
      int position,
      bool error,
      int numsubpods,
      List<Subpods> subpods,
      Expressiontypes expressiontypes}) {
    this._title = title;
    this._scanner = scanner;
    this._id = id;
    this._position = position;
    this._error = error;
    this._numsubpods = numsubpods;
    this._subpods = subpods;
    this._expressiontypes = expressiontypes;
  }

  String get title => _title;
  set title(String title) => _title = title;
  String get scanner => _scanner;
  set scanner(String scanner) => _scanner = scanner;
  String get id => _id;
  set id(String id) => _id = id;
  int get position => _position;
  set position(int position) => _position = position;
  bool get error => _error;
  set error(bool error) => _error = error;
  int get numsubpods => _numsubpods;
  set numsubpods(int numsubpods) => _numsubpods = numsubpods;
  List<Subpods> get subpods => _subpods;
  set subpods(List<Subpods> subpods) => _subpods = subpods;
  Expressiontypes get expressiontypes => _expressiontypes;
  set expressiontypes(Expressiontypes expressiontypes) =>
      _expressiontypes = expressiontypes;

  Pods.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _scanner = json['scanner'];
    _id = json['id'];
    _position = json['position'];
    _error = json['error'];
    _numsubpods = json['numsubpods'];
    if (json['subpods'] != null) {
      _subpods = new List<Subpods>();
      json['subpods'].forEach((v) {
        _subpods.add(new Subpods.fromJson(v));
      });
    }
    _expressiontypes = json['expressiontypes'] != null
        ? new Expressiontypes.fromJson(json['expressiontypes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this._title;
    data['scanner'] = this._scanner;
    data['id'] = this._id;
    data['position'] = this._position;
    data['error'] = this._error;
    data['numsubpods'] = this._numsubpods;
    if (this._subpods != null) {
      data['subpods'] = this._subpods.map((v) => v.toJson()).toList();
    }
    if (this._expressiontypes != null) {
      data['expressiontypes'] = this._expressiontypes.toJson();
    }
    return data;
  }
}

class Subpods {
  String _title;
  Img _img;

  Subpods({String title, Img img}) {
    this._title = title;
    this._img = img;
  }

  String get title => _title;
  set title(String title) => _title = title;
  Img get img => _img;
  set img(Img img) => _img = img;

  Subpods.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _img = json['img'] != null ? new Img.fromJson(json['img']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this._title;
    if (this._img != null) {
      data['img'] = this._img.toJson();
    }
    return data;
  }
}

class Img {
  String _src;
  String _alt;
  String _title;
  int _width;
  int _height;
  String _type;
  String _themes;
  bool _colorinvertable;

  Img(
      {String src,
      String alt,
      String title,
      int width,
      int height,
      String type,
      String themes,
      bool colorinvertable}) {
    this._src = src;
    this._alt = alt;
    this._title = title;
    this._width = width;
    this._height = height;
    this._type = type;
    this._themes = themes;
    this._colorinvertable = colorinvertable;
  }

  String get src => _src;
  set src(String src) => _src = src;
  String get alt => _alt;
  set alt(String alt) => _alt = alt;
  String get title => _title;
  set title(String title) => _title = title;
  int get width => _width;
  set width(int width) => _width = width;
  int get height => _height;
  set height(int height) => _height = height;
  String get type => _type;
  set type(String type) => _type = type;
  String get themes => _themes;
  set themes(String themes) => _themes = themes;
  bool get colorinvertable => _colorinvertable;
  set colorinvertable(bool colorinvertable) =>
      _colorinvertable = colorinvertable;

  Img.fromJson(Map<String, dynamic> json) {
    _src = json['src'];
    _alt = json['alt'];
    _title = json['title'];
    _width = json['width'];
    _height = json['height'];
    _type = json['type'];
    _themes = json['themes'];
    _colorinvertable = json['colorinvertable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['src'] = this._src;
    data['alt'] = this._alt;
    data['title'] = this._title;
    data['width'] = this._width;
    data['height'] = this._height;
    data['type'] = this._type;
    data['themes'] = this._themes;
    data['colorinvertable'] = this._colorinvertable;
    return data;
  }
}

class Expressiontypes {
  Expressiontype _expressiontype;

  Expressiontypes({Expressiontype expressiontype}) {
    this._expressiontype = expressiontype;
  }

  Expressiontype get expressiontype => _expressiontype;
  set expressiontype(Expressiontype expressiontype) =>
      _expressiontype = expressiontype;

  Expressiontypes.fromJson(Map<String, dynamic> json) {
    _expressiontype = json['expressiontype'] != null
        ? new Expressiontype.fromJson(json['expressiontype'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._expressiontype != null) {
      data['expressiontype'] = this._expressiontype.toJson();
    }
    return data;
  }
}

class Expressiontype {
  String _name;

  Expressiontype({String name}) {
    this._name = name;
  }

  String get name => _name;
  set name(String name) => _name = name;

  Expressiontype.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    return data;
  }
}
