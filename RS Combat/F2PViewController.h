//
//  F2PViewController.h
//  RS Combat
//
//  Created by Erik Bean on 7/16/14.
//  Copyright (c) 2015 Erik Bean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface F2PViewController : UIViewController <ADBannerViewDelegate>

@property NSInteger *attackNumber;
@property NSInteger *strengthNumber;
@property NSInteger *defenceNumber;
@property NSInteger *magicNumber;
@property NSInteger *rangeNumber;
@property NSInteger *prayerNumber;
@property NSInteger *summoningNumber;
@property NSInteger *constitutionNumber;

@end