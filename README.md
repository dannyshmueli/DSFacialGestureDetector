DSFacialGestureDetector
=======================

In iOS7 Apple introduced new face features detection to the [CIDetecor](https://developer.apple.com/library/iOS//documentation/CoreImage/Reference/CIDetector_Ref/index.html).

[CIDetectorEyeBlink, CIDetectorSmile](https://developer.apple.com/library/iOS//documentation/CoreImage/Reference/CIDetector_Ref/index.html#//apple_ref/doc/constant_group/Feature_Detection_Keys)

Ever since i was wondering if i could "feed" it streaming video and maybe make NEW kind of gestures- facial gestures.

This is a basic version of it:

[![IMAGE ALT TEXT HERE](http://img.youtube.com/vi/cdzPRymOC7o/0.jpg)](http://www.youtube.com/watch?v=cdzPRymOC7o)

<a href="http://www.youtube.com/watch?feature=player_embedded&v=cdzPRymOC7o
" target="_blank"><img src="http://img.youtube.com/vi/cdzPRymOC7o/0.jpg" 
alt="Demo" width="480" height="360" border="10" /></a>

### Installing:

Using cocoapods: (coming soon)

`pod install 'DSFacialGestures'`

or import all the files under the Detector directory to your project.

### Using:

In your view controler:

1. implement: `<DSFacialDetectorDelegate>`
2. init:

```objc
self.facialGesturesDetector = [DSFacialGesturesDetector new];
self.facialGesturesDetector.delegate = self;
self.facialGesturesDetector.cameraPreviewView = self.cameraPreview;
NSError *error;
[self.facialGesturesDetector startDetection:&error];
```

See also example project.
