#import <UIKit/UIKit.h>

#import <CFNetwork/CFNetwork.h>
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"

@interface SMTPSenderViewController : UIViewController <SKPSMTPMessageDelegate>
{
    IBOutlet UITextField *fromEmail;
    IBOutlet UITextField *toEmail;
    IBOutlet UITextField *relayHost;
    IBOutlet UITextField *login;
    IBOutlet UITextField *password;
    IBOutlet UITextField *subject;
    IBOutlet UITextField *message;
    IBOutlet UITextField *sig;
    IBOutlet UISwitch *SSLSwitch;
    IBOutlet UISwitch *useAuthSwitch;
    IBOutlet UISwitch *sendImageSwitch;
    IBOutlet UISwitch *sendVCFSwitch;
}
- (IBAction)sendMail:(id)sender;
- (IBAction)switchSSL:(UISwitch *)sender;
- (IBAction)switchSendImage:(UISwitch *)sender;
- (IBAction)switchSendVCF:(UISwitch *)sender;
- (IBAction)switchUseAuth:(UISwitch *)sender;
@end
