//
//  makeFile.m
//  ModelCoder
//
//  Created by 朱潮 on 14-8-14.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//

#import "MakeFile.h"
#define templateHUrl @"https://raw.githubusercontent.com/zhuchaowe/mojo-database/master/h.strings"
#define templateMUrl @"https://raw.githubusercontent.com/zhuchaowe/mojo-database/master/m.strings"
@implementation MakeFile

-(void)startWithArgv:(NSArray *)arguments{
    if(arguments.count < 4){
        NSLog(@" fileName location jsonUrl is needed");
        return;
    }
    NSString *fileName =  [arguments objectAtIndex:1];
    NSString *location =  [arguments objectAtIndex:2];
    NSString *jsonUrl = [arguments objectAtIndex:3];
    
    NSLog(@"%@ %@ %@",fileName,location,jsonUrl);
    self.path = location;
    NSString *json = [self getJSONWithURL:jsonUrl];
    NSMutableArray *array = [self checkProperty:json fileName:fileName];
    NSLog(@"%@",array);
    [self generateClass:json fileName:fileName];
}

-(NSMutableArray *)checkProperty:(NSString *)json fileName:(NSString *)fileName {
    NSDictionary *dict   = [json objectFromJSONString];
    if(dict == nil)
    {
        NSLog(@"json is invalid.");
        return nil;
    }
   return [self generateProperty:dict withName:fileName];
}

-(NSMutableArray *)generateProperty:(NSDictionary *)json withName:(NSString *)className;
{
    NSMutableArray *array = [NSMutableArray array];
    for(NSString *key in [json allKeys])
    {
        JsonValueType type = [self type:[json objectForKey:key]];
        switch (type) {
            case kString:
            {
                NSDictionary *dic =
                @{
                  @"jsonKey":key,
                  @"jsonType":@"string",
                  @"classKey":[NSString stringWithFormat:@"%@",key],
                  @"classType":@"NSString",
                  @"className":className
                  };
                [array addObject:[dic mutableCopy]];
            }
                break;
            case kNumber:
            {
                NSDictionary *dic =
                @{
                  @"jsonKey":key,
                  @"jsonType":@"number",
                  @"classKey":[NSString stringWithFormat:@"%@",key],
                  @"classType":@"NSNumber",
                  @"className":className
                  
                  };
                [array addObject:[dic mutableCopy]];
            }
                break;
            case kArray:
            {
                {
                    NSDictionary *dic =
                    @{
                      @"jsonKey":key,
                      @"jsonType":@"array",
                      @"classKey":[NSString stringWithFormat:@"%@",key],
                      @"classType":[NSString stringWithFormat:@"NSArray(%@)",[self uppercaseFirstChar:key]],
                      @"className":className
                      };
                    [array addObject:[dic mutableCopy]];
                    if([self isDataArray:[json objectForKey:key]])
                    {
                        [self generateProperty:[[json objectForKey:key] objectAtIndex:0]
                                      withName:[self uppercaseFirstChar:key]];
                    }
                }
                break;
            }
                break;
            case kDictionary:
            {
                NSDictionary *dic =
                @{
                  @"jsonKey":[self lowercaseFirstChar:key],
                  @"jsonType":@"object",
                  @"classKey":[NSString stringWithFormat:@"%@",key],
                  @"classType":[self uppercaseFirstChar:key],
                  @"className":className,
                  @"subClass":[self generateProperty:[json objectForKey:key]
                                            withName:[self uppercaseFirstChar:key]]
                  };
                [array addObject:[dic mutableCopy]];
            }
                break;
            case kBool:
            {
                NSDictionary *dic =
                @{
                  @"jsonKey":[self lowercaseFirstChar:key],
                  @"jsonType":@"bool",
                  @"classKey":[NSString stringWithFormat:@"%@",key],
                  @"classType":@"BOOL",
                  @"className":className
                  };
                [array addObject:[dic mutableCopy]];
            }
                break;
            default:
                break;
        }
    }
    return array;
}

-(NSString*)getJSONWithURL:(NSString *)strUrl{
    
    NSString *str = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:nil
                                                     error:nil];
    
    NSDictionary *json = [data objectFromJSONData];
    if(json != nil){
        return [json JSONStringWithOptions:JKSerializeOptionPretty error:nil];
    }else{
        return nil;
    }
}


//表示该数组内有且只有字典 并且 结构一致。
-(BOOL)isDataArray:(NSArray *)theArray
{
    if(theArray.count <=0 ) return NO;
    for(id item in theArray)
    {
        if([self type:item] != kDictionary)
        {
            return NO;
        }
    }
    
    NSMutableSet *newKeys = [NSMutableSet set];
    for(id item in theArray)
    {
        for(NSString *key in [item allKeys])
        {
            if(![newKeys containsObject:key]){
                [newKeys addObject:key];
            }
        }
    }
    return YES;
}


-(JsonValueType)type:(id)obj
{
    if([[obj className] isEqualToString:@"__NSCFString"] || [[obj className] isEqualToString:@"__NSCFConstantString"]) return kString;
    else if([[obj className] isEqualToString:@"__NSCFNumber"]) return kNumber;
    else if([[obj className] isEqualToString:@"__NSCFBoolean"])return kBool;
    else if([[obj className] isEqualToString:@"JKDictionary"])return kDictionary;
    else if([[obj className] isEqualToString:@"JKArray"])return kArray;
    return -1;
}

-(NSString *)typeName:(JsonValueType)type
{
    switch (type) {
        case kString:
            return @"NSString";
            break;
        case kNumber:
            return @"NSNumber";
            break;
        case kBool:
            return @"BOOL";
            break;
        case kArray:
        case kDictionary:
            return @"";
            break;
            
        default:
            break;
    }
}

-(NSString *)uppercaseFirstChar:(NSString *)str
{
    return [NSString stringWithFormat:@"%@%@",[[str substringToIndex:1] uppercaseString],[str substringWithRange:NSMakeRange(1, str.length-1)]];
}
-(NSString *)lowercaseFirstChar:(NSString *)str
{
    return [NSString stringWithFormat:@"%@%@",[[str substringToIndex:1] lowercaseString],[str substringWithRange:NSMakeRange(1, str.length-1)]];
}

-(void)generateClass:(NSString *)name forDic:(NSDictionary *)json
{
    //准备模板
    if([_templateH isEqualTo:@""] || _templateH == nil){
        _templateH =[NSMutableString stringWithContentsOfURL:[NSURL URLWithString:templateHUrl] encoding:NSUTF8StringEncoding error:nil];
        if([_templateH isEqualTo:@""] || _templateH == nil ){
            NSLog(@"%@ is empty",templateHUrl);
            return;
        }
    }
    
    if([_templateM isEqualTo:@""] || _templateM == nil){
        _templateM =[NSMutableString stringWithContentsOfURL:[NSURL URLWithString:templateMUrl] encoding:NSUTF8StringEncoding error:nil];
        if( [_templateM isEqualTo:@""] || _templateM == nil){
            NSLog(@"%@ is empty",templateMUrl);
            return;
        }
    }

    
    NSMutableString *templateM = [_templateM mutableCopy];
    NSMutableString *templateH = [_templateH mutableCopy];
    //.h
    //name
    //property
    NSMutableString *proterty = [NSMutableString string];
    NSMutableString *import = [NSMutableString string];
    
    for(NSString *key in [json allKeys])
    {
        JsonValueType type = [self type:[json objectForKey:key]];
        switch (type) {
            case kString:
            case kNumber:
                [proterty appendFormat:@"@property (nonatomic,strong) %@ *%@;\n",[self typeName:type],key];
                break;
            case kArray:
            {
                if([self isDataArray:[json objectForKey:key]])
                {
                    [proterty appendFormat:@"@property (nonatomic,strong) NSMutableArray *%@;\n",key];
                    [import appendFormat:@"\n#import \"%@Entity.h\"",[self uppercaseFirstChar:key]];
                    [self generateClass:[NSString stringWithFormat:@"%@Entity",[self uppercaseFirstChar:key]] forDic:[[json objectForKey:key]objectAtIndex:0]];
                }
            }
                break;
            case kDictionary:
                [proterty appendFormat:@"@property (nonatomic,strong) %@Entity *%@;\n",[self uppercaseFirstChar:key],key];
                [import appendFormat:@"\n#import \"%@Entity.h\"",[self uppercaseFirstChar:key]];
                [self generateClass:[NSString stringWithFormat:@"%@Entity",[self uppercaseFirstChar:key]] forDic:[json objectForKey:key]];
                
                break;
            case kBool:
                [proterty appendFormat:@"@property (nonatomic,assign) %@ %@;\n",[self typeName:type],key];
                break;
            default:
                break;
        }
    }
    
    [templateH replaceOccurrencesOfString:@"#name#"
                               withString:name
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateH.length)];
    [templateH replaceOccurrencesOfString:@"#import#"
                               withString:import
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateH.length)];
    [templateH replaceOccurrencesOfString:@"#property#"
                               withString:proterty
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateH.length)];
    
    //.m
    //name
    [templateM replaceOccurrencesOfString:@"#name#"
                               withString:name
                                  options:NSCaseInsensitiveSearch
                                    range:NSMakeRange(0, templateM.length)];
    
    
    //写文件
    NSLog(@"%@",[NSString stringWithFormat:@"%@/%@.h",_path,name]);
    [templateH writeToFile:[NSString stringWithFormat:@"%@/%@.h",_path,name]
                atomically:NO
                  encoding:NSUTF8StringEncoding
                     error:nil];
    [templateM writeToFile:[NSString stringWithFormat:@"%@/%@.m",_path,name]
                atomically:NO
                  encoding:NSUTF8StringEncoding
                     error:nil];
    
    
}

- (void)generateClass:(NSString *)jsonString fileName:(NSString *)name {
    NSDictionary *json   = [jsonString objectFromJSONString];
    
    if(json == nil)
    {
        NSLog(@"json is invalid.");
        return;
    }
    [self generateClass:name forDic:json];
    NSLog(@"generate .h.m(ARC)files，put those to the folder");
}



@end
