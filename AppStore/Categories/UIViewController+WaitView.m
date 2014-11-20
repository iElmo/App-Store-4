//
//  UIViewController+WaitView.m
//  AppStore
//
//  Created by Dan Mac Hale on 12/11/2014.
//  Copyright (c) 2014 iElmo. All rights reserved.
//

#import "UIViewController+WaitView.h"
@interface UIViewController ()
@end

@implementation UIViewController (WaitView)

-(void)createView {
    UIView *container = [[UIView alloc] initWithFrame:self.view.bounds ];
    container.tag = 999;
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
    loadingLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    loadingLabel.text = @"Loading....";
    [container addSubview:loadingLabel];
    [container setBackgroundColor:[UIColor whiteColor]];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [spinner setHidesWhenStopped:YES];
    
    loadingLabel.center = container.center;
    
    spinner.frame = CGRectMake(loadingLabel.frame.origin.x - spinner.frame.size.width , loadingLabel.frame.origin.y, spinner.frame.size.width, spinner.frame.size.height);
    [spinner startAnimating];
    [container addSubview:spinner];
    [container addSubview:loadingLabel];
    [container setAlpha:0.3];
    [UIView animateWithDuration:0.5 animations:^{
        [container setAlpha:1.0];
        [self.view addSubview:container];
    }];
}

-(void)showWaitView {
    [self createView];
}

-(void)hideWaitView {
    for (UIView *containerView in self.view.subviews) {
        if ([containerView isKindOfClass:[UIView class]]) {
            if (containerView.tag == 999) {
                [UIView animateWithDuration:0.3 animations:^{
                    [containerView setAlpha:0.1];
                } completion:^(BOOL finished) {
                    [containerView removeFromSuperview];
                }];
            }
        }
    }
}

@end
