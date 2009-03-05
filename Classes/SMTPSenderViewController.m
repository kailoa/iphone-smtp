#import "SMTPSenderViewController.h"

@implementation SMTPSenderViewController

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
                                     [message.text stringByAppendingString:@"\n"], kSKPSMTPPartMessageKey,
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
    [textField resignFirstResponder];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark SKPSMTPMessage Delegate Methods

- (void)messageSent:(SKPSMTPMessage *)SMTPmessage
{
    [SMTPmessage release];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Sent!"
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];    
    [alert release];
    DEBUGLOG(@"delegate - message sent");
}
- (void)messageFailed:(SKPSMTPMessage *)SMTPmessage error:(NSError *)error
{
    [SMTPmessage release];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription]
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];    
    [alert release];
    DEBUGLOG(@"delegate - error(%d): %@", [error code], [error localizedDescription]);
}

@end
