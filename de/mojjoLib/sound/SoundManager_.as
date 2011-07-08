﻿package de.mojjoLib.sound{	import com.greensock.TweenMax;		import flash.media.Sound;	import flash.media.SoundChannel;	import flash.media.SoundTransform;	import flash.utils.Dictionary;			/**	 * The SoundManager is a singleton that allows you to have various ways to control sounds in your project.	 * <p />	 * The SoundManager can load external or library sounds, pause/mute/stop/control volume for one or more sounds at a time, 	 * fade sounds up or down, and allows additional control to sounds not readily available through the default classes.	 * <p />	 * This class is dependent on TweenLite (http://www.tweenlite.com) to aid in easily fading the volume of the sound.	 * 	 * @author Matt Przybylski [http://www.reintroducing.com]	 * @version 1.0	 */	public class SoundManager_	{		private static var _instance:SoundManager;				private var _soundsDict:Dictionary;		private var _sounds:Array;				public var masterVolBgm:Number;		public var masterVolFx:Number;				public static function getInstance():SoundManager 		{			return _instance ? _instance : _instance = new SoundManager();		}				public function SoundManager_() 		{			this._soundsDict = new Dictionary(true);			this._sounds = new Array();			this.masterVolBgm = 1;			this.masterVolFx = 1;						if (_instance)			{				throw new Error("Error: Use SoundManager.getInstance() instead of the new keyword.");			}		}				public function addSound(sound:Sound, name:String, category:String):Boolean		{			for (var i:int = 0; i < this._sounds.length; i++)			{				if (this._sounds[i].name == name)				{					//trace('['+name+'] este som já foi adicionado a biblioteca');					return false;				}			}						var sndObj:Object = new Object();			var snd:Sound = sound;						sndObj.name = name;			sndObj.category = category;			sndObj.sound = snd;			sndObj.channel = new SoundChannel();			sndObj.position = 0;			sndObj.paused = true;			sndObj.volume = 1;			sndObj.volMultiplier = 1;			sndObj.startTime = 0;			sndObj.loops = 0;			sndObj.pausedByAll = false;						this._soundsDict[name] = sndObj;			this._sounds.push(sndObj);						return true;		}						public function removeSound(name:String):void		{			for (var i:int = 0; i < this._sounds.length; i++)			{				if (this._sounds[i].name == name)				{					this._sounds[i] = null;					this._sounds.splice(i, 1);				}			}						delete this._soundsDict[name];		}				public function removeAllSounds():void		{			for (var i:int = 0; i < this._sounds.length; i++)			{				this._sounds[i] = null;			}						this._sounds = new Array();			this._soundsDict = new Dictionary(true);		}		public function playSound(name:String, volume:Number = 1, startTime:Number = 0, loops:int = 0, fadeIn:Number = 0):void		{			var snd:Object = this._soundsDict[name];			snd.volume = volume;			snd.startTime = startTime;			snd.loops = loops;							if (snd.paused)			{				snd.channel = snd.sound.play(snd.position, snd.loops, new SoundTransform(0));				if(snd.channel) TweenMax.to(snd.channel, fadeIn, {volume:(snd.volume * snd.volMultiplier)});			}			else			{				snd.channel = snd.sound.play(startTime, snd.loops, new SoundTransform(0));				if(snd.channel) TweenMax.to(snd.channel, fadeIn, {volume:(snd.volume * snd.volMultiplier)});			}						snd.paused = false;		}				public function stopSound(name:String):void		{			var snd:Object = this._soundsDict[name];			snd.paused = true;			snd.channel.stop();			snd.position = snd.channel.position;		}						public function stopAllSounds(useCurrentlyPlayingOnly:Boolean = true):void		{			for (var i:int = 0; i < this._sounds.length; i++)			{				var id:String = this._sounds[i].name;								if (useCurrentlyPlayingOnly)				{					if (!this._soundsDict[id].paused)					{						this._soundsDict[id].pausedByAll = true;						this.stopSound(id);					}				}				else				{					this.stopSound(id);				}			}		}				public function setAllSoundVolume(vol:Number, category:String = null):void		{			for (var i:int = 0; i < this._sounds.length; i++)			{				var id:String;								if(category && this._sounds[i].category == category)				{					id = this._sounds[i].name;				}				else if (!category)				{					id = this._sounds[i].name;				}								if(id)	this.setSoundVolume(id, vol);			}		}						public function setSoundVolume(name:String, volume:Number):void		{			var snd:Object = this._soundsDict[name];			var curTransform:SoundTransform = snd.channel.soundTransform;			curTransform.volume = volume * snd.volMultiplier;			snd.channel.soundTransform = curTransform;		}				public function getSound(name:String):Object {	return this._soundsDict[name];	}		public function get sounds():Array { return this._sounds; }		}}