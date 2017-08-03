//
//  NEDBAccessor.m
//
//  Created by Akihiro Matsui
//

#import "NEDBAccessor.h"

@interface NEDBAccessor()

@property (nonatomic) NSMutableDictionary *contexts;
@property (nonatomic) NSManagedObjectContext *mainContext;

@end

@implementation NEDBAccessor

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


# pragma mark -- Singleton design pattern

+ (instancetype)instance {
    static NEDBAccessor *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[NEDBAccessor alloc] initSharedInstance];
    });
    return _sharedInstance;
}

- (id)initSharedInstance {
    self = [super init];
    if (self) {
        _contexts = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}


# pragma mark --- NEDBAccessor private methods

- (NSString *)persistentFilePath {
    NSString *path = [self libraryDirectoryPath];
	return [path stringByAppendingPathComponent:@"FTData.sqlite"];
}


# pragma mark --- NEDBAccessor methods

- (void)editContextDidSave:(NSNotification *)saveNotification {
	[[self managedObjectContext] mergeChangesFromContextDidSaveNotification:saveNotification];
}

- (void)deleteCoreDataFile {
	NSString *path = [self persistentFilePath];
	if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
	}
}


# pragma mark --- CoreData methods

- (NSManagedObjectContext *)_managedObjectContextWithThread:(NSThread *)thread {
    NSString *str = [NSString stringWithFormat:@"%@", thread];
    if (!self.contexts[str]) {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if(coordinator!=nil) {
            NSManagedObjectContext *context = nil;
            if ([NSThread isMainThread]) {
                context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
                [context setPersistentStoreCoordinator:coordinator];
            } else {
                context = [[NSManagedObjectContext alloc] init];
                [context setPersistentStoreCoordinator:coordinator];
            }
            self.contexts[str] = context;
        }
    }
    return self.contexts[str];
}

- (NSManagedObjectContext *)managedObjectContext {
    return [self _managedObjectContextWithThread:[NSThread currentThread]];
}

- (NSManagedObjectContext *)mainManagedObjectContext {
    return [self _managedObjectContextWithThread:[NSThread currentThread]];
}

- (NSManagedObjectModel *)managedObjectModel {
	if(_managedObjectModel!=nil) {
		return _managedObjectModel;
    }
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"FTData" withExtension:@"momd"];
	_managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:url] copy];
    
    // 全てのモデルを取得する場合はこちら
    //	NSMutableSet *allBundles = [NSMutableSet set];
    //	[allBundles addObjectsFromArray:[NSBundle allBundles]];
    //	_managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:[allBundles allObjects]];
    
	return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	if(_persistentStoreCoordinator!=nil)
		return _persistentStoreCoordinator;

    // マイグレーション用オプション
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption: @(YES),
                              NSInferMappingModelAutomaticallyOption: @(YES)
                             };

    NSURL *storeURL = [NSURL fileURLWithPath:[self persistentFilePath]];
	NSError *error = nil;
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
		NSLog(@"PersistentStoreCoordinator Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	return _persistentStoreCoordinator;
}

- (NSString *)libraryDirectoryPath {
    static NSString *libraryDirectory = nil;
    if (!libraryDirectory) {
        libraryDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    return libraryDirectory;
}


@end

