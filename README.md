Introduction
============

OpenSSL and libcurl for Latest iOS.

Usage
=====

 1. do "sh build-libraries.sh"
 2. libraries are created at "lib".
 3. Copy libs and headers to your project.
 4. Import "libssl.a", "libcrypto.a", "libcurl.a".
 5. Reference Headers, "Headers/openssl", "Headers/curl".
 6. Specifying the flag  "-lz" in "Other Linker Flags" (OTHER_LDFLAGS) setting in the "Linking" section in the Build settings of the target.
 7. If use cURL, see below,

        #include <curl/curl.h>

        - (void)foo {    
            CURL* cURL = curl_easy_init();  
            ...  
        }
