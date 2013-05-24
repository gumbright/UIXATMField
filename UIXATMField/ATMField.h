//
//  UIXATMField.h
//  UIXATMField
//
//  Created by Guy Umbright on 8/23/11.
//  Copyright 2011 Kickstand Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATMField;

@protocol UIXATMFieldDelegate

- (BOOL)currencyTextFieldShouldEndEditing:(ATMField *)currencyTextField;

@end

@interface ATMField : UIView <UITextFieldDelegate>

@property (nonatomic, retain) UIColor* textColor;
@property (nonatomic, retain) UIColor* backgroundColor;
@property (nonatomic, retain) UIFont* font;
@property (nonatomic, assign) CGFloat caretWidth;

//@property (nonatomic, assign) NSDecimalNumber* value;
@property (nonatomic, assign) float value;
@property (unsafe_unretained, nonatomic, readonly) NSDecimalNumber* decimalValue;
@property (nonatomic, unsafe_unretained) NSObject<UIXATMFieldDelegate>* delegate;
//font
//textcolor
//background
//alignment
//force locale?

- (void) setDecimalValue:(NSDecimalNumber *)decimalValue;

- (void) handleBecomeFirstResponder;
- (void) handleResignFirstResponder;


- (NSDecimalNumber*) floatToAppropriateNSDecimalNumber:(float) f;

@end
