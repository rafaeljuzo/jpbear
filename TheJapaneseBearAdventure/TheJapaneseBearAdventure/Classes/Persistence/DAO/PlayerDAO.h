//
//  PlayerDAO.h
//  TheJapaneseBearAdventure
//
//  Created by Eduardo Urso on 3/23/14.
//  Copyright (c) 2014 Eduardo Urso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PlayerDAO : NSObject
{
    NSManagedObjectContext *moc;
}

-(void)insertBestScore:(NSNumber *)bestScore;
-(NSArray *)fetchBestScore;
-(void)savePlayerDataChanges;

@end
