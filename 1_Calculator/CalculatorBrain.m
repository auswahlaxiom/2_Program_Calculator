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

@property (nonatomic, strong) NSMutableArray *programStack;

@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack {
    if(_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}
-(void) clear {
    [self.programStack removeAllObjects];
}
- (void)pushOperand: (double)operand {

    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
    
}
- (double)performOperation: (NSString *)operation {
    [self.programStack addObject:operation];
    
    return [CalculatorBrain runProgram:self.program];
}

- (id)program {
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program {
    NSMutableArray *stack;
    NSMutableString *description;
    if([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    description = [[self popStringDescriptionOffStack:stack intoString:description] mutableCopy];
    if([description characterAtIndex:0] == '(' && [description characterAtIndex:[description length]-1] == ')' ) {
        [description deleteCharactersInRange:NSMakeRange(0, 1)];
        [description deleteCharactersInRange:NSMakeRange([description length]-1, 1)];
    }
    return description;
}
+ (NSString *)popStringDescriptionOffStack:(NSMutableArray *)stack intoString:(NSString *)description {
    id topOfStack = [stack lastObject];
    if(topOfStack) [stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        //NSLog([NSString stringWithFormat:@"recieved: %@", operation]);
        
        if([operation isEqualToString:@"+"]) {
            NSString *firstPart = [self popStringDescriptionOffStack:stack intoString:description];
            description =[NSString stringWithFormat:@"(%@ %@ %@)", [self popStringDescriptionOffStack:stack intoString:description], operation, firstPart];
        } else if([@"*" isEqualToString:operation]) {
            NSString *firstPart = [self popStringDescriptionOffStack:stack intoString:description];
            description =[NSString stringWithFormat:@"%@ %@ %@", [self popStringDescriptionOffStack:stack intoString:description], operation, firstPart];
        } else if([operation isEqualToString:@"/"]) {
            NSString *subtravisor = [self popStringDescriptionOffStack:stack intoString:description];
            if(subtravisor) description =[NSString stringWithFormat:@"%@ %@ %@", [self popStringDescriptionOffStack:stack intoString:description], operation, subtravisor];
        }else if([operation isEqualToString:@"-"]) {
            NSString *subtravisor = [self popStringDescriptionOffStack:stack intoString:description];
            if(subtravisor) description =[NSString stringWithFormat:@"(%@ %@ %@)", [self popStringDescriptionOffStack:stack intoString:description], operation, subtravisor];

        } else if([operation isEqualToString:@"sin"] || [operation isEqualToString:@"cos"] || [operation isEqualToString:@"√"]) {
            description =[NSString stringWithFormat:@"%@(%@)", operation, [self popStringDescriptionOffStack:stack intoString:description]];
        } else if([operation isEqualToString:@"sqrt"]) {
            description =[NSString stringWithFormat:@"√(%@)", [self popStringDescriptionOffStack:stack intoString:description]];
        }else if([operation isEqualToString:@"π"] || [operation isEqualToString:@"pi"]) {
            description = @"π";
        } else if([operation isEqualToString:@"+/-"]) {
            description =[NSString stringWithFormat:@"-%@", [self popStringDescriptionOffStack:stack intoString:description]];
        } else {
            return operation; //in this case it's a variable, just return it
        }
    } else if([topOfStack isKindOfClass:[NSNumber class]]) {
        NSNumber *operand = topOfStack;
       // NSLog([NSString stringWithFormat:@"recieved: %@", [operand stringValue]]);
        return [operand stringValue];
    }
    //NSLog([NSString stringWithFormat:@"current description: %@", description]);
    return description;
}
+ (double)runProgram:(id)program {
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues {
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    //replace all variables with their values
    for(int i = 0; i < stack.count; i++) {
        if ([variableValues objectForKey:[stack objectAtIndex:i]] != nil) {
            [stack replaceObjectAtIndex:i withObject:
             [variableValues objectForKey:[stack objectAtIndex:i]]];
        }
    }
    //execute program normally now
    return [self popOperandOffStack:stack];
}
+ (double)popOperandOffStack:(NSMutableArray *)stack {
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if(topOfStack) [stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if([@"*" isEqualToString:operation]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffStack:stack];
            if(divisor) result =  [self popOperandOffStack:stack] / divisor;
        } else if([operation isEqualToString:@"sin"]) {
            double op = [self popOperandOffStack:stack];
            result = sin(op);
        } else if([operation isEqualToString:@"cos"]) {
            double op = [self popOperandOffStack:stack];
            result = cos(op);
        } else if([operation isEqualToString:@"√"] || [operation isEqualToString:@"sqrt"]) { //square root symbol: √
            double op = [self popOperandOffStack:stack];
            if(op >= 0) {
                result = sqrt(op);
            } else {
                result = 0;
            }
        } else if([operation isEqualToString:@"π"] || [operation isEqualToString:@"pi"]) {
            result = M_PI;
        } else if([operation isEqualToString:@"+/-"]) {
            result = -1 * [self popOperandOffStack:stack];
        }
    }

    return result;

}
    


@end
