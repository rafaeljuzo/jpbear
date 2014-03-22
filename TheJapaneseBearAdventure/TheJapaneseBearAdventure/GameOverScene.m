//
//  GameOverScene.m
//  TheJapaneseBearAdventure
//
//  Created by Eduardo Urso on 3/22/14.
//  Copyright 2014 Eduardo Urso. All rights reserved.
//

#import "GameOverScene.h"


@implementation GameOverScene

+ (GameOverScene *)sceneWithScore:(int)score
{
    return [[self alloc] initWithScore:score];
}

- (id) initWithScore:(int) score{

    self = [super init];
    if (!self) return(nil);
    
    // HighScore text Label
    CCLabelTTF *highScoreTextLabel = [CCLabelTTF labelWithString:@"HighScore" fontName:@"Chalkduster" fontSize:36.0f];
    highScoreTextLabel.positionType = CCPositionTypeNormalized;
    highScoreTextLabel.position = ccp(0.5f, 0.8f); // Middle of screen
    [self addChild:highScoreTextLabel];
    
    // HighScore Label
    CCLabelTTF *highScoreLabel = [CCLabelTTF labelWithString:@"HighScore" fontName:@"Chalkduster" fontSize:36.0f];
    highScoreLabel.positionType = CCPositionTypeNormalized;
    highScoreLabel.position = ccp(0.5f, .65f); // Middle of screen
    [highScoreLabel setString:[NSString stringWithFormat:@"%d",score]];
    [self addChild:highScoreLabel];
    
    
    // create the restart scene button
    CCButton *restartButton = [CCButton buttonWithTitle:@"[ Restart ]" fontName:@"Verdana-Bold" fontSize:22.0f];
    restartButton.positionType = CCPositionTypeNormalized;
    restartButton.position = ccp(0.5f, 0.35f);
    //set the target to the onRestartButtonClicked method
    [restartButton setTarget:self selector:@selector(onRestartButtonClicked)];
    [self addChild:restartButton];
    
    return self;

    
}

- (id)init
{
    
    self = [super init];
    if (!self) return(nil);
    
    // HighScore text Label
    CCLabelTTF *highScoreTextLabel = [CCLabelTTF labelWithString:@"HighScore" fontName:@"Chalkduster" fontSize:36.0f];
    highScoreTextLabel.positionType = CCPositionTypeNormalized;
    highScoreTextLabel.position = ccp(0.5f, 0.8f); // Middle of screen
    [self addChild:highScoreTextLabel];
    
    // HighScore Label
    CCLabelTTF *highScoreLabel = [CCLabelTTF labelWithString:@"HighScore" fontName:@"Chalkduster" fontSize:36.0f];
    highScoreLabel.positionType = CCPositionTypeNormalized;
    highScoreLabel.position = ccp(0.5f, .5f); // Middle of screen
    [highScoreLabel setString:[NSString stringWithFormat:@"%d",self.finalScore]];
    [self addChild:highScoreLabel];

    
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
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:.5f]];

}



@end
