> Note: This is an old thing made as quickie tool in WatchKit 1.0 days.
> Use it if you still find use for it, but it's abandoned (by me).


# WatchRingGenerator 1.1

iOS app to generate series of PNG images, to be used in WatchKit apps. It’s primarily made to be used in iOS Simulator, so you can easily get to the pics.
I recommend to use iPad Air simulator.

It looks like this (from ver 1.0):

![](screen.png)

## Ver 1.0

You can set your color hex codes and tap Return key to have them instantly applied. Same with other text fields – change value and tap Return to apply it.
The color boxes are actually buttons and I first wanted to add color picker there, but gave up for the lack of time. Progress can go from 0.0 to 1.0 and it is there simply as preview.

This is the format of the file names: `RINGID-RINGSIZE-RINGWIDTH_COUNTER@2x.png`. It generates 100 pics for each ring. 

* `RINGID` is either `outer` or `innner`
* `RINGSIZE` is size in points, by default it's 120 for outer ring and 100 for inner
* `RINGWIDTH` is also in points, defines how fat the ring is (default is 9)

Images are generated in `img` folder inside app's `Documents` directory.

## Ver 1.1

Added option to generate .xcassets file, automatically for both 38mm and 42mm. The difference between the pics is 20pt, so it's easy to generate both sizes automatically.

### How to use

* Set the watch size to 38mm (it's the default, but just in case you tried 42mm)
* Setup your rings anyway you want (keep in mind that max size is 134pt)
* Tap `Generate .xcassets` button and look for the app's `Documents` folder in iOS Simulator

Now just add `Ring.xcassets` into Watch app target (not the extension) and use it like this:

```objective-c
[self.progressImage setImageNamed:@"inner-124-12-"];
```

Have fun creating your images. Code is a bit convoluted, but it does the job and I hope you can find your way around in case you want to change the naming.
