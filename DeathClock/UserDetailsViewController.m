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

- (void)viewDidAppear:(BOOL)animated
{
    // set the contentSize for the scrollview. For some reason this
    // can't be done in the interface builder.
    [self.scrollView setContentSize:CGSizeMake(320, 780)];
    
    // load the defaults (if set)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"dobDate"]) {
        [self.dobPicker setDate:[defaults objectForKey:@"dobDate"]];
        
        // Note: the enums map perfectly into the SegmentIndex
        [self.genderSegControl setSelectedSegmentIndex:[defaults integerForKey:@"gender"]];
        [self.alcoholSegControl setSelectedSegmentIndex:[defaults integerForKey:@"alcohol"]];
        [self.smokerSegControl setSelectedSegmentIndex:[defaults integerForKey:@"smoker"]];
        [self.overweightSegControl setSelectedSegmentIndex:[defaults integerForKey:@"overweight"]];
        [self.displayFormatSegControl setSelectedSegmentIndex:[defaults integerForKey:@"displayFormat"]];
    }
}

- (IBAction)saveButtonClicked:(id)sender
{
    [self persistSettings];
    
    [self showAlertWithMessage:@"Save successful. You can double-tap the screen to return to configuration settings."];
    
    [self dismissModalViewControllerAnimated:true];
}

- (void)persistSettings
{
    NSDate *dobDate = [self.dobPicker date];
    
    // Note: SegmentIndex maps to Enum values :)
    Gender gender = [self.genderSegControl selectedSegmentIndex];
    Alcohol alcohol = [self.alcoholSegControl selectedSegmentIndex];
    Smoker smoker = [self.smokerSegControl selectedSegmentIndex];
    Overweight overweight = [self.overweightSegControl selectedSegmentIndex];
    DisplayFormat displayFormat = [self.displayFormatSegControl selectedSegmentIndex];
    
    NSDate *deathDate = [self getDeathDateFromDobDate:dobDate
                                               Gender:gender
                                              Alcohol:alcohol
                                               Smoker:smoker
                                           Overweight:overweight];
    
    // Persist everything to NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // persist dob date
    [defaults setObject:dobDate forKey:@"dobDate"];
    [defaults setInteger:gender forKey:@"gender"];
    [defaults setInteger:alcohol forKey:@"alcohol"];
    [defaults setInteger:smoker forKey:@"smoker"];
    [defaults setInteger:overweight forKey:@"overweight"];
    [defaults setInteger:displayFormat forKey:@"displayFormat"];
    [defaults setObject:deathDate forKey:@"deathDate"];
}

- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (NSDate *)getDeathDateFromDobDate:(NSDate *)dobDate
                             Gender:(Gender)gender
                            Alcohol:(Alcohol)alcohol
                             Smoker:(Smoker)smoker
                         Overweight:(Overweight)overweight
{
    // generate predicted age based on parameters
    NSInteger predictedAge;
    
    if (gender == GenderMale) {
        predictedAge = 75;
    } else if (gender == GenderFemale) {
        predictedAge = 80;
    }

    if (alcohol == AlcoholYes) {
        predictedAge -= 5;
    }
    
    if (smoker == SmokerYes) {
        predictedAge -= 5;
    }
        
    if (overweight == OverweightYes) {
        predictedAge -= 3;
    } else if (overweight == OverweightObese) {
        predictedAge -= 8;
    }

    // calaculate the death date from predictedAge
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:predictedAge];

    NSDate *deathDate = [gregorian dateByAddingComponents:dateComponents toDate:dobDate options:0];

    return deathDate;
}

@end
