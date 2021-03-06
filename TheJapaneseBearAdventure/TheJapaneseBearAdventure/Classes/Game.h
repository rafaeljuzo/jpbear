//
//  Game.h
//  TheJapaneseBearAdventure
//
//  Created by Eduardo Urso on 3/19/14.
//  Copyright 2014 Eduardo Urso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Background.h"
#import "GameOverScene.h"
#import <CoreMotion/CoreMotion.h>

@interface Game : Background {
    
    //the player position.
	CGPoint _player_pos;
    
	ccVertex2F _player_vel;
	ccVertex2F _player_acc;
    
	float _currentPlatformY;
	int _currentPlatformTag;
	float _currentMaxPlatformStep;
	int _currentcoinPlatformIndex;
	int _currentcoinType;
	int _platformCount;
    
	//bool to pause/return game.
	BOOL _gameSuspended;
    //bool to recognize what side the sprite player is looking for.
	BOOL _playerLookingRight;
	
	int _playerScore;
    
}

+ (Game *)scene;
- (id)init;
- (void)startGame;


@property (strong, nonatomic) CMMotionManager *motionManager;


@end
