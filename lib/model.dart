import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flame_audio/flame_audio.dart';

class Model extends ChangeNotifier {
  Model() {
    _init();
  }
  SharedPreferences? _prefs;

  Future<void> playsfx(String sound) async {
    if (sound == 'click' && _clickPool != null) {
      _clickPool!.start();
    }else{
       FlameAudio.play('$sound.mp3');

    }
   
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // VARS
  AudioPool? _clickPool;
  int _bits = 0;
  int _clicks = 1;
  int _plus = 0;
  int _health = 0;
  int _rank = 0;
  int _costumes = 1;
  int _image = 1;
  bool _isBatteryDead = false;

  int page = 1;
  Timer? _timer;
  Color clickOne = const Color.fromARGB(255, 239, 239, 241);
  Color clickTwo = const Color.fromARGB(255, 227, 225, 234);

  // SHOP DATA
  final List<int> rankspots = [0, 1000, 1000000, 1000000000];

  final List<String> kbItemNames = [
    "Shiny Floppy",
    "Macro.exe",
    "Discount Keyboard",
    "Dusty Cooling Fan",
    "Leaf OS",
  ];
  final List<int> kbItemCost = [150, 250, 450, 676, 950];
  final List<int> kbItemValues = [1, 2, 4, 6, 8];
  final List<int> kbItemHitValues = [1, 2, 3, 4, 5];

  final List<String> mbItemNames = [
    "Boxy Hardrive",
    "Pirated Software",
    "Gaming Mouse",
    "Cheep Graphics Card",
    "Burrow-fi",
  ];
  final List<int> mbItemCost = [15000, 45000, 67676, 90000, 150000];
  final List<int> mbItemValues = [16, 19, 23, 26, 29];
  final List<int> mbItemHitValues = [6, 7, 8, 9, 10];

  final List<String> gbItemNames = [
    "Liquid Cooling",
    "Overclocked CPU",
    "Fiber Optic Internet",
    "SSD Upgrade",
    "Global Quokka Net",
  ];
  final List<int> gbItemCost = [
    2000000,
    5000000,
    10000000,
    67676767,
    900000000,
  ];
  final List<int> gbItemValues = [32, 35, 38, 42, 45];
  final List<int> gbItemHitValues = [11, 12, 13, 14, 15];

  final List<String> tbItemNames = [
    "Gasoline Cooling System",
    "Top Notch Rich Software",
    "AI Model",
    "Massive Cloud Hosting",
    "Neural Nuzzle",
  ];
  final List<int> tbItemCost = [
    2000000000,
    4500000000,
    6767676767,
    80000000000,
    99999999999,
  ];
  final List<int> tbItemValues = [48, 52, 55, 58, 62];
  final List<int> tbItemHitValues = [16, 17, 18, 19, 20];

  Future<void> _init() async {
    _clickPool = await AudioPool.create(
      source: AssetSource('audio/click.mp3'),
      maxPlayers: 5,
    );

    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('boogie.mp3', volume: 0.3);

    _prefs = await SharedPreferences.getInstance(); // Get it once here
    loadData();

    startLoop();
  }

  // SAVE DATA
  void saveData() async {
    if (_prefs == null) return;
    _prefs!.setInt('bits', _bits);
    _prefs!.setInt('clicks', _clicks);
    _prefs!.setInt('plus', _plus);
    _prefs!.setInt('health', _health);
    _prefs!.setInt('rank', _rank);
    _prefs!.setInt('costumes', _costumes);
    _prefs!.setBool('isBatteryDead', _isBatteryDead);
  }

  Future<void> loadData() async {
    _bits = _prefs!.getInt('bits') ?? 0;
    _clicks = _prefs!.getInt('clicks') ?? 1;
    _plus = _prefs!.getInt('plus') ?? 0;
    _health = _prefs!.getInt('health') ?? 0;
    _rank = _prefs!.getInt('rank') ?? 0;
    _costumes = _prefs!.getInt('costumes') ?? 1;
    _isBatteryDead = _prefs!.getBool('isBatteryDead') ?? false;
    notifyListeners();
  }

  // GETERS
  int get bits => _bits;
  int get clicks => _clicks;
  int get plus => _plus;
  int get health => _health;
  int get rank => _rank;
  int get costumes => _costumes;
  int get image => _image;

  String get formattedBits {
    if (_bits < 1000) return _bits.toString();
    if (_bits < 1000000) return (_bits / 1000).toStringAsFixed(3);
    if (_bits < 1000000000) return (_bits / 1000000).toStringAsFixed(3);
    return (_bits / 1000000000).toStringAsFixed(3);
  }

  String get quokka => _isBatteryDead ? 'dedquokka_' : 'quokka_';
  String get display =>
      _isBatteryDead ? 'BATTERY DED!' : 'AUTO: $_plus    HITS: $_clicks';
  String get type {
    const types = ["KB", "MB", "GB", "TB"];

    if (_rank < 0 || _rank >= types.length) return "KB";

    return types[_rank];
  }

  // SHOP GETTERS
  List<String> get currentNames {
    return [_kbNames, _mbNames, _gbNames, _tbNames][_rank];
  }

  List<int> get currentCosts {
    return [_kbCosts, _mbCosts, _gbCosts, _tbCosts][_rank];
  }

  List<int> get currentValues {
    return switch (_rank) {
      3 => tbItemValues,
      2 => gbItemValues,
      1 => mbItemValues,
      _ => kbItemValues,
    };
  }

  List<int> get currentHitValues {
    return switch (_rank) {
      3 => tbItemHitValues,
      2 => gbItemHitValues,
      1 => mbItemHitValues,
      _ => kbItemHitValues,
    };
  }

  List<String> get _kbNames => kbItemNames;
  List<int> get _kbCosts => kbItemCost;
  List<String> get _mbNames => mbItemNames;
  List<int> get _mbCosts => mbItemCost;
  List<String> get _gbNames => gbItemNames;
  List<int> get _gbCosts => gbItemCost;
  List<String> get _tbNames => tbItemNames;
  List<int> get _tbCosts => tbItemCost;

  int get batteryCurrentCosts => currentCosts[0];

  // FUNCTIONSS
  void incrementBits() {
    _bits += _clicks;
    switchDaImage();
    updateRank();
    notifyListeners();
  }

  void incrementPlus() {
    _bits += (_isBatteryDead ? 0 : _plus);
    updateRank();
  }

  void updateRank() {
    if (_rank + 1 < rankspots.length) {
      if (_bits >= rankspots[_rank + 1]) {
        _rank++;
        notifyListeners();
      }
    }
  }

  void shopPlus(int perSecond, int cost) {
    if (_bits >= cost) {
      _plus += perSecond;
      _bits -= cost;
      saveData();
      notifyListeners();
    }
  }

  void shopHitPlus(int perHit, int cost) {
    if (_bits >= cost) {
      _clicks += perHit;
      _bits -= cost;
      saveData();
      notifyListeners();
    }
  }

  void repairComputer() {
    if (_bits >= batteryCurrentCosts) {
      _bits -= batteryCurrentCosts;
      _health = 0;
      _isBatteryDead = false;
      saveData();
      notifyListeners();
    }
  }

  bool isAnimating = false;

  void switchDaImage() async {
    if (!isAnimating) {
      isAnimating = true;
      if (_image == 1) {
        _image = 2;
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 60));
        _image = 1;
        notifyListeners();
        isAnimating = false;
      }
    }
  }

  void clickColor(int clickNumber) {
    if (clickNumber == 1) {
      clickOne = const Color.fromARGB(255, 239, 239, 241);
      clickTwo = const Color.fromARGB(255, 227, 225, 234);
    } else {
      clickOne = const Color.fromARGB(255, 227, 225, 234);
      clickTwo = const Color.fromARGB(255, 255, 255, 255);
    }
    notifyListeners();
  }

  void startLoop() {
    if (_timer != null) return;
    int autoSaveCounter = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      incrementPlus();
      _isBatteryDead = (_health >= 16);

      autoSaveCounter++;
      if (autoSaveCounter >= 10) {
        saveData();
        autoSaveCounter = 0;
      }
      notifyListeners();
    });
  }
}
