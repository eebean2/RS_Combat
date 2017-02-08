//
//  SecondViewController.m
//  RS Combat
//
//  Created by Erik Bean on 7/16/14.
//  Copyright (c) 2015 Erik Bean. All rights reserved.
//

#import "SecondViewController.h"
#import "OSViewController.h"

@interface SecondViewController () {
    IBOutlet ADBannerView *adBanner;
    IBOutlet UITextField *attackText;
    IBOutlet UITextField *strengthText;
    IBOutlet UITextField *defenceText;
    IBOutlet UITextField *magicText;
    IBOutlet UITextField *rangeText;
    IBOutlet UITextField *prayerText;
    IBOutlet UITextField *hpText;
    IBOutlet UIScrollView *theScroll;
    IBOutlet UIButton *calculate;
    
    UITextField *activeField;
    NSInteger intAttack;
    NSInteger intStrength;
    NSInteger intDefence;
    NSInteger intMagic;
    NSInteger intRange;
    NSInteger intPrayer;
    NSInteger intHP;
    BOOL bannerIsVisable;
}

@end

@implementation SecondViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    
    calculate.layer.cornerRadius = 5;
    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"osBackground.png"]];
    
    
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Done"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(doneClicked:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    attackText.inputAccessoryView = keyboardDoneButtonView;
    strengthText.inputAccessoryView = keyboardDoneButtonView;
    defenceText.inputAccessoryView = keyboardDoneButtonView;
    magicText.inputAccessoryView = keyboardDoneButtonView;
    rangeText.inputAccessoryView = keyboardDoneButtonView;
    prayerText.inputAccessoryView = keyboardDoneButtonView;
    hpText.inputAccessoryView = keyboardDoneButtonView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [theScroll addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    adBanner.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self deregisterFromKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!bannerIsVisable) {
        adBanner.hidden = NO;
        bannerIsVisable = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (error) {
        adBanner.hidden = YES;
        bannerIsVisable = NO;
        NSLog(@"AdBanner Error: %ld", (long)[error code]);
        /*
         AdBanner Error: 3 - Ad inventory unavailable
         AdBanner Error: 7 - Ad was unloaded from banner
         */
    }
}

- (void)registerForKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)deregisterFromKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

- (void)keyboardWasShown:(NSNotification *)notification {
    if ([attackText isFirstResponder]) {
        activeField = attackText;
    } else if ([strengthText isFirstResponder]) {
        activeField = strengthText;
    } else if ([defenceText isFirstResponder]) {
        activeField = defenceText;
    } else if ([magicText isFirstResponder]) {
        activeField = magicText;
    } else if ([rangeText isFirstResponder]) {
        activeField = rangeText;
    } else if ([prayerText isFirstResponder]) {
        activeField = prayerText;
    } else if ([hpText isFirstResponder]) {
        activeField = hpText;
    }
    
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGPoint buttonOrigin = activeField.frame.origin;
    CGFloat buttonHeight = activeField.frame.size.height;
    CGRect  visibleRect = self.view.frame;
    visibleRect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(visibleRect, buttonOrigin)) {
        CGPoint scrollPoint = CGPointMake(0, buttonOrigin.y - visibleRect.size.height + buttonHeight);
        [theScroll setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notificaion {
    [theScroll setContentOffset:CGPointZero animated:YES];
}

- (void)dismissKeyboard {
    [attackText resignFirstResponder];
    [strengthText resignFirstResponder];
    [defenceText resignFirstResponder];
    [magicText resignFirstResponder];
    [rangeText resignFirstResponder];
    [prayerText resignFirstResponder];
    [hpText resignFirstResponder];
}

- (IBAction)doneClicked:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)work:(id)sender {
    intAttack = [attackText.text integerValue];
    intStrength = [strengthText.text integerValue];
    intDefence = [defenceText.text integerValue];
    intMagic = [magicText.text integerValue];
    intRange = [rangeText.text integerValue];
    intPrayer = [prayerText.text integerValue];
    intHP = [hpText.text integerValue];
    [self performSegueWithIdentifier:@"osPush" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"osPush"]) {
        OSViewController *controller = (OSViewController *)segue.destinationViewController;
        
        controller.attackNumber = &(intAttack);
        controller.strengthNumber = &(intStrength);
        controller.defenceNumber = &(intDefence);
        controller.magicNumber = &(intMagic);
        controller.rangeNumber = &(intRange);
        controller.prayerNumber = &(intPrayer);
        controller.hpNumber = &(intHP);
    }
}

@end
