//
//  ViewController.h
//  DeathClock
//
//  Created by Kontagent on 12-07-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, retain) NSDate *dobDate;
@property (nonatomic, retain) NSDate *deathDate;

@property (nonatomic, retain) IBOutlet UILabel *countdownLabel;
@property (nonatomic, retain) IBOutlet UIProgressView *completionBar;


- (void)onTick;

@end
