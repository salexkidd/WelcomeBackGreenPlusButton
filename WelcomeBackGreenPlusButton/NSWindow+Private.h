//
//  NSWindow+Private.h
//  WelcomeBackGreenPlusButton
//
//  Created by salexkidd on 2018/08/31.
//  Copyright © 2018年 salexkidd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow (PrivateMethods)

- (CGRect)_frameForFullScreenMode;

- (CGRect)_tileFrameForFullScreen;

@end
