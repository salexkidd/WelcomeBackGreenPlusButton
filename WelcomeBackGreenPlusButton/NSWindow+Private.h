//
//  NSWindow+Private.h
//  WelcomeBackPlusButton
//
//  Created by salexkidd on 2018/08/31.
//  Copyright © 2018年 salexkidd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow (Private)

- (CGRect)_frameForFullScreenMode;

- (CGRect)_tileFrameForFullScreen;

@end
