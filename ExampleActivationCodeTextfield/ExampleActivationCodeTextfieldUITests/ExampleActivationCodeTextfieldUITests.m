//
//  ExampleActivationCodeTextfieldUITests.m
//  ExampleActivationCodeTextfieldUITests
//
//  Created by Sandeep Aggarwal on 08/04/17.
//
//

#import <XCTest/XCTest.h>
#import <SACodedTextField/ActivationCodeTextField.h>

@interface ExampleActivationCodeTextfieldUITests : XCTestCase

@end

@implementation ExampleActivationCodeTextfieldUITests

- (void)setUp
{
    [super setUp];
    
    self.continueAfterFailure = NO;
    [[[XCUIApplication alloc] init] launch];
    [XCUIDevice sharedDevice].orientation = UIDeviceOrientationPortrait;
    
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testLabelVisibilityUponEnteringText
{
    XCUIApplication* app = [[XCUIApplication alloc] init];
    XCUIElement *textField = [[app.otherElements containingType:XCUIElementTypeStaticText identifier:@"Please enter the 6 digit code below:"] childrenMatchingType:XCUIElementTypeTextField].element;
   
    [textField typeText:@"1"];
    [textField typeText:@"2"];
    [textField typeText:@"3"];
    [textField typeText:@"4"];
    [textField typeText:@"5"];
    [textField typeText:@"6"];
    
    NSMutableString* outputString = [NSMutableString new];
    NSString* minSpaceString = @"   ";
    for (NSInteger i = 1; i <= 6; i++)
    {
        [outputString appendFormat:@"%@", [NSString stringWithFormat:@"%ld%@",i,minSpaceString]];
    }
    
    XCTAssert([[[textField
                childrenMatchingType:(XCUIElementTypeAny)] elementMatchingType:(XCUIElementTypeAny) identifier:@"ACTPlaceholderLabel"].value isEqualToString:outputString]);
}

- (void)testLabelVisibilityUponEnteringTextHavingLengthGreaterThanAllowedLength
{
    XCUIApplication* app = [[XCUIApplication alloc] init];
    XCUIElement *textField = [[app.otherElements containingType:XCUIElementTypeStaticText identifier:@"Please enter the 6 digit code below:"] childrenMatchingType:XCUIElementTypeTextField].element;
    
    [textField typeText:@"1"];
    [textField typeText:@"2"];
    [textField typeText:@"3"];
    [textField typeText:@"4"];
    [textField typeText:@"5"];
    [textField typeText:@"6"];
    [textField typeText:@"7"];
    
    NSMutableString* outputString = [NSMutableString new];
    NSString* minSpaceString = @"   ";
    for (NSInteger i = 1; i <= 6; i++)
    {
        [outputString appendFormat:@"%@", [NSString stringWithFormat:@"%ld%@",i,minSpaceString]];
    }
    
    XCTAssert([[[textField
                 childrenMatchingType:(XCUIElementTypeAny)] elementMatchingType:(XCUIElementTypeAny) identifier:@"ACTPlaceholderLabel"].value isEqualToString:outputString]);
}


@end
