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

@synthesize countdownLabel, completionBar, deathDate, dobDate;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults objectForKey:@"deathDate"]) {
        // not initialized, show them the setup screen
        NSLog(@"No deathTimestamp detected, showing setup screen.");

        UserDetailsViewController *userDetailsViewController = [[UserDetailsViewController alloc] initWithNibName:@"UserDetailsViewController_iPhone" bundle:nil];
        [self presentModalViewController:userDetailsViewController animated:true];
    } else {
        [self setDeathDate:[defaults objectForKey:@"deathDate"]];
        [self setDobDate:[defaults objectForKey:@"dobDate"]];
        
        // show them the countdown screen
        NSLog(@"deathTimeStamp with value: %@ found. Showing countdown screen.", [self deathDate]);
        
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onTick) userInfo:nil repeats:YES];
    }
}

- (void)onTick
{   
    // Note: all intervals are in seconds
    
    // the interval of your total life (from birth to death)
    long long dobToDeathInterval = round([[self deathDate] timeIntervalSinceDate:[self dobDate]]);
    
    // interval representing your total life left (now til death)
    long nowToDeathInterval = round([[self deathDate] timeIntervalSinceNow]);
    
    // interval representing the amount you've lived so far (birth til now)
    long dobToNowInterval = dobToDeathInterval - nowToDeathInterval;
    
    // compute the percentage of life completion
    float lifeCompletionPercentage = (float)dobToNowInterval/(float)dobToDeathInterval;
    
    // Compute the countdown timer values
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
    
    NSString *displayString = [NSString stringWithFormat:@"%d years, %d months, %d days, %d hours, %d minutes, and %d seconds left.",
                               years, months, days, hours, minutes, seconds];
    
    [self.countdownLabel setText:displayString];

    // update UI elements
    [self.completionBar setProgress:lifeCompletionPercentage animated:YES];
}

@end
