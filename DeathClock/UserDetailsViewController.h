//
//  UserDetailsViewController.h
//  DeathClock
//
//  Created by Kontagent on 12-07-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailsViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIDatePicker *dobPicker;

- (IBAction)saveButtonClicked:(id)sender;

@end
