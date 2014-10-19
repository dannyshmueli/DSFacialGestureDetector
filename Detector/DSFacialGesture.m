//
//  FacialGesture.m
//  FacialGestures
//
//  Created by Danny Shmueli on 6/28/13.
//  Copyright (c) 2013 Danny Shmueli. All rights reserved.
//

#import "DSFacialGesture.h"

@implementation DSFacialGesture

+(DSFacialGesture *)facialGestureOfType:(GestureType)type withTimeStamp:(double)timestamp
{
	DSFacialGesture *newGesture = [DSFacialGesture new];

	newGesture.type = type;
	newGesture.timestamp = timestamp;

	return newGesture;
}

+(NSString *)gestureTypeToString:(GestureType)type
{
    NSString *typString;
    switch (type) {
        case GestureTypeSmile:
            typString = @"Smiling";
            break;
        case GestureTypeLeftBlink:
            typString = @"Left Blink";
            break;
        case GestureTypeRightBlink:
            typString = @"Rigt Blink";
            break;
        case GestureTypeNoGesture:
            typString = @"No Gesture";
        default:
            typString = @"No Gesture - Default";
            break;
    }
    return typString;
}

@end
