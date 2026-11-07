# fps_tap_to_pay_ios

A small Flutter plugin used by FPS APP to present Apple's **Tap to Pay on iPhone** merchant education
(`ProximityReaderDiscovery`, iOS 18 and later). Apple keeps this content up to date and localized,
including PIN entry guidance.

```dart
import 'package:fps_tap_to_pay_ios/fps_tap_to_pay_ios.dart';

if (await FpsTapToPayIos.isEducationAvailable()) {
  await FpsTapToPayIos.showEducation();
}
```

On iOS versions before 18 and on other platforms both calls return `false`, so the app can fall back to
its own education screens. The plugin contains no payment logic and no credentials; payments are handled
by the payment service provider's SDK (Stripe Terminal).
