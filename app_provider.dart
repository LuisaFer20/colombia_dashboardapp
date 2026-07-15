import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/colombia_model.dart';
import '../models/region_model.dart';
import '../models/attraction_model.dart';
import '../models/iss_model.dart';

enum LoadingState { initial, loading, success, error }

class AppProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  LoadingState countryState = LoadingState.initial;
  LoadingState regionsState = LoadingState.initial;
  LoadingState attractionsState = LoadingState.initial;
  LoadingState issState = LoadingState.initial;

  CountryModel? countryData;
  List<RegionModel> regions = [];
  List<AttractionModel> attractions = [];
  List<AttractionModel> filteredAttractions = [];
  IssModel? issData;
  Timer? _issTimer;

  String errorMessage = '';

  void fetchCountryData() async {
    countryState = LoadingState.loading;
    notifyListeners();
    try {
      countryData = await _apiService.getColombiaGeneral();
      countryState = LoadingState.success;
    } catch (e) {
      countryState = LoadingState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  void fetchRegions() async {
    regionsState = LoadingState.loading;
    notifyListeners();
    try {
      regions = await _apiService.getRegions();
      regionsState = LoadingState.success;
    } catch (e) {
      regionsState = LoadingState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  void fetchAttractions() async {
    attractionsState = LoadingState.loading;
    notifyListeners();
    try {
      attractions = await _apiService.getAttractions();
      filteredAttractions = attractions;
      attractionsState = LoadingState.success;
    } catch (e) {
      attractionsState = LoadingState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  void filterAttractions(String query) {
    if (query.isEmpty) {
      filteredAttractions = attractions;
    } else {
      filteredAttractions = attractions
          .where((element) =>
              element.name.toLowerCase().contains(query.toLowerCase()) ||
              (element.cityName?.toLowerCase().contains(query.toLowerCase()) ??
                  false))
          .toList();
    }
    notifyListeners();
  }

  void startIssTracking() {
    _fetchIssPosition();
    _issTimer?.cancel();
    _issTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchIssPosition();
    });
  }

  void stopIssTracking() {
    _issTimer?.cancel();
  }

  void _fetchIssPosition() async {
    try {
      issData = await _apiService.getIssLocation();
      issState = LoadingState.success;
    } catch (e) {
      if (issState == LoadingState.initial) {
        issState = LoadingState.error;
        errorMessage = e.toString();
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _issTimer?.cancel();
    super.dispose();
  }
}
