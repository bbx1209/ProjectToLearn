//
//  AppDelegate.h
//  ChangeBar
//
//  Created by 程科 on 2016/12/5.
//  Copyright © 2016年 程科. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

