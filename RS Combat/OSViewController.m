//
//  OSViewController.m
//  RS Combat
//
//  Created by Erik Bean on 7/17/14.
//  Copyright (c) 2015 Erik Bean. All rights reserved.
//

#import "OSViewController.h"

@interface OSViewController () {
    
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
    IBOutlet UILabel *hpWord;
    IBOutlet UILabel *nextWord;
    
    // Dynamic Text
    IBOutlet UILabel *attackText;
    IBOutlet UILabel *strengthText;
    IBOutlet UILabel *defenceText;
    IBOutlet UILabel *magicText;
    IBOutlet UILabel *rangeText;
    IBOutlet UILabel *prayerText;
    IBOutlet UILabel *hpText;
    IBOutlet UILabel *nextLevel;
    IBOutlet UILabel *currentLevel;
    
    NSInteger attack;
    NSInteger strength;
    NSInteger defence;
    NSInteger magic;
    NSInteger range;
    NSInteger prayer;
    NSInteger hp;
    NSInteger lvl;
    NSString *fightTitle;
    
    IBOutlet UIButton *osDone;
    IBOutlet ADBannerView *adBanner;
    BOOL bannerIsVisable;
}

@end

@implementation OSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    osDone.layer.cornerRadius = 5;
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"osBackground.png"]];
    
    attack = *(self.attackNumber);
    strength = *(self.strengthNumber);
    defence = *(self.defenceNumber);
    magic = *(self.magicNumber);
    range = *(self.rangeNumber);
    prayer = *(self.prayerNumber);
    hp = *(self.hpNumber);
    
    [self setLevelCalculations];
    
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
         AdBanner Error: 3 - No add to display
         */
    }
}

- (void)setLevelCalculations {
    NSString *empty = @" ";
    NSString *singleMax = @"0";
    
    float sumPrayer = prayer/2;
    float base = (defence + hp + sumPrayer)/4;
    NSInteger warriorNum = attack + strength;
    float warrior = .325 * warriorNum;
    NSInteger rangerNum = 1.5 * range;
    float ranger = .325 * rangerNum;
    NSInteger mageNum = 1.5 * magic;
    float mage = .325 * mageNum;
    
    if ((warrior > ranger) && (warrior > mage)) {
        lvl = base + warrior;
        fightTitle = @"Warrior";
    } else if ((ranger > warrior) && (ranger > mage)) {
        lvl = base + ranger;
        fightTitle = @"Ranger";
    } else if ((mage > warrior) && (mage > ranger)) {
        lvl = base + mage;
        fightTitle = @"Mage";
    } else {
        lvl = base + warrior;
        fightTitle = @"Warrior";
    }
    
    if (attack == 99 && strength == 99 && defence == 99 && magic == 99 && range == 99 && prayer == 99 && hp == 99) {
        
        currentLevel.text = @"126";
        maxOne.text = @"Oh No!";
        maxTwo.text = @"Your Already Max Combat Level!";
        titleWord.text = empty;
        attackWord.text = empty;
        strengthWord.text = empty;
        defenceWord.text = empty;
        magicWord.text = empty;
        rangeWord.text = empty;
        prayerWord.text = empty;
        hpWord.text = empty;
        nextWord.text = empty;
        attackText.text = empty;
        strengthText.text = empty;
        defenceText.text = empty;
        magicText.text = empty;
        rangeText.text = empty;
        prayerText.text = empty;\
        hpText.text = empty;
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
        hpWord.text = @"Hitpoint Levels";
        
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
                float sumPrayer = prayer/2;
                float baseMath = (defence + hp + sumPrayer)/4;
                NSInteger num = temp + strength;
                float warriorMath = .325 * num;
                i = baseMath + warriorMath;
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
                float sumPrayer = prayer/2;
                float baseMath = (defence + hp + sumPrayer)/4;
                NSInteger num = attack + temp;
                float warriorMath = .325 * num;
                i = baseMath + warriorMath;
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
                if ([fightTitle isEqualToString:@"Warrior"]) {
                    float sumPrayer = prayer/2;
                    float baseMath = (temp + hp + sumPrayer)/4;
                    NSInteger num = attack + strength;
                    float warriorMath = .325 * num;
                    i = baseMath + warriorMath;
                    c += 1;
                } else if ([fightTitle isEqualToString:@"Mage"]) {
                    float sumPrayer = prayer/2;
                    float baseMath = (temp + hp + sumPrayer)/4;
                    NSInteger num = magic/2;
                    float mageMath = .325 * num;
                    i = baseMath + mageMath;
                    c += 1;
                } else if ([fightTitle isEqualToString:@"Ranger"]) {
                    float sumPrayer = prayer/2;
                    float baseMath = (temp + hp + sumPrayer)/4;
                    NSInteger num = range/2;
                    float rangerMath = .325 * num;
                    i = baseMath + rangerMath;
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
                float sumPrayer = prayer/2;
                float baseMath = (defence + hp + sumPrayer)/4;
                NSInteger num = 1.5 * temp;
                float mageMath = .325 * num;
                i = baseMath + mageMath;
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
                float sumPrayer = prayer/2;
                float baseMath = (defence + hp + sumPrayer)/4;
                NSInteger num = 1.5 * temp;
                float rangerMath = .325 * num;
                i = baseMath + rangerMath;
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
                if ([fightTitle isEqualToString:@"Warrior"]) {
                    float sumPrayer = temp/2;
                    float baseMath = (defence + hp + sumPrayer)/4;
                    NSInteger num = attack + strength;
                    float warriorMath = .325 * num;
                    i = baseMath + warriorMath;
                    c += 1;
                } else if ([fightTitle isEqualToString:@"Mage"]) {
                    float sumPrayer = temp/2;
                    float baseMath = (defence + hp + sumPrayer)/4;
                    NSInteger num = 1.5 * magic;
                    float mageMath = .325 * num;
                    i = baseMath + mageMath;
                    c += 1;
                } else if ([fightTitle isEqualToString:@"Ranger"]) {
                    float sumPrayer = temp/2;
                    float baseMath = (defence + hp + sumPrayer)/4;
                    NSInteger num = 1.5 * range;
                    float rangerMath = .325 * num;
                    i = baseMath + rangerMath;
                    c += 1;
                }
                if (i > lvl) {
                    prayerText.text = [NSString stringWithFormat:@"%ld", (long)c];
                }
            }
        }
// Hitpoints
        if (hp == 99) {
            hpText.text = singleMax;
        } else {
            i = 1;
            c = 0;
            temp = hp;
            while (i <= lvl) {
                temp += 1;
                if ([fightTitle isEqualToString:@"Warrior"]) {
                    float sumPrayer = prayer/2;
                    float baseMath = (defence + temp + sumPrayer)/4;
                    NSInteger num = attack + strength;
                    float warriorMath = .325 * num;
                    i = baseMath + warriorMath;
                    c += 1;
                } else if ([fightTitle isEqualToString:@"Mage"]) {
                    float sumPrayer = prayer/2;
                    float baseMath = (defence + temp + sumPrayer)/4;
                    NSInteger num = 1.5 * magic;
                    float mageMath = .325 * num;
                    i = baseMath + mageMath;
                    c += 1;
                } else if ([fightTitle isEqualToString:@"Ranger"]) {
                    float sumPrayer = prayer/2;
                    float baseMath = (defence + temp + sumPrayer)/4;
                    NSInteger num = 1.5 * range;
                    float rangerMath = .325 * num;
                    i = baseMath + rangerMath;
                    c += 1;
                }
                if (i > lvl) {
                    hpText.text = [NSString stringWithFormat:@"%ld", (long)c];
                }
            }
        }
    }
}

- (IBAction)returnToPreviousStoryboard:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:NO completion:^{}];
}

@end
