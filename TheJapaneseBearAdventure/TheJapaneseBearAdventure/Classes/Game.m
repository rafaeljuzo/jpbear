//
//  Game.m
//  TheJapaneseBearAdventure
//
//  Created by Eduardo Urso on 3/19/14.
//  Copyright 2014 Eduardo Urso. All rights reserved.
//

#import "Game.h"

@interface Game (Private)
- (void)initPlatforms;
- (void)initPlatform;
- (void)startGame;
- (void)resetPlatforms;
- (void)resetPlatform;
- (void)resetplayer;
- (void)resetBonus;
- (void)jump;
- (void)showHighscores;
@end

@implementation Game

+ (Game *)scene
{
    return [[self alloc] init];
}
- (id)init {
	
    self = [super init];
    if (!self) return(nil);
    
	CCSpriteBatchNode *batchNode = (CCSpriteBatchNode *)[self getChildByName:kSpriteManager recursively:NO];
    
	[self initPlatforms];
	
	CCSprite *player = [CCSprite spriteWithTexture:[batchNode texture] rect:CGRectMake(608,16,44,32)];
	[batchNode addChild:player z:4 name:kplayer];

    
    //Create a label to show the player score.
//	CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"bitmapFont.fnt"];
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"0" fontName:@"Verdana-Bold" fontSize:17.0f];
	[self addChild:label z:5 name:kScoreLabel];
    label.positionType = CCPositionTypeNormalized;
//  label.position = ccp(0.50f, 0.95f); // Middle, Near Top
    label.position = CGPointMake(0.50f, 0.95f); // Middle, Near Top
    
    // Core Motion Accelerometer
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 1.0 / kFPS;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                 [self accelerometer:accelerometerData.acceleration];
                                                 if(error){
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
	[self startGame];
	return self;
}

- (void)startGame {
    //	CCLOG(@"startGame");
    
	_score = 0;
	
	[self resetClouds];
	[self resetPlatforms];
	[self resetplayer];
//	[self resetBonus];
	
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	_gameSuspended = NO;
}

- (void)initPlatforms {
	
	_currentPlatformTag = kPlatformsStartTag;
	while(_currentPlatformTag < kPlatformsStartTag + kNumPlatforms) {
		[self initPlatform];
		_currentPlatformTag++;
	}
	
	[self resetPlatforms];
}

- (void)initPlatform {
    
	CGRect rect;
	switch(random()%2) {
		case 0: rect = CGRectMake(608,64,102,36); break;
		case 1: rect = CGRectMake(608,128,90,32); break;
	}
    
	CCSpriteBatchNode *batchNode = (CCSpriteBatchNode*)[self getChildByName:kSpriteManager recursively:NO];
	CCSprite *platform = [CCSprite spriteWithTexture:[batchNode texture] rect:rect];
	[batchNode addChild:platform z:3 name:[NSString stringWithFormat:@"%d",_currentPlatformTag]];
}

- (void)resetPlatforms {
    //	CCLOG(@"resetPlatforms");
	
	_currentPlatformY = -1;
	_currentPlatformTag = kPlatformsStartTag;
	_currentMaxPlatformStep = 60.0f;
	_currentBonusPlatformIndex = 0;
	_currentBonusType = 0;
	_platformCount = 0;
    
	while(_currentPlatformTag < kPlatformsStartTag + kNumPlatforms) {
		[self resetPlatform];
		_currentPlatformTag++;
	}
}

- (void)resetPlatform {
    
	//check if the _currentPlatformY is < 0, if so that means that the _currentPlatformY is the first one to be positioned.
	if(_currentPlatformY < 0) {
        //set the first platform Y axis
		_currentPlatformY = 30.0f;
	} else {
        //set the Y axis random if it is not the first platform.
		_currentPlatformY += random() % (int)(_currentMaxPlatformStep - kMinPlatformStep) + kMinPlatformStep;
		if(_currentMaxPlatformStep < kMaxPlatformStep) {
			_currentMaxPlatformStep += 0.5f;
		}
	}
	
	CCSpriteBatchNode *batchNode = (CCSpriteBatchNode*)[self getChildByName:kSpriteManager recursively:NO];
	CCSprite *platform = (CCSprite*)[batchNode getChildByName:[NSString stringWithFormat:@"%d",_currentPlatformTag] recursively:NO];
	
	if(random()%2==1) platform.scaleX = -1.0f;
	
	float x;
    //create a CGSize with the plataform contentSize.
	CGSize size = platform.contentSize;
    //check if is the initial plataform positions by Y axis.
	if(_currentPlatformY == 30.0f) {
        //set the first platform X axis to the middle of the screen, just the same position that the player is positioned, otherwise the player can fail if the plataform position is random.
		x = (int)[[UIScreen mainScreen] bounds].size.width/2;
	} else {
        //set the X axis random if it is not the first platform.
		x = random() % ((int)[[UIScreen mainScreen] bounds].size.width-(int)size.width) + size.width/2;
	}
	
	platform.position = ccp(x,_currentPlatformY);
	_platformCount++;
	//CCLOG(@"platformCount = %d",_platformCount);
	
	if(_platformCount == _currentBonusPlatformIndex) {
        //		CCLOG(@"platformCount == _currentBonusPlatformIndex");
		CCSprite *bonus = (CCSprite*)[batchNode getChildByName:[NSString stringWithFormat:@"%d",(kBonusStartTag+_currentBonusType)] recursively:NO];
		bonus.position = ccp(x,_currentPlatformY+30);
		bonus.visible = YES;
	}
}


- (void)resetplayer {
    //	CCLOG(@"resetplayer");
    
	CCSpriteBatchNode *batchNode = (CCSpriteBatchNode*)[self getChildByName:kSpriteManager recursively:NO];
	CCSprite *player = (CCSprite*)[batchNode getChildByName:kplayer recursively:NO];
	
	//positioning the player in the middle of the screen everytime that resetplayer method is called.
    _player_pos.x = (int)[[UIScreen mainScreen] bounds].size.width/2;
	_player_pos.y = (int)[[UIScreen mainScreen] bounds].size.width/5;
	player.position = _player_pos;
	
	_player_vel.x = 0;
	_player_vel.y = 0;
	
	_player_acc.x = 0;
	_player_acc.y = -550.0f;
	
	_playerLookingRight = YES;
	player.scaleX = 1.0f;
}

- (void)update:(CCTime)dt {
    //	CCLOG(@"Game::step");
    
    [super update:dt];
    
    if(_gameSuspended) return;
    
    CCSpriteBatchNode *batchNode = (CCSpriteBatchNode*)[self getChildByName:kSpriteManager recursively:NO];
    CCSprite *player = (CCSprite*)[batchNode getChildByName:kplayer recursively:NO];
    
    _player_pos.x += _player_vel.x * dt;
    
    if(_player_vel.x < -30.0f && _playerLookingRight) {
        _playerLookingRight = NO;
        player.scaleX = -1.0f;
    } else if (_player_vel.x > 30.0f && !_playerLookingRight) {
        _playerLookingRight = YES;
        player.scaleX = 1.0f;
    }
    
    CGSize player_size = player.contentSize;
    float max_x = (int)[[UIScreen mainScreen] bounds].size.width - player_size.width/2;
    float min_x = 0+player_size.width/2;
    
    if(_player_pos.x>max_x) _player_pos.x = max_x;
    if(_player_pos.x<min_x) _player_pos.x = min_x;
    
    _player_vel.y += _player_acc.y * dt;
    _player_pos.y += _player_vel.y * dt;
    
//    CCSprite *bonus = (CCSprite*)[batchNode getChildByName:[NSString stringWithFormat:@"%d",(kBonusStartTag+_currentBonusType)] recursively:NO];
//    
//    if(bonus.visible) {
//        CGPoint bonus_pos = bonus.position;
//        float range = 20.0f;
//        if(_player_pos.x > bonus_pos.x - range &&
//           _player_pos.x < bonus_pos.x + range &&
//           _player_pos.y > bonus_pos.y - range &&
//           _player_pos.y < bonus_pos.y + range ) {
//            switch(_currentBonusType) {
//                case kBonus5:   _score += 5000;   break;
//                case kBonus10:  _score += 10000;  break;
//                case kBonus50:  _score += 50000;  break;
//                case kBonus100: _score += 100000; break;
//            }
//            NSString *scoreStr = [NSString stringWithFormat:@"%d",_score];
//            CCLabelBMFont *scoreLabel = (CCLabelBMFont*)[self getChildByName:kScoreLabel recursively:NO];
//            [scoreLabel setString:scoreStr];
//            id a1 = [CCActionScaleTo actionWithDuration:0.2f scaleX:1.5f scaleY:0.8f];
//            id a2 = [CCActionScaleTo actionWithDuration:0.2f scaleX:1.0f scaleY:1.0f];
//            id a3 = [CCActionSequence actions:a1,a2,a1,a2,a1,a2,nil];
//            [scoreLabel runAction:a3];
//            [self resetBonus];
//        }
//    }
    
    if(_player_vel.y < 0) {
        
        for(int t=kPlatformsStartTag; t < kPlatformsStartTag + kNumPlatforms; t++) {
            CCSprite *platform = (CCSprite*)[batchNode getChildByName:[NSString stringWithFormat:@"%d",t] recursively:NO];
            
            CGSize platform_size = platform.contentSize;
            CGPoint platform_pos = platform.position;
            
            max_x = platform_pos.x - platform_size.width/2 - 10;
            min_x = platform_pos.x + platform_size.width/2 + 10;
            float min_y = platform_pos.y + (platform_size.height+player_size.height)/2 - kPlatformTopPadding;
            
            if(_player_pos.x > max_x &&
               _player_pos.x < min_x &&
               _player_pos.y > platform_pos.y &&
               _player_pos.y < min_y) {
                [self jump];
            }
        }
        
//        if(_player_pos.y < -player_size.height/2) {
//            [self showHighscores];
//        }
//        
    } else if(_player_pos.y > 240) {
        
        float delta = _player_pos.y - 240;
        _player_pos.y = 240;
        
        _currentPlatformY -= delta;
        
        for(int t=kCloudsStartTag; t < kCloudsStartTag + kNumClouds; t++) {
            CCSprite *cloud = (CCSprite*)[batchNode getChildByName:[NSString stringWithFormat:@"%d",t] recursively:NO];
            CGPoint pos = cloud.position;
            pos.y -= delta * cloud.scaleY * 0.8f;
            if(pos.y < -cloud.contentSize.height/2) {
                _currentCloudTag = t;
                [self resetCloud];
            } else {
                cloud.position = pos;
            }
        }
        
        for(int t=kPlatformsStartTag; t < kPlatformsStartTag + kNumPlatforms; t++) {
            CCSprite *platform = (CCSprite*)[batchNode getChildByName:[NSString stringWithFormat:@"%d",t] recursively:NO];
            CGPoint pos = platform.position;
            pos = ccp(pos.x,pos.y-delta);
            if(pos.y < -platform.contentSize.height/2) {
                _currentPlatformTag = t;
                [self resetPlatform];
            } else {
                platform.position = pos;
            }
        }
        
//        if(bonus.visible) {
//            CGPoint pos = bonus.position;
//            pos.y -= delta;
//            if(pos.y < -bonus.contentSize.height/2) {
//                [self resetBonus];
//            } else {
//                bonus.position = pos;
//            }
//        }
        
        _score += (int)delta;
        NSString *scoreStr = [NSString stringWithFormat:@"%d",_score];
        
        CCLabelBMFont *scoreLabel = (CCLabelBMFont*)[self getChildByName:kScoreLabel recursively:NO];
        [scoreLabel setString:scoreStr];
    }
    
    player.position = _player_pos;
}

- (void)jump {
    _player_vel.y = 350.0f + fabsf(_player_vel.x);
}

- (void)accelerometer:(CMAcceleration)acceleration {
	if(_gameSuspended) return;
    
	float accel_filter = 0.1f;
	_player_vel.x = _player_vel.x * accel_filter + acceleration.x * (1.0f - accel_filter) * 500.0f;
}



@end
