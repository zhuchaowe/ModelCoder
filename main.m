//
//  main.m
//  Model
//
//  Created by 朱潮 on 14-8-14.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdio.h>
#import "MakeFile.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSArray *arguments = [[NSProcessInfo processInfo] arguments];
        if(arguments.count < 4){
            NSLog(@" fileName location jsonUrl is needed");
            return 0;
        }
//        NSArray *arguments = @[@"123",@"Test",@"/Users/huwei/Desktop/objc",@"http://test-leway.zjseek.com.cn:8000/api/goods/listCategories"];
        NSString *fileName =  [arguments objectAtIndex:1];
        NSString *location =  [arguments objectAtIndex:2];
        NSString *jsonUrl = [arguments objectAtIndex:3];
        
        NSLog(@"%@ %@ %@",fileName,location,jsonUrl);
        MakeFile *make = [[MakeFile alloc] init];
        make.path = location;
        NSString *json = [make getJSONWithURL:jsonUrl];
        NSMutableArray *array = [make checkProperty:json fileName:fileName];
        NSLog(@"%@",array);
        
        [make generateClass:json fileName:fileName];
    }
    return 0;
}
