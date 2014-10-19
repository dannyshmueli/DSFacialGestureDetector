//
//  FacialDetector.m
//  FacialGestures
//
//  Created by Danny Shmueli on 6/28/13.
//  Copyright (c) 2013 Danny Shmueli. All rights reserved.
//

#import "DSFacialGesturesDetector.h"
#import "DSFacialGesture.h"
#import "UIDevice+ExifOrientation.h"
#import "DSFacialGestureAggregator.h"
#import "DSFacialGestureCameraCapturer.h"

@interface DSFacialGesturesDetector () <DSFacialGestureCameraCapturerDelegate, FacialGestureAggregatorDelegte>

@property (nonatomic, strong) CIDetector *faceDetector;
@property (nonatomic, strong) DSFacialGestureCameraCapturer *cameraCapturer;
@property (nonatomic, strong) DSFacialGestureAggregator *gestureAggregator;

@property (nonatomic, strong) CIImage *lastImage;
@end


@implementation DSFacialGesturesDetector

/**
 *  if this value is too low it takes a lot of CPU, if too high the effect is bad cause detection is not happening a lot.
 */
const float kSamplesPerSecond = 0.3;

- (id)init
{
    self = [super init];
    if (self) {
		self.gestureAggregator = [DSFacialGestureAggregator new];
        self.gestureAggregator.samplesPerSecond = kSamplesPerSecond;
        self.gestureAggregator.delegate = self;
		self.faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace
											 context:nil
											 options:@{CIDetectorAccuracy : CIDetectorAccuracyLow}];
        self.cameraCapturer = [DSFacialGestureCameraCapturer new];
        self.cameraCapturer.delegate = self;
        
    }
    return self;
}

-(void)startDetection:(NSError **)error
{
    [self.cameraCapturer setAVCaptureAtSampleRate:kSamplesPerSecond withCameraPreviewView:self.cameraPreviewView withError:error];
}

-(void)stopDetection
{
    self.lastImage = nil;
	[self.cameraCapturer teardownAVCapture];
}

#pragma mark - Camera Capturer Delegate

-(void)imageFromCamera:(CIImage *)ciImage isUsingFrontCamera:(BOOL)isUsingFrontCamera
{
    ExifForOrientationType exifOrientation = [[UIDevice currentDevice] exifForCurrentOrientationWithFrontCamera:isUsingFrontCamera];
    
    NSDictionary *detectionOtions = @{ CIDetectorImageOrientation : @(exifOrientation),
                                       CIDetectorSmile : @YES,
                                       CIDetectorEyeBlink : @YES,
                                       CIDetectorAccuracy : CIDetectorAccuracyLow
                                       
                                       };

    NSArray *features = [self.faceDetector featuresInImage:ciImage
                                                   options:detectionOtions];
    self.lastImage = ciImage;
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self extractFacialGesturesFromFeatures:features];
    });
}

#pragma mark - Aggregator Delegte
-(void)didUpdateProgress:(DSFacialGesture *)gesture
{
    [self.delegate didUpdateProgress:gesture.precentForFullGesture forType:gesture.type];
}

#pragma mark - Private

-(void)extractFacialGesturesFromFeatures:(NSArray *)features
{
	for ( CIFaceFeature *faceFeature in features )
	{
	    if (faceFeature.hasSmile)
        {
			[self.gestureAggregator addGesture:GestureTypeSmile];
		}
		if (faceFeature.leftEyeClosed)
		{
			[self.gestureAggregator addGesture:GestureTypeLeftBlink];
		}
		if (faceFeature.rightEyeClosed)
		{
			[self.gestureAggregator addGesture:GestureTypeRightBlink];
		}
	}
	GestureType registeredGestured = [self.gestureAggregator checkIfRegisteredGesturesAndUpdateProgress];
	if (registeredGestured == GestureTypeNoGesture)
		return;

	UIImage *lastImage = [UIImage imageWithCIImage:self.lastImage scale:1 orientation:UIImageOrientationLeftMirrored];

    [self.delegate didRegisterFacialGesutreOfType:registeredGestured withLastImage:lastImage];
}
@end
