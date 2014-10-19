//
//  UIDevice+ExifOrientation.h
//  FacialGestures
//
//  Created by Danny Shmueli on 6/28/13.
//  Copyright (c) 2013 Danny Shmueli. All rights reserved.
//

/* kCGImagePropertyOrientation values
 The intended display orientation of the image. If present, this key is a CFNumber value with the same value as defined
 by the TIFF and EXIF specifications -- see enumeration of integer constants.
 The value specified where the origin (0,0) of the image is located. If not present, a value of 1 is assumed.

 used when calling featuresInImage: options: The value for this key is an integer number from 1..8 as found in kCGImagePropertyOrientation.
 If present, the detection will be done based on that orientation but the coordinates in the returned features will still be based on those of the image. */


#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger , ExifForOrientationType) {
	ExifForOrientationTypePHOTOS_EXIF_0ROW_TOP_0COL_LEFT			= 1, //   1  =  0th row is at the top, and 0th column is on the left (THE DEFAULT).
	ExifForOrientationTypePHOTOS_EXIF_0ROW_TOP_0COL_RIGHT			= 2, //   2  =  0th row is at the top, and 0th column is on the right.
	ExifForOrientationTypePHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3, //   3  =  0th row is at the bottom, and 0th column is on the right.
	ExifForOrientationTypePHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4, //   4  =  0th row is at the bottom, and 0th column is on the left.
	ExifForOrientationTypePHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5, //   5  =  0th row is on the left, and 0th column is the top.
	ExifForOrientationTypePHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6, //   6  =  0th row is on the right, and 0th column is the top.
	ExifForOrientationTypePHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7, //   7  =  0th row is on the right, and 0th column is the bottom.
	ExifForOrientationTypePHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8  //   8  =  0th row is on the left, and 0th column is the bottom.
};

@interface UIDevice (ExifOrientation)

-(ExifForOrientationType)exifForCurrentOrientationWithFrontCamera:(BOOL)isUsingFrontCamera;

@end
