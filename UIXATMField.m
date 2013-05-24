//
//  UIXATMField.m
//  UIXATMFieldDemo
//
//  Created by Guy Umbright on 5/23/13.
//  Copyright (c) 2013 Salesforce.com. All rights reserved.
//

#import "UIXATMField.h"

@implementation UIXATMField

- (void) commonInit
{
    self.textAlignment = NSTextAlignmentRight;
    self.keyboardType = UIKeyboardTypeNumberPad;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void) awakeFromNib
{
    [self commonInit];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- 
////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
- (void) setDecimalValue:(NSDecimalNumber *)decValue
{
    NSDecimalNumber* scale = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:10] decimalValue]];
    scale = [scale decimalNumberByRaisingToPower:[self.formatter maximumFractionDigits]];
    NSDecimalNumber* num = [decValue decimalNumberByMultiplyingBy:scale];
    
    self.entryField.text = [num stringValue];
    [self updateDisplay];
    
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
- (NSDecimalNumber*) decimalValue
{
    NSDecimalNumber* num = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:[self.entryField.text intValue]] decimalValue]];
    NSDecimalNumber* scale = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:10] decimalValue]];
    scale = [scale decimalNumberByRaisingToPower:[self.formatter maximumFractionDigits]];
    num = [num decimalNumberByDividingBy:scale];
    
    return num;
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
- (NSDecimalNumber*) floatToAppropriateNSDecimalNumber:(float) value
{
    NSString* floatString = [NSString stringWithFormat:@"%f",value];
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                                      scale:[self.formatter maximumFractionDigits]
                                                                                           raiseOnExactness:FALSE
                                                                                            raiseOnOverflow:TRUE
                                                                                           raiseOnUnderflow:TRUE
                                                                                        raiseOnDivideByZero:TRUE];
    
    [self.formatter setNumberStyle:NSNumberFormatterNoStyle];
    NSNumber* n = [self.formatter numberFromString:floatString];
    [self.formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithDecimal:[n decimalValue]];
    
    NSDecimalNumber *roundedDecimalNumber = [decimalNumber decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return roundedDecimalNumber;
}

@end
