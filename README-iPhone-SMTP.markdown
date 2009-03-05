iPhone-SMTP

This is a fork of the SKPSMTPMessage library
http://code.google.com/p/skpsmtpmessage/

See the original author's blog entry on the subject:
http://blog.skorpiostech.com/2009/02/11/skpsmptmessage-economics-of-open-source/

This is not intended to be full SMTP implementation, but rather a simple way of sending emails without the limitations of the mailto: URL handler in the iPhone SDK.

## Necessary Components

Please add the following to your projects:

1. Frameworks
    
    required by the STMP client files.

    * CFNetwork.framework


2. SMTP client files

    These are used to send the actual mail

    * HSK_CFUtilities.h
    * HSK_CFUtilities.m
    * NSStream+SKPSMTPExtensions.h
    * NSStream+SKPSMTPExtensions.m
    * SKPSMTPMessage.h
    * SKPSMTPMessage.m

3. Encoders

    These files are necessary if you want to use attachments

    * Base64Transcoder.h
    * Base64Transcoder.m
    * NSData+Base64Additions.h
    * NSData+Base64Additions.m

