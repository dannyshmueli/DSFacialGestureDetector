//
//  ViewController.m
//  DSFacialGestureDetectorExampleProject
//
//  Created by Danny Shmueli on 10/18/14.
//  Copyright (c) 2014 DS. All rights reserved.
//

#import "ViewController.h"
#import "DSFacialGesturesDetector.h"
#import "RoundProgressView.h"


@interface ViewController () <DSFacialDetectorDelegate>

@property (nonatomic, weak) IBOutlet UIView *cameraPreview;
@property (nonatomic, strong) IBOutlet RoundProgressView *smileProgressView, *leftBlinkProgressView, *rightBlinkProgressView;

@property (nonatomic, strong) IBOutlet UIView *detectedGestureWrapperView;
@property (nonatomic, strong) IBOutlet UILabel *detectedGestureLabel;

@property (nonatomic, strong) DSFacialGesturesDetector *facialGesturesDetector;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ViewController

const float kTimeToDissmissDetectedGestureLabel = 2.6f;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    self.cameraPreview.bounds = screen;
    
    self.facialGesturesDetector = [DSFacialGesturesDetector new];
    self.facialGesturesDetector.delegate = self;
    self.facialGesturesDetector.cameraPreviewView = self.cameraPreview;
    NSError *error;
    [self.facialGesturesDetector startDetection:&error];
    if (error)
    {
        [self showError:error];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Facial Detector Delegate

-(void)didRegisterFacialGesutreOfType:(GestureType)facialGestureType withLastImage:(UIImage *)lastImage
{
    self.detectedGestureLabel.text = [NSString stringWithFormat:@"Ok you %@", [DSFacialGesture gestureTypeToString:facialGestureType]];
    self.detectedGestureWrapperView.hidden = NO;
    [self startTimerDetecetedLabelDismisallTimer];
}

-(void)didUpdateProgress:(float)progress forType:(GestureType)facialGestureType
{
    RoundProgressView *progressView = [self getCorrectProgressBasedOnType:facialGestureType];
    progressView.progress = progress;
}

#pragma mark - Private

-(void)showError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:
      [NSString stringWithFormat:@"Failed with error %d", (int)[error code]]
                                message:[error localizedDescription]
                               delegate:nil
                      cancelButtonTitle:@"Dismiss"
                      otherButtonTitles:nil] show];
}

-(void)startTimerDetecetedLabelDismisallTimer
{
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kTimeToDissmissDetectedGestureLabel
                                                                            target:self selector:@selector(dismissDetectedLabel)
                                                                          userInfo:nil
                                                                           repeats:NO];
}

-(void)dismissDetectedLabel
{
    [UIView animateWithDuration:0.5 animations:^(){
        self.detectedGestureWrapperView.alpha = 0;
    } completion:^(BOOL finisehd){
        self.detectedGestureWrapperView.hidden = YES;
        self.detectedGestureWrapperView.alpha = 1;
    }];
    
}

-(RoundProgressView *)getCorrectProgressBasedOnType:(GestureType)gestureType
{
    if (gestureType == GestureTypeLeftBlink)
        return self.leftBlinkProgressView;

    if (gestureType == GestureTypeRightBlink)
        return self.rightBlinkProgressView;

    if (gestureType == GestureTypeSmile)
        return self.smileProgressView;

    return nil;
}

@end
