//
//  ViewController.h
//  DeathClock
//
//  Created by Kontagent on 12-07-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *countdownLabel;
@property (nonatomic, retain) IBOutlet UIProgressView *completionBar;

- (IBAction)screenDoubleTapped:(id)sender;

@end
