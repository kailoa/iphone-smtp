//
//  SMTPSenderAppDelegate.m
//  SMTPSender
//
//  Created by Ian Baird on 10/28/2008.
//
//  Copyright (c) 2008 Skorpiostech, Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "SMTPSenderAppDelegate.h"
#import "SMTPSenderViewController.h"
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"

@implementation SMTPSenderAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{    
	NSString *test_value = [[NSUserDefaults standardUserDefaults] stringForKey:MESSAGE_SIG_PREF_KEY];
	if (test_value == nil)
	{
        DEBUGLOG(@"No default values set, Creating...");
		// since no default values have been set (i.e. no preferences file created), create it here
		NSDictionary *app_defaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"receiver@example.com", TO_EMAIL_PREF_KEY,
                                      @"sender@example.com", FROM_EMAIL_PREF_KEY,
                                      @"mail.example.com", RELAY_HOST_PREF_KEY,
                                      [NSNumber numberWithBool:YES], USE_SSL_BOOL_PREF_KEY,
                                      [NSNumber numberWithBool:YES], USE_AUTH_BOOL_PREF_KEY,
                                      @"", AUTH_USERNAME_PREF_KEY,
                                      @"", AUTH_PASSWORD_PREF_KEY,
                                      @"Hello From Test App", MESSAGE_SUBJECT_PREF_KEY,
                                      @"There should be an image attachment that Says \"Success\".\n\n", MESSAGE_BODY_PREF_KEY,
                                      @"\n\nTest Unicode:☃,漢字", MESSAGE_SIG_PREF_KEY,
                                      [NSNumber numberWithBool:YES], SEND_IMAGE_BOOL_PREF_KEY,
                                      [NSNumber numberWithBool:NO], SEND_VCARD_BOOL_PREF_KEY,
									  nil];
		
		[[NSUserDefaults standardUserDefaults] registerDefaults:app_defaults];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

@end
