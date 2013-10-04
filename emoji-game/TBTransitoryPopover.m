//
//  TBTransitoryPopover.m
//  
//
//  Created by Tyler Barth on 2013-02-25.
//
// For accessibility this should probably trigger a voice-over reading of the text.

#import "TBTransitoryPopover.h"
#import <QuartzCore/QuartzCore.h>

@interface TBTransitoryPopover ()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UILabel *popupView;

@property (nonatomic, strong) NSString* message;

@end

@implementation TBTransitoryPopover

- (void) displayWithMessage:(NSString*) displayMessage
{
    self.message = displayMessage;
    [self show];
}

- (void) show {

    //This code is kind of bad, but it does the job.
    //Is this kind of placement code ever nice looking?
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.windowLevel = UIWindowLevelAlert;
    self.window.backgroundColor = [UIColor clearColor];
    
    self.center = CGPointMake(CGRectGetMidX(self.window.bounds), CGRectGetMidY(self.window.bounds));
    self.frame = [[UIScreen mainScreen] bounds] ;
    
    [self.window addSubview:self];
    
    self.popupView = [[UILabel alloc] init];
    [self.popupView setText:self.message];
    
    CGSize size = [self calculateSize:self.message];
    [self addSubview:[self popupView]];
    
    self.popupView.frame = CGRectMake(0,0, size.width, size.height);
    self.popupView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    self.popupView.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.85f];
    self.popupView.textColor = [UIColor whiteColor];
    self.popupView.textAlignment = NSTextAlignmentCenter;
    self.popupView.numberOfLines = 0;
    
    self.popupView.layer.cornerRadius = 8;
    
    [self.window makeKeyAndVisible];
    
    //Animation
    self.window.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.window.alpha = 0.0f;
    
    __block UIWindow *animationWindow = self.window;
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveEaseIn animations:^() {
        animationWindow.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        animationWindow.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self hide];
    }];
    
}

#define LABEL_WIDTH 230.
#define PADDING 20.;
- (CGSize) calculateSize: (NSString*) string
{
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:14]];
    
    CGFloat horizontal = 0.;
    CGFloat vertical = 0;
    if (size.width > LABEL_WIDTH) {
        NSUInteger columns = ceil(size.width / LABEL_WIDTH);
        horizontal = LABEL_WIDTH + 2 * PADDING;
        vertical = size.height * columns + 2*PADDING;
    }
    else {
        horizontal = size.width + 2*PADDING;
        vertical = size.height + 2*PADDING;
    }

    return CGSizeMake(horizontal, vertical);
}

#define DELAY 2.
- (void) hide {
    __block UIWindow *animationWindow = self.window;
    
    [UIView animateWithDuration:0.3f delay:DELAY options:UIViewAnimationCurveEaseOut animations:^() {
        animationWindow.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        animationWindow.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.window.hidden = YES;
        self.window = nil;
    }];
}


@end
