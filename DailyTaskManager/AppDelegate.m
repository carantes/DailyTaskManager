//
//  AppDelegate.m
//  DailyTaskManager
//
//  Created by Carlos Eduardo Arantes Ferreira on 26/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "AppDelegate.h"
#import "TaskListTableViewController.h"
#import "PersistentStack.h"
#import "Store.h"

@interface AppDelegate ()

@property (nonatomic, strong) PersistentStack *persistentStack;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption
{
    self.persistentStack = [[PersistentStack alloc] initWithStoreURL:self.storeURL modelURL:self.modelURL];
    self.managedObjectContext = self.persistentStack.managedObjectContext;
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.persistentStack.managedObjectContext save:nil];
}

#pragma mark - Core Data stack


- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL*)storeURL
{
    return [self.applicationDocumentsDirectory URLByAppendingPathComponent:@"DailyTaskManager.sqlite"];
}

- (NSURL*)modelURL
{
    return [[NSBundle mainBundle] URLForResource:@"DailyTaskManager" withExtension:@"momd"];
}

@end
