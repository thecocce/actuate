﻿/**
 * @author Joshua Granick
 * @version 1.2
 */


package com.eclecticdesignstudio.motion.actuators;


import com.eclecticdesignstudio.motion.easing.IEasing;
import com.eclecticdesignstudio.motion.Actuate;
import flash.events.Event;


class GenericActuator implements IGenericActuator {
	
	
	public var duration:Float;
	public var id:String;
	public var properties:Dynamic;
	public var target:Dynamic;
	
	private var _autoVisible:Bool;
	private var _delay:Float;
	private var _ease:IEasing;
	private var _onComplete:Dynamic;
	private var _onCompleteParams:Array <Dynamic>;
	private var _onRepeat:Dynamic;
	private var _onRepeatParams:Array <Dynamic>;
	private var _onUpdate:Dynamic;
	private var _onUpdateParams:Array <Dynamic>;
	private var _reflect:Bool;
	private var _repeat:Int;
	private var _reverse:Bool;
	private var _smartRotation:Bool;
	private var _snapping:Bool;
	private var special:Bool;
	
	
	public function new (target:Dynamic, duration:Float, properties:Dynamic) {
		
		_autoVisible = true;
		_delay = 0;
		_reflect = false;
		_repeat = 0;
		_reverse = false;
		_smartRotation = false;
		_snapping = false;
		special = false;
		
		this.target = target;
		this.properties = properties;
		this.duration = duration;
		
		_ease = Actuate.defaultEase;
		
	}
	
	
	public function apply ():Void {
		
		for (i in Reflect.fields (properties)) {
			
			Reflect.setField (target, i, Reflect.field (properties, i));
			
		}
		
	}
	
	
	/**
	 * Flash performs faster when objects are set to visible = false rather than only alpha = 0. autoVisible toggles automatically based on alpha values
	 * @param	value		Whether autoVisible should be enabled (Default is true)
	 * @return		The current actuator instance
	 */
	public function autoVisible (?value:Null<Bool>):IGenericActuator {
		
		if (value == null) {
			
			value = true;
			
		}
		
		_autoVisible = value;
		
		return this;
		
	}
	
	
	private function change ():Void {
		
		if (_onUpdate != null) {
			
			Reflect.callMethod (_onUpdate, _onUpdate, _onUpdateParams);
			
		}
		
	}
	
	
	private function complete (sendEvent:Bool = true):Void {
		
		if (sendEvent) {
			
			change ();
			
			if (_onComplete != null) {
				
				Reflect.callMethod (_onComplete, _onComplete, _onCompleteParams);
				
			}
			
		}
		
		Actuate.unload (this);
		
	}
	
	
	/**
	 * Increases the delay before a tween is executed
	 * @param	duration		The amount of seconds to delay
	 * @return		The current actuator instance
	 */
	public function delay (duration:Float):IGenericActuator {
		
		_delay = duration;
		
		return this;
		
	}
	
	
	/**
	 * Sets the easing which is used when running the tween
	 * @param	easing		An easing equation, like Elastic.easeIn or Quad.easeOut
	 * @return		The current actuator instance
	 */
	public function ease (easing:IEasing):IGenericActuator {
		
		_ease = easing;
		
		return this;
		
	}
	
	
	public function move ():Void {
		
		
		
	}
	
	
	/**
	 * Defines a function which will be called when the tween finishes
	 * @param	handler		The function you would like to be called
	 * @param	parameters		Parameters you would like to pass to the handler function when it is called
	 * @return		The current actuator instance
	 */
	public function onComplete (handler:Dynamic, parameters:Array <Dynamic> = null):IGenericActuator {
		
		_onComplete = handler;
		_onCompleteParams = parameters;
		
		if (duration == 0) {
			
			complete ();
			
		}
		
		return this;
		
	}
	
	
	/**
	 * Defines a function which will be called when the tween repeats
	 * @param	handler		The function you would like to be called
	 * @param	parameters		Parameters you would like to pass to the handler function when it is called
	 * @return		The current actuator instance
	 */
	public function onRepeat (handler:Dynamic, parameters:Array <Dynamic> = null):IGenericActuator {
		
		_onRepeat = handler;
		_onRepeatParams = parameters;
		
		return this;
		
	}
	
	
	/**
	 * Defines a function which will be called when the tween updates
	 * @param	handler		The function you would like to be called
	 * @param	parameters		Parameters you would like to pass to the handler function when it is called
	 * @return		The current actuator instance
	 */
	public function onUpdate (handler:Dynamic, parameters:Array <Dynamic> = null):IGenericActuator {
		
		_onUpdate = handler;
		_onUpdateParams = parameters;
		
		return this;
		
	}
	
	
	public function pause ():Void {
		
		
		
	}
	
	
	/**
	 * Automatically changes the reverse value when the tween repeats. Repeat must be enabled for this to have any effect
	 * @param	value		Whether reflect should be enabled (Default is true)
	 * @return		The current actuator instance
	 */
	public function reflect (?value:Null<Bool>):IGenericActuator {
		
		if (value == null) {
			
			value = true;
			
		}
		
		_reflect = value;
		special = true;
		
		return this;
		
	}
	
	
	/**
	 * Repeats the tween after it finishes
	 * @param	times		The number of times you would like the tween to repeat, or -1 if you would like to repeat the tween indefinitely (Default is -1)
	 * @return		The current actuator instance
	 */
	public function repeat (?times:Null<Int>):IGenericActuator {
		
		if (times == null) {
			
			times = -1;
			
		}
		
		_repeat = times;
		
		return this;
		
	}
	
	
	public function resume ():Void {
		
		
		
	}
	
	
	/**
	 * Sets if the tween should be handled in reverse
	 * @param	value		Whether the tween should be reversed (Default is true)
	 * @return		The current actuator instance
	 */
	public function reverse (?value:Null<Bool>):IGenericActuator {
		
		if (value == null) {
			
			value = true;
			
		}
		
		_reverse = value;
		special = true;
		
		return this;
		
	}
	
	
	/**
	 * Enabling smartRotation can prevent undesired results when tweening rotation values
	 * @param	value		Whether smart rotation should be enabled (Default is true)
	 * @return		The current actuator instance
	 */
	public function smartRotation (?value:Null<Bool>):IGenericActuator {
		
		if (value == null) {
			
			value = true;
			
		}
		
		_smartRotation = value;
		special = true;
		
		return this;
		
	}
	
	
	/**
	 * Snapping causes tween values to be rounded automatically
	 * @param	value		Whether tween values should be rounded (Default is true)
	 * @return		The current actuator instance
	 */
	public function snapping (?value:Null<Bool>):IGenericActuator {
		
		if (value == null) {
			
			value = true;
			
		}
		
		_snapping = value;
		special = true;
		
		return this;
		
	}
	
	
	public function stop (properties:Dynamic, complete:Bool, sendEvent:Bool):Void {
		
		
		
	}
	
	
}


interface IGenericActuator {
	
	/**
	 * Flash performs faster when objects are set to visible = false rather than only alpha = 0. autoVisible toggles automatically based on alpha values
	 * @param	value		Whether autoVisible should be enabled (Default is true)
	 * @return		The current actuator instance
	 */
	public function autoVisible (?value:Null<Bool>):IGenericActuator;
	
	/**
	 * Increases the delay before a tween is executed
	 * @param	duration		The amount of seconds to delay
	 * @return		The current actuator instance
	 */
	public function delay (duration:Float):IGenericActuator;
	
	/**
	 * Sets the easing which is used when running the tween
	 * @param	easing		An easing equation, like Elastic.easeIn or Quad.easeOut
	 * @return		The current actuator instance
	 */
	public function ease (easing:IEasing):IGenericActuator;
	
	/**
	 * Defines a function which will be called when the tween finishes
	 * @param	handler		The function you would like to be called
	 * @param	parameters		Parameters you would like to pass to the handler function when it is called
	 * @return		The current actuator instance
	 */
	public function onComplete (handler:Dynamic, ?parameters:Array <Dynamic>):IGenericActuator;
	
	/**
	 * Defines a function which will be called when the tween repeats
	 * @param	handler		The function you would like to be called
	 * @param	parameters		Parameters you would like to pass to the handler function when it is called
	 * @return		The current actuator instance
	 */
	public function onRepeat (handler:Dynamic, ?parameters:Array <Dynamic>):IGenericActuator;
	
	/**
	 * Defines a function which will be called when the tween updates
	 * @param	handler		The function you would like to be called
	 * @param	parameters		Parameters you would like to pass to the handler function when it is called
	 * @return		The current actuator instance
	 */
	public function onUpdate (handler:Dynamic, ?parameters:Array <Dynamic>):IGenericActuator;
	
	/**
	 * Automatically changes the reverse value when the tween repeats. Repeat must be enabled for this to have any effect
	 * @param	value		Whether reflect should be enabled (Default is true)
	 * @return		The current actuator instance
	 */
	public function reflect (?value:Null<Bool>):IGenericActuator;
	
	/**
	 * Repeats the tween after it finishes
	 * @param	times		The number of times you would like the tween to repeat, or -1 if you would like to repeat the tween indefinitely (Default is -1)
	 * @return		The current actuator instance
	 */
	public function repeat (?times:Null<Int>):IGenericActuator;
	
	/**
	 * Sets if the tween should be handled in reverse
	 * @param	value		Whether the tween should be reversed (Default is true)
	 * @return		The current actuator instance
	 */
	public function reverse (?value:Null<Bool>):IGenericActuator;
	
	/**
	 * Enabling smartRotation can prevent undesired results when tweening rotation values
	 * @param	value		Whether smart rotation should be enabled (Default is true)
	 * @return		The current actuator instance
	 */
	public function smartRotation (?value:Null<Bool>):IGenericActuator;
	
	/**
	 * Snapping causes tween values to be rounded automatically
	 * @param	value		Whether tween values should be rounded (Default is true)
	 * @return		The current actuator instance
	 */
	public function snapping (?value:Null<Bool>):IGenericActuator;
	
}