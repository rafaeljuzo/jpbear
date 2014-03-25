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
- (void)resetcoin;
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
	
	CCSprite *player = [CCSprite spriteWithTexture:[batchNode texture] rect:CGRectMake(608,5,45,50)];
	[batchNode addChild:player z:4 name:kplayer];

    CCSprite *coin;
    
	for(int i=0; i<kNumcoines; i++) {
		coin = [CCSprite spriteWithTexture:[batchNode texture] rect:CGRectMake(608+i*32,256,25,25)];
		[batchNode addChild:coin z:4 name:[NSString stringWithFormat:@"%d",kcoinStartTag+i]];
		coin.visible = NO;
	}
    
    //Create a label to show the player score.
    //	CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"bitmapFont.fnt"];
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"0" fontName:@"Verdana-Bold" fontSize:17.0f];
	[self addChild:label z:5 name:kScoreLabel];
    label.positionType = CCPositionTypeNormalized;
    label.position = ccp(0.50f, 0.95f); // Middle, Near Top
    
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
    
	_playerScore = 0;
	
	[self resetClouds];
	[self resetPlatforms];
	[self resetplayer];
	[self resetcoin];
	
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	_gameSuspended = NO;
}

// -----------------------------------------------------------------------
#pragma mark - Init Methods
// -----------------------------------------------------------------------


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
		case 0: rect = CGRectMake(608,64,90,36); break;
		case 1: rect = CGRectMake(608,128,60,32); break;
	}
    
	CCSpriteBatchNode *batchNode = (CCSpriteBatchNode*)[self getChildByName:kSpriteManager recursively:NO];
	CCSprite *platform = [CCSprite spriteWithTexture:[batchNode texture] rect:rect];
	[batchNode addChild:platform z:3 name:[NSString stringWithFormat:@"%d",_currentPlatformTag]];
}

// -----------------------------------------------------------------------
#pragma mark - Reset Methods
// -----------------------------------------------------------------------

- (void)resetPlatforms {
    //	CCLOG(@"resetPlatforms");
	
	_currentPlatformY = -1;
	_currentPlatformTag = kPlatformsStartTag;
	_currentMaxPlatformStep = 60.0f;
	_currentcoinPlatformIndex = 0;
	_currentcoinType = 0;
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
	
	if(_platformCount == _currentcoinPlatformIndex) {
        //		CCLOG(@"platformCount == _currentcoinPlatformIndex");
		CCSprite *coin = (CCSprite*)[batchNode getChildByName:[NSString stringWithFormat:@"%d",(kcoinStartTag+_currentcoinType)] recursively:NO];
		coin.position = ccp(x,_currentPlatformY+30);
		coin.visible = YES;
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
	_player_acc.y = -1500.0f;
	
	_playerLookingRight = YES;
	player.scaleX = 1.0f;
}

- (void)resetcoin {
    //	CCLOG(@"resetcoin");
	
	CCSpriteBatchNode *batchNode = (CCSpriteBatchNode*)[self getChildByName:kSpriteManager recursively:NO];
	CCSprite *coin = (CCSprite*)[batchNode getChildByName:[NSString stringWithFormat:@"%d",(kcoinStartTag+_currentcoinType)] recursively:NO];
	coin.visible = NO;
	_currentcoinPlatformIndex += random() % (kMaxcoinStep - kMincoinStep) + kMincoinStep;
    
	if(_playerScore < 10) {
		_currentcoinType = 0;
	} else if(_playerScore < 50) {
		_currentcoinType = random() % 2;
	} else if(_playerScore < 100) {
		_currentcoinType = random() % 3;
	} else {
		_currentcoinType = random() % 2 + 2;
	}
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
    
    //create a coin sprite with a random type when the update is called.
    CCSprite *coin = (CCSprite*)[batchNode getChildByName:[NSString stringWithFormat:@"%d",(kcoinStartTag+_currentcoinType)] recursively:NO];
    //check if the coin is visible
    if(coin.visible) {
        CGPoint coin_pos = coin.position;
        float range = 20.0f;
        if(_player_pos.x > coin_pos.x - range &&
           _player_pos.x < coin_pos.x + range &&
           _player_pos.y > coin_pos.y - range &&
           _player_pos.y < coin_pos.y + range ) {
            switch(_currentcoinType) {
                case kcoin5:   _playerScore += 5;   break;
                case kcoin10:  _playerScore += 10;  break;
                case kcoin50:  _playerScore += 50;  break;
                case kcoin100: _playerScore += 100; break;
            }
            //create a score string to update the real score
            NSString *scoreStr = [NSString stringWithFormat:@"%d",_playerScore];
            //getting the score label
            CCLabelTTF *scoreLabel = (CCLabelTTF*)[self getChildByName:kScoreLabel recursively:NO];
            //updating the score
            [scoreLabel setString:scoreStr];
            //creating an animation when the player reach the coin
            id a1 = [CCActionScaleTo actionWithDuration:0.2f scaleX:1.5f scaleY:0.8f];
            id a2 = [CCActionScaleTo actionWithDuration:0.2f scaleX:1.0f scaleY:1.0f];
            id a3 = [CCActionSequence actions:a1,a2,a1,a2,a1,a2,nil];
            //run the action to animate the label
            [scoreLabel runAction:a3];
            [self resetcoin];
        }
    }
    
    
    if(_player_vel.y < 0) {


        for(int t=kPlatformsStartTag; t < kPlatformsStartTag + kNumPlatforms; t++) {
            CCSprite *platform = (CCSprite*)[batchNode getChildByName:[NSString stringWithFormat:@"%d",t] recursively:NO];
            
            CGSize platform_size = platform.contentSize;
            CGPoint platform_pos = platform.position;
            
            max_x = platform_pos.x - platform_size.width/2 - 10;
            min_x = platform_pos.x + platform_size.width/2 + 10;
            float min_y = platform_pos.y + (platform_size.height+player_size.height)/2 - kPlatformTopPadding;
            //check if the player is touching the platform, with min and max X and in the platform uper side.
            if(_player_pos.x > max_x &&
               _player_pos.x < min_x &&
               _player_pos.y > platform_pos.y &&
               _player_pos.y < min_y) {
                [self jump];
                //if has a colision, set the _currentPlatformTag with the counter and call the reset plataform method that reorganize the platforms
                if (CGRectIntersectsRect(player.boundingBox, platform.boundingBox)) {
                    _currentPlatformTag = t;
                    [self resetPlatform];
                    //set the score with the delta (player position Y)
                    _playerScore += 1;
                    NSString *scoreStr = [NSString stringWithFormat:@"%d",_playerScore];
                    
                    CCLabelBMFont *scoreLabel = (CCLabelBMFont*)[self getChildByName:kScoreLabel recursively:NO];
                    [scoreLabel setString:scoreStr];
                }
            }
        }

        
        if(_player_pos.y < -player_size.height/2) {
//            [self showHighscores];
            CCLOG(@"MORREU");
            [self startGameOverSceneWithScore:_playerScore];
        }
        
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
        
        if(coin.visible) {
            CGPoint pos = coin.position;
            pos.y -= delta;
            if(pos.y < -coin.contentSize.height/2) {
                [self resetcoin];
            } else {
                coin.position = pos;
            }
        }
//        //set the score with the delta (player position Y)
//        _playerScore += (int)delta;
//        NSString *scoreStr = [NSString stringWithFormat:@"%d",_playerScore];
//        
//        CCLabelBMFont *scoreLabel = (CCLabelBMFont*)[self getChildByName:kScoreLabel recursively:NO];
//        [scoreLabel setString:scoreStr];
    }
    
    player.position = _player_pos;
}

- (void)jump {
    _player_vel.y = 800.0f + fabsf(_player_vel.x);
}

// -----------------------------------------------------------------------
#pragma mark - Acceleration Delegates
// -----------------------------------------------------------------------

- (void)accelerometer:(CMAcceleration)acceleration {
	if(_gameSuspended) return;
    
	float accel_filter = 0.1f;
    // setting the player position X when the acelerometer delegate recoginize changes.
	_player_vel.x = _player_vel.x * accel_filter + acceleration.x * (1.0f - accel_filter) * 650.0f;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)startGameOverSceneWithScore:(int)score
{
    
    // start spinning scene with transition
    [[CCDirector sharedDirector] replaceScene:[GameOverScene sceneWithScore:score]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:.5f]];
}


@end
