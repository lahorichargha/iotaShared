//
//  NSArray+PacketSend.m
//  iotaShared
//
//  Created by Martin Wehlou on 2011-09-23.
//  Copyright (c) 2011 MITM AB. All rights reserved.
//

#import "NSArray+PacketSend.h"

static NSString *kInvalidObjectException = @"Invalid Object Exception";

@implementation NSArray (PacketSend)

- (NSData *)contentsForTransfer {
    NSMutableData *ret = [NSMutableData data];
    for (NSData *oneData in self) {
        if (![oneData isKindOfClass:[NSData class]])
            [NSException raise:kInvalidObjectException format: @"arrayContentsForTransfer only supports instances of NSData"];

        uint64_t dataSize[1];
        dataSize[0] = [oneData length];
        [ret appendBytes:dataSize length:sizeof(uint64_t)];
        [ret appendBytes:[oneData bytes] length:[oneData length]];
    }
    return ret;
}

@end
