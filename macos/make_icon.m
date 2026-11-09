// Draws the TeamPulse app icon (violet rounded square with the white pulse line) at every size
// macOS needs, into the folder given as the first argument. build_mac.sh turns it into AppIcon.icns.

#import <Cocoa/Cocoa.h>

static NSData *drawIcon(NSInteger px) {
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:px pixelsHigh:px
        bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:rep]];
    CGFloat s = (CGFloat)px;

    // Rounded square with the margin macOS icons use.
    CGFloat side = s * 0.80, inset = (s - side) / 2;
    NSBezierPath *tile = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(inset, inset, side, side) xRadius:side * 0.225 yRadius:side * 0.225];
    [[NSColor colorWithSRGBRed:0x6A / 255.0 green:0x5A / 255.0 blue:0xE0 / 255.0 alpha:1] setFill];
    [tile fill];

    // Pulse line, the same shape as the TeamPulse logo (28 x 28 grid).
    CGFloat pts[6][2] = {{2, 15}, {8, 15}, {11, 6}, {16, 23}, {19, 15}, {26, 15}};
    CGFloat gx = inset + side * 0.14, gw = side * 0.72;
    NSBezierPath *line = [NSBezierPath bezierPath];
    for (int i = 0; i < 6; i++) {
        NSPoint p = NSMakePoint(gx + (pts[i][0] - 2) / 24 * gw, inset + side * 0.14 + (1 - (pts[i][1] - 4) / 21) * side * 0.72);
        if (i == 0) { [line moveToPoint:p]; } else { [line lineToPoint:p]; }
    }
    line.lineWidth = side * 0.075;
    line.lineCapStyle = NSLineCapStyleRound;
    line.lineJoinStyle = NSLineJoinStyleRound;
    [[NSColor whiteColor] setStroke];
    [line stroke];

    [NSGraphicsContext restoreGraphicsState];
    return [rep representationUsingType:NSBitmapImageFileTypePNG properties:@{}];
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        if (argc < 2) { printf("usage: make_icon <iconset folder>\n"); return 1; }
        NSString *dir = [NSString stringWithUTF8String:argv[1]];
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
        struct { const char *name; NSInteger px; } sizes[] = {
            {"icon_16x16", 16}, {"icon_16x16@2x", 32}, {"icon_32x32", 32}, {"icon_32x32@2x", 64},
            {"icon_128x128", 128}, {"icon_128x128@2x", 256}, {"icon_256x256", 256}, {"icon_256x256@2x", 512},
            {"icon_512x512", 512}, {"icon_512x512@2x", 1024},
        };
        for (size_t i = 0; i < sizeof(sizes) / sizeof(sizes[0]); i++) {
            NSString *path = [dir stringByAppendingFormat:@"/%s.png", sizes[i].name];
            [drawIcon(sizes[i].px) writeToFile:path atomically:YES];
        }
        printf("icon files written to %s\n", argv[1]);
    }
    return 0;
}
