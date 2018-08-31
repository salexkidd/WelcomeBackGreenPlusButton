//  RuntimeHandler.h
//  Created by salexkidd on 2018/08/31.
//  Reference from https://qiita.com/marty-suzuki/items/48b57f54fc65abaf145b

#import "RuntimeHandler.h"

@implementation _RuntimeHandler

+ (void)handleLoad {
    NSLog(@"Please override RuntimeHandler.handleLoad if you want to use");
}

+ (void)handleInitialize {
    NSLog(@"Please override RuntimeHandler.handleInitialize if you want to use");
}

@end

@implementation RuntimeHandler

+ (void)initialize {
    [super initialize];
    [self handleInitialize];
}

+ (void)load {
    [super load];
    [self handleLoad];
}

@end
