//  RuntimeHandler.h
//  Created by salexkidd on 2018/08/31.
//  Reference from https://qiita.com/marty-suzuki/items/48b57f54fc65abaf145b

#import <Foundation/Foundation.h>

@interface _RuntimeHandler : NSObject

+ (void)handleLoad;

+ (void)handleInitialize;

@end


@interface RuntimeHandler: _RuntimeHandler
@end
