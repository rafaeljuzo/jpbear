//
//  Background.h
//  TheJapaneseBearAdventure
//
//  Created by Eduardo Urso on 3/19/14.
//  Copyright 2014 Eduardo Urso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


#define kFPS 60
// number of clouds to appear on background movement.
#define kNumClouds			8
//values for distance between plataforms (max and min).
#define kMinPlatformStep	150
#define kMaxPlatformStep	400
//number of plataforms shown at the screen
#define kNumPlatforms		10
#define kPlatformTopPadding 10
//values for distance between coins (max and min).
#define kMincoinStep		30
#define kMaxcoinStep		50

#define kSpriteManager      @"manager"
#define kplayer             @"player"
#define kScoreLabel         @"scoreLabel"

#define kCloudsStartTag     100
#define kPlatformsStartTag  200
#define kcoinStartTag       300

enum {
	kcoin5 = 0,
	kcoin10,
	kcoin50,
	kcoin100,
	kNumcoines
};

@interface Background : CCScene {
    
    int _currentCloudTag;
}

+ (Background *)scene;
- (id)init;

- (void)resetClouds;
- (void)resetCloud;

@end

