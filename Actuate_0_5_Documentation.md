# Introduction #

Actuate is easy-to-use and powerful. It provides useful and simple global control for instance-based tweens, and gives you the power to add features that are missing in the original tween library.

Actuate is lightweight and fast. Using its internal tween engine, Actuate adds 3.7 KB to your final SWF and benchmarks at higher frame rates than TweenLite.

Actuate offers the flexibility of choosing your own engine. Beta 0.4 includes support for BetweenAS3, GTween, TweenLite and TweenMax, but it's easy to add support for almost any other tween library.


### Actuate + BetweenAS3 ###

  * Compatibility with Actuate
  * Added auto-toggling of visible for DisplayObjects (autoVisible)
  * Added tween overwrite support
  * Compatibility with Actuate.apply
  * Compatibility with Actuate.timer
  * Global pause support
  * Global resume support
  * Global stop support


### Actuate + GTween ###

  * Compatibility with Actuate
  * Added onComplete and onChange handler support
  * Added tween overwrite support
  * Small bug fixes
  * Compatibility with Actuate.apply
  * Compatibility with Actuate.timer
  * Global pause support
  * Global resume support
  * Global stop support


### Actuate + TweenLite ###

  * Compatibility with Actuate
  * Compatibility with Actuate.apply
  * Compatibility with Actuate.timer


### Actuate + TweenMax ###

  * Compatibility with Actuate
  * Compatibility with Actuate.apply
  * Compatibility with Actuate.timer




---


---



# Benchmarks #

| BetweenAS3 | 108.1 fps |
|:-----------|:----------|
| BetweenAS3 Actuator | 104.8 fps |
| GTween     | 54.6 fps  |
| GTween Actuator | 51.3 fps  |
| TweenLite  | 85.6 fps  |
| TweenLite Actuator | 83.5 fps  |
| TweenMax   | 82.8 fps  |
| TweenMax Actuator | 80.9 fps  |

| Simple Actuator | 87.9 fps |
|:----------------|:---------|


## Difference ##

| BetweenAS3 Actuator | -3.1% |
|:--------------------|:------|
| GTween Actuator     | -6.0% |
| TweenLite Actuator  | -2.5% |
| TweenMax Actuator   | -2.3% |

| Simple Actuator | n/a |
|:----------------|:----|



## Distribution ##

| BetweenAS3 Actuator | 100% |
|:--------------------|:-----|
| GTween Actuator     | 49.0% |
| TweenLite Actuator  | 79.7% |
| TweenMax Actuator   | 77.2% |

| Simple Actuator | 83.9% |
|:----------------|:------|


---


---


# Comparison #

Since each actuator has its own advantages and disadvantages, here are some points to help decide which actuator is best for each use.


### BetweenAS3 Actuator (Beta) ###

  * Best performance
  * Only supports Flash 10
  * Supports most Actuate tween properties
  * Supports whole tween overwriting
  * Free for use in all projects

### GTween Actuator (Beta) ###

  * Average performance
  * Supports Flash 9
  * Supports all Actuate tween properties
  * Supports whole and partial tween overwriting
  * Free for use in all projects

### TweenLite Actuator (Alpha) ###

  * Above average performance
  * Supports Flash 9
  * Does not allow pause or resume
  * Supports many Acutate tween properties
  * Supports whole and partial tween overwriting
  * Must be licensed for certain commercial projects


### TweenMax Actuator (Alpha) ###

  * Above average performance
  * Supports Flash 9
  * Supports all Actuate tween properties
  * Supports whole and partial tween overwriting
  * Must be licensed for certain commercial projects

### Simple Actuator (Beta) ###

  * Above average performance
  * Supports Flash 9
  * Supports many Actuate tween properties
  * Supports whole tween overwriting
  * Free for use in all projects
  * Included with Actuate



---


---


# How To Use Actuate #

## Initializing ##

The default actuator is Actuate's SimpleActuator, and the default ease function for each actuator is Expo.easeOut. If you like, you can configure your own default actuator and default easing functions.

```
Actuate.defaultActuator = BetweenAS3Actuator;
BetweenAS3Actuator.defaultEase = Sine.easeInOut;
```

The easing functions from BetweenAS3 have been ported over to the "com.eclecticdesignstudio.motion.easing" package for convenience. If you have an easing function you would like to use that does not implement the IEasing interface, you can use the Custom easing class to make your function compatible.

```
BetweenAS3Actuator.defaultEase = Custom.func (MyEasingFunction);
```

## Tweening ##

To create a new tween, use the Actuate.tween method. You can pass the object you would like to tween, the duration of the tween in seconds, the properties you would like to change, and optionally you may enter any tween properties you would like to use or a custom actuator for the tween.

```
Actuate.tween (MyClip, 1, { alpha: 1 } );
Actuate.tween (MyClip, 1, { alpha: 1 }, { ease: Sine.easeInOut }, GTweenActuator);
```

## Controlling Tweens ##

Once your tweens are active, Actuate includes a number of methods to help control them. You can pause or resume all your tweens, one tween or several tweens at once. You can stop all the tweens associated with a single target or only the tweens based upon a specific property. You can also reset Actuate to stop and clear out all of your tweens.

```
Actuate.pause ();
Actuate.pause (MyClip);
Actuate.pause (MyClip, MyClip2, MyClip3);
Actuate.resume ();
Actuate.resume (MyClip);
Actuate.resume (MyClip, MyClip2, MyClip3);
Actuate.stop (MyClip);
Actuate.stop (MyClip, { alpha: null } );
Actuate.reset ();
```

### Registering Tweens ###

If you want the flexibility of customizing your own actuator instance by hand but still would like it to be managed under Actuate, you can register your tween with or without overwriting previous tweens. The default overwrite value is true.

```
var actuator:GTweenActuator = new GTweenActuator (MyClip, 1, { alpha: 1 } );
Actuate.register (actuator);
```

### Applying Properties ###

Sometimes you need to set an object to an exact set of properties, but you want to make sure there are no active tweens that may change those values again. The apply method is a shortcut for removing conflicting tweens then copying properties from one object to another.

```
Actuate.apply (MyClip, { alpha: 1 } );
```

### Timers ###

You may have actions that you want to sequence which are not tweens. The timer method is a shortcut for creating a tween to do the timing for you. It is quicker to use than creating a Flash timer, and it uses the same timing mode as your current actuator so you can be sure that it will fire in sync with your animation. You can use tween properties like "changeListener", "completeListener", "onComplete" or "onChange" to put your timer to work. Timers also support custom actuators if you would like to use a different actuator than the default.

```
Actuate.timer (10, { onComplete: trace, onCompleteParams: [ "Hello World!" ] } );
Actuate.timer (10, { onComplete: trace, onCompleteParams: [ "Hello World!" ] }, GTweenActuator);
```





---


---


# Tween Properties #

Here are all of the currently supported tween properties. Actuate is in constant development so if your favorite property isn't here, let me know! There are still more to come as it is continually improved.

  * **autoRotation**

> Flash reports rotation values in a way that can have undesirable results when tweening. This property fixes this problem by rotating objects in the shortest direction. This is called "shortRotation" in TweenMax, and is false by default.

  * **autoVisible**

> Automatically changes the visible property of display objects when tweening it's alpha property. Setting visible to false provides considerably better performance over a visible DisplayObject with an alpha of zero. This property is true by default, but you may choose to include it in your tween properties to set it to false.

  * **changeListener**

> Define an event listener to handle Event.CHANGE events which are fired repeatedly during a tween's progress.

  * **completeListener**

> Define an event listener to handle an Event.COMPLETE event which is fired when the tween is complete. This event will not fire if a tween is overwritten.

  * **delay**

> Define the amount of delay in seconds before a tween begins.

  * **ease**

> Define a custom easing function. All of the actuators use the easing functions which are included with BetweenAS3, which have been relocated to the "com.eclecticdesignstudio.motion.easing" package for ease of use. Custom easing functions must implement BetweenAS3's IEasing interface to be used with Actuate, but conversion is very easy to do. BetweenAS3's system of easing functions was chosen to allow compatibility across all libraries.

  * **reflect**

> Repeats the tween in reverse when it reaches its end, but only if repeat is defined.

  * **repeat**

> Repeats a tween a specified number of times. A value of -1 will repeat the tween indefinitely.

  * **onChange**

> Defines a function which will be called repeatedly during a tween's progress.

  * **onChangeParams**

> An array of parameters which will be passed to the function defined in onChange.

  * **onComplete**

> Defines a function which will be called when a tween is finished. The function will not be called if the tween is overwritten.

  * **onCompleteParams**

> An array of parameters which will be passed to the function defined in onComplete.

  * **overwrite**

> Defines whether conflicting tweens should be overwritten. The default is true, but setting this value to false can be used to sequence a series of similar tweens. However, to prevent errors, make sure that the delay and duration of each tween protects each tween from conflicting with each other.

  * **snapping**

> Will round properties to the nearest whole number while tweening. This is called "roundProps" in TweenMax. All of the properties in the current tween will be rounded when using this property.



---


---



# Tween Property Support #

### BetweenAS3 Actuator (Beta) ###

  * autoVisible
  * changeListener
  * completeListener
  * delay
  * ease
  * repeat
  * onChange
  * onChangeParams
  * onComplete
  * onCompleteParams
  * overwrite


### GTween Actuator (Beta) ###

  * autoRotation
  * autoVisible
  * changeListener
  * completeListener
  * delay
  * ease
  * reflect
  * repeat
  * onChange
  * onChangeParams
  * onComplete
  * onCompleteParams
  * overwrite
  * snapping

### TweenLite Actuator (Alpha) ###

  * changeListener
  * completeListener
  * delay
  * ease
  * onChange
  * onChangeParams
  * onComplete
  * onCompleteParams
  * overwrite


### TweenMax Actuator (Alpha) ###

  * autoRotation
  * autoVisible
  * changeListener
  * completeListener
  * delay
  * ease
  * reflect
  * repeat
  * onChange
  * onChangeParams
  * onComplete
  * onCompleteParams
  * overwrite
  * snapping

### Simple Actuator (Beta) ###

  * autoVisible
  * changeListener
  * completeListener
  * delay
  * ease
  * onChange
  * onChangeParams
  * onComplete
  * onCompleteParams
  * overwrite



---


---



# Download #

If you would just like to download Actuate, you can get it here:

### [Actuate Beta 0.4.zip](http://actuate.googlecode.com/files/Actuate%20Beta%200.4.zip) ###

Actuate comes with the Simple Actuator, but you will need to download classes for either BetweenAS3, GTween, TweenLite or TweenMax if you would like to use their respective actuators.

You can also download the source for the Particle Demo, which includes classes for every tween library:

### [Particle Demo.zip](http://actuate.googlecode.com/files/Particle%20Demo.zip) ###



---


---



# Feedback #

Please send me an email or comment on [this thread](http://www.flashdevelop.org/community/viewtopic.php?f=7&t=5258) to leave me feedback, or if you have code you would like to contribute to the project.

Thanks, and enjoy!