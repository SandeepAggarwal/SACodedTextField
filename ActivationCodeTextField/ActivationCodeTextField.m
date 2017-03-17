//
//  ActivationCodeTextField.m
//
//  Created by Sandeep Aggarwal on 16/03/17.
//  Copyright © 2017 Sandeep Aggarwal. All rights reserved.
//

#import "ActivationCodeTextField.h"

@interface ActivationCodeTextField ()

@property (nonatomic, strong) NSString* space;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSString* separator;
@property (nonatomic, strong) NSString* placeholderString;

@end

@implementation ActivationCodeTextField

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    self.space = @" ";
    self.customPlaceholder = @"_" ; //default value
    self.maxCodeLength = 6;  //default value
    
    
    UILabel *label = [UILabel new];
    [label setTextColor:[UIColor blackColor]];
    self.label = label;
    [self addSubview:label];
    [self sendSubviewToBack:label];
    
    self.tintColor = [UIColor clearColor]; //to avoid cursor blink
    self.keyboardType = UIKeyboardTypeNumberPad;
    
    self.textAlignment = NSTextAlignmentCenter;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textEditingChanged:) name:UITextFieldTextDidChangeNotification object:self];

    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.label.frame;
    frame.origin.x = self.bounds.origin.x;
    frame.origin.y = self.bounds.origin.y;
    frame.size.width = self.bounds.size.width;
    frame.size.height = self.bounds.size.height;
    self.label.frame = frame;
    
    _separator = nil;
    [self updateLabelWithPlaceHolderText];
}

#pragma mark - Public Methods

- (CGFloat) minWidthTextField
{
    CGFloat totalMaxWidthTakenByContent = [self totalMaxWidthTakenByContent];
    NSInteger numberOfSpacesRequired = 3 * (_maxCodeLength -1); 
    CGFloat totalWidthTakenbySpaces  = [self widthOfString:[self spaceString:self.space withNumberOfSpaces:numberOfSpacesRequired]];
    
    return (totalMaxWidthTakenByContent + totalWidthTakenbySpaces);
}

#pragma mark - Overridden Methods

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.label.font = font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    
    self.label.textAlignment = textAlignment;
}

- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:[UIColor clearColor]]; //to avoid showing textfield text
    
    [self.label setTextColor:textColor];
}

#pragma mark - overridden accessors

- (NSString*)placeholderString
{
    if (!_placeholderString)
    {
        _placeholderString = [NSString stringWithFormat:@"%@%@",self.customPlaceholder , self.separator];
    }
    
    return _placeholderString;
}

- (NSString*)separator
{
    if (!_separator)
    {
        CGFloat totalMaxWidthTakenByContent = [self totalMaxWidthTakenByContent];
        
        CGFloat widthAllowed = self.label.bounds.size.width;
        CGFloat emptySpaceLeft = widthAllowed - totalMaxWidthTakenByContent;
        NSInteger numGaps = _maxCodeLength - 1;
        CGFloat separatorWidth;
        if (emptySpaceLeft > 0)
        {
            separatorWidth = emptySpaceLeft/(numGaps * 1.0f);
            _separator = [self spaceString: self.space withWidth:separatorWidth];
        }
        else
        {
            _separator = @"";
        }
    }
    
    return _separator;
}


#pragma mark - Private Methods

- (void)textEditingChanged:(NSNotification *)notification
{
    UITextField* textField = notification.object;
    if (textField != self)
    {
        return;
    }
    
    NSInteger textLength = textField.text.length;
    if (textLength > _maxCodeLength)
    {
        textField.text = [textField.text substringToIndex:(_maxCodeLength)];
    }
    else
    {
        [self updateLabelWithPlaceHolderText];
    }
}

- (void)updateLabelWithPlaceHolderText
{
    NSString* textFieldText = self.text;
    NSInteger textLength = textFieldText.length;
    if (textLength > _maxCodeLength)
    {
        return;
    }
    
    NSMutableString* labelText = [NSMutableString stringWithString:@""];
    NSArray<NSString*>*  numbersArray = [self numbersFromString:textFieldText];
    for (NSString* numberString in numbersArray)
    {
        [labelText appendString:[NSString stringWithFormat:@"%@%@",numberString,self.separator]];
    }
    
    
    for (NSInteger i = textLength; i < _maxCodeLength; i++)
    {
        [labelText appendString:self.placeholderString];
    }
    [self.label setText:labelText];
}

- (NSArray<NSString*>*)numbersFromString:(NSString*)string
{
    if (string.length == 0)
    {
        return nil;
    }
    
    NSMutableArray* array = [NSMutableArray new];
    NSInteger stringLength = string.length;
    for (NSInteger i = 0; i < stringLength; i++)
    {
        unsigned int character = [string characterAtIndex:i];
        [array addObject:[NSString stringWithFormat:@"%C",(unichar)character]];
    }
    
    return array;
}

- (CGFloat)totalMaxWidthTakenByContent
{
    CGFloat maxWidth = [self maxWidthTakenByAnyNumber];
    
    CGFloat customPlaceholderWidth = [self widthOfString:self.customPlaceholder];
    if (customPlaceholderWidth > maxWidth)
    {
        maxWidth = customPlaceholderWidth;
    }
    
    CGFloat totalMaxWidthTakenByContent = maxWidth * _maxCodeLength;
    
    return totalMaxWidthTakenByContent;
}

- (CGFloat)maxWidthTakenByAnyNumber
{
    CGFloat maxWidth = 0.0f;
    
    CGFloat width;
    NSString* string;
    for (NSInteger i = 0; i < 10; i++)
    {
        string = [NSString stringWithFormat:@"%ld",(long)i];
        width = [self widthOfString:string];
        if (width > maxWidth)
        {
            maxWidth = width;
        }
    }
    
    return maxWidth;
}

- (CGFloat)widthOfString:(NSString*)string
{
    NSDictionary *attr = [NSDictionary dictionaryWithObject:[self font]
                                                     forKey:NSFontAttributeName];
    CGSize stringSize = [string sizeWithAttributes:attr];
   
    return stringSize.width;
}

- (NSString*)spaceString:(NSString*)spaceString withNumberOfSpaces:(NSInteger)numSpaces
{
    NSMutableString* finalString = [NSMutableString new];
    for (NSInteger i = 0; i < numSpaces; i++)
    {
        [finalString appendString:spaceString];
    }
    
    return finalString;
}

- (NSString*)spaceString:(NSString*)spaceString withWidth:(CGFloat)width
{
    CGFloat spaceStringwidth = [self widthOfString:spaceString];
    
    NSInteger numberOfSpacesRequired = floorf(width/spaceStringwidth);
    
    return [self spaceString:spaceString withNumberOfSpaces:numberOfSpacesRequired];
}


@end
