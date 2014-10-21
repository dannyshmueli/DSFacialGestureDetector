DSFacialGestureDetector
=======================

In iOS7 Apple introduced new face features detection to the [CIDetecor](https://developer.apple.com/library/iOS//documentation/CoreImage/Reference/CIDetector_Ref/index.html).

[CIDetectorEyeBlink, CIDetectorSmile](https://developer.apple.com/library/iOS//documentation/CoreImage/Reference/CIDetector_Ref/index.html#//apple_ref/doc/constant_group/Feature_Detection_Keys)

Ever since i was wondering if i could "feed" it streaming video and maybe make NEW kind of gestures- facial gestures.

This is a basic version of it.
[![IMAGE ALT TEXT HERE](http://img.youtube.com/vi/cdzPRymOC7o/0.jpg)](http://www.youtube.com/watch?v=YOUTUBE_cdzPRymOC7o)


### Installing:

//Using cocoapods:

//#`pod install 'DSFacialGestures'`

import all the files under the Detector directory to your project.

### Using:

1. in your view controler:
2. * implement: `<DSFacialDetectorDelegate>`

```objc
self.facialGesturesDetector = [DSFacialGesturesDetector new];
self.facialGesturesDetector.delegate = self;
self.facialGesturesDetector.cameraPreviewView = self.cameraPreview;
NSError *error;
[self.facialGesturesDetector startDetection:&error];
```

See also example project.
