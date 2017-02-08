//
//  iPadRs3ViewController.m
//  RS Combat
//
//  Created by Erik Bean on 8/12/14.
//  Copyright (c) 2015 Erik Bean. All rights reserved.
//

#import "iPadRs3ViewController.h"

@interface iPadRs3ViewController () {
    
    IBOutlet UITextField *attackText;
    IBOutlet UITextField *strengthText;
    IBOutlet UITextField *defenceText;
    IBOutlet UITextField *magicText;
    IBOutlet UITextField *rangeText;
    IBOutlet UITextField *prayerText;
    IBOutlet UITextField *constitutionText;
    IBOutlet UITextField *summoningText;
    
    IBOutlet UILabel *attackLabel;
    IBOutlet UILabel *strengthLabel;
    IBOutlet UILabel *defenceLabel;
    IBOutlet UILabel *magicLabel;
    IBOutlet UILabel *rangeLabel;
    IBOutlet UILabel *prayerLabel;
    IBOutlet UILabel *summoningLabel;
    IBOutlet UILabel *constitutionLabel;
    
    IBOutlet UILabel *attackWord;
    IBOutlet UILabel *strengthWord;
    IBOutlet UILabel *defenceWord;
    IBOutlet UILabel *magicWord;
    IBOutlet UILabel *rangeWord;
    IBOutlet UILabel *prayerWord;
    IBOutlet UILabel *summoningWord;
    IBOutlet UILabel *constitutionWord;
    
    IBOutlet UILabel *maxOne;
    IBOutlet UILabel *maxTwo;
    IBOutlet UILabel *titleWord;
    IBOutlet UILabel *nextWord;
    IBOutlet UILabel *combatLevel;
    IBOutlet UILabel *nextLevel;
    IBOutlet UILabel *combatType;
    IBOutlet UIScrollView *theScroll;
    IBOutlet UIButton *calculate;
    IBOutlet ADBannerView *adBanner;
    
    UITextField *activeField;
    NSInteger attack;
    NSInteger strength;
    NSInteger defence;
    NSInteger magic;
    NSInteger range;
    NSInteger prayer;
    NSInteger constitution;
    NSInteger summoning;
    NSInteger lvl;
    NSString *fightTitle;
    BOOL bannerIsVisable;
}

@end

@implementation iPadRs3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
         AdBanner Error: 1 - Service session terminated
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
    } else if ([constitutionText isFirstResponder]) {
        activeField = constitutionText;
    } else if ([summoningText isFirstResponder]) {
        activeField = summoningText;
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
    [constitutionText resignFirstResponder];
    [summoningText resignFirstResponder];
}

- (IBAction)work:(id)sender {
    attack = [attackText.text integerValue];
    strength = [strengthText.text integerValue];
    defence = [defenceText.text integerValue];
    magic = [magicText.text integerValue];
    range = [rangeText.text integerValue];
    prayer = [prayerText.text integerValue];
    constitution = [constitutionText.text integerValue];
    summoning = [summoningText.text integerValue];
    
    NSString *empty = @" ";
    NSString *singleMax = @"99";
    
    if ((attack + strength) > (magic * 2) && (attack + strength) > (range * 2)) {
        NSInteger sum = attack + strength;
        NSInteger sum2 = defence + constitution;
        NSInteger sum3 = prayer/2;
        NSInteger sum4 = summoning/2;
        float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
        lvl = sum5/4;
        fightTitle = @"Melee";
    } else if ((magic * 2) > (strength + attack) && (magic * 2) > (range * 2)) {
        NSInteger sum = magic * 2;
        NSInteger sum2 = defence + constitution;
        NSInteger sum3 = prayer/2;
        NSInteger sum4 = summoning/2;
        float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
        lvl = sum5/4;
        fightTitle = @"Mage";
    } else if ((range * 2) > (strength + attack) && (range * 2) > (magic * 2)) {
        NSInteger sum = range * 2;
        NSInteger sum2 = defence + constitution;
        NSInteger sum3 = prayer/2;
        NSInteger sum4 = summoning/2;
        float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
        lvl = sum5/4;
        fightTitle = @"Range";
    } else {
        NSInteger sum = attack + strength;
        NSInteger sum2 = defence + constitution;
        NSInteger sum3 = prayer/2;
        NSInteger sum4 = summoning/2;
        float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
        lvl = sum5/4;
        fightTitle = @"Skiller";
    }
    if (attack == 99 && strength == 99 && defence == 99 && magic == 99 && range == 99 && prayer == 99 && summoning == 99 && constitution == 99) {
        
        combatLevel.text = @"138";
        maxOne.text = @"Oh No!";
        maxTwo.text = @"Your Already Max Combat Level!";
        titleWord.text = empty;
        attackWord.text = empty;
        strengthWord.text = empty;
        defenceWord.text = empty;
        magicWord.text = empty;
        rangeWord.text = empty;
        prayerWord.text = empty;
        summoningWord.text = empty;
        constitutionWord.text = empty;
        nextWord.text = empty;
        nextLevel.text = empty;
        attackLabel.text = empty;
        strengthLabel.text = empty;
        defenceLabel.text = empty;
        magicLabel.text = empty;
        rangeLabel.text = empty;
        prayerLabel.text = empty;
        summoningLabel.text = empty;
        constitutionLabel.text = empty;
        combatType.text = @"the strongest!";
    } else {
        maxOne.text = @" ";
        maxTwo.text = @" ";
        titleWord.text = @"You need one of the following to up your combat level:";
        nextWord.text = @"Your Next Level is:";
        attackWord.text = @"Attack Levels";
        strengthWord.text = @"Strength Levels";
        defenceWord.text = @"Defence Levels";
        magicWord.text = @"Magic Levels";
        rangeWord.text = @"Range Levels";
        summoningWord.text = @"Summoning Levels";
        constitutionWord.text = @"Constitution Levels";
        
        NSInteger next = lvl + 1;
        nextLevel.text = [NSString stringWithFormat:@"%ld", (long) next];
        combatLevel.text = [NSString stringWithFormat:@"%ld", (long) lvl];
        
        NSInteger temp = 0;
        NSInteger i = 1;
        NSInteger c = 0;
// Attack
        if (attack == 99) {
            attackLabel.text = singleMax;
        } else {
            i = 1;
            c = 0;
            temp = attack;
            while (i <= lvl) {
                temp += 1;
                NSInteger sum = temp + strength;
                NSInteger sum2 = defence + constitution;
                NSInteger sum3 = prayer/2;
                NSInteger sum4 = summoning/2;
                float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                i = sum5/4;
                c += 1;
                if (i > lvl) {
                    attackLabel.text = [NSString stringWithFormat:@"%ld", (long)c];
                    combatType.text = @"a warrior.";
                }
            }
        }
// Strength
        if (strength == 99) {
            strengthLabel.text = singleMax;
        } else {
            i = 1;
            c = 0;
            temp = strength;
            while (i <= lvl) {
                temp += 1;
                NSInteger sum = attack + temp;
                NSInteger sum2 = defence + constitution;
                NSInteger sum3 = prayer/2;
                NSInteger sum4 = summoning/2;
                float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                i = sum5/4;
                c += 1;
                if (i > lvl) {
                    strengthLabel.text = [NSString stringWithFormat:@"%ld", (long)c];
                    combatType.text = @"a warrior.";
                }
            }
        }
// Defence
        if (defence == 99) {
            defenceLabel.text = singleMax;
        } else {
            i = 1;
            c = 0;
            temp = defence;
            while (i <= lvl) {
                temp += 1;
                if ([fightTitle isEqualToString:@"Melee"] || [fightTitle isEqualToString:@"Skiller"]) {
                    NSInteger sum = attack + strength;
                    NSInteger sum2 = temp + constitution;
                    NSInteger sum3 = prayer/2;
                    NSInteger sum4 = summoning/2;
                    float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                    i = sum5/4;
                    c += 1;
                    combatType.text = @"a warrior.";
                } else if ([fightTitle isEqualToString:@"Mage"]) {
                    NSInteger sum = magic * 2;
                    NSInteger sum2 = temp + constitution;
                    NSInteger sum3 = prayer/2;
                    NSInteger sum4 = summoning/2;
                    float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                    i = sum5/4;
                    c += 1;
                    combatType.text = @"a mage.";
                } else if ([fightTitle isEqualToString:@"Range"]) {
                    NSInteger sum = range * 2;
                    NSInteger sum2 = temp + constitution;
                    NSInteger sum3 = prayer/2;
                    NSInteger sum4 = summoning/2;
                    float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                    i = sum5/4;
                    c += 1;
                    combatType.text = @"a ranger.";
                }
                if (i > lvl) {
                    defenceLabel.text = [NSString stringWithFormat:@"%ld", (long)c];
                }
            }
        }
// Magic
        if (magic == 99) {
            magicLabel.text = singleMax;
        } else {
            i = 1;
            c = 0;
            temp = magic;
            while (i <= lvl) {
                temp += 1;
                NSInteger sum = temp * 2;
                NSInteger sum2 = defence + constitution;
                NSInteger sum3 = prayer/2;
                NSInteger sum4 = summoning/2;
                float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                i = sum5/4;
                c += 1;
                if (i > lvl) {
                    magicLabel.text = [NSString stringWithFormat:@"%ld", (long)c];
                    combatType.text = @"a mage.";
                }
            }
        }
// Range
        if (range == 99) {
            rangeLabel.text = singleMax;
        } else {
            i = 1;
            c = 0;
            temp = range;
            while (i <= lvl) {
                temp += 1;
                NSInteger sum = temp * 2;
                NSInteger sum2 = defence + constitution;
                NSInteger sum3 = prayer/2;
                NSInteger sum4 = summoning/2;
                float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                i = sum5/4;
                c += 1;
                if (i > lvl) {
                    rangeLabel.text = [NSString stringWithFormat:@"%ld", (long)c];
                    combatType.text = @"a ranger.";
                }
            }
        }
// Prayer
        if (prayer == 99) {
            prayerLabel.text = singleMax;
        } else {
            i = 1;
            c = 0;
            temp = prayer;
            while (i <= lvl) {
                temp += 1;
                if ([fightTitle isEqualToString:@"Melee"] || [fightTitle isEqualToString:@"Skiller"]) {
                    NSInteger sum = attack + strength;
                    NSInteger sum2 = defence + constitution;
                    NSInteger sum3 = temp/2;
                    NSInteger sum4 = summoning/2;
                    float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                    i = sum5/4;
                    c += 1;
                    combatType.text = @"a warrior.";
                } else if ([fightTitle isEqualToString:@"Mage"]) {
                    NSInteger sum = magic * 2;
                    NSInteger sum2 = defence + constitution;
                    NSInteger sum3 = temp/2;
                    NSInteger sum4 = summoning/2;
                    float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                    i = sum5/4;
                    c += 1;
                    combatType.text = @"a mage.";
                } else if ([fightTitle isEqualToString:@"Range"]) {
                    NSInteger sum = range * 2;
                    NSInteger sum2 = defence + constitution;
                    NSInteger sum3 = temp/2;
                    NSInteger sum4 = summoning/2;
                    float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                    i = sum5/4;
                    c += 1;
                    combatType.text = @"a ranger.";
                }
                if (i > lvl) {
                    prayerLabel.text = [NSString stringWithFormat:@"%ld", (long)c];
                }
            }
        }
// Summoning
        if (summoning == 99) {
            summoningLabel.text = singleMax;
        } else {
            i = 1;
            c = 0;
            temp = summoning;
            while (i <= lvl) {
                temp += 1;
                if ([fightTitle isEqualToString:@"Melee"] || [fightTitle isEqualToString:@"Skiller"]) {
                    NSInteger sum = attack + strength;
                    NSInteger sum2 = defence + constitution;
                    NSInteger sum3 = prayer/2;
                    NSInteger sum4 = temp/2;
                    float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                    i = sum5/4;
                    c += 1;
                    combatType.text = @"a warrior.";
                } else if ([fightTitle isEqualToString:@"Mage"]) {
                    NSInteger sum = magic * 2;
                    NSInteger sum2 = defence + constitution;
                    NSInteger sum3 = prayer/2;
                    NSInteger sum4 = temp/2;
                    float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                    i = sum5/4;
                    c += 1;
                    combatType.text = @"a mage.";
                } else if ([fightTitle isEqualToString:@"Range"]) {
                    NSInteger sum = range * 2;
                    NSInteger sum2 = defence + constitution;
                    NSInteger sum3 = prayer/2;
                    NSInteger sum4 = temp/2;
                    float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                    i = sum5/4;
                    c += 1;
                    combatType.text = @"a ranger.";
                }
                if (i > lvl) {
                    summoningLabel.text = [NSString stringWithFormat:@"%ld", (long)c];
                }
            }
        }
// Constitution
        if (constitution == 99) {
            constitutionLabel.text = singleMax;
        } else {
            i = 1;
            c = 0;
            temp = constitution;
            while (i <= lvl) {
                temp += 1;
                if ([fightTitle isEqualToString:@"Melee"] || [fightTitle isEqualToString:@"Skiller"]) {
                    NSInteger sum = attack + strength;
                    NSInteger sum2 = defence + temp;
                    NSInteger sum3 = prayer/2;
                    NSInteger sum4 = summoning/2;
                    float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                    i = sum5/4;
                    c += 1;
                    combatType.text = @"a warrior.";
                } else if ([fightTitle isEqualToString:@"Mage"]) {
                    NSInteger sum = magic * 2;
                    NSInteger sum2 = defence + temp;
                    NSInteger sum3 = prayer/2;
                    NSInteger sum4 = summoning/2;
                    float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                    i = sum5/4;
                    c += 1;
                    combatType.text = @"a mage.";
                } else if ([fightTitle isEqualToString:@"Range"]) {
                    NSInteger sum = range * 2;
                    NSInteger sum2 = defence + temp;
                    NSInteger sum3 = prayer/2;
                    NSInteger sum4 = summoning/2;
                    float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                    i = sum5/4;
                    c += 1;
                    combatType.text = @"a ranger.";
                }
                if (i > lvl) {
                    constitutionLabel.text = [NSString stringWithFormat:@"%ld", (long)c];
                }
            }
        }
    }
}

@end
