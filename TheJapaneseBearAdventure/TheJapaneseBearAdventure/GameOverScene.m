//
//  GameOverScene.m
//  TheJapaneseBearAdventure
//
//  Created by Eduardo Urso on 3/22/14.
//  Copyright 2014 Eduardo Urso. All rights reserved.
//

#import "GameOverScene.h"


@implementation GameOverScene

+ (Background *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    
    self = [super init];
    if (!self) return(nil);
    
    // create the restart scene button
    CCButton *restartButton = [CCButton buttonWithTitle:@"[ Restart ]" fontName:@"Verdana-Bold" fontSize:22.0f];
    restartButton.positionType = CCPositionTypeNormalized;
    restartButton.position = ccp(0.5f, 0.35f);
    //set the target to the onRestartButtonClicked method
    [restartButton setTarget:self selector:@selector(onRestartButtonClicked)];
    [self addChild:restartButton];
    
    return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onRestartButtonClicked
{
    // start game scene with transition
    [[CCDirector sharedDirector] replaceScene:[Game scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionUp duration:.5f]];
    //restart game
    Game *game = [[Game alloc]init];
    [game startGame];
}

@end
