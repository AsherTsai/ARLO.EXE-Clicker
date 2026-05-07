import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

class Model extends ChangeNotifier {
  //USED AI TO ORGANIZE
  //ADDED Shared Preferences and Audio Players

  final AudioPlayer bgMusicPlayer = AudioPlayer();

  Future<void> startBackgroundMusic() async {
    await bgMusicPlayer.setReleaseMode(ReleaseMode.loop);
    await bgMusicPlayer.setVolume(0.4); // Lower volume so clicks stand out
    await bgMusicPlayer.play(AssetSource('SFX/boogie.mp3'));
  }

  // VARS
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

  // CONSTRUCTOR
  Model() {
    _init();
  }

  Future<void> _init() async {
    await loadData();
    await startBackgroundMusic();
    startLoop();
  }

  // SAVE DATA
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('bits', _bits);
    await prefs.setInt('clicks', _clicks);
    await prefs.setInt('plus', _plus);
    await prefs.setInt('health', _health);
    await prefs.setInt('rank', _rank);
    await prefs.setInt('costumes', _costumes);
    await prefs.setBool('isBatteryDead', _isBatteryDead);
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _bits = prefs.getInt('bits') ?? 0;
    _clicks = prefs.getInt('clicks') ?? 1;
    _plus = prefs.getInt('plus') ?? 0;
    _health = prefs.getInt('health') ?? 0;
    _rank = prefs.getInt('rank') ?? 0;
    _costumes = prefs.getInt('costumes') ?? 1;
    _isBatteryDead = prefs.getBool('isBatteryDead') ?? false;
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
    saveData();
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

  void switchDaImage() async {
    if (_image == 1) {
      _image = 2;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 60));
      _image = 1;
      notifyListeners();
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
