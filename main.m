//
//  main.m
//  Model
//
//  Created by 朱潮 on 14-8-14.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//     NSArray *arguments = @[@"123",@"Test",@"/Users/huwei/Desktop/objc",@"http://test-leway.zjseek.com.cn:8000/api/goods/listCategories"];

#import "MakeFile.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        MakeFile *make = [[MakeFile alloc] init];
        [make startWithArgv:[[NSProcessInfo processInfo] arguments]];
    }
    return 0;
}