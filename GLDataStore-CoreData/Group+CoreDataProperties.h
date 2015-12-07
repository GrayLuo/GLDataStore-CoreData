//
//  Group+CoreDataProperties.h
//  GLDataStore-CoreData
//
//  Created by hyq on 15/12/4.
//  Copyright © 2015年 Grey. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Group.h"

NS_ASSUME_NONNULL_BEGIN

@interface Group (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *id;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSManagedObject *user;

@end

NS_ASSUME_NONNULL_END
