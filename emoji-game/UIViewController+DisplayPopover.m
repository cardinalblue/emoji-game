//
//  UIViewController+DisplayPopover.m
//  chAse
//
//  Created by Tyler Barth on 2013-02-25.
//  Copyright (c) 2013年 Kenzou. All rights reserved.
//

#import "UIViewController+DisplayPopover.h"
#import "TBTransitoryPopover.h"
@implementation UIViewController (DisplayPopover)


- (void) displayPopoverWithMessage: (NSString*) message
{
    [[[TBTransitoryPopover alloc] init] displayWithMessage:message];
}

@end
