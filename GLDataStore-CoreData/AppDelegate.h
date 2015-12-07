//
//  AppDelegate.h
//  GLDataStore-CoreData
//
//  Created by hyq on 15/12/1.
//  Copyright © 2015年 Grey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;//数据上下文
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;//数据模型
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;//数据持久化助理

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (NSManagedObjectContext *)managedObjectContext ;
- (NSManagedObjectModel *)managedObjectModel;


@end

