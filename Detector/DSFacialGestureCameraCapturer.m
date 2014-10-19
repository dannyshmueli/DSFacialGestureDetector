//
//  DSFacialGestureCameraCapturer.m
//  DSFacialGestureDetectorExampleProject
//
//  Created by Danny Shmueli on 10/18/14.
//  Copyright (c) 2014 DS. All rights reserved.
//

#import "DSFacialGestureCameraCapturer.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface DSFacialGestureCameraCapturer() <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;
@property (nonatomic) dispatch_queue_t videoDataOutputQueue;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, readwrite) BOOL isUsingFrontCamera;
@property (nonatomic, readwrite) double lastSampleTimestamp;

@property (nonatomic, readwrite) float sampleRate;

@end

@implementation DSFacialGestureCameraCapturer


-(void)setAVCaptureAtSampleRate:(float)sampleRate withCameraPreviewView:(UIView *)cameraPreviewView withError:(NSError **)error
{
    self.sampleRate = sampleRate;
    self.session = nil;
    self.session = [AVCaptureSession new];
    self.session.sessionPreset = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone ? AVCaptureSessionPreset640x480 : AVCaptureSessionPresetPhoto;
    AVCaptureDeviceInput *deviceInput = [self getCaptureDeviceInput:error];
    
    if (*error) {
        [self teardownAVCapture];
        return;
    }
    
    // add the input to the session
    if ( [self.session canAddInput:deviceInput] ){
        [self.session addInput:deviceInput];
    }
    
    // Make a video data output
    self.videoDataOutput = [AVCaptureVideoDataOutput new];
    
    // we want BGRA, both CoreGraphics and OpenGL work well with 'BGRA'
    self.videoDataOutput.videoSettings = @{ (id)kCVPixelBufferPixelFormatTypeKey : @(kCMPixelFormat_32BGRA) };
    // discard if the data output queue is blocked
    self.videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
    
    // create a serial dispatch queue used for the sample buffer delegate
    // a serial dispatch queue must be used to guarantee that video frames will be delivered in order
    // see the header doc for setSampleBufferDelegate:queue: for more information
    self.videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [self.videoDataOutput setSampleBufferDelegate:self queue:self.videoDataOutputQueue];
    
    if ( [self.session canAddOutput:self.videoDataOutput] ){
        [self.session addOutput:self.videoDataOutput];
    }
    
    // get the output for doing face detection.
    [[self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
    
    if (cameraPreviewView)
    {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        self.previewLayer.backgroundColor = [[UIColor blackColor] CGColor];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        CALayer *rootLayer = cameraPreviewView.layer;
        rootLayer.masksToBounds = YES;
        self.previewLayer.frame = rootLayer.bounds;
        [rootLayer addSublayer:self.previewLayer];
    }
    [self.session startRunning];
}

-(AVCaptureDeviceInput *)getCaptureDeviceInput:(NSError **)error;
{
    AVCaptureDevice *device;
    
    AVCaptureDevicePosition desiredPosition = AVCaptureDevicePositionFront;
    
    // find the front facing camera
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if (d.position == desiredPosition) {
            device = d;
            self.isUsingFrontCamera = YES;
            break;
        }
    }
    // fall back to the default camera.
    if( nil == device )
    {
        self.isUsingFrontCamera = NO;
        device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    // get the input device
    return [AVCaptureDeviceInput deviceInputWithDevice:device error:error];
}

- (void)teardownAVCapture
{
    self.videoDataOutput = nil;
    if (self.videoDataOutputQueue) {
        self.videoDataOutputQueue = nil;
    }
    
    [self.previewLayer removeFromSuperlayer];
    self.previewLayer = nil;
    
    self.session = nil;
}


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    if (!self.lastSampleTimestamp){
        self.lastSampleTimestamp = CACurrentMediaTime();
    }
    else{
        double now = CACurrentMediaTime();
        double timePassedSinceLastSample = now - self.lastSampleTimestamp;
        
        if (timePassedSinceLastSample < self.sampleRate)
            return;
        self.lastSampleTimestamp = now;
    }
    
    // get the image
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer
                                                      options:(__bridge NSDictionary *)attachments];
    if (attachments) {
        CFRelease(attachments);
    }
    [self.delegate imageFromCamera:ciImage isUsingFrontCamera:self.isUsingFrontCamera];
}


@end
