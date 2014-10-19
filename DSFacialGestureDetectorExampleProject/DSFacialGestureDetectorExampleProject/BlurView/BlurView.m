//
//  BlurView.m
//  DSFacialGestureDetectorExampleProject
//
//  Created by Danny Shmueli on 10/18/14.
//  Copyright (c) 2014 DS. All rights reserved.
//

#import "BlurView.h"

@implementation BlurView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)  return nil;
    [self internalInit];
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self)  return nil;
    [self internalInit];
    return self;
}

-(void)internalInit
{
    self.backgroundColor = [UIColor clearColor];
    
    if ([self isIOS8AndAbove])
    {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
        blurView.frame = self.bounds;
        [self insertSubview:blurView atIndex:0];
    }
    else
    {
        UIToolbar *toolbar =  [[UIToolbar alloc] initWithFrame:self.bounds];
        [self insertSubview:toolbar atIndex:0];
    }
}

-(BOOL)isIOS8AndAbove
{
    if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending)) {
        return NO;
    }
    else {
        return YES;
    }
}

@end
