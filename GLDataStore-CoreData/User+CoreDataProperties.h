//
//  User+CoreDataProperties.h
//  GLDataStore-CoreData
//
//  Created by hyq on 15/12/4.
//  Copyright © 2015年 Grey. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSString *created_at;
@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) Group *group;

@end

NS_ASSUME_NONNULL_END
