//
//  ViewController.m
//  1_Calculator
//
//  Created by Zachary Fleischman on 1/14/13.
//  Copyright (c) 2013 Zachary Fleischman. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorBrain.h"

@interface ViewController ()

@property (nonatomic) BOOL userIsEnteringNumber;
@property (nonatomic) BOOL userHasEnteredDecimal;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation ViewController

@synthesize display = _display, operationsDisplay = _operationsDisplay;
@synthesize userIsEnteringNumber = _userIsEnteringNumber;
@synthesize userHasEnteredDecimal = _userHasEnteredDecimal;
@synthesize  brain = _brain;

- (CalculatorBrain *)brain {
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}
- (IBAction)digitPressed:(UIButton*)sender {
    NSString *digit = [sender currentTitle];
    if(self.userIsEnteringNumber) {
        [self.display setText:[self.display.text stringByAppendingString:digit]];
    } else {
        self.display.text = digit;
        self.userIsEnteringNumber = YES;
    }
    [self.operationsDisplay setText:[self.operationsDisplay.text stringByAppendingString:digit] ];
}

- (IBAction)operationPressed:(UIButton *)sender {
    if(self.userIsEnteringNumber) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    [self.operationsDisplay setText:[self.operationsDisplay.text stringByAppendingString:[NSString stringWithFormat:@"%@ ", sender.currentTitle]] ];
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    if(self.userIsEnteringNumber) {
        [self.operationsDisplay setText:[self.operationsDisplay.text stringByAppendingString:@" "] ];
    } else {
        [self.operationsDisplay setText:[self.operationsDisplay.text stringByAppendingString:[NSString stringWithFormat:@"%@ ", self.display.text]] ];
    }
    self.userIsEnteringNumber = NO;
    self.userHasEnteredDecimal = NO;
}

- (IBAction)decimalPressed {
    if(!self.userHasEnteredDecimal) {
        [self.operationsDisplay setText:[self.operationsDisplay.text stringByAppendingString:@"."] ];
        if(self.userIsEnteringNumber) {
            [self.display setText:[self.display.text stringByAppendingString:@"."]];
        } else {
            self.display.text = @"0.";
            self.userIsEnteringNumber = YES;
        }
        self.userHasEnteredDecimal = YES;
    }
}

- (IBAction)clearPressed {
    self.display.text = @"0";
    self.operationsDisplay.text = @"";
    self.userIsEnteringNumber = NO;
    self.userHasEnteredDecimal = NO;
    [self.brain clear];
}
@end
