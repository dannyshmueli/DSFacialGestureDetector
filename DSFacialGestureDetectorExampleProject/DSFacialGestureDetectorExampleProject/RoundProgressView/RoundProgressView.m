//
//  RoundProgressView.m
//  RoundProgressView
//
//  Created by Danny Shmueli on 7/9/13.
//  Copyright (c) 2013 Danny Shmueli. All rights reserved.
//

#import "RoundProgressView.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface RoundProgressView ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation RoundProgressView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self internalInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self internalInit];
    }
    return self;
}

-(void)internalInit
{
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 46, 30)];
    self.label.center = self.center;
    self.label.textColor = [UIColor blueColor];
    self.label.lineBreakMode = NSLineBreakByClipping;
}

-(void)setProgress:(float)progress
{
	_progress = progress;
    self.label.text = [@"%" stringByAppendingString:[NSString stringWithFormat:@"%i", (int)(progress * 100)]];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	CGRect smallerRect = CGRectInset(rect, rect.size.width *.2 , rect.size.height *.2);
	[self drawFullCircleInRect:smallerRect];
    [self drawArcInRect:smallerRect forProgress:self.progress];
}

-(void)drawFullCircleInRect:(CGRect)rect
{
	UIColor *strokeColor = [UIColor grayColor];
	UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:rect];
	ovalPath.lineWidth = 15;
	[strokeColor setStroke];
	[ovalPath stroke];
}


-(void)drawArcInRect:(CGRect)rect forProgress:(float)progress
{
	UIColor *strokeColor = [UIColor blueColor];
	CGRect ovalRect = rect;
	UIBezierPath *ovalPath = [UIBezierPath bezierPath];
	[ovalPath addArcWithCenter:CGPointMake(0, 0)
						radius:CGRectGetWidth(ovalRect) / 2
					startAngle: DEGREES_TO_RADIANS(-90)
					  endAngle: DEGREES_TO_RADIANS((progress * 360)- 90) clockwise:YES];
	CGAffineTransform ovalTransform = CGAffineTransformMakeTranslation(CGRectGetMidX(ovalRect),
																	   CGRectGetMidY(ovalRect));
	ovalTransform = CGAffineTransformScale(ovalTransform, 1, CGRectGetHeight(ovalRect) / CGRectGetWidth(ovalRect));
	[ovalPath applyTransform:ovalTransform];

	[strokeColor setStroke];
	ovalPath.lineWidth = 8;
	[ovalPath stroke];
}

@end