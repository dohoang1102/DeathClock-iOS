//
//  ViewController.m
//  DeathClock
//
//  Created by Kontagent on 12-07-19.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "UserDetailsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(onTick)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"deathDate"]) {
        // not initialized, show them the setup screen
        [self showUserDetailsView];
    }
}

- (void)onTick
{
    // TODO: get displayStringFormat from NSUserDefaults
    NSDictionary *dictionary = [self getDisplayDataWithFormat:[[NSUserDefaults standardUserDefaults] integerForKey:@"displayFormat"]];
                                
    NSString *displayString = [dictionary objectForKey:@"displayString"];
    NSNumber *lifeCompletionPercentage = [dictionary objectForKey:@"lifeCompletionPercentage"];
    
    [self.countdownLabel setText:displayString];

    // update UI elements
    [self.completionBar setProgress:(1.0-[lifeCompletionPercentage floatValue]) animated:YES];
}

- (void)screenDoubleTapped:(id)sender
{
    [self showUserDetailsView];
}

- (void)showUserDetailsView
{
    UserDetailsViewController *userDetailsViewController = [[UserDetailsViewController alloc] initWithNibName:@"UserDetailsViewController_iPhone" bundle:nil];
    
    [self presentModalViewController:userDetailsViewController animated:true];
}

// This function returns a dictionary with 2 keys @"displayString" and @"lifeCompletionPercentage"
- (NSDictionary *)getDisplayDataWithFormat:(DisplayFormat)displayFormat
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSDate *deathDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"deathDate"];
    NSDate *dobDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"dobDate"];
    
    // Note: all intervals are in seconds
    
    // the interval of your total life (from birth to death)
    long long dobToDeathInterval = round([deathDate timeIntervalSinceDate:dobDate]);
    
    // interval representing your total life left (now til death)
    long nowToDeathInterval = round([deathDate timeIntervalSinceNow]);
    
    // interval representing the amount you've lived so far (birth til now)
    long dobToNowInterval = dobToDeathInterval - nowToDeathInterval;
    
    // compute the percentage of life completion
    // TODO: look into whether we should change this to lifeLeftPercentage
    float lifeCompletionPercentage = (float)dobToNowInterval/(float)dobToDeathInterval;
    
    NSString *displayString;
    
    switch(displayFormat) {
        case(DisplayFormatFull):
        {
            int years, months, days, hours, minutes, seconds;
            
            years = floor(nowToDeathInterval/(60*60*24*30*12));
            
            nowToDeathInterval %= 60*60*24*30*12;
            months = floor(nowToDeathInterval/(60*60*24*30));
            
            nowToDeathInterval %= 60*60*24*30;
            days = floor(nowToDeathInterval/(60*60*24));
            
            nowToDeathInterval %= 60*60*24;
            hours = floor(nowToDeathInterval/(60*60));
            
            nowToDeathInterval %= 60*60;
            minutes = floor(nowToDeathInterval/60);
            
            nowToDeathInterval %= 60;
            seconds = nowToDeathInterval;
            
            displayString = [NSString stringWithFormat:@"%d years, %d months, %d days, %d hours, %d minutes, and %d seconds left.",
                                       years, months, days, hours, minutes, seconds];
            break;
        }
        case(DisplayFormatSeconds):
        {
            displayString = [NSString stringWithFormat:@"%ld seconds left.", nowToDeathInterval];
            break;
        }
        case(DisplayFormatPercent):
        {
            displayString = [NSString stringWithFormat:@"%.02f/100%% health.", (100-lifeCompletionPercentage*100)];
            break;
        }
    }
    
    [dictionary setObject:displayString forKey:@"displayString"];
    [dictionary setObject:[NSNumber numberWithFloat:lifeCompletionPercentage] forKey:@"lifeCompletionPercentage"];
    
    return dictionary;
}

@end
