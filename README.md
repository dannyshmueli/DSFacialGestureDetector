DSFacialGestureDetector
=======================

In iOS7 Apple introduced new face features detection to the [CIDetecor](https://developer.apple.com/library/iOS//documentation/CoreImage/Reference/CIDetector_Ref/index.html)
[CIDetectorEyeBlink, CIDetectorSmile](https://developer.apple.com/library/iOS//documentation/CoreImage/Reference/CIDetector_Ref/index.html#//apple_ref/doc/constant_group/Feature_Detection_Keys)

Ever since i was wondering if i could "feed" it streaming video and maybe make NEW kind of gestures- facial gestures.

This is a basic version of it.

How To use:
Using cocoapods:

`pod install 'DSFacialGestures'`


1. import all the files under the Detector directory to your project.

2. in your view controler:
* implement: `<DSFacialDetectorDelegate>`

`
self.facialGesturesDetector = [[DSFacialGesturesDetector alloc] init];
self.facialGesturesDetector.delegate = self;
self.facialGesturesDetector.cameraPreviewView = self.cameraPreview;
NSError *error;
[self.facialGesturesDetector startDetection:&error];
    `

3. See example project.
