//
//  UserEntity.h
//  CoreData
//
//  Created by DucLT on 8/3/17.
//  Copyright © 2017 DucLT. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface UserEntity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneNumber;

- (void)saveEntity;

+ (UserEntity *)fetchOrCreateByUserJID:(NSString *)username andPhoneNumber:(NSString *)phoneNumber;

@end
