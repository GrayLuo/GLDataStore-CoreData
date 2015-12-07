//
//  ViewController.m
//  GLDataStore-CoreData
//
//  Created by hyq on 15/12/1.
//  Copyright © 2015年 Grey. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Group.h"
#import "User.h"
#import <sqlite3.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self insertCoreDataTest2];
//    [self fetchDataTest2];
    
//    [self fmdbTest];
    [self fmdbQueueTest];
}

- (void)insertCoreDataTest2{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    user.id = @111;
    user.name = @"Grey.Luo";
    user.address = @"成都高新区";
    user.age = @18;
    
    Group *group = [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:context];
    group.id = @199;
    group.name = @"无线事业部";
    
    user.group = group;
    group.user = user;
    
    NSError *error;
    if(![context save:&error]){
        NSLog(@"Core Data save error:%@",[error localizedDescription]);
    }
}
- (void)fetchDataTest2{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (User *user in fetchedObjects) {
        NSLog(@"id:%@",user.id);
        NSLog(@"name:%@",user.name);
        NSLog(@"age:%@",user.age);
        NSLog(@"address:%@",user.address);
        
        Group *group = user.group;
        
        NSLog(@"group id:%@",group.id);
        NSLog(@"group name:%@",group.name);
    }

}
- (void)insertCoreDataTest{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    NSManagedObject *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    [user setValue:@"罗国辉" forKey:@"name"];
    [user setValue:@18 forKey:@"age"];
    [user setValue:@"成都高新区" forKey:@"address"];
    [user setValue:@"1449210815" forKey:@"created_at"];
    [user setValue:@101 forKey:@"id"];
    
    NSManagedObject *group = [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:context];
    [group setValue:@"研发组" forKey:@"name"];
    [group setValue:@222 forKey:@"id"];
    
    //Relationship
    [user setValue:group forKey:@"group"];
    [group setValue:user forKey:@"user"];
    
    //Save
    NSError *error;
    if(![context save:&error]){
        NSLog(@"Core Data save error:%@",[error localizedDescription]);
    }
    NSLog(@"insert core data completed..................");
}

- (void)fetchDataTest{
    NSLog(@"fetch core data test..................");
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *user in fetchedObjects) {
        NSLog(@"id:%@",[user valueForKey:@"id"]);
        NSLog(@"name:%@",[user valueForKey:@"name"]);
        NSLog(@"age:%@",[user valueForKey:@"age"]);
        NSLog(@"address:%@",[user valueForKey:@"address"]);
        NSLog(@"address:%@",[user valueForKey:@"address"]);
        
        NSManagedObject *group = [user valueForKey:@"group"];
        
        NSLog(@"group Id:%@",[group valueForKey:@"id"]);
        NSLog(@"group Name:%@",[group valueForKey:@"name"]);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Sqlite

- (void)sqliteTest{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    sqlite3 *db;
    NSString *database_path = [documents stringByAppendingPathComponent:@"sqliteTest.sqlite"];
    NSLog(@"database path:%@",database_path);
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"Open DB Error");
    }
    
    //create table
    NSString *sql_drop = @"drop table if exists `User`";
    NSString *sql_create = @"create table `User`(`id` INTEGER not null PRIMARY KEY AUTOINCREMENT,`name` varchar(32) not null,`age` int(11) not null,`address` varchar(255),`group_id` int(11) not NULL, FOREIGN KEY(`group_id`) REFERENCES `group`(id))";
    
    NSString *sql_drop2 = @"drop table if exists `Group`";
    NSString *sql_create2 = @"create table `Group`(`id` INTEGER not null PRIMARY KEY AUTOINCREMENT, `name` varchar(32) not null)";
    
    [self execSql:sql_drop db:db];
    [self execSql:sql_create db:db];
    
    [self execSql:sql_drop2 db:db];
    [self execSql:sql_create2 db:db];
    
    //insert data test
    NSString *sql_insert = @"insert into 'Group'('name') values('研发组')";
    NSString *sql_insert2 = [NSString stringWithFormat:@"insert into `User` (`name`,`age`,`address`,`group_id`) values ('%@','%@','%@','%@')",@"Grey.Luo",@"18",@"成都高新",@1];
    
    [self execSql:sql_insert db:db];
    [self execSql:sql_insert2 db:db];
    
    //read data
    
    NSString *query_sql = @"select * from User";
    sqlite3_stmt *statement = nil;
    
    if(sqlite3_prepare_v2(db, [query_sql UTF8String], -1, &statement, NULL) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int uid = sqlite3_column_int(statement, 0);
            
            char *name = (char *)sqlite3_column_text(statement, 1);
            NSString *nameOb = [NSString stringWithFormat:@"%s",name];
            
            NSLog(@"id:%d,name:%@",uid,nameOb);
        }
    }
    sqlite3_close(db);
}


- (void)execSql:(NSString *)sql db:(sqlite3 *)db{
    char *error;
    if(sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error) != SQLITE_OK){
        sqlite3_close(db);
        NSLog(@"exec sql error:%s",error);
    }
}

#pragma mark - FMDB
- (void)fmdbTest{
    //
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:@"sqliteTest2.sqlite"];

    FMDatabase *db = [FMDatabase databaseWithPath:database_path];
    if(![db open]){
        NSLog(@"Open db failed");
        return;
    }
    //
    NSString *sql_drop = @"drop table if exists `User`";
    NSString *sql_create = @"create table `User`(`id` INTEGER not null PRIMARY KEY AUTOINCREMENT,`name` varchar(32) not null,`age` int(11) not null,`address` varchar(255),`group_id` int(11) not NULL, FOREIGN KEY(`group_id`) REFERENCES `group`(id))";
    if (![db executeUpdate:sql_drop]) {
        NSLog(@"execupdate error:%@",sql_drop);
    }
    if(![db executeUpdate:sql_create]){
        NSLog(@"execupdate error:%@",sql_create);
    }
    
    NSString *sql_drop2 = @"drop table if exists `Group`";
    NSString *sql_create2 = @"create table `Group`(`id` INTEGER not null PRIMARY KEY AUTOINCREMENT, `name` varchar(32) not null)";
    if (![db executeUpdate:sql_drop2]) {
        NSLog(@"execupdate error:%@",sql_drop2);
    }
    if(![db executeUpdate:sql_create2]){
        NSLog(@"execupdate error:%@",sql_create2);
    }
    
    //
    NSString *sql_insert = @"insert into 'Group'('name') values('研发组')";
    NSString *sql_insert2 = [NSString stringWithFormat:@"insert into `User` (`name`,`age`,`address`,`group_id`) values ('%@','%@','%@','%@')",@"Grey.Luo",@"18",@"成都高新",@1];
    if (![db executeUpdate:sql_insert]) {
        NSLog(@"execupdate error:%@",sql_insert);
    }
    if(![db executeUpdate:sql_insert2]){
        NSLog(@"execupdate error:%@",sql_insert2);
    }
    //
    NSString *querySql = @"select * from User";
    FMResultSet *rs = [db executeQuery:querySql];
    while ([rs next]) {
        int uid = [rs intForColumn:@"id"];
        NSString *name = [rs stringForColumn:@"name"];
        int age = [rs intForColumn:@"age"];
        NSString *address = [rs stringForColumn:@"address"];
        int groupId = [rs intForColumn:@"group_id"];
        NSLog(@"%d-%@-%d-%@-%d",uid,name,age,address,groupId);
    }
    //
    
    
    //
    [db close];
}
- (void)fmdbQueueTest{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:@"sqliteTest2.sqlite"];

    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:database_path];
    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
    dispatch_queue_t q2 = dispatch_queue_create("queue2", NULL);
    dispatch_async(q1, ^{
        for (int i = 0; i< 100; i++) {
            [queue inDatabase:^(FMDatabase *db) {
                NSString *sql_insert = @"insert into 'Group'('name') values('研发组')";
                NSString *sql_insert2 = [NSString stringWithFormat:@"insert into `User` (`name`,`age`,`address`,`group_id`) values ('%@','%@','%@','%@')",@"Grey.Luo",@"18",@"成都高新",@1];
                if([db executeUpdate:sql_insert]){
                    NSLog(@"[1]insert into data:%@",sql_insert);
                }
                if([db executeUpdate:sql_insert2]){
                    NSLog(@"[1]insert into data:%@",sql_insert2);
                }
            }];
        }
    });
    
    dispatch_async(q2, ^{
        for (int i = 0; i< 100; i++) {
            [queue inDatabase:^(FMDatabase *db) {
                NSString *sql_insert = @"insert into 'Group'('name') values('研发组')";
                NSString *sql_insert2 = [NSString stringWithFormat:@"insert into `User` (`name`,`age`,`address`,`group_id`) values ('%@','%@','%@','%@')",@"Grey.Luo",@"18",@"成都高新",@1];
                if([db executeUpdate:sql_insert]){
                    NSLog(@"[2]insert into data:%@",sql_insert);
                }
                if([db executeUpdate:sql_insert2]){
                    NSLog(@"[2]insert into data:%@",sql_insert2);
                }
            }];
        }
    });
}
@end
