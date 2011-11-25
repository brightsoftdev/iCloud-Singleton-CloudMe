Singleton for iCloud
================================

Upload text documents and images easily, also you can save your defaults in your cloud, just with few lines.

* Upload Images:
<pre>
    [[CloudMe shared] uploadImage:[UIImage imageNamed:@"myImage.png"]
                           result:^(BOOL success) {
                              
                               NSLog(@"SUCCESS? => %@", (success) ? @"YES" : @"NO");
                               
                           }];
    
    [[CloudMe shared] downloadAllImagesWithResult:^(UIImage *image) {
       
        //Loop images and do something
        NSLog(@"EMPTY IMAGE? => %@", (image == nil) ? @"YES" : @"NO");
    }];
	
    [[CloudMe shared] downloadImageWithKey:@"KEY_IMAGE" result:^(UIImage *image) {
        
        //image retrieved
        NSLog(@"EMPTY IMAGE? => %@", (image == nil) ? @"YES" : @"NO");
    }];
</pre>

* Upload Text documents:
<pre>
    [[CloudMe shared] uploadDocumentWithcontents:@"text to cloud" result:^(BOOL success) {
        
        NSLog(@"UPLOAD? => %@", (success) ? @"YES" : @"NO");
    }];
    
    [[CloudMe shared] downloadAllDocumentsWithResult:^(UIDocument *document) {
        
        //Loop documents and do something
        NSLog(@"EMPTY DOC? => %@", (document == nil) ? @"YES" : @"NO");
    }];
    
    [[CloudMe shared] downloadDocumentWithName:@"DOC_NAME" result:^(UIDocument *document) {
        
        //Loop documents and do something
        NSLog(@"EMPTY DOC? => %@", (document == nil) ? @"YES" : @"NO");
    }];
</pre>