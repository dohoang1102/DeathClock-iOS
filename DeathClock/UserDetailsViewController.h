//
//  UserDetailsViewController.h
//  DeathClock
//
//  Created by Kontagent on 12-07-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface UserDetailsViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIDatePicker *dobPicker;
@property (nonatomic, retain) IBOutlet UISegmentedControl *genderSegControl;
@property (nonatomic, retain) IBOutlet UISegmentedControl *alcoholSegControl;
@property (nonatomic, retain) IBOutlet UISegmentedControl *smokerSegControl;
@property (nonatomic, retain) IBOutlet UISegmentedControl *overweightSegControl;
@property (nonatomic, retain) IBOutlet UISegmentedControl *displayFormatSegControl;

- (IBAction)saveButtonClicked:(id)sender;

@end
