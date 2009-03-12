#import "SMTPSenderViewController.h"

@implementation SMTPSenderViewController

- (void)viewWillAppear:(BOOL)animated
{
    prefKeyDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                         toEmail, TO_EMAIL_PREF_KEY,
                         fromEmail, FROM_EMAIL_PREF_KEY,
                         relayHost, RELAY_HOST_PREF_KEY,
                         SSLSwitch, USE_SSL_BOOL_PREF_KEY,
                         useAuthSwitch, USE_AUTH_BOOL_PREF_KEY,
                         login, AUTH_USERNAME_PREF_KEY,
                         password, AUTH_PASSWORD_PREF_KEY,
                         subject, MESSAGE_SUBJECT_PREF_KEY,
                         messageBody, MESSAGE_BODY_PREF_KEY,
                         sig, MESSAGE_SIG_PREF_KEY,
                         sendImageSwitch, SEND_IMAGE_BOOL_PREF_KEY,
                         sendVCFSwitch, SEND_VCARD_BOOL_PREF_KEY,
                         nil];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *pref_keys = [NSArray arrayWithArray:[prefKeyDictionary allKeys]];
    for (id pref_key in pref_keys)
    {
        id ui_element = [prefKeyDictionary objectForKey:pref_key];
        if ([ui_element isKindOfClass:[UITextField class]])
        {
            ((UITextField *)ui_element).text = [defaults stringForKey:pref_key];
        }
        else if ([ui_element isKindOfClass:[UISwitch class]])
        {
            ((UISwitch *)ui_element).on = [defaults boolForKey:pref_key];
        }
    }

}

#pragma mark IBActions
- (IBAction)sendMail:(id)sender 
{
    SKPSMTPMessage *test_smtp_message = [[SKPSMTPMessage alloc] init];
    test_smtp_message.fromEmail = fromEmail.text;
    test_smtp_message.toEmail = toEmail.text;
    test_smtp_message.relayHost = relayHost.text;
    test_smtp_message.requiresAuth = useAuthSwitch.on;
    test_smtp_message.login = login.text;
    test_smtp_message.pass = password.text;
    test_smtp_message.wantsSecure = SSLSwitch.on; // smtp.gmail.com doesn't work without TLS!
    test_smtp_message.subject = subject.text;
//    test_smtp_message.bccEmail = @"testbcc@test.com";
    
    // Only do this for self-signed certs!
    // test_smtp_message.validateSSLChain = NO;
    test_smtp_message.delegate = self;
    
    NSMutableArray *parts_to_send = [NSMutableArray array];
    
    //If you are not sure how to format your message part, send an email to your self.  
    //In Mail.app, View > Message> Raw Source to see the raw text that a standard email client will generate.
    //This should give you an idea of the proper format and options you need
    NSDictionary *plain_text_part = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"text/plain\r\n\tcharset=UTF-8;\r\n\tformat=flowed", kSKPSMTPPartContentTypeKey,
                                     [messageBody.text stringByAppendingString:@"\n"], kSKPSMTPPartMessageKey,
                                     @"quoted-printable", kSKPSMTPPartContentTransferEncodingKey,
                                     nil];
    [parts_to_send addObject:plain_text_part];
        
    if (sendVCFSwitch.on)
    {
        NSString *vcard_path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"vcf"];
        NSData *vcard_data = [NSData dataWithContentsOfFile:vcard_path];
        NSDictionary *vcard_part = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"text/directory;\r\n\tx-unix-mode=0644;\r\n\tname=\"test.vcf\"",kSKPSMTPPartContentTypeKey,
                                    @"attachment;\r\n\tfilename=\"test.vcf\"",kSKPSMTPPartContentDispositionKey,
                                    [vcard_data encodeBase64ForData],kSKPSMTPPartMessageKey,
                                    @"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
        [parts_to_send addObject:vcard_part];
    }

    if (sendImageSwitch.on)
    {
        NSString *image_path = [[NSBundle mainBundle] pathForResource:@"Success" ofType:@"png"];
        NSData *image_data = [NSData dataWithContentsOfFile:image_path];        
        NSDictionary *image_part = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"inline;\r\n\tfilename=\"Success.png\"",kSKPSMTPPartContentDispositionKey,
                                    @"base64",kSKPSMTPPartContentTransferEncodingKey,
                                    @"image/png;\r\n\tname=Success.png;\r\n\tx-unix-mode=0666",kSKPSMTPPartContentTypeKey,
                                    [image_data encodeWrappedBase64ForData],kSKPSMTPPartMessageKey,
                                    nil];
        [parts_to_send addObject:image_part];
    }

    NSDictionary *sig_text_part = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"text/plain\r\n\tcharset=UTF-8;\r\n\tformat=flowed", kSKPSMTPPartContentTypeKey,
                                     [@"\n" stringByAppendingString:sig.text], kSKPSMTPPartMessageKey,
                                     @"quoted-printable", kSKPSMTPPartContentTransferEncodingKey,
                                     nil];
    [parts_to_send addObject:sig_text_part];
    
    test_smtp_message.parts = parts_to_send;
    
    Spinner.hidden = NO;
    [Spinner startAnimating];
    ProgressBar.hidden = NO;
    HighestState = 0;
    
    [test_smtp_message send];
}

- (IBAction)switchSSL:(UISwitch *)sender;
{
    
}
- (IBAction)switchSendImage:(UISwitch *)sender;
{
    
}
- (IBAction)switchSendVCF:(UISwitch *)sender;
{
    
}
- (IBAction)switchUseAuth:(UISwitch *)sender;
{
    
}

#pragma mark UITextField Delegate Methods
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *current_pref_key_array = [prefKeyDictionary allKeysForObject:textField];
    NSString *current_pref_key = [current_pref_key_array objectAtIndex:0];
    DEBUGLOG(@"Setting Preference for key: %@ to: %@", current_pref_key, textField.text);
    [defaults setObject:textField.text forKey:current_pref_key];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark SKPSMTPMessage Delegate Methods
- (void)messageState:(SKPSMTPState)messageState;
{
    NSLog(@"HighestState:%d", HighestState);
    if (messageState > HighestState)
        HighestState = messageState;
    
    ProgressBar.progress = (float)HighestState/(float)kSKPSMTPWaitingSendSuccess;
}
- (void)messageSent:(SKPSMTPMessage *)SMTPmessage
{
    [SMTPmessage release];

    Spinner.hidden = YES;
    [Spinner stopAnimating];
    ProgressBar.hidden = YES;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Sent!"
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];    
    [alert release];
    DEBUGLOG(@"delegate - message sent");

}
- (void)messageFailed:(SKPSMTPMessage *)SMTPmessage error:(NSError *)error
{
    [SMTPmessage release];
    
    Spinner.hidden = YES;
    [Spinner stopAnimating];
    ProgressBar.hidden = YES;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription]
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];    
    [alert release];
    DEBUGLOG(@"delegate - error(%d): %@", [error code], [error localizedDescription]);
}

@end
