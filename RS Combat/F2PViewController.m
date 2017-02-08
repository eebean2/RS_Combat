//
//  F2PViewController.m
//  RS Combat
//
//  Created by Erik Bean on 7/16/14.
//  Copyright (c) 2015 Erik Bean. All rights reserved.
//

#import "F2PViewController.h"

@interface F2PViewController () {
    
    // Static Text
    IBOutlet UILabel *titleWord;
    IBOutlet UILabel *maxOne;
    IBOutlet UILabel *maxTwo;
    IBOutlet UILabel *attackWord;
    IBOutlet UILabel *strengthWord;
    IBOutlet UILabel *defenceWord;
    IBOutlet UILabel *magicWord;
    IBOutlet UILabel *rangeWord;
    IBOutlet UILabel *prayerWord;
    IBOutlet UILabel *summoningWord;
    IBOutlet UILabel *constitutionWord;
    IBOutlet UILabel *nextWord;
    
    // Dynamic Text
    IBOutlet UILabel *attackText;
    IBOutlet UILabel *strengthText;
    IBOutlet UILabel *defenceText;
    IBOutlet UILabel *magicText;
    IBOutlet UILabel *rangeText;
    IBOutlet UILabel *prayerText;
    IBOutlet UILabel *summoningText;
    IBOutlet UILabel *constitutionText;
    IBOutlet UILabel *nextLevel;
    IBOutlet UILabel *currentLevel;
    
    NSInteger attack;
    NSInteger strength;
    NSInteger defence;
    NSInteger magic;
    NSInteger range;
    NSInteger prayer;
    NSInteger summoning;
    NSInteger constitution;
    NSInteger lvl;
    NSString *fightTitle;
    
    IBOutlet ADBannerView *adBanner;
    BOOL bannerIsVisable;
}

@end

@implementation F2PViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setLevelCalculations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    adBanner.delegate = self;
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

- (void)setLevelCalculations {
    NSString *empty = @" ";
    NSString *singleMax = @"0";
    attack = *(self.attackNumber);
    strength = *(self.strengthNumber);
    defence = *(self.defenceNumber);
    magic = *(self.magicNumber);
    range = *(self.rangeNumber);
    prayer = *(self.prayerNumber);
    summoning = *(self.summoningNumber);
    constitution = *(self.constitutionNumber);
    
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
        
        currentLevel.text = @"138";
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
        attackText.text = empty;
        strengthText.text = empty;
        defenceText.text = empty;
        magicText.text = empty;
        rangeText.text = empty;
        prayerText.text = empty;
        summoningText.text = empty;
        constitutionText.text = empty;
        nextLevel.text = empty;
    } else {
        maxOne.text = @" ";
        maxTwo.text = @" ";
        titleWord.text = @"You Need Either:";
        nextWord.text = @"Till your level:";
        attackWord.text = @"Attack Levels";
        strengthWord.text = @"Strength Levels";
        defenceWord.text = @"Defence Levels";
        magicWord.text = @"Magic Levels";
        rangeWord.text = @"Range Levels";
        summoningWord.text = @"Summoning Levels";
        constitutionWord.text = @"Constitution Levels";
        
        NSInteger next = lvl + 1;
        nextLevel.text = [NSString stringWithFormat:@"%ld", (long) next];
        currentLevel.text = [NSString stringWithFormat:@"%ld", (long) lvl];
        
        NSInteger temp = 0;
        NSInteger i = 1;
        NSInteger c = 0;
// Attack
        if (attack == 99) {
            attackText.text = singleMax;
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
                    attackText.text = [NSString stringWithFormat:@"%ld", (long)c];
                }
            }
        }
// Strength
        if (strength == 99) {
            strengthText.text = singleMax;
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
                    strengthText.text = [NSString stringWithFormat:@"%ld", (long)c];
                }
            }
        }
// Defence
        if (defence == 99) {
            defenceText.text = singleMax;
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
                } else if ([fightTitle isEqualToString:@"Mage"]) {
                    NSInteger sum = magic * 2;
                    NSInteger sum2 = temp + constitution;
                    NSInteger sum3 = prayer/2;
                    NSInteger sum4 = summoning/2;
                    float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                    i = sum5/4;
                    c += 1;
                } else if ([fightTitle isEqualToString:@"Range"]) {
                    NSInteger sum = range * 2;
                    NSInteger sum2 = temp + constitution;
                    NSInteger sum3 = prayer/2;
                    NSInteger sum4 = summoning/2;
                    float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                    i = sum5/4;
                    c += 1;
                }
                if (i > lvl) {
                    defenceText.text = [NSString stringWithFormat:@"%ld", (long)c];
                }
            }
        }
// Magic
        if (magic == 99) {
            magicText.text = singleMax;
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
                    magicText.text = [NSString stringWithFormat:@"%ld", (long)c];
                }
            }
        }
// Range
        if (range == 99) {
            rangeText.text = singleMax;
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
                    rangeText.text = [NSString stringWithFormat:@"%ld", (long)c];
                }
            }
        }
// Prayer
        if (prayer == 99) {
            prayerText.text = singleMax;
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
                } else if ([fightTitle isEqualToString:@"Mage"]) {
                    NSInteger sum = magic * 2;
                    NSInteger sum2 = defence + constitution;
                    NSInteger sum3 = temp/2;
                    NSInteger sum4 = summoning/2;
                    float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                    i = sum5/4;
                    c += 1;
                } else if ([fightTitle isEqualToString:@"Range"]) {
                    NSInteger sum = range * 2;
                    NSInteger sum2 = defence + constitution;
                    NSInteger sum3 = temp/2;
                    NSInteger sum4 = summoning/2;
                    float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                    i = sum5/4;
                    c += 1;
                }
                if (i > lvl) {
                    prayerText.text = [NSString stringWithFormat:@"%ld", (long)c];
                }
            }
        }
// Summoning
        if (summoning == 99) {
            summoningText.text = singleMax;
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
                } else if ([fightTitle isEqualToString:@"Mage"]) {
                    NSInteger sum = magic * 2;
                    NSInteger sum2 = defence + constitution;
                    NSInteger sum3 = prayer/2;
                    NSInteger sum4 = temp/2;
                    float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                    i = sum5/4;
                    c += 1;
                } else if ([fightTitle isEqualToString:@"Range"]) {
                    NSInteger sum = range * 2;
                    NSInteger sum2 = defence + constitution;
                    NSInteger sum3 = prayer/2;
                    NSInteger sum4 = temp/2;
                    float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                    i = sum5/4;
                    c += 1;
                }
                if (i > lvl) {
                    summoningText.text = [NSString stringWithFormat:@"%ld", (long)c];
                }
            }
        }
// Constitution
        if (constitution == 99) {
            constitutionText.text = singleMax;
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
                } else if ([fightTitle isEqualToString:@"Mage"]) {
                    NSInteger sum = magic * 2;
                    NSInteger sum2 = defence + temp;
                    NSInteger sum3 = prayer/2;
                    NSInteger sum4 = summoning/2;
                    float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                    i = sum5/4;
                    c += 1;
                } else if ([fightTitle isEqualToString:@"Range"]) {
                    NSInteger sum = range * 2;
                    NSInteger sum2 = defence + temp;
                    NSInteger sum3 = prayer/2;
                    NSInteger sum4 = summoning/2;
                    float sum5 = 1.3 * sum + sum2 + sum3 + sum4;
                    i = sum5/4;
                    c += 1;
                }
                if (i > lvl) {
                    constitutionText.text = [NSString stringWithFormat:@"%ld", (long)c];
                }
            }
        }
    }
}

- (IBAction)returnToPreviousStoryboard {
    [self.presentingViewController dismissViewControllerAnimated:NO completion:^{}];
}

@end