#import "CoreDataManager.h"
#import <CoreData/CoreData.h>

@implementation CoreDataManager
@synthesize moc, model, coordinator;


+(id)shared {
    static id shared=nil;
    if (shared == nil) {
        shared=[[self alloc] init];
    }
    return shared;
}

#pragma mark -
#pragma mark External Services

- (void)saveMoc
{
    NSError *error = nil;
    if (self.moc != nil) {
        if ([moc hasChanges] && ![moc save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (NSURL *)storeDirectory {
    // applications document directory
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark -
#pragma mark Getters

- (NSManagedObjectModel *)model
{
    if (model != nil) return model;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GameModel" withExtension:@"momd"];
    
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return model;
}

- (NSPersistentStoreCoordinator *)coordinator
{
    if (coordinator != nil) return coordinator;
    
    NSURL *storeURL = [[self storeDirectory] URLByAppendingPathComponent:@"GameModel.sqlite"];
    
    NSError *error = nil;
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];
    
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    return coordinator;
}

- (NSManagedObjectContext *)moc
{
    if (moc != nil) return moc;
    
    if (self.coordinator != nil) {
        moc = [[NSManagedObjectContext alloc] init];
        [moc setPersistentStoreCoordinator:coordinator];
    }
    return moc;
}

@end
