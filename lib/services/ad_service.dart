import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  RewardedAd? _rewardedAd;
  bool _isRewardedAdLoading = false;

  // Provided IDs
  static const String androidRewardedUnitId = 'ca-app-pub-8043279937480250/9889808438';
  static const String iosRewardedUnitId = 'ca-app-pub-8043279937480250/4058763807';


  String get rewardedAdUnitId {
    if (kDebugMode) {
      // Use test IDs in debug mode to avoid policy violations
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/1712485313';
    }
    return Platform.isAndroid ? androidRewardedUnitId : iosRewardedUnitId;
  }

  void loadRewardedAd() {
    if (_isRewardedAdLoading) return;
    _isRewardedAdLoading = true;

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdLoading = false;
          debugPrint('Rewarded Ad Loaded');
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
          _isRewardedAdLoading = false;
          debugPrint('Rewarded Ad Failed to Load: $error');
        },
      ),
    );
  }

  void showRewardedAd({
    required Function(RewardItem reward) onRewardEarned,
    VoidCallback? onAdClosed,
  }) {
    if (_rewardedAd == null) {
      debugPrint('Warning: Attempted to show rewarded ad before it was loaded.');
      loadRewardedAd(); // Try loading for next time
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd(); // Preload next one
        if (onAdClosed != null) onAdClosed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
        debugPrint('Rewarded Ad Failed to Show: $error');
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        onRewardEarned(reward);
      },
    );
  }

  void dispose() {
    _rewardedAd?.dispose();
  }
}
