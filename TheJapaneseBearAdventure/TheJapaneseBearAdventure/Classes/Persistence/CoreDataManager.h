#import "cocos2d.h"

@interface CoreDataManager : NSObject 
{
    
}
@property (nonatomic, retain, readonly) NSManagedObjectContext *moc;
@property (nonatomic, retain, readonly) NSManagedObjectModel *model;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *coordinator;

+(id)shared;

-(void)saveMoc; // save context into store
-(NSURL *)storeDirectory; // url to store
@end
