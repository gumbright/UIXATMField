//
//  UIXATMField.m
//  UIXATMFieldDemo
//
//  Created by Guy Umbright on 5/23/13.
//  Copyright (c) 2013 Salesforce.com. All rights reserved.
//

#import "UIXATMField.h"

@interface UIXATMField () <UITextFieldDelegate>
@property (nonatomic, strong) NSNumberFormatter* formatter;
@property (nonatomic, strong) NSString* actualStringValue;
@property (nonatomic, assign) NSUInteger fractionDigits;
@property (nonatomic, strong) NSCharacterSet* validationCharacterSet;
@end

@implementation UIXATMField

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) commonInit
{
    self.textAlignment = NSTextAlignmentRight;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:self];
    
    self.delegate = self;
    self.actualStringValue = @"";
    
    self.fractionDigits = 0;
    
    self.validationCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    [self contentChanged:nil];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame andMode:(UIXATMFieldMode)mode
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _mode = mode;
        switch (_mode)
        {
            case UIXATMFieldModeCurrentCurrency:
            {
                [self setCurrencyMode];
            }
                break;
                
            case UIXATMFieldModePercentage:
            {
                [self setPercentMode];
            }
                break;
                
            default:
                break;
        }

        [self commonInit];
    }
    return self;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) awakeFromNib
{
    [self commonInit];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) setCurrencyMode
{
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.rightView = nil;
    
    self.formatter = [[NSNumberFormatter alloc] init];
    self.formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    _numDecimalDigits = [self.formatter maximumFractionDigits];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) setPercentMode
{
    self.keyboardType = UIKeyboardTypeNumberPad;
    
    UILabel* l = [[UILabel alloc] initWithFrame:CGRectZero];
    l.text = @"%";
    l.font = self.font;
    l.textColor = self.textColor;
    l.backgroundColor = [UIColor clearColor];  //black box if set to bg of self
    [l sizeToFit];
    self.rightView = l;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    self.formatter = [[NSNumberFormatter alloc] init];
    self.formatter.numberStyle = NSNumberFormatterDecimalStyle;
    self.formatter.maximumFractionDigits = self.fractionDigits;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) setMode:(UIXATMFieldMode)mode
{
    _mode = mode;
    
    switch (_mode)
    {
        case UIXATMFieldModeCurrentCurrency:
        {
            [self setCurrencyMode];
        }
            break;
            
        case UIXATMFieldModePercentage:
        {
            [self setPercentMode];
        }
            break;
            
        default:
            break;
    }
    [self updateCurrentValue];
    [self updateDisplay];
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

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
//- (void) setDecimalValue:(NSDecimalNumber *)decValue
//{
//    NSDecimalNumber* scale = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:10] decimalValue]];
//    scale = [scale decimalNumberByRaisingToPower:[self.formatter maximumFractionDigits]];
//    NSDecimalNumber* num = [decValue decimalNumberByMultiplyingBy:scale];
//    
//    self.entryField.text = [num stringValue];
//    [self updateDisplay];
//    
//}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
//- (NSDecimalNumber*) decimalValue
//{
//    NSDecimalNumber* num = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:[self.entryField.text intValue]] decimalValue]];
//    NSDecimalNumber* scale = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:10] decimalValue]];
//    scale = [scale decimalNumberByRaisingToPower:[self.formatter maximumFractionDigits]];
//    num = [num decimalNumberByDividingBy:scale];
//    
//    return num;
//}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
//- (NSDecimalNumber*) floatToAppropriateNSDecimalNumber:(float) value
//{
//    NSString* floatString = [NSString stringWithFormat:@"%f",value];
//    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
//                                                                                                      scale:[self.formatter maximumFractionDigits]
//                                                                                           raiseOnExactness:FALSE
//                                                                                            raiseOnOverflow:TRUE
//                                                                                           raiseOnUnderflow:TRUE
//                                                                                        raiseOnDivideByZero:TRUE];
//    
//    [self.formatter setNumberStyle:NSNumberFormatterNoStyle];
//    NSNumber* n = [self.formatter numberFromString:floatString];
//    [self.formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
//    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithDecimal:[n decimalValue]];
//    
//    NSDecimalNumber *roundedDecimalNumber = [decimalNumber decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
//    return roundedDecimalNumber;
//}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
- (void) updateDisplay
{
    if (self.text.length == 0)
    {
        self.text = [self.formatter stringFromNumber:[NSNumber numberWithFloat:0.0]];
    }
    else
    {
        self.text = [self.formatter stringFromNumber:self.decimalValue];
    }
}

////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////
- (void) contentChanged:(NSNotification*) notification
{
    [self updateCurrentValue];
    [self updateDisplay];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) updateCurrentValue
{
    NSDecimalNumber* num;
    if (self.actualStringValue.length == 0)
    {
        num = [NSDecimalNumber zero];
    }
    else
    {
        num = [NSDecimalNumber decimalNumberWithString:self.actualStringValue];
    }
    
    NSDecimalNumber* scale = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithInt:10] decimalValue]];
    scale = [scale decimalNumberByRaisingToPower:self.numDecimalDigits];
    _decimalValue = [num decimalNumberByDividingBy:scale];
    
    if (self.mode == UIXATMFieldModePercentage)
    {
        [_decimalValue decimalNumberByMultiplyingByPowerOf10:-2];
    }
    
//    [self updateFloatValue];
    
    NSLog(@"float=%f dec=%@",self.value, self.decimalValue);
    
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
//- (void) updateFloatValue
//{
//    double d = [self.decimalValue doubleValue];
//    _value = (float) d;
//}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) actualFromDecimal
{
    NSString* s = [self.decimalValue stringValue];
    
    NSCharacterSet* set = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray* arr = [s componentsSeparatedByCharactersInSet:set];
    NSString* newActual = [arr componentsJoinedByString:@""];
    self.actualStringValue  = newActual;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //first lets make sure we have no inappropriate characters
    
    if ([string rangeOfCharacterFromSet:self.validationCharacterSet].location != NSNotFound)
    {
        //invalid char - dont do nothing
        NSLog(@"Oh no you dont -- %@",string);
        return NO;
    }
    
    NSRange modRange;
    BOOL update = YES;
    
    if (range.length == 1)
    {
        if (self.actualStringValue.length == 0)
        {
            update = NO;
        }
        else
        {
            modRange = NSMakeRange(self.actualStringValue.length-1, range.length);
        }
        
    }
    else
    {
        //adjust by the diff between field & actual
        NSInteger diff = self.text.length - self.actualStringValue.length;
        modRange = NSMakeRange(range.location - diff, range.length);
    }
    
    if (update)
    {
        NSLog(@"range=%@ repl=<%@> -- modRange=%@ currentText=%@ actual=%@",NSStringFromRange(range),string,NSStringFromRange(modRange),self.text,self.actualStringValue);
        self.actualStringValue = [self.actualStringValue stringByReplacingCharactersInRange:modRange withString:string];
        [self updateCurrentValue];
        [self updateDisplay];
    }
    return NO;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) setValue:(float)value
{
    self.decimalValue = [NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithFloat:value] decimalValue]];
    
//    [self updateDisplay];
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (float) getValue
{
    double d = [self.decimalValue doubleValue];
    return (float) d;
}

/////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////
- (void) setDecimalValue:(NSDecimalNumber *)decimalValue
{
    _decimalValue = [decimalValue copy];
    
    [self actualFromDecimal];
//    [self updateFloatValue];
    [self updateDisplay];
}
@end
