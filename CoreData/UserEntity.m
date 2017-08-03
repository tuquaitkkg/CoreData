//
//  UserEntity.m
//  CoreData
//
//  Created by DucLT on 8/3/17.
//  Copyright © 2017 DucLT. All rights reserved.
//

#import "UserEntity.h"
#import "NEDBAccessor.h"

@implementation UserEntity

@dynamic name;
@dynamic phoneNumber;

- (void)saveEntity {
    
    NSManagedObjectContext *managedObjectContext = [[NEDBAccessor instance] managedObjectContext];
    if ([NSThread isMainThread]) {
        NSError *error = nil;
        if(![managedObjectContext save:&error]) {
            @throw [NSException exceptionWithName:@"SaveGroupMember" reason:[error description] userInfo:nil];
        }
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSManagedObjectContext *managedObjectContext = [[NEDBAccessor instance] managedObjectContext];
            NSError *error = nil;
            if(![managedObjectContext save:&error]) {
                @throw [NSException exceptionWithName:@"SaveGroupMember" reason:[error description] userInfo:nil];
            }
        });
    }
}

+ (UserEntity *)fetchOrCreateByUserJID:(NSString *)username andPhoneNumber:(NSString *)phoneNumber {
    UserEntity *entity = nil;
//    if (username) {
//        entity = [FTGroupMemberEntity entityByUserJID:username];
//    }
    if (!entity) {
        NSManagedObjectContext *managedObjectContext = [[NEDBAccessor instance] managedObjectContext];
        entity = (UserEntity *)[NSEntityDescription insertNewObjectForEntityForName:@"UserEntity"
                                                                      inManagedObjectContext:managedObjectContext];
    }
    return entity;
}

@end
