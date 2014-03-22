//
//  GameOverScene.h
//  TheJapaneseBearAdventure
//
//  Created by Eduardo Urso on 3/22/14.
//  Copyright 2014 Eduardo Urso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "Background.h"
#import "Game.h"

@interface GameOverScene : Background {
    int _finalScore;
}
@property (nonatomic) int finalScore;
+ (GameOverScene *)sceneWithScore:(int)score;
- (id)init;

@end
