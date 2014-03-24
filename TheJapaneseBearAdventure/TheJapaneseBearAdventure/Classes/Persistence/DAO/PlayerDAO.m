//
//  PlayerDAO.m
//  TheJapaneseBearAdventure
//
//  Created by Eduardo Urso on 3/23/14.
//  Copyright (c) 2014 Eduardo Urso. All rights reserved.
//

#import "PlayerDAO.h"
#import "CoreDataManager.h"

@implementation PlayerDAO


#pragma mark -
#pragma mark Initialization

-(id)init
{
    if ((self = [super init])) {
        moc = [[CoreDataManager shared] moc];
    }
    return self;
}


#pragma mark -
#pragma mark Save Data Changes

-(void)savePlayerDataChanges
{
    [[CoreDataManager shared] saveMoc];
}

#pragma mark -
#pragma mark Score

-(void)insertBestScore:(NSNumber *)bestScore
{
    // Insert employee in context
    NSManagedObject *player = [NSEntityDescription insertNewObjectForEntityForName:@"PlayerVO" inManagedObjectContext:moc];
    // set employee atributes
    [player setValue:bestScore forKey:@"bestScore"];
    
}

-(NSArray *)fetchBestScore
{
    
    // construct a fetch request
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PlayerVO" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    // return the result of executing the fetch request
    return [moc executeFetchRequest:fetchRequest error:&error];
}



@end
