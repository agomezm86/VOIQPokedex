//
//  ActivityIndicatorView.m
//  VOIQPokedex
//
//  Created by Field Service on 5/22/16.
//  Copyright © 2016 Alejandro Gomez Mutis. All rights reserved.
//

#import "ActivityIndicatorView.h"

@implementation ActivityIndicatorView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createActivityIndicatorView];
    }
    return self;
}

- (void)createActivityIndicatorView {
    UIView *loadingView = [[UIView alloc] initWithFrame:self.bounds];
    loadingView.tag = 1;
    loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    loadingView.clipsToBounds = YES;
    loadingView.layer.cornerRadius = 20;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.bounds.size.width / 2) - 30, 20, 60, 60)];
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [loadingView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.bounds.size.width, 50)];
    loadingLabel.numberOfLines = 0;
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.adjustsFontSizeToFitWidth = YES;
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = NSLocalizedString(@"LOADING_MESSAGE", nil);
    [loadingView addSubview:loadingLabel];
    
    [self addSubview:loadingView];
}

@end
