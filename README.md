# WatchRingGenerator

iOS app to generate series of PNG images, to be used in WatchKit apps. I'ts primarily made to be used in iOS Simulator, so you can easily get to the pics.
I recommend to use iPad Air simulator.

It looks like this:

![](screen.png)

You can set your color hex codes and tap Return key to have them instantly applied. Same with other text fields – change value and tap Return to apply it.
The color boxes are actually buttons and I first wanted to add color picker there, but gave up for the lack of time.

This is the format of the file names: `RINGID-RINGSIZE-RINGWIDTH_COUNTER.png`. It generates 100 pics for each ring. 

* `RINGID` is either `outer` or `innner`
* `RINGSIZE` is size in points, by default it's 120 for outer ring and 100 for inner
* `RINGWIDTH` is also in points, defines how fat the ring is (default is 9)

Images are generated in `img` folder inside app's `Documents` directory.
