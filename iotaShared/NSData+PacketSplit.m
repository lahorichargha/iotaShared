//
//  NSData+PacketSplit.m
//  iotaShared
//
//  Created by Martin Wehlou on 2011-09-23.
//  Copyright (c) 2011 MITM AB. All rights reserved.
//

#import "NSData+PacketSplit.h"

@implementation NSData (PacketSplit)

- (NSArray *)splitTransferredPackets:(NSData **)leftover {
    NSMutableArray *ret = [NSMutableArray array];
    const unsigned char *beginning = [self bytes];
    const unsigned char *offset = [self bytes];
    NSInteger bytesEnd = (NSInteger)offset + [self length];
    
    while ((NSInteger)offset < bytesEnd) {
        uint64_t dataSize[1];
        NSInteger dataSizeStart = offset - beginning;
        NSInteger dataStart = dataSizeStart + sizeof(uint64_t);
        
        NSRange headerRange = NSMakeRange(dataSizeStart, sizeof(uint64_t));
        [self getBytes:dataSize range:headerRange];
        
        if ((dataStart + dataSize[0] + (NSInteger)offset) > bytesEnd) {
            NSInteger lengthOfRemainingData = [self length] - dataSizeStart;
            NSRange dataRange = NSMakeRange(dataSizeStart, lengthOfRemainingData);
            *leftover = [self subdataWithRange:dataRange];
            return ret;
        }
        
        NSRange dataRange = NSMakeRange(dataStart, dataSize[0]);
        NSData *parsedData = [self subdataWithRange:dataRange];
        
        [ret addObject:parsedData];
        offset = offset + dataSize[0] + sizeof(uint64_t);
    }
    return ret;
}

@end
