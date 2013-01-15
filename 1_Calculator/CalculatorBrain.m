//
//  CalculatorBrain.m
//  1_Calculator
//
//  Created by Zachary Fleischman on 1/14/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import "CalculatorBrain.h"
#include <math.h>

@interface CalculatorBrain ()

@property (nonatomic, strong) NSMutableArray *operandStack;

@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack {
    if(_operandStack == nil) _operandStack = [[NSMutableArray alloc] init];
    return _operandStack;
}
-(void) clear {
    [self.operandStack removeAllObjects];
}
- (void)pushOperand: (double)operand {

    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
    
}
- (double)performOperation: (NSString *)operation {
    double result = 0;
    NSLog(@"operation performed: %@", operation);
    if([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    } else if([@"*" isEqualToString:operation]) {
        result = [self popOperand] * [self popOperand];
    } else if([operation isEqualToString:@"-"]) {
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    } else if([operation isEqualToString:@"/"]) {
        double divisor = [self popOperand];
        if(divisor) result =  [self popOperand] / divisor;
    } else if([operation isEqualToString:@"sin"]) {
        double op = [self popOperand];
        result = sin(op);
    } else if([operation isEqualToString:@"cos"]) {
        double op = [self popOperand];
        result = cos(op);
    } else if([operation isEqualToString:@"√"]) { //square root symbol: √
        double op = [self popOperand];
        if(op >= 0) {
            result = sqrt(op);
        } else {
            result = 0;
        }
    } else if([operation isEqualToString:@"π"]) {
        result = M_PI;
    }
    
    [self pushOperand:result];
    return result;
}

- (double)popOperand {
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

@end
