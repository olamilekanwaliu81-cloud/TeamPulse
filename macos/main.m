// TeamPulse for Mac: opens the bundled prototype site (landing page + app) in a native window.
// Build with macos/build_mac.sh. Run with --selftest to check the bundled site without showing a window.

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate, WKNavigationDelegate, WKUIDelegate>
@property (strong) NSWindow *window;
@property (strong) WKWebView *webView;
@property (assign) BOOL selfTestMode;
@property (assign) BOOL testStarted;
@end

@implementation AppDelegate

- (NSURL *)siteDir {
    return [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"site" isDirectory:YES];
}

- (NSURL *)indexURL {
    return [[self siteDir] URLByAppendingPathComponent:@"index.html"];
}

- (void)loadHome {
    [self.webView loadFileURL:[self indexURL] allowingReadAccessToURL:[self siteDir]];
}

#pragma mark - Launch

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    self.selfTestMode = [[[NSProcessInfo processInfo] arguments] containsObject:@"--selftest"];

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // The self-test works in throwaway storage, so it can never touch the data of a real user.
    if (self.selfTestMode) { config.websiteDataStore = [WKWebsiteDataStore nonPersistentDataStore]; }
    // Tells the page it is running inside the desktop app, so it hides its own download buttons.
    WKUserScript *flag = [[WKUserScript alloc] initWithSource:@"window.TP_DESKTOP='mac';" injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [config.userContentController addUserScript:flag];
    self.webView = [[WKWebView alloc] initWithFrame:NSMakeRect(0, 0, 1280, 860) configuration:config];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.allowsBackForwardNavigationGestures = YES;

    NSWindowStyleMask style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable;
    self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 1280, 860) styleMask:style backing:NSBackingStoreBuffered defer:NO];
    self.window.title = @"TeamPulse";
    self.window.minSize = NSMakeSize(380, 560);
    self.window.contentView = self.webView;
    self.window.delegate = self;
    self.window.releasedWhenClosed = NO;

    if (self.selfTestMode) {
        // Keep the window out of sight and run the checks once the page has loaded.
        [self.window setFrameOrigin:NSMakePoint(-6000, -6000)];
        [self.window orderFrontRegardless];
        [self loadHome];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            printf("FAIL: self-test timed out\n");
            exit(2);
        });
        return;
    }

    [self buildMenu];
    [self.window setFrameAutosaveName:@"TeamPulseMainWindow"];
    if (![self.window setFrameUsingName:@"TeamPulseMainWindow"]) { [self.window center]; }
    [self loadHome];
    [self.window makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender { return YES; }
- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app { return YES; }

#pragma mark - Links open in the default browser, never inside the app

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)action decisionHandler:(void (^)(WKNavigationActionPolicy))handler {
    NSURL *url = action.request.URL;
    NSString *scheme = url.scheme.lowercaseString;
    if (scheme && [@[@"http", @"https", @"mailto", @"tel"] containsObject:scheme]) {
        [[NSWorkspace sharedWorkspace] openURL:url];
        handler(WKNavigationActionPolicyCancel);
        return;
    }
    handler(WKNavigationActionPolicyAllow);
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)action windowFeatures:(WKWindowFeatures *)features {
    if (action.request.URL) { [[NSWorkspace sharedWorkspace] openURL:action.request.URL]; }
    return nil;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.selfTestMode) { [self runSelfTest]; }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (self.selfTestMode) { printf("FAIL: page did not load: %s\n", error.localizedDescription.UTF8String); exit(2); }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (self.selfTestMode) { printf("FAIL: page did not load: %s\n", error.localizedDescription.UTF8String); exit(2); }
}

#pragma mark - Menus

- (NSMenuItem *)itemTitled:(NSString *)title action:(SEL)action key:(NSString *)key target:(id)target {
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:title action:action keyEquivalent:key];
    item.target = target;
    return item;
}

- (NSMenu *)addMenuTitled:(NSString *)title to:(NSMenu *)bar {
    NSMenuItem *holder = [[NSMenuItem alloc] init];
    NSMenu *menu = [[NSMenu alloc] initWithTitle:title];
    holder.submenu = menu;
    [bar addItem:holder];
    return menu;
}

- (void)buildMenu {
    NSMenu *bar = [[NSMenu alloc] init];

    NSMenu *app = [self addMenuTitled:@"TeamPulse" to:bar];
    [app addItemWithTitle:@"About TeamPulse" action:@selector(orderFrontStandardAboutPanel:) keyEquivalent:@""];
    [app addItem:[NSMenuItem separatorItem]];
    [app addItemWithTitle:@"Hide TeamPulse" action:@selector(hide:) keyEquivalent:@"h"];
    NSMenuItem *hideOthers = [app addItemWithTitle:@"Hide Others" action:@selector(hideOtherApplications:) keyEquivalent:@"h"];
    hideOthers.keyEquivalentModifierMask = NSEventModifierFlagCommand | NSEventModifierFlagOption;
    [app addItemWithTitle:@"Show All" action:@selector(unhideAllApplications:) keyEquivalent:@""];
    [app addItem:[NSMenuItem separatorItem]];
    [app addItemWithTitle:@"Quit TeamPulse" action:@selector(terminate:) keyEquivalent:@"q"];

    // Edit menu, so copy and paste work in the forms.
    NSMenu *edit = [self addMenuTitled:@"Edit" to:bar];
    [edit addItemWithTitle:@"Undo" action:NSSelectorFromString(@"undo:") keyEquivalent:@"z"];
    NSMenuItem *redo = [edit addItemWithTitle:@"Redo" action:NSSelectorFromString(@"redo:") keyEquivalent:@"z"];
    redo.keyEquivalentModifierMask = NSEventModifierFlagCommand | NSEventModifierFlagShift;
    [edit addItem:[NSMenuItem separatorItem]];
    [edit addItemWithTitle:@"Cut" action:@selector(cut:) keyEquivalent:@"x"];
    [edit addItemWithTitle:@"Copy" action:@selector(copy:) keyEquivalent:@"c"];
    [edit addItemWithTitle:@"Paste" action:@selector(paste:) keyEquivalent:@"v"];
    [edit addItemWithTitle:@"Select All" action:@selector(selectAll:) keyEquivalent:@"a"];

    NSMenu *go = [self addMenuTitled:@"Go" to:bar];
    [go addItem:[self itemTitled:@"Landing page" action:@selector(goLanding) key:@"1" target:self]];
    [go addItem:[self itemTitled:@"Open the app" action:@selector(goApp) key:@"2" target:self]];
    [go addItem:[self itemTitled:@"Sign in" action:@selector(goSignIn) key:@"3" target:self]];
    [go addItem:[self itemTitled:@"Register as a team leader" action:@selector(goRegister) key:@"4" target:self]];

    NSMenu *view = [self addMenuTitled:@"View" to:bar];
    [view addItem:[self itemTitled:@"Reload and reset example data" action:@selector(reloadPage) key:@"r" target:self]];
    [view addItem:[NSMenuItem separatorItem]];
    [view addItem:[self itemTitled:@"Zoom In" action:@selector(zoomIn) key:@"=" target:self]];
    [view addItem:[self itemTitled:@"Zoom Out" action:@selector(zoomOut) key:@"-" target:self]];
    [view addItem:[self itemTitled:@"Actual Size" action:@selector(zoomReset) key:@"0" target:self]];
    [view addItem:[NSMenuItem separatorItem]];
    NSMenuItem *fs = [view addItemWithTitle:@"Enter Full Screen" action:@selector(toggleFullScreen:) keyEquivalent:@"f"];
    fs.keyEquivalentModifierMask = NSEventModifierFlagCommand | NSEventModifierFlagControl;

    NSMenu *win = [self addMenuTitled:@"Window" to:bar];
    [win addItemWithTitle:@"Minimize" action:@selector(performMiniaturize:) keyEquivalent:@"m"];
    [win addItemWithTitle:@"Zoom" action:@selector(performZoom:) keyEquivalent:@""];
    [NSApp setWindowsMenu:win];

    [NSApp setMainMenu:bar];
}

#pragma mark - Actions

// Switch the page's view with its own address ending, or reload the home page if it is not showing.
- (void)goHash:(NSString *)hash {
    NSString *js = [NSString stringWithFormat:@"(function(){ if(!document.getElementById('appview')) return false; location.hash='%@'; return true })()", hash];
    [self.webView evaluateJavaScript:js completionHandler:^(id result, NSError *error) {
        if (![result isKindOfClass:[NSNumber class]] || ![result boolValue]) { [self loadHome]; }
    }];
}

- (void)goLanding { [self goHash:@""]; }
- (void)goApp { [self goHash:@"app"]; }
- (void)goSignIn { [self goHash:@"app-signin"]; }
- (void)goRegister { [self goHash:@"app-register"]; }
- (void)reloadPage { [self loadHome]; }
- (void)zoomIn { self.webView.pageZoom = MIN(self.webView.pageZoom + 0.1, 3.0); }
- (void)zoomOut { self.webView.pageZoom = MAX(self.webView.pageZoom - 0.1, 0.5); }
- (void)zoomReset { self.webView.pageZoom = 1.0; }

#pragma mark - Self-test (run with --selftest)

- (void)runSelfTest {
    if (self.testStarted) { return; }
    self.testStarted = YES;
    NSURL *scriptURL = [[NSBundle mainBundle] URLForResource:@"selftest" withExtension:@"js"];
    NSString *script = [NSString stringWithContentsOfURL:scriptURL encoding:NSUTF8StringEncoding error:nil];
    if (!script) { printf("FAIL: selftest.js is missing from the app\n"); exit(2); }
    [self.webView callAsyncJavaScript:script arguments:@{} inFrame:nil inContentWorld:[WKContentWorld pageWorld] completionHandler:^(id result, NSError *error) {
        if (error) {
            NSString *detail = error.userInfo[@"WKJavaScriptExceptionMessage"] ?: error.localizedDescription;
            NSString *line = [NSString stringWithFormat:@"%@", error.userInfo[@"WKJavaScriptExceptionLineNumber"]];
            printf("FAIL: the test could not run: %s (line %s)\n", detail.UTF8String, line.UTF8String);
            exit(2);
        }
        NSString *text = [result isKindOfClass:[NSString class]] ? result : [NSString stringWithFormat:@"%@", result];
        printf("%s\n", text.UTF8String);
        exit([text containsString:@"FAIL"] ? 1 : 0);
    }];
}

@end

static AppDelegate *gDelegate;

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        BOOL selfTest = NO;
        for (int i = 1; i < argc; i++) { if (strcmp(argv[i], "--selftest") == 0) { selfTest = YES; } }
        NSApplication *app = [NSApplication sharedApplication];
        gDelegate = [[AppDelegate alloc] init];
        app.delegate = gDelegate;
        [app setActivationPolicy:selfTest ? NSApplicationActivationPolicyAccessory : NSApplicationActivationPolicyRegular];
        [app run];
    }
    return 0;
}
