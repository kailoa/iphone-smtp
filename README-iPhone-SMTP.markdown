iPhone-SMTP

This is a fork of the skpsmtpmessage library
http://code.google.com/p/skpsmtpmessage/


This is not intended to be full SMTP implementation, but rather a simple 

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

