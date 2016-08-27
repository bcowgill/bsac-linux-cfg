#import "Cocoa1AppDelegate.h"

@implementation Cocoa1AppDelegate

@synthesize window,siteUrl,pageContents;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    model = [[Cocoa1Model alloc] init];
}

- (IBAction)getSiteContents:(id)sender {
    [model setPageUrl:[siteUrl stringValue]];
    NSString* reply = [model getUrlAsString];
    NSLog(@"pageSrc: %@", reply);
    [pageContents setString:reply];
    [[[pageContents textStorage] mutableString] appendString:reply];
}

@end
