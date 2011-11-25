{\rtf1\ansi\ansicpg1252\cocoartf1038\cocoasubrtf360
{\fonttbl\f0\fswiss\fcharset0 Helvetica;\f1\fnil\fcharset0 Menlo-Regular;}
{\colortbl;\red255\green255\blue255;\red63\green110\blue116;\red38\green71\blue75;\red92\green38\blue153;
\red46\green13\blue110;\red196\green26\blue22;\red170\green13\blue145;\red0\green116\blue0;}
\paperw11900\paperh16840\margl1440\margr1440\vieww18880\viewh10380\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\ql\qnatural\pardirnatural

\f0\fs24 \cf0 Singleton for iCloud\
---------------------------\
\
Upload text documents and images easily, also you can save your defaults in your cloud, just with few lines.\
\
- Upload Images:\
\
\pard\tx560\pardeftab560\ql\qnatural\pardirnatural

\f1\fs22 \cf0 \CocoaLigature0     [[\cf2 CloudMe\cf0  \cf3 shared\cf0 ] \cf3 uploadImage\cf0 :[\cf4 UIImage\cf0  \cf5 imageNamed\cf0 :\cf6 @"myImage.png"\cf0 ]\
                           \cf3 result\cf0 :^(\cf7 BOOL\cf0  success) \{\
                              \
                               \cf5 NSLog\cf0 (\cf6 @"SUCCESS? => %@"\cf0 , (success) ? \cf6 @"YES"\cf0  : \cf6 @"NO"\cf0 );\
                               \
                           \}];\
    \
    [[\cf2 CloudMe\cf0  \cf3 shared\cf0 ] \cf3 downloadAllImagesWithResult\cf0 :^(\cf4 UIImage\cf0  *image) \{\
       \
        \cf8 //Loop images and do something\cf0 \
        \cf5 NSLog\cf0 (\cf6 @"EMPTY IMAGE? => %@"\cf0 , (image == \cf7 nil\cf0 ) ? \cf6 @"YES"\cf0  : \cf6 @"NO"\cf0 );\
    \}];\
	\
    [[\cf2 CloudMe\cf0  \cf3 shared\cf0 ] \cf3 downloadImageWithKey\cf0 :\cf6 @"KEY_IMAGE"\cf0  \cf3 result\cf0 :^(\cf4 UIImage\cf0  *image) \{\
        \
        \cf8 //image retrieved\cf0 \
        \cf5 NSLog\cf0 (\cf6 @"EMPTY IMAGE? => %@"\cf0 , (image == \cf7 nil\cf0 ) ? \cf6 @"YES"\cf0  : \cf6 @"NO"\cf0 );\
    \}];\
\
\
- Upload Text documents:
\f0\fs24 \CocoaLigature1 \
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\ql\qnatural\pardirnatural
\cf0 \
\pard\tx560\pardeftab560\ql\qnatural\pardirnatural

\f1\fs22 \cf0 \CocoaLigature0     [[\cf2 CloudMe\cf0  \cf3 shared\cf0 ] \cf3 uploadDocumentWithcontents\cf0 :\cf6 @"text to cloud"\cf0  \cf3 result\cf0 :^(\cf7 BOOL\cf0  success) \{\
        \
        \cf5 NSLog\cf0 (\cf6 @"UPLOAD? => %@"\cf0 , (success) ? \cf6 @"YES"\cf0  : \cf6 @"NO"\cf0 );\
    \}];\
    \
    [[\cf2 CloudMe\cf0  \cf3 shared\cf0 ] \cf3 downloadAllDocumentsWithResult\cf0 :^(\cf4 UIDocument\cf0  *document) \{\
        \
        \cf8 //Loop documents and do something\cf0 \
        \cf5 NSLog\cf0 (\cf6 @"EMPTY DOC? => %@"\cf0 , (document == \cf7 nil\cf0 ) ? \cf6 @"YES"\cf0  : \cf6 @"NO"\cf0 );\
    \}];\
    \
    [[\cf2 CloudMe\cf0  \cf3 shared\cf0 ] \cf3 downloadDocumentWithName\cf0 :\cf6 @"DOC_NAME"\cf0  \cf3 result\cf0 :^(\cf4 UIDocument\cf0  *document) \{\
        \
        \cf8 //Loop documents and do something\cf0 \
        NSLog(\cf6 @"EMPTY DOC? => %@"\cf0 , (document == \cf7 nil\cf0 ) ? \cf6 @"YES"\cf0  : \cf6 @"NO"\cf0 );\
    \}];}