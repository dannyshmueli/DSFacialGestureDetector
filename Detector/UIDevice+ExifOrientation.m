//
//  UIDevice+ExifOrientation.m
//  FacialGestures
//
//  Created by Danny Shmueli on 6/28/13.
//  Copyright (c) 2013 Danny Shmueli. All rights reserved.
//

#import "UIDevice+ExifOrientation.h"

@implementation UIDevice (ExifOrientation)

-(ExifForOrientationType)exifForCurrentOrientationWithFrontCamera:(BOOL)isUsingFrontCamera
{
	ExifForOrientationType exifOrientation;

	switch (self.orientation) {
		case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
			exifOrientation = ExifForOrientationTypePHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM;
			break;
		case UIDeviceOrientationLandscapeLeft:       // Device oriented horizontally, home button on the right
			if (isUsingFrontCamera)
				exifOrientation = ExifForOrientationTypePHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
			else
				exifOrientation = ExifForOrientationTypePHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
			break;
		case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
			if (isUsingFrontCamera)
				exifOrientation = ExifForOrientationTypePHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
			else
				exifOrientation = ExifForOrientationTypePHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
			break;
		case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
		default:
			exifOrientation = ExifForOrientationTypePHOTOS_EXIF_0ROW_RIGHT_0COL_TOP;
			break;
	}
    return exifOrientation;
}
@end
