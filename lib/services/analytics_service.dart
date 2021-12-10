import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

class AnalyticsService with ChangeNotifier{
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver getAnalyticsObserver() => FirebaseAnalyticsObserver(analytics: _analytics);

  Future setUserProperties({required String userID, required String userRole}) async {
    await _analytics.setUserId(userID);
    await _analytics.setUserProperty(name: 'user_role', value: userRole);

    /// property to indicate if it's a pro member
    /// property to tell us if it's a regular poster
    /// Others
  }

  Future logLogin() async {
    await _analytics.logLogin(loginMethod: 'email');
    notifyListeners();
  }

  Future logSignUp() async {
    await _analytics.logSignUp(signUpMethod: 'email');
    notifyListeners();
  }

  Future logSearch(String item, String origin) async {
    await _analytics.logSearch(searchTerm: item, origin: origin);
    notifyListeners();
  }

  Future logViewSearchResults(String term) async {
    await _analytics.logViewSearchResults(searchTerm: term);
    notifyListeners();
  }

  Future logSelectContent(String contentType, String itemId) async {
    await _analytics.logSelectContent(contentType: contentType, itemId: itemId);
    notifyListeners();
  }

  Future logOnboardBegin() async {
    await _analytics.logTutorialBegin();
    notifyListeners();
  }

  Future logOnboardComplete() async {
    await _analytics.logTutorialComplete();
  }

  Future logCreateRecipe(String username) async {
    await _analytics
        .logEvent(
        name: 'create_recipe',
        parameters: {
          'username': username,
        }
    );
  }
}