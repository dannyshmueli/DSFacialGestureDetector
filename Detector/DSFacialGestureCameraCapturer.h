//
//  DSFacialGestureCameraCapturer.h
//  DSFacialGestureDetectorExampleProject
//
//  Created by Danny Shmueli on 10/18/14.
//  Copyright (c) 2014 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CIImage;
@class UIView;

@protocol DSFacialGestureCameraCapturerDelegate <NSObject>

-(void)imageFromCamera:(CIImage *)ciImage isUsingFrontCamera:(BOOL)isUsingFrontCamera;

@end


@interface DSFacialGestureCameraCapturer : NSObject

@property (nonatomic, weak) id<DSFacialGestureCameraCapturerDelegate> delegate;

-(void)setAVCaptureAtSampleRate:(float)sampleRate withCameraPreviewView:(UIView *)cameraPreviewView withError:(NSError **)error;
- (void)teardownAVCapture;
@end
