//
//  FacialGestureAggregator.m
//  FacialGestures
//
//  Created by Danny Shmueli on 6/28/13.
//  Copyright (c) 2013 Danny Shmueli. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DSFacialGestureAggregator.h"

@interface DSFacialGestureAggregator()

@property (nonatomic, strong) NSMutableArray *smilesArray, *leftBlinksArray, *rightBlinksArray;

@property (nonatomic, strong) NSTimer *simileGesturesCounterInvalidatorTimer, *leftBlinkGesturesCounterInvalidatorTimer, *rightBlinkGesturesCounterInvalidatorTimer;

@property (atomic, readwrite) BOOL isSearchingForGesture;

@end

@implementation DSFacialGestureAggregator

const static int kNumberOfRecordsToStore = 30;
const static float kTimeNeedsToSmile = 3;
const static float kTimeNeedsToWink = 2.0f;
const static float kMaxTimeBetweenConsecutiveGesturesMutiplier = 4.0f;

#pragma mark - API

-(void)addGesture:(GestureType)gestureType
{
    DSFacialGesture *gesture = [DSFacialGesture facialGestureOfType:gestureType withTimeStamp:CACurrentMediaTime()];

    [self addObjectToArray:[self getArrayBasedOnGestureType:gestureType]
                    object:gesture
     withMaxRecordsToStore:kNumberOfRecordsToStore];
    
    //reset no gesture timer
    NSTimer *timer = [self getTimerBasedOnGestureType:gestureType];
    [timer invalidate];
    NSTimeInterval interval = (float)self.samplesPerSecond * (float)kMaxTimeBetweenConsecutiveGesturesMutiplier;
    timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                             target:self selector:@selector(noGesturesCameAfterAWhile:)
                                           userInfo:gesture
                                            repeats:NO];
    [self assignTimer:timer toGestureType:gestureType];
}

-(GestureType)checkIfRegisteredGesturesAndUpdateProgress
{
    GestureType gestureToReturn = GestureTypeNoGesture;
    
    if ([self updateProgressAndCheckIfRegisteredGesture:GestureTypeSmile neededTimeForGesture:kTimeNeedsToSmile])
        gestureToReturn = GestureTypeSmile;
    
    if ([self updateProgressAndCheckIfRegisteredGesture:GestureTypeLeftBlink neededTimeForGesture:kTimeNeedsToWink])
        gestureToReturn = GestureTypeLeftBlink;
    
    if ([self updateProgressAndCheckIfRegisteredGesture:GestureTypeRightBlink neededTimeForGesture:kTimeNeedsToWink])
        gestureToReturn = GestureTypeRightBlink;
    
    return gestureToReturn;
}

#pragma mark - Inits

-(id)init
{
	self = [super init];
	if (!self) return nil;

	self.smilesArray = [[NSMutableArray alloc] initWithCapacity:kNumberOfRecordsToStore];
    self.leftBlinksArray = [[NSMutableArray alloc] initWithCapacity:kNumberOfRecordsToStore];
    self.rightBlinksArray = [[NSMutableArray alloc] initWithCapacity:kNumberOfRecordsToStore];
    
	return self;
}

#pragma mark - Timer CallsBacks

-(void)noGesturesCameAfterAWhile:(NSTimer *)timer
{
    DSFacialGesture *gesture = (DSFacialGesture *)timer.userInfo;
	[[self getArrayBasedOnGestureType:gesture.type] removeAllObjects];
	[self updateProgress:0 forGestureType:gesture.type];
}

#pragma mark - Private

-(BOOL)updateProgressAndCheckIfRegisteredGesture:(GestureType)type neededTimeForGesture:(NSTimeInterval)neededTimeForGesture
{
    NSArray *gestures = [self getArrayBasedOnGestureType:type];
    
    if (!gestures || gestures.count == 0)
        return NO;
    
	double lastTimestamp = 0;
	double timeRangeCounter = 0;
	for (DSFacialGesture *gesture in gestures)
	{
		if (lastTimestamp == 0)//first round
		{
			lastTimestamp = gesture.timestamp;
			continue;
		}
		double timeSinceLastGesture = gesture.timestamp - lastTimestamp;
		if (timeSinceLastGesture > (float)((float)self.samplesPerSecond * (float)4.0f))
			return NO;
		timeRangeCounter += timeSinceLastGesture;
		lastTimestamp = gesture.timestamp;
	}

    float progress = timeRangeCounter / neededTimeForGesture;
	[self updateProgress:progress forGestureType:type];
	return neededTimeForGesture < timeRangeCounter; //we have been gesturing for at least timeRange
}

-(void)updateProgress:(float)progress forGestureType:(GestureType)gestureType
{
	DSFacialGesture *facialGesutre = [DSFacialGesture facialGestureOfType:gestureType withTimeStamp:0];
	facialGesutre.precentForFullGesture = progress;
    [self.delegate didUpdateProgress:facialGesutre];
}

-(NSMutableArray *)getArrayBasedOnGestureType:(GestureType)gestureType
{
    NSMutableArray *array;
    if (gestureType == GestureTypeSmile)
    {
        array = self.smilesArray;
    }
    else if (gestureType == GestureTypeLeftBlink)
    {
        array = self.leftBlinksArray;
    }
    else if (gestureType == GestureTypeRightBlink)
    {
        array = self.rightBlinksArray;
    }
    return array;
}

-(NSTimer *)getTimerBasedOnGestureType:(GestureType)gestureType
{
    NSTimer *timer;
    if (gestureType == GestureTypeSmile)
    {
        timer = self.simileGesturesCounterInvalidatorTimer;
    }
    else if (gestureType == GestureTypeLeftBlink)
    {
        timer = self.leftBlinkGesturesCounterInvalidatorTimer;
    }
    else if (gestureType == GestureTypeRightBlink)
    {
        timer = self.rightBlinkGesturesCounterInvalidatorTimer;
    }
    return timer;
}

-(void)assignTimer:(NSTimer *)timer toGestureType:(GestureType)gestureType
{
    if (gestureType == GestureTypeSmile)
    {
        self.simileGesturesCounterInvalidatorTimer = timer;
    }
    else if (gestureType == GestureTypeLeftBlink)
    {
        self.leftBlinkGesturesCounterInvalidatorTimer = timer;
    }
    else if (gestureType == GestureTypeRightBlink)
    {
        self.rightBlinkGesturesCounterInvalidatorTimer = timer;;
    }
}

-(void)addObjectToArray:(NSMutableArray *)array object:(id)object withMaxRecordsToStore:(NSInteger)maxRecordsToStore
{
    if (array.count + 1 == maxRecordsToStore)
    {
        [array removeObjectAtIndex:0];
    }
    [array addObject:object];
}

@end
