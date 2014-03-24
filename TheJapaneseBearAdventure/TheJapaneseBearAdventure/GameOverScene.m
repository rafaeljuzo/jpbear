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

#pragma mark -
#pragma mark Initialization

- (id) initWithScore:(int) score{

    if ((self = [super init])) {
        playerDAO = [[PlayerDAO alloc] init];
    }
    if (!self) return(nil);
    
    //when the scene is initialized we save the new best score if it is necessary.
    [self saveNewBestScore:[NSNumber numberWithInt:score]];
    
    
    // gameOver text label
    CCLabelTTF *gameOverLabel = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Chalkduster" fontSize:36.0f];
    gameOverLabel.positionType = CCPositionTypeNormalized;
    gameOverLabel.position = ccp(0.5f, 0.8f); // Middle of screen
    [self addChild:gameOverLabel];
    
    // score text label
    CCLabelTTF *scoreTextLabel = [CCLabelTTF labelWithString:@"Score" fontName:@"Chalkduster" fontSize:32.0f];
    scoreTextLabel.positionType = CCPositionTypeNormalized;
    scoreTextLabel.position = ccp(0.5f, .65f); // Middle of screen
    [self addChild:scoreTextLabel];
    
    // score label
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:28.0f];
    scoreLabel.positionType = CCPositionTypeNormalized;
    scoreLabel.position = ccp(0.5f, .55f); // Middle of screen
    [scoreLabel setString:[NSString stringWithFormat:@"%d",score]];
    [self addChild:scoreLabel];
    
    // best score text label
    CCLabelTTF *bestScoreTextLabel = [CCLabelTTF labelWithString:@"Best" fontName:@"Chalkduster" fontSize:32.0f];
    bestScoreTextLabel.positionType = CCPositionTypeNormalized;
    bestScoreTextLabel.position = ccp(0.5f, .45f); // Middle of screen
    [self addChild:bestScoreTextLabel];

    
    // best score Label
    CCLabelTTF *bestScoreLabel = [CCLabelTTF labelWithString:@"" fontName:@"Chalkduster" fontSize:28.0f];
    bestScoreLabel.positionType = CCPositionTypeNormalized;
    bestScoreLabel.position = ccp(0.5f, .35f); // Middle of screen
    [bestScoreLabel setString:[NSString stringWithFormat:@"%@",[self listBestScoreFromDataBase]]];
    [self addChild:bestScoreLabel];

    
    // create the restart scene button
    CCButton *restartButton = [CCButton buttonWithTitle:@"[ Restart ]" fontName:@"Chalkduster" fontSize:28.0f];
    restartButton.positionType = CCPositionTypeNormalized;
    restartButton.position = ccp(0.5f, 0.25f);
    restartButton.color = [CCColor yellowColor];
    //set the target to the onRestartButtonClicked method
    [restartButton setTarget:self selector:@selector(onRestartButtonClicked)];
    [self addChild:restartButton];
    
    return self;

    
}

// -----------------------------------------------------------------------
#pragma mark - Data Base Methods
// -----------------------------------------------------------------------

/**
 Method resposible to check and insert or update the score on database.
 @param score a NSNumber that is the actual player score.
 */
- (void)saveNewBestScore:(NSNumber *)score
{
    //create an NSNumber that allows to compare the double value, otherwise compare a number will compare a pointer.
    NSNumber *scoreFromDB = [self listBestScoreFromDataBase];
    
    if ([scoreFromDB doubleValue] < [score doubleValue]) {
        //check if the return is nil, if so that means that the data base is empty.
        if ([self listBestScoreFromDataBase] != nil) {
            //update de data base with the new score.
            [self updateScore:score];
        } else {
            //insert the score in data base.
            [self addBestScoreToDataBase:score];
        }
    }
}

/**
 Method resposible to insert the send the score to be inserted on database.
 @param bestScore a NSNumber that is the player score
 */
-(void)addBestScoreToDataBase:(NSNumber *)bestScore
{
    NSLog(@"* added best score in database *");
    //calling playerDAO to insert the best score into database.
    [playerDAO insertBestScore:bestScore];
    //saving the database context, otherwise the value will not persist when the app is closed.
    [playerDAO savePlayerDataChanges];
}

/**
 Method resposible to update the score on database.
 @param score a NSNumber that is the player score to update the old one.
 */
-(void)updateScore:(NSNumber *)score
{
    // fetch score form database
    NSArray *fetchedObjects = [playerDAO fetchBestScore];
    
    for (NSManagedObject *newBestScore in fetchedObjects) {
        [newBestScore setValue:score forKey:@"bestScore"];
    }
    //saving the database context, otherwise the value will not persist when the app is closed.
    [playerDAO savePlayerDataChanges];
}

/**
 Method resposible to update the score on data base.
 @return a NSNumber that is the player score on the database
 */
-(NSNumber *)listBestScoreFromDataBase
{
    NSLog(@"* list score *");
    // fetch score form database
    NSArray *fetchedObjects = [playerDAO fetchBestScore];
    NSNumber *scoreFromDataBase;
    
    // List them and populate the scoreFromDataBase variable to be returned.
    for (NSManagedObject *score in fetchedObjects) {
        CCLOG(@"score: %@", [score valueForKey:@"bestScore"]);
        scoreFromDataBase = [score valueForKey:@"bestScore"];
    }
    return scoreFromDataBase;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

/**
 Method resposible to replace the actual scene to the game scene.
 */
- (void)onRestartButtonClicked
{
    // restart game scene with transition
    [[CCDirector sharedDirector] replaceScene:[Game scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:.5f]];

}



@end
