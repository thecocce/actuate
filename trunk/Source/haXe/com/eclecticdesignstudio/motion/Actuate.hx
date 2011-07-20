﻿/**
 * @author Joshua Granick
 * @version 1.24
 */


package com.eclecticdesignstudio.motion;


import com.eclecticdesignstudio.motion.actuators.GenericActuator;
//import com.eclecticdesignstudio.motion.actuators.MethodActuator;
//import com.eclecticdesignstudio.motion.actuators.MotionInternal;
//import com.eclecticdesignstudio.motion.actuators.MotionPathActuator;
import com.eclecticdesignstudio.motion.actuators.SimpleActuator;
//import com.eclecticdesignstudio.motion.actuators.TransformActuator;
import com.eclecticdesignstudio.motion.easing.Expo;
import com.eclecticdesignstudio.motion.easing.IEasing;
import flash.display.DisplayObject;
import flash.events.Event;


class Actuate {
	
	
	public static var defaultActuator:Class <GenericActuator> = SimpleActuator;
	public static var defaultEase:IEasing = Expo.easeOut;
	private static var targetLibraries:Hash <Array <GenericActuator>> = new Hash <Array <GenericActuator>> ();
	
	
	/**
	 * Copies properties from one object to another. Conflicting tweens are stopped automatically
	 * @example		<code>Actuate.apply (MyClip, { alpha: 1 } );</code>
	 * @param	target		The object to copy to
	 * @param	properties		The object to copy from
	 * @param	customActuator		A custom actuator to use instead of the default (Optional)
	 * @return		The current actuator instance, which can be used to apply properties like onComplete or onUpdate handlers
	 */
	public static function apply (target:Dynamic, properties:Dynamic, customActuator:Class <GenericActuator> = null):GenericActuator {
		
		stop (target, properties);
		
		#if cpp
			
			// Type.createInstance doesn't work right now for the properties object
			
			var actuator:GenericActuator = new SimpleActuator (target, 0, properties);
			
		#else
			
			var actuateClass:Class <GenericActuator> = customActuator;
			
			if (actuateClass == null) {
				
				actuateClass = defaultActuator;
				
			}
			
			var actuator:GenericActuator = Type.createInstance (actuateClass, [ target, 0, properties ] );
			
		#end
		
		var internal:MotionInternal = actuator;
		
		internal.apply ();
		
		return actuator;
		
	}
	
	
	/**
	 * Creates a new effects tween 
	 * @param	target		The object to tween
	 * @param	duration		The length of the tween in seconds
	 * @param	overwrite		Sets whether previous tweens for the same target and properties will be overwritten (Default is true)
	 * @return		An EffectsOptions instance, which is used to select the kind of effect you would like to apply to the target
	 */
	public static function effects (target:DisplayObject, duration:Float, overwrite:Bool = true):EffectsOptions {
		
		return new EffectsOptions (target, duration, overwrite);
		
	}
	
	
	private static function getLibrary (target:Dynamic):Array <GenericActuator> {
		
		var targetString:String = Std.string (target);
		
		if (!targetLibraries.exists (targetString)) {
			
			targetLibraries.set (targetString, new Array <GenericActuator> ());
			
		}
		
		return targetLibraries.get (targetString);
		
	}
	
	
	/**
	 * Creates a new MotionPath tween
	 * @param	target		The object to tween
	 * @param	duration		The length of the tween in seconds
	 * @param	properties		An object containing a motion path for each property you wish to tween
	 * @param	overwrite		Sets whether previous tweens for the same target and properties will be overwritten (Default is true)
	 * @return		The current actuator instance, which can be used to apply properties like ease, delay, onComplete or onUpdate
	 */
	/*public static function motionPath (target:Dynamic, duration:Float, properties:Dynamic, overwrite:Bool = true):GenericActuator {
		
		return tween (target, duration, properties, overwrite, MotionPathActuator);
		
	}*/
	
	
	/**
	 * Pauses tweens for the specified target objects
	 * @param	... targets		The target objects which will have their tweens paused. Passing no value pauses tweens for all objects
	 */
	//public static function pause (... targets:Array):void {
	public static function pause (target:Dynamic):Void {
		
		var actuator:GenericActuator;
		var library:Array <GenericActuator>;
		
		library = getLibrary (target);
		
		for (actuator in library) {
			
			var actuatorInternal:MotionInternal = actuator;
			
			if (actuatorInternal.target == target) {
				
				actuatorInternal.pause ();
				
			}
			
		}
		
	}
	
	
	public static function pauseAll ():Void {
		
		for (library in targetLibraries) {
			
			for (i in 0...library.length) {
				
				var actuatorInternal:MotionInternal = library[i];
				actuatorInternal.pause ();
				
			}
			
		}
		
	}
	
	
	/**
	 * Resets Actuate by stopping and removing tweens for all objects
	 */
	public static function reset ():Void {
		
		var actuator:GenericActuator;
		
		for (library in targetLibraries) {
			
			for (i in 0...library.length) {
				
				var actuatorInternal:MotionInternal = library[i];
				actuatorInternal.stop (null, false, false);
				
			}
			
		}
		
		targetLibraries = new Hash <Array <GenericActuator>> ();
		
	}
	
	
	/**
	 * Resumes paused tweens for the specified target objects
	 * @param	... targets		The target objects which will have their tweens resumed. Passing no value resumes tweens for all objects
	 */
	public static function resume (target:Dynamic):Void {
		
		var actuator:GenericActuator;
		var library:Array <GenericActuator>;
		
		library = getLibrary (target);
		
		for (actuator in library) {
			
			var actuatorInternal:MotionInternal = actuator;
			
			if (actuatorInternal.target == target) {
				
				actuatorInternal.resume ();
				
			}
			
		}
		
	}
	
	
	public static function resumeAll ():Void {
		
		for (library in targetLibraries) {
			
			for (i in 0...library.length) {
				
				var actuatorInternal:MotionInternal = library[i];
				actuatorInternal.resume ();
				
			}
			
		}
		
	}
	
	
	/**
	 * Stops all tweens for an individual object
	 * @param	target		The target object which will have its tweens stopped
	 * @param  properties		A string, array or object which contains the properties you wish to stop, like "alpha", [ "x", "y" ] or { alpha: null }. Passing no value removes all tweens for the object (Optional)
	 * @param	complete		If tweens should apply their final target values before stopping. Default is false (Optional) 
	 * @param	sendEvent	If a complete() event should be dispatched for the specified target. Default is true (Optional)
	 */
	public static function stop (target:Dynamic, properties:Dynamic = null, complete:Bool = false, sendEvent:Bool = true):Void {
		
		if (target != null) {
			
			var actuator:GenericActuator;
			var library:Array <GenericActuator> = getLibrary (target);
			
			var temp = {};
			
			if (Std.is (properties, String)) {
				
				Reflect.setField (temp, properties, null);
				//temp[properties] = null;
				properties = temp;
				
			} else if (Std.is (properties, Array)) {
				
				for (i in Reflect.fields (properties)) {
					
					Reflect.setField (temp, i, null);
					
				}
				
				properties = temp;
				
			}
			
			for (actuator in library) {
				
				var actuatorInternal:MotionInternal = actuator;
				
				if (actuatorInternal.target == target) {
					
					actuatorInternal.stop (properties, complete, sendEvent);
					
				}
				
			}
			
		}
		
	}
	
	
	/**
	 * Creates a tween-based timer, which is useful for synchronizing function calls with other animations
	 * @example		<code>Actuate.timer (1).onComplete (trace, "Timer is now complete");</code>
	 * @param	duration		The length of the timer in seconds
	 * @param	customActuator		A custom actuator to use instead of the default (Optional)
	 * @return		The current actuator instance, which can be used to apply properties like onComplete or to gain a reference to the target timer object
	 */
	public static function timer (duration:Float, customActuator:Class <GenericActuator> = null):GenericActuator {
		
		return tween (new TweenTimer (0), duration, new TweenTimer (1), false, customActuator);
		
	}
	
	
	/**
	 * Creates a new transform tween
	 * @example		<code>Actuate.transform (MyClip, 1).color (0xFF0000);</code>
	 * @param	target		The object to tween
	 * @param	duration		The length of the tween in seconds
	 * @param	overwrite		Sets whether previous tweens for the same target and properties will be overwritten (Default is true)
	 * @return		A TransformOptions instance, which is used to select the kind of transform you would like to apply to the target
	 */
	public static function transform (target:Dynamic, duration:Float = 0, overwrite:Bool = true):TransformOptions {
		
		return new TransformOptions (target, duration, overwrite);
		
	}
	
	
	/**
	 * Creates a new tween
	 * @example		<code>Actuate.tween (MyClip, 1, { alpha: 1 } ).onComplete (trace, "MyClip is now visible");</code>
	 * @param	target		The object to tween
	 * @param	duration		The length of the tween in seconds
	 * @param	properties		The end values to tween the target to
	 * @param	overwrite			Sets whether previous tweens for the same target and properties will be overwritten (Default is true)
	 * @param	customActuator		A custom actuator to use instead of the default (Optional)
	 * @return		The current actuator instance, which can be used to apply properties like ease, delay, onComplete or onUpdate
	 */ 
	public static function tween (target:Dynamic, duration:Float, properties:Dynamic, overwrite:Bool = true, customActuator:Class <GenericActuator> = null):GenericActuator {
		
		if (target != null) {
			
			if (duration > 0) {
				
				// Type.createInstance doesn't work right now for the properties object
				var actuator:GenericActuator = new SimpleActuator (target, duration, properties);
				
				/*var actuateClass:Class <GenericActuator> = customActuator;
				
				if (actuateClass == null) {
					
					actuateClass = defaultActuator;
					
				}
				
				var actuator:GenericActuator = Type.createInstance (actuateClass, [ target, duration, properties ] );*/
				
				if (overwrite) {
					
					stop (target, properties);
					
				}
				
				var library:Array <GenericActuator> = getLibrary (target);
				
				/*if (overwrite) {
					
					for (childActuator in library) {
						
						var childActuatorInternal:MotionInternal = childActuator;
						
						if (childActuatorInternal.target == target) {
							
							childActuatorInternal.stop (properties, false, false);
							
						}
						
					}
					
				}*/
				
				library.push (actuator);
				
				var actuatorInternal:MotionInternal = actuator;
				actuatorInternal.move ();
				
				return actuator;
				
			} else {
				
				return apply (target, properties, customActuator);
				
			}
			
		}
		
		return null;
		
	}
	
	
	private static function unload (actuator:GenericActuator):Void {
		
		var internal:MotionInternal = actuator;
		var targetString:String = Std.string (internal.target);
		
		if (targetLibraries.exists (targetString)) {
			
			targetLibraries.get (targetString).remove (actuator);
			
			if (targetLibraries.get (targetString).length == 0) {
				
				targetLibraries.remove (targetString);
				
			}
			
		}
		
	}
	
	
	/**
	 * Creates a new tween that updates a method rather than setting the properties of an object
	 * @example		<code>Actuate.update (trace, 1, ["Value: ", 0], ["", 1]).onComplete (trace, "Finished tracing values between 0 and 1");</code>
	 * @param	target		The method to update		
	 * @param	duration		The length of the tween in seconds
	 * @param	start		The starting parameters of the method call. You may use both numeric and non-numeric values
	 * @param	end		The ending parameters of the method call. You may use both numeric and non-numeric values, but the signature should match the start parameters
	 * @param	overwrite		Sets whether previous tweens for the same target and properties will be overwritten (Default is true)
	 * @return		The current actuator instance, which can be used to apply properties like ease, delay, onComplete or onUpdate
	 */
	//public static function update (target:Function, duration:Number, start:Array = null, end:Array = null, overwrite:Boolean = true):GenericActuator {
		
		//var properties:Object = { start: start, end: end };
		
		//return tween (target, duration, properties, overwrite, MethodActuator);
		
	//}
	
	
}


//import com.eclecticdesignstudio.motion.actuators.FilterActuator;
import com.eclecticdesignstudio.motion.actuators.GenericActuator;
//import com.eclecticdesignstudio.motion.actuators.TransformActuator;
import com.eclecticdesignstudio.motion.Actuate;
import flash.display.DisplayObject;
import flash.filters.BitmapFilter;
//import flash.filters.ColorMatrixFilter;
import flash.geom.Matrix;


class EffectsOptions {


private var duration:Float;
private var overwrite:Bool;
private var target:DisplayObject;


public function new (target:DisplayObject, duration:Float, overwrite:Bool) {
	
	this.target = target;
	this.duration = duration;
	this.overwrite = overwrite;
	
}


/**
 * Creates a new BitmapFilter tween
 * @param	reference		A reference to the target's filter, which can be an array index or the class of the filter
 * @param	properties		The end properties to use for the tween
 * @return		The current actuator instance, which can be used to apply properties like ease, delay, onComplete or onUpdate
 */
/*public function filter (reference:Dynamic, properties:Dynamic):GenericActuator {
	
	properties.filter = reference;
	
	return Actuate.tween (target, duration, properties, overwrite, FilterActuator);
	
}*/


}


class TransformOptions {


private var duration:Float;
private var overwrite:Bool;
private var target:Dynamic;


public function new (target:Dynamic, duration:Float, overwrite:Bool) {
	
	this.target = target;
	this.duration = duration;
	this.overwrite = overwrite;
	
}


/**
 * Creates a new ColorTransform tween
 * @param	color		The color value
 * @param	strength		The percentage amount of tint to apply (Default is 1)
 * @param	alpha		The end alpha of the target. If you wish to tween alpha and tint simultaneously, you must do them both as part of the ColorTransform. A value of null will make no change to the alpha of the object (Default is null)
 * @return		The current actuator instance, which can be used to apply properties like ease, delay, onComplete or onUpdate
 */
/*public function color (value:Float = 0x000000, strength:Float = 1, alpha:Dynamic = null):GenericActuator {
	
	var properties:Object = { colorValue: value, colorStrength: strength };
	
	if (Type.typeof (alpha) == Float) {
		
		properties.colorAlpha = alpha;
		
	}
	
	return Actuate.tween (target, duration, properties, overwrite, TransformActuator);
	
}*/


/**
 * Creates a new SoundTransform tween
 * @param	volume		The end volume for the target, or null if you would like to ignore this property (Default is null)
 * @param	pan		The end pan for the target, or null if you would like to ignore this property (Default is null)
 * @return		The current actuator instance, which can be used to apply properties like ease, delay, onComplete or onUpdate
 */
/*public function sound (volume:Dynamic = null, pan:Dynamic = null):GenericActuator {
	
	var properties:Object = new Object ();
	
	if (Type.typeof (volume) == Float) {
		
		properties.soundVolume = volume;
		
	}
	
	if (Type.typeof (pan) == Float) {
		
		properties.soundPan = pan;
		
	}
	
	return Actuate.tween (target, duration, properties, overwrite, TransformActuator);
	
}*/


}


class TweenTimer {


public var progress:Float;


public function new (progress:Float):Void {
	
	this.progress = progress;
	
}


}


typedef ActuateInternal = {
	private function unload (actuator:GenericActuator):Void;
}