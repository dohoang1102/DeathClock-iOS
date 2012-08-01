//
//  UserDetailsViewController.m
//  DeathClock
//
//  Created by Kontagent on 12-07-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserDetailsViewController.h"

@interface UserDetailsViewController ()

@end

@implementation UserDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)saveButtonClicked:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSDate *dobDate = [self.dobPicker date];
    
    // persist dob date
    [defaults setObject:dobDate forKey:@"dobDate"];
    
    // persist death date
    [defaults setObject:[self getDeathDateFromDobDate:dobDate] forKey:@"deathDate"];
    
    // persist the format
    switch([self.formatSegControl selectedSegmentIndex]) {
        case(0):
            [defaults setInteger:DisplayFormatFull forKey:@"displayFormat"];
            break;
        case(1):
            [defaults setInteger:DisplayFormatSeconds forKey:@"displayFormat"];
            break;
        case(2):
            [defaults setInteger:DisplayFormatPercent forKey:@"displayFormat"];
            break;
        default:
            // TODO: throw an exception here
            break;
    }
    
    [self dismissModalViewControllerAnimated:true];
}

- (NSDate *)getDeathDateFromDobDate:(NSDate *)dobDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:80];

    NSDate *deathDate = [gregorian dateByAddingComponents:dateComponents toDate:dobDate options:0];

    return deathDate;
}

@end
