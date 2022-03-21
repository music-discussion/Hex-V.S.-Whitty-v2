package;

import openfl.ui.KeyLocation;
import openfl.events.Event;
import haxe.EnumTools;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import Replay.Ana;
import Replay.Analysis;
#if cpp
import webm.WebmPlayer;
#end
import flixel.input.keyboard.FlxKey;
import haxe.Exception;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import lime.graphics.Image;
import flixel.graphics.FlxGraphic;
import openfl.utils.AssetManifest;
import openfl.utils.AssetLibrary;
import flixel.system.FlxAssets;

import lime.app.Application;
import lime.media.AudioContext;
import lime.media.AudioManager;

import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;

import openfl.Lib;
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

#if windows
import Discord.DiscordClient;
#end
#if windows
import Sys;
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState = null;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var weekScore:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;
	public static var mania:Int = 0;
	public static var maniaToChange:Int = 0;
	public static var keyAmmo:Array<Int> = [4, 6, 9, 5, 7, 8, 1, 2, 3];
	public static var keyBotplay:Bool = false;
	public static var practiceMode:Bool = false;
	private var ctrTime:Float = 0;

	public static var songPosBG:FlxSprite;
	public var visibleCombos:Array<FlxSprite> = [];
	public static var songPosBar:FlxBar;

	public static var rep:Replay;
	public static var loadRep:Bool = false;

	public static var noteBools:Array<Bool> = [false, false, false, false];

	var halloweenLevel:Bool = false;

	var songLength:Float = 0;
	var kadeEngineWatermark:FlxText;
	
	#if windows
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	private var vocals:FlxSound;

	public var originalX:Float;

	public static var arrowSliced:Array<Bool> = [false, false, false, false, false, false, false, false, false]; //leak :)

	public static var dad:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;

	public var notes:FlxTypedGroup<Note>;
	var noteSplashes:FlxTypedGroup<NoteSplash>;
	private var unspawnNotes:Array<Note> = [];

	private var sDir:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	private var bfsDir:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	private var missDir:Array<String> = ['RIGHT', 'UP', 'DOWN', 'LEFT'];

	public var strumLine:FlxSprite;
	private var curSection:Int = 0;

	var replacableTypeList:Array<Int> = [3,4,7]; //note types do wanna hit
	var nonReplacableTypeList:Array<Int> = [1,2,6]; //note types you dont wanna hit

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	var dadT:FlxTrail;

	var shaggyTrail:FlxTrail;
	var dadTrail:FlxTrail;
	var dad2Trail:FlxTrail;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	public static var cpuStrums:FlxTypedGroup<FlxSprite> = null;

	var grace:Bool = false;

	public var hank:FlxSprite;
	public var hexError:FlxSprite;
	public var terminateError:FlxSprite;

	var cover:FlxSprite = new FlxSprite(-180,755).loadGraphic(Paths.image('fourth/cover','clown'));
	var hole:FlxSprite = new FlxSprite(50,530).loadGraphic(Paths.image('fourth/Spawnhole_Ground_BACK','clown'));
	var converHole:FlxSprite = new FlxSprite(7,578).loadGraphic(Paths.image('fourth/Spawnhole_Ground_COVER','clown'));

	public var cutsceneText:Array<String> = ["OMFG CLOWN!!!!", "YOU DO NOT KILL CLOWN", "CLOWN KILLS YOU!!!!!!"];

	public var TrickyLinesSing:Array<String> = ["SUFFER","INCORRECT", "INCOMPLETE", "INSUFFICIENT", "INVALID", "CORRECTION", "MISTAKE", "REDUCE", "ERROR", "ADJUSTING", "IMPROBABLE", "IMPLAUSIBLE", "MISJUDGED"];
	public var ExTrickyLinesSing:Array<String> = ["YOU AREN'T HANK", "WHERE IS HANK", "HANK???", "WHO ARE YOU", "WHERE AM I", "THIS ISN'T RIGHT", "MIDGET", "SYSTEM UNRESPONSIVE", "WHY CAN'T I KILL?????"];
	public var TrickyLinesMiss:Array<String> = ["TERRIBLE", "WASTE", "MISS CALCULTED", "PREDICTED", "FAILURE", "DISGUSTING", "ABHORRENT", "FORESEEN", "CONTEMPTIBLE", "PROGNOSTICATE", "DISPICABLE", "REPREHENSIBLE"];

	private var camZooming:Bool = false;
	private var curSong:String = "";

	/*
	source/PlayState.hx:439: characters 3-18 : Unknown identifier : TrickyLinesSing
source/PlayState.hx:440: characters 3-18 : Unknown identifier : TrickyLinesMiss
source/PlayState.hx:441: characters 3-20 : Unknown identifier : ExTrickyLinesSing
source/PlayState.hx:2018: characters 10-24 : Unknown identifier : loadSongHazard
source/PlayState.hx:6929: characters 8-22 : Unknown identifier : loadSongHazard
source/PlayState.hx:7523: characters 29-43 : Unknown identifier : loadSongHazard
source/PlayState.hx:6882: characters 26-40 : Unknown identifier : loadSongHazard
*/

// MY GOD HOW TO FIX THE STUPID DUMB LOADSONGHAZARD!!!!!!!!!!!!!!!!! UGHHHHHHHHHHHHHHHHHHHHHHHH

	private var gfSpeed:Int = 1;
	public var health:Float = 1; //making public because sethealth doesnt work without it
	private var combo:Int = 0;
	public static var misses:Int = 0;
	public static var campaignMisses:Int = 0;
	public static var campaignSicks:Int = 0;
	public static var campaignGoods:Int = 0;
	public static var campaignBads:Int = 0;
	public static var campaignShits:Int = 0;
	public var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;
	private var ss:Bool = false;
	public static var trans:FlxSprite;

	var hold:Array<Bool>;
	var press:Array<Bool>;
	var release:Array<Bool>;

	var hazardRandom:Int = 1; //This integer is randomised upon song start between 1-5.
	var cessationTroll:FlxSprite;
	var streetBG:FlxSprite;
	var qt_tv01:FlxSprite;
	var streetFront:FlxSprite;
	//For detecting if the song has already ended internally for Careless's end song dialogue or something -Haz.
	var qtCarelessFin:Bool = false; //If true, then the song has ended, allowing for the school intro to play end dialogue instead of starting dialogue.
	var qtCarelessFinCalled:Bool = false; //Used for terminates meme ending to stop it constantly firing code when song ends or something.
	//For Censory Overload -Haz
	var qt_gas01:FlxSprite;
	var qt_gas02:FlxSprite;
	public static var cutsceneSkip:Bool = false;
	//For changing the visuals -Haz
	var streetBGerror:FlxSprite;
	var streetFrontError:FlxSprite;
	var dad404:Character;
	var gf404:Character;
	var boyfriend404:Boyfriend;

	//how im doing bluescreens
	var isdad404:Bool = false;
	var isbf404:Bool = false;
	var isgf404:Bool = false;

	var do404:Bool = false;

	var makeItCRASH:FlxSprite;
//	var bfWhitty:Boyfriend;
	var qtIsBlueScreened:Bool = false;
	//Termination-playable
	var bfDodging:Bool = false;
	var bfCanDodge:Bool = false;
	var bfDodgeTiming:Float = 0.15;
	var bfDodgeCooldown:Float = 0.1135;
	var kb_attack_saw:FlxSprite;
	var kb_attack_alert:FlxSprite;
	var pincer1:FlxSprite;
	public static var isUsingBot:Bool = false;
	var pincer2:FlxSprite;
	var pincer3:FlxSprite;
	var pincer4:FlxSprite;
	var MaxHealth:Int = 5;
	var hasStarted:Bool = true;
	var canDie:Bool = true;
	public static var deathBySawBlade:Bool = false;
	var canSkipEndScreen:Bool = false; //This is set to true at the "thanks for playing" screen. Once true, in update, if enter is pressed it'll skip to the main menu.

	var noGameOver:Bool = false; //If on debug mode, pressing 5 would toggle this variable, making it impossible to die!

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;
	private var overhealthBar:FlxBar;
	private var songPositionBar:Float = 0;
	
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon; //making these public again because i may be stupid
	public var iconP2:HealthIcon; //what could go wrong?
	public var camHUD:FlxCamera;
	public var camSustains:FlxCamera;
	public var camNotes:FlxCamera;
	var cs_reset:Bool = false;
	public var cannotDie = false;
	private var camGame:FlxCamera;
	private var floatdad:Float = 0;
	private var floatdad2:Float = 0;

	private var dad2:Character; //p2 vars
	var isdad2:Bool = false;

	var isdad:Bool = true; //auto set to true
	var isbf:Bool = true;

	var exDad:Bool = false;

	public static var offsetTesting:Bool = false;

	private var shakeCam:Bool = false;
	private var shakeCock:Bool = false;

	var notesHitArray:Array<Date> = [];
	var currentFrames:Int = 0;
	var idleToBeat:Bool = true; // change if bf and dad would idle to the beat of the song
	var idleBeat:Int = 2; // how frequently bf and dad would play their idle animation(1 - every beat, 2 - every 2 beats and so on)

	public var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;
	var songName:FlxText;
	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var fc:Bool = true;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();

	var talking:Bool = true;
	public var songScore:Int = 0;
	var songScoreDef:Int = 0;
	var scoreTxt:FlxText;
	var replayTxt:FlxText;
	var startedCountdown:Bool = false;

	var maniaChanged:Bool = false;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;

	public static var daPixelZoom:Float = 6;

	public var currentSection:SwagSection;

	public static var theFunne:Bool = true;
	var funneEffect:FlxSprite;
	var inCutscene:Bool = false;
	public static var repPresses:Int = 0;
	public static var repReleases:Int = 0;

	public static var timeCurrently:Float = 0;
	public static var timeCurrentlyR:Float = 0;

//	var makeItCRASH:FlxSprite; //used to make the game fake crash on Terminate. -Discussions
	
	// Will fire once to prevent debug spam messages and broken animations
	private var triggeredAlready:Bool = false;
	
	// Will decide if she's even allowed to headbang at all depending on the song
	private var allowedToHeadbang:Bool = false;
	// Per song additive offset
	public static var songOffset:Float = 0;
	// BotPlay text
	private var botPlayState:FlxText;
	// Replay shit
	private var saveNotes:Array<Dynamic> = [];
	private var saveJudge:Array<String> = [];
	private var replayAna:Analysis = new Analysis(); // replay analysis
	var shadow1:FlxSprite;
	var shadow2:FlxSprite;
	var theBlackBG:FlxSprite;
	var cum:FlxSprite;

	public static var highestCombo:Int = 0;
	private var godModeFloat:Bool = false;

	var tstatic:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('TrickyStatic','clown'), true, 320, 180);

	var tStaticSound:FlxSound = new FlxSound().loadEmbedded(Paths.sound("staticSound","preload"));

	private var executeModchart = false;
	public static var startTime = 0.0;

	var MAINLIGHT:FlxSprite;

	// API stuff
	
	public function addObject(object:FlxBasic) { add(object); }
	public function removeObject(object:FlxBasic) { remove(object); }


	override public function create()
	{
		FlxG.mouse.visible = false;
		instance = this;
		
		if (FlxG.save.data.fpsCap > 290)
			(cast (Lib.current.getChildAt(0), Main)).setFPSCap(800);
		
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		if (!isStoryMode)
		{
			sicks = 0;
			bads = 0;
			shits = 0;
			goods = 0;
		}
		misses = 0;

		repPresses = 0;
		repReleases = 0;


		PlayStateChangeables.useDownscroll = FlxG.save.data.downscroll;
		PlayStateChangeables.safeFrames = FlxG.save.data.frames;
		PlayStateChangeables.scrollSpeed = FlxG.save.data.scrollSpeed;
		PlayStateChangeables.botPlay = FlxG.save.data.botplay;
		PlayStateChangeables.Optimize = FlxG.save.data.optimize;

		// pre lowercasing the song name (create)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
		}
		
		removedVideo = false;

		#if windows
		executeModchart = FileSystem.exists(Paths.lua(songLowercase  + "/modchart"));
		if (executeModchart)
			PlayStateChangeables.Optimize = false;
		#end
		#if !cpp
		executeModchart = false; // FORCE disable for non cpp targets
		#end

		trace('Mod chart: ' + executeModchart + " - " + Paths.lua(songLowercase + "/modchart"));


		noteSplashes = new FlxTypedGroup<NoteSplash>();
		var daSplash = new NoteSplash(100, 100, 0);
		daSplash.alpha = 0;
		noteSplashes.add(daSplash);


		#if windows
		// Making difficulty text for Discord Rich Presence.
		storyDifficultyText = CoolUtil.difficultyFromInt(storyDifficulty);

		iconRPC = SONG.player2;

		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore +  " | why are you looking in here" + " | Misses: " + misses  , iconRPC);
		#end


		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camSustains = new FlxCamera();
		camSustains.bgColor.alpha = 0;
		camNotes = new FlxCamera();
		camNotes.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camSustains);
		FlxG.cameras.add(camNotes);

		camHUD.zoom = PlayStateChangeables.zoom;

		FlxCamera.defaultCameras = [camGame];

		TrickyLinesSing = CoolUtil.coolTextFile(Paths.txt('trickySingStrings'));
		TrickyLinesMiss = CoolUtil.coolTextFile(Paths.txt('trickyMissStrings'));
		ExTrickyLinesSing = CoolUtil.coolTextFile(Paths.txt('trickyExSingStrings'));

		//load cutscene text
		cutsceneText = CoolUtil.coolTextFile(Paths.txt('cutMyBalls'));
		//yes i called it "cut my balls" fuck you i can name my txts whatever i want


		persistentUpdate = true;
		persistentDraw = true;

		mania = SONG.mania;

		traceBoth('testing to see if mania is undefined...');
		traceBoth('mania is: '+mania);

		if (Std.string(mania).toLowerCase() == 'null' || Std.string(mania).toLowerCase() == 'undefined') { //new check for mania, the old one messed up on windows lol.
			traceBoth('mania was null/undefined. resetting to 0');
			mania = 0;
		}
		else {
			traceBoth('mania was not null.');
		}

		traceBoth('mania is now: '+mania);

		maniaToChange = mania;

		Note.scaleSwitch = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial', 'tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		trace('INFORMATION ABOUT WHAT U PLAYIN WIT:\nFRAMES: ' + PlayStateChangeables.safeFrames + '\nZONE: ' + Conductor.safeZoneOffset + '\nTS: ' + Conductor.timeScale + '\nBotPlay : ' + PlayStateChangeables.botPlay + '\nMania Amount: ' + mania + '/' + SONG.mania);
	
		//dialogue shit
		switch (songLowercase)
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
			case 'senpai':
				dialogue = CoolUtil.coolTextFile(Paths.txt('senpai/senpaiDialogue'));
			case 'roses':
				dialogue = CoolUtil.coolTextFile(Paths.txt('roses/rosesDialogue'));
			case 'thorns':
				dialogue = CoolUtil.coolTextFile(Paths.txt('thorns/thornsDialogue'));
			case 'carefree':
				dialogue = CoolUtil.coolTextFile(Paths.txt('carefree/carefreeDialogue'));
			case 'careless':
				dialogue = CoolUtil.coolTextFile(Paths.txt('careless/carelessDialogue'));
			case 'cessation':
				dialogue = CoolUtil.coolTextFile(Paths.txt('cessation/finalDialogue'));
			case 'censory-overload':
				dialogue = CoolUtil.coolTextFile(Paths.txt('censory-overload/censory-overloadDialogue'));
			case 'terminate': //dont take advantage that i didn't hard code this shit
				dialogue = CoolUtil.coolTextFile(Paths.txt('terminate/terminateDialogue'));
		}

		//defaults if no stage was found in chart
		var stageCheck:String = 'stage';
		
		if (SONG.stage == null) {
			switch(storyWeek)
			{
				case 2: stageCheck = 'halloween';
				case 3: stageCheck = 'philly';
				case 4: stageCheck = 'limo';
				case 5: if (songLowercase == 'winter-horrorland') {stageCheck = 'mallEvil';} else {stageCheck = 'mall';}
				case 6: if (songLowercase == 'thorns') {stageCheck = 'schoolEvil';} else {stageCheck = 'school';}
				//i should check if its stage (but this is when none is found in chart anyway)
			}
		} else {stageCheck = SONG.stage;}

		if (!PlayStateChangeables.Optimize)
		{

		switch(stageCheck)
		{
			case 'halloween': 
			{
				curStage = 'spooky';
				halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('halloween_bg','week2');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = FlxG.save.data.antialiasing;
				add(halloweenBG);

				isHalloween = true;
			}
			case 'philly': 
					{
					curStage = 'philly';

					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky', 'week3'));
					bg.scrollFactor.set(0.1, 0.1);
					add(bg);

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city', 'week3'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					add(city);

					phillyCityLights = new FlxTypedGroup<FlxSprite>();
					if(FlxG.save.data.distractions){
						add(phillyCityLights);
					}

					for (i in 0...5)
					{
							var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i, 'week3'));
							light.scrollFactor.set(0.3, 0.3);
							light.visible = false;
							light.setGraphicSize(Std.int(light.width * 0.85));
							light.updateHitbox();
							light.antialiasing = FlxG.save.data.antialiasing;
							phillyCityLights.add(light);
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain','week3'));
					add(streetBehind);

					phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train','week3'));
					if(FlxG.save.data.distractions){
						add(phillyTrain);
					}

					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes','week3'));
					FlxG.sound.list.add(trainSound);

					// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

					var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street','week3'));
					add(street);
			}
			case 'limo':
			{
					curStage = 'limo';
					defaultCamZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset','week4'));
					skyBG.scrollFactor.set(0.1, 0.1);
					skyBG.antialiasing = FlxG.save.data.antialiasing;
					add(skyBG);

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo','week4');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					bgLimo.antialiasing = FlxG.save.data.antialiasing;
					add(bgLimo);
					if(FlxG.save.data.distractions){
						grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
						add(grpLimoDancers);
	
						for (i in 0...5)
						{
								var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
								dancer.scrollFactor.set(0.4, 0.4);
								grpLimoDancers.add(dancer);
						}
					}

					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('limo/limoOverlay','week4'));
					overlayShit.alpha = 0.5;
					// add(overlayShit);

					// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

					// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

					// overlayShit.shader = shaderBullshit;

					var limoTex = Paths.getSparrowAtlas('limo/limoDrive','week4');

					limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = FlxG.save.data.antialiasing;

					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol','week4'));
					fastCar.antialiasing = FlxG.save.data.antialiasing;
					// add(limo);
			}
			case 'mall':
			{
					curStage = 'mall';

					defaultCamZoom = 0.80;

					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls','week5'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					upperBoppers = new FlxSprite(-240, -90);
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop','week5');
					upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
					upperBoppers.antialiasing = FlxG.save.data.antialiasing;
					upperBoppers.scrollFactor.set(0.33, 0.33);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(upperBoppers);
					}


					var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator','week5'));
					bgEscalator.antialiasing = FlxG.save.data.antialiasing;
					bgEscalator.scrollFactor.set(0.3, 0.3);
					bgEscalator.active = false;
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					add(bgEscalator);

					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree','week5'));
					tree.antialiasing = FlxG.save.data.antialiasing;
					tree.scrollFactor.set(0.40, 0.40);
					add(tree);

					bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop','week5');
					bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
					bottomBoppers.antialiasing = FlxG.save.data.antialiasing;
					bottomBoppers.scrollFactor.set(0.9, 0.9);
					bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
					bottomBoppers.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bottomBoppers);
					}


					var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow','week5'));
					fgSnow.active = false;
					fgSnow.antialiasing = FlxG.save.data.antialiasing;
					add(fgSnow);

					santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('christmas/santa','week5');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = FlxG.save.data.antialiasing;
					if(FlxG.save.data.distractions){
						add(santa);
					}
			}
			case 'mallEvil':
			{
					curStage = 'mallEvil';
					var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG','week5'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					add(bg);

					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree','week5'));
					evilTree.antialiasing = FlxG.save.data.antialiasing;
					evilTree.scrollFactor.set(0.2, 0.2);
					add(evilTree);

					var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow",'week5'));
						evilSnow.antialiasing = FlxG.save.data.antialiasing;
					add(evilSnow);
			}
			case 'school':
			{
					curStage = 'school';

					// defaultCamZoom = 0.9;

					var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky','week6'));
					bgSky.scrollFactor.set(0.1, 0.1);
					add(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool','week6'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					add(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet','week6'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					add(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack','week6'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					add(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees','week6');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					add(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals','week6');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					add(treeLeaves);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);

					fgTrees.updateHitbox();
					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();

					bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					if (songLowercase == 'roses')
						{
							if(FlxG.save.data.distractions){
								bgGirls.getScared();
							}
						}

					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					bgGirls.updateHitbox();
					if(FlxG.save.data.distractions){
						add(bgGirls);
					}
			}
			case 'schoolEvil':
			{
					curStage = 'schoolEvil';

					if (!PlayStateChangeables.Optimize)
						{
							var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
							var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);
						}

					var posX = 400;
					var posY = 200;

					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool','week6');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					add(bg);
			}
		}

		switch (SONG.song.toLowerCase())
		{
			case 'improbable-outset' | 'madness':
				//trace("line 538");
				defaultCamZoom = 0.75;
				curStage = 'nevada';
	
				tstatic.antialiasing = true;
				tstatic.scrollFactor.set(0,0);
				tstatic.setGraphicSize(Std.int(tstatic.width * 8.3));
				tstatic.animation.add('static', [0, 1, 2], 24, true);
				tstatic.animation.play('static');
	
				tstatic.alpha = 0;
	
				var bg:FlxSprite = new FlxSprite(-350, -300).loadGraphic(Paths.image('red','clown'));
				// bg.setGraphicSize(Std.int(bg.width * 2.5));
				// bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				var stageFront:FlxSprite;
				if (SONG.song.toLowerCase() != 'madness')
				{
					add(bg);
					stageFront = new FlxSprite(-1100, -460).loadGraphic(Paths.image('island_but_dumb','clown'));
				}
				else
					stageFront = new FlxSprite(-1100, -460).loadGraphic(Paths.image('island_but_rocks_float','clown'));
	
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.4));
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);
				
				MAINLIGHT = new FlxSprite(-470, -150).loadGraphic(Paths.image('hue','clown'));
				MAINLIGHT.alpha - 0.3;
				MAINLIGHT.setGraphicSize(Std.int(MAINLIGHT.width * 0.9));
				MAINLIGHT.blend = "screen";
				MAINLIGHT.updateHitbox();
				MAINLIGHT.antialiasing = true;
				MAINLIGHT.scrollFactor.set(1.2, 1.2);
			case 'hellclown':
				//trace("line 538");
				defaultCamZoom = 0.35;
				curStage = 'nevadaSpook';
	
				tstatic.antialiasing = true;
				tstatic.scrollFactor.set(0,0);
				tstatic.setGraphicSize(Std.int(tstatic.width * 10));
				tstatic.screenCenter(Y);
				tstatic.animation.add('static', [0, 1, 2], 24, true);
				tstatic.animation.play('static');
	
				tstatic.alpha = 0;
	
	
				var bg:FlxSprite = new FlxSprite(-1000, -1000).loadGraphic(Paths.image('fourth/bg','clown'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.setGraphicSize(Std.int(bg.width * 5));
				bg.active = false;
				add(bg);
	
				var stageFront:FlxSprite = new FlxSprite(-2000, -400).loadGraphic(Paths.image('hellclwn/island_but_red','clown'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 2.6));
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				add(stageFront);
				
				hank = new FlxSprite(60,-170);
				hank.frames = Paths.getSparrowAtlas('hellclwn/Hank','clown');
				hank.animation.addByPrefix('dance','Hank',24);
				hank.animation.play('dance');
				hank.scrollFactor.set(0.9, 0.9);
				hank.setGraphicSize(Std.int(hank.width * 1.55));
				hank.antialiasing = true;
				
	
				add(hank);
			case 'expurgation':
				//trace("line 538");
				defaultCamZoom = 0.55;
				curStage = 'auditorHell';
	
				tstatic.antialiasing = true;
				tstatic.scrollFactor.set(0,0);
				tstatic.setGraphicSize(Std.int(tstatic.width * 8.3));
				tstatic.animation.add('static', [0, 1, 2], 24, true);
				tstatic.animation.play('static');
	
				tstatic.alpha = 0;
	
				var bg:FlxSprite = new FlxSprite(-10, -10).loadGraphic(Paths.image('fourth/bg','clown'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 4));
				add(bg);
	
				hole.antialiasing = true;
				hole.scrollFactor.set(0.9, 0.9);
						
				converHole.antialiasing = true;
				converHole.scrollFactor.set(0.9, 0.9);
				converHole.setGraphicSize(Std.int(converHole.width * 1.3));
				hole.setGraphicSize(Std.int(hole.width * 1.55));
	
				cover.antialiasing = true;
				cover.scrollFactor.set(0.9, 0.9);
				cover.setGraphicSize(Std.int(cover.width * 1.55));
	
				var energyWall:FlxSprite = new FlxSprite(1350,-690).loadGraphic(Paths.image("fourth/Energywall","clown"));
				energyWall.antialiasing = true;
				energyWall.scrollFactor.set(0.9, 0.9);
				add(energyWall);
				
				var stageFront:FlxSprite = new FlxSprite(-350, -355).loadGraphic(Paths.image('fourth/daBackground','clown'));
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.55));
				add(stageFront);
	
				hexError = new FlxSprite(0,0).loadGraphic(Paths.image('fourth/hexError', 'clown'));
				hexError.antialiasing = true;
				hexError.scrollFactor.set(0.9, 0.9);
				hexError.setGraphicSize(Std.int(stageFront.width * 1));
				add(hexError);
				// hexError = new FlxSprite('fourth/hexError','clown'); beta add code lol
			case 'termination':
				defaultCamZoom = 0.8125;
					
				curStage = 'streetFinal';

			//	var streetBG:FlxSprite;

				//Back Layer - Normal
				streetBG = new FlxSprite(-750, -145).loadGraphic(Paths.image('stage/streetBack', 'qt'));
				streetBG.antialiasing = true;
				streetBG.scrollFactor.set(0.9, 0.9);
				add(streetBG);


				//Front Layer - Normal
				streetFront = new FlxSprite(-820, 710).loadGraphic(Paths.image('stage/streetFront', 'qt'));
				streetFront.setGraphicSize(Std.int(streetFront.width * 1.15));
				streetFront.updateHitbox();
				streetFront.antialiasing = true;
				streetFront.scrollFactor.set(0.9, 0.9);
				streetFront.active = false;
				add(streetFront);

			//	var qt_tv01:FlxSprite;

				//Back Layer - Error (glitched version of normal Back)
				streetBGerror = new FlxSprite(-750, -145).loadGraphic(Paths.image('stage/streetBackError', 'qt'));
				streetBGerror.antialiasing = true;
				streetBGerror.scrollFactor.set(0.9, 0.9);
				add(streetBGerror);

				streetBGerror.visible = false;

				if(!Main.qtOptimisation){
					//Front Layer - Error (changes to have a glow)
					streetFrontError = new FlxSprite(-820, 710).loadGraphic(Paths.image('stage/streetFrontError', 'qt'));
					streetFrontError.setGraphicSize(Std.int(streetFrontError.width * 1.15));
					streetFrontError.updateHitbox();
					streetFrontError.antialiasing = true;
					streetFrontError.scrollFactor.set(0.9, 0.9);
					streetFrontError.active = false;
					add(streetFrontError);
					streetFrontError.visible = false;
				}

				qt_tv01 = new FlxSprite();
				qt_tv01.frames = Paths.getSparrowAtlas('stage/TV_V5', 'qt');
				qt_tv01.animation.addByPrefix('idle', 'TV_Idle', 24, true);
				qt_tv01.animation.addByPrefix('eye', 'TV_brutality', 24, true); //Replaced the hex eye with the brutality symbols for more accurate lore.
				qt_tv01.animation.addByPrefix('eyeRight', 'TV_eyeRight', 24, true);
				qt_tv01.animation.addByPrefix('eyeLeft', 'TV_eyeLeft', 24, true);
				qt_tv01.animation.addByPrefix('error', 'TV_Error', 24, true);	
				qt_tv01.animation.addByPrefix('404', 'TV_Bluescreen', 24, true);		
				qt_tv01.animation.addByPrefix('alert', 'TV_Attention', 36, false);		
				qt_tv01.animation.addByPrefix('watch', 'TV_Watchout', 24, true);
				qt_tv01.animation.addByPrefix('drop', 'TV_Drop', 24, true);
				qt_tv01.animation.addByPrefix('sus', 'TV_sus', 24, true);
				qt_tv01.animation.addByPrefix('instructions', 'TV_Instructions-Normal', 24, true);
				qt_tv01.animation.addByPrefix('gl', 'TV_GoodLuck', 24, true);
				qt_tv01.setPosition(-62, 540);
				qt_tv01.setGraphicSize(Std.int(qt_tv01.width * 1.2));
				qt_tv01.updateHitbox();
				qt_tv01.antialiasing = true;
				qt_tv01.scrollFactor.set(0.89, 0.89);
				add(qt_tv01);
				qt_tv01.animation.play('idle');

					boyfriend404 = new Boyfriend(770, 450, 'bf_404');
					dad404 = new Character(100,100,'robot_404-TERMINATION');
					gf404 = new Character(400,130,'gf_404');
					gf404.scrollFactor.set(0.95, 0.95);

					//These are set to 0 on first step. Not 0 here because otherwise they aren't cached in properly or something?
					//I dunno
					boyfriend404.alpha = 0.0125; 
					dad404.alpha = 0.0125;
					gf404.alpha = 0.0125;

				//Alert!

			//	var kb_attack_alert:FlxSprite;

				kb_attack_alert = new FlxSprite();
				kb_attack_alert.frames = Paths.getSparrowAtlas('bonus/attack_alert_NEW', 'qt');
				kb_attack_alert.animation.addByPrefix('alert', 'kb_attack_animation_alert-single', 24, false);	
				kb_attack_alert.animation.addByPrefix('alertDOUBLE', 'kb_attack_animation_alert-double', 24, false);	
				kb_attack_alert.antialiasing = true;
				kb_attack_alert.setGraphicSize(Std.int(kb_attack_alert.width * 1.5));
				kb_attack_alert.cameras = [camHUD];
				kb_attack_alert.x = FlxG.width - 700;
				kb_attack_alert.y = 205;
				//kb_attack_alert.animation.play("alert"); //Placeholder, change this to start already hidden or whatever.

				//Saw that one coming!
			//	var kb_attack_saw:FlxSprite;
				kb_attack_saw = new FlxSprite();
				kb_attack_saw.frames = Paths.getSparrowAtlas('bonus/attackv6', 'qt');
				kb_attack_saw.animation.addByPrefix('fire', 'kb_attack_animation_fire', 24, false);	
				kb_attack_saw.animation.addByPrefix('prepare', 'kb_attack_animation_prepare', 24, false);	
				kb_attack_saw.setGraphicSize(Std.int(kb_attack_saw.width * 1.15));
				kb_attack_saw.antialiasing = true;
				kb_attack_saw.setPosition(-860,615);

				//Pincer shit for moving notes around for a little bit of trollin'
			//	var pincer1:FlxSprite;
				pincer1 = new FlxSprite(0, 0).loadGraphic(Paths.image('bonus/pincer-close', 'qt'));
				pincer1.antialiasing = true;
				pincer1.scrollFactor.set();
				
				pincer2 = new FlxSprite(0, 0).loadGraphic(Paths.image('bonus/pincer-close', 'qt'));
				pincer2.antialiasing = true;
				pincer2.scrollFactor.set();
				
				pincer3 = new FlxSprite(0, 0).loadGraphic(Paths.image('bonus/pincer-close', 'qt'));
				pincer3.antialiasing = true;
				pincer3.scrollFactor.set();

				pincer4 = new FlxSprite(0, 0).loadGraphic(Paths.image('bonus/pincer-close', 'qt'));
				pincer4.antialiasing = true;
				pincer4.scrollFactor.set();
				
				if (FlxG.save.data.downscroll){
					pincer4.angle = 270;
					pincer3.angle = 270;
					pincer2.angle = 270;
					pincer1.angle = 270;
					pincer1.offset.set(192,-75);
					pincer2.offset.set(192,-75);
					pincer3.offset.set(192,-75);
					pincer4.offset.set(192,-75);
				}else{
					pincer4.angle = 90;
					pincer3.angle = 90;
					pincer2.angle = 90;
					pincer1.angle = 90;
					pincer1.offset.set(218,240);
					pincer2.offset.set(218,240);
					pincer3.offset.set(218,240);
					pincer4.offset.set(218,240);
				} //ripped straight from vs qt lol*/
			case 'terminate':
				defaultCamZoom = 0.8125;
					curStage = 'street';
					var bg:FlxSprite = new FlxSprite(-750, -145).loadGraphic(Paths.image('stage/streetBack', 'qt'));
					bg.antialiasing = true;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					add(bg);
	
					var streetFront:FlxSprite = new FlxSprite(-820, 710).loadGraphic(Paths.image('stage/streetFront', 'qt'));
					streetFront.setGraphicSize(Std.int(streetFront.width * 1.15));
					streetFront.updateHitbox();
					streetFront.antialiasing = true;
					streetFront.scrollFactor.set(0.9, 0.9);
					streetFront.active = false;
					add(streetFront);
	
					qt_tv01 = new FlxSprite();
				qt_tv01.frames = Paths.getSparrowAtlas('stage/TV_V5', 'qt');
				qt_tv01.animation.addByPrefix('idle', 'TV_Idle', 24, true);
				qt_tv01.animation.addByPrefix('eye', 'TV_brutality', 24, true); //Replaced the hex eye with the brutality symbols for more accurate lore.
				qt_tv01.animation.addByPrefix('eyeRight', 'TV_eyeRight', 24, true);
				qt_tv01.animation.addByPrefix('eyeLeft', 'TV_eyeLeft', 24, true);
				qt_tv01.animation.addByPrefix('error', 'TV_Error', 24, true);	
				qt_tv01.animation.addByPrefix('404', 'TV_Bluescreen', 24, true);		
				qt_tv01.animation.addByPrefix('alert', 'TV_Attention', 36, false);		
				qt_tv01.animation.addByPrefix('watch', 'TV_Watchout', 24, true);
				qt_tv01.animation.addByPrefix('drop', 'TV_Drop', 24, true);
				qt_tv01.animation.addByPrefix('sus', 'TV_sus', 24, true);
				qt_tv01.animation.addByPrefix('instructions', 'TV_Instructions-Normal', 24, true);
				qt_tv01.animation.addByPrefix('gl', 'TV_GoodLuck', 24, true);
				qt_tv01.setPosition(-62, 540);
				qt_tv01.setGraphicSize(Std.int(qt_tv01.width * 1.2));
				qt_tv01.updateHitbox();
				qt_tv01.antialiasing = true;
				qt_tv01.scrollFactor.set(0.89, 0.89);
				add(qt_tv01);
				qt_tv01.animation.play('idle');
	
					terminateError = new FlxSprite(0,0).loadGraphic(Paths.image('terminateError', 'qt'));
					terminateError.antialiasing = true;
					terminateError.scrollFactor.set(0.9, 0.9);
					terminateError.screenCenter();
					terminateError.setGraphicSize(Std.int(streetFront.width * 1));
					add(terminateError);
	
					kb_attack_alert = new FlxSprite();
					kb_attack_alert.frames = Paths.getSparrowAtlas('bonus/attack_alert_NEW', 'qt');
					kb_attack_alert.animation.addByPrefix('alert', 'kb_attack_animation_alert-single', 24, false);	
					kb_attack_alert.animation.addByPrefix('alertDOUBLE', 'kb_attack_animation_alert-double', 24, false);	
					kb_attack_alert.antialiasing = true;
					kb_attack_alert.setGraphicSize(Std.int(kb_attack_alert.width * 1.5));
					kb_attack_alert.cameras = [camHUD];
					kb_attack_alert.x = FlxG.width - 700;
					kb_attack_alert.y = 205;
	
					kb_attack_saw = new FlxSprite();
					kb_attack_saw.frames = Paths.getSparrowAtlas('bonus/attackv6', 'qt');
					kb_attack_saw.animation.addByPrefix('fire', 'kb_attack_animation_fire', 24, false);	
					kb_attack_saw.animation.addByPrefix('prepare', 'kb_attack_animation_prepare', 24, false);	
					kb_attack_saw.setGraphicSize(Std.int(kb_attack_saw.width * 1.15));
					kb_attack_saw.antialiasing = true;
					kb_attack_saw.setPosition(-860,615);
					//kb_attack_alert.animation.play("alert"); //Placeholder, change this to start already hidden or whatever.
			case 'censory-overload':
					defaultCamZoom = 0.8125;
					
					curStage = 'streetFinal';
	
					if(!Main.qtOptimisation){
						//Far Back Layer - Error (blue screen)
						var errorBG:FlxSprite = new FlxSprite(-750, -145).loadGraphic(Paths.image('stage/streetError', 'qt'));
						errorBG.antialiasing = true;
						errorBG.scrollFactor.set(0.9, 0.9);
						errorBG.active = false;
						add(errorBG);
	
						//Back Layer - Error (glitched version of normal Back)
						streetBGerror = new FlxSprite(-750, -145).loadGraphic(Paths.image('stage/streetBackError', 'qt'));
						streetBGerror.antialiasing = true;
						streetBGerror.scrollFactor.set(0.9, 0.9);
						add(streetBGerror);
					}
	
					//Back Layer - Normal
					streetBG = new FlxSprite(-750, -145).loadGraphic(Paths.image('stage/streetBack', 'qt'));
					streetBG.antialiasing = true;
					streetBG.scrollFactor.set(0.9, 0.9);
					add(streetBG);
	
	
					//Front Layer - Normal
					var streetFront:FlxSprite = new FlxSprite(-820, 710).loadGraphic(Paths.image('stage/streetFront', 'qt'));
					streetFront.setGraphicSize(Std.int(streetFront.width * 1.15));
					streetFront.updateHitbox();
					streetFront.antialiasing = true;
					streetFront.scrollFactor.set(0.9, 0.9);
					streetFront.active = false;
					add(streetFront);
	
					if(!Main.qtOptimisation){
						//Front Layer - Error (changes to have a glow)
						streetFrontError = new FlxSprite(-820, 710).loadGraphic(Paths.image('stage/streetFrontError', 'qt'));
						streetFrontError.setGraphicSize(Std.int(streetFrontError.width * 1.15));
						streetFrontError.updateHitbox();
						streetFrontError.antialiasing = true;
						streetFrontError.scrollFactor.set(0.9, 0.9);
						streetFrontError.active = false;
						add(streetFrontError);
						streetFrontError.visible = false;
					}

					kb_attack_alert = new FlxSprite();
					kb_attack_alert.frames = Paths.getSparrowAtlas('bonus/attack_alert_NEW', 'qt');
					kb_attack_alert.animation.addByPrefix('alert', 'kb_attack_animation_alert-single', 24, false);	
					kb_attack_alert.animation.addByPrefix('alertDOUBLE', 'kb_attack_animation_alert-double', 24, false);	
					kb_attack_alert.antialiasing = true;
					kb_attack_alert.setGraphicSize(Std.int(kb_attack_alert.width * 1.5));
					kb_attack_alert.cameras = [camHUD];
					kb_attack_alert.x = FlxG.width - 700;
					kb_attack_alert.y = 205;
	
					kb_attack_saw = new FlxSprite();
					kb_attack_saw.frames = Paths.getSparrowAtlas('bonus/attackv6', 'qt');
					kb_attack_saw.animation.addByPrefix('fire', 'kb_attack_animation_fire', 24, false);	
					kb_attack_saw.animation.addByPrefix('prepare', 'kb_attack_animation_prepare', 24, false);	
					kb_attack_saw.setGraphicSize(Std.int(kb_attack_saw.width * 1.15));
					kb_attack_saw.antialiasing = true;
					kb_attack_saw.setPosition(-860,615);
	
	
					qt_tv01 = new FlxSprite();
					qt_tv01.frames = Paths.getSparrowAtlas('stage/TV_V5', 'qt');
					qt_tv01.animation.addByPrefix('idle', 'TV_Idle', 24, true);
					qt_tv01.animation.addByPrefix('eye', 'TV_brutality', 24, true); //Replaced the hex eye with the brutality symbols for more accurate lore.
					qt_tv01.animation.addByPrefix('error', 'TV_Error', 24, true);	
					qt_tv01.animation.addByPrefix('404', 'TV_Bluescreen', 24, true);		
					qt_tv01.animation.addByPrefix('alert', 'TV_Attention', 32, false);		
					qt_tv01.animation.addByPrefix('watch', 'TV_Watchout', 24, true);
					qt_tv01.animation.addByPrefix('drop', 'TV_Drop', 24, true);
					qt_tv01.animation.addByPrefix('sus', 'TV_sus', 24, true);
					qt_tv01.setPosition(-62, 540);
					qt_tv01.setGraphicSize(Std.int(qt_tv01.width * 1.2));
					qt_tv01.updateHitbox();
					qt_tv01.antialiasing = true;
					qt_tv01.scrollFactor.set(0.89, 0.89);
					add(qt_tv01);
					qt_tv01.animation.play('idle');
	
					//https://youtu.be/Nz0qjc8WRyY?t=1749
					//Wow, I guess it's that easy huh? -Haz
						boyfriend404 = new Boyfriend(770, 450, 'bf_404');
						dad404 = new Character(100,100,'robot_404');
						gf404 = new Character(400,130,'gf_404');
						gf404.scrollFactor.set(0.95, 0.95);
	
						//These are set to 0 on first step. Not 0 here because otherwise they aren't cached in properly or something?
						//I dunno
						boyfriend404.alpha = 0.0125; 
						dad404.alpha = 0.0125;
						gf404.alpha = 0.0125;
	
						//Probably a better way of doing this... too bad! -Haz
						qt_gas01 = new FlxSprite();
						//Old gas sprites.
						//qt_gas01.frames = Paths.getSparrowAtlas('stage/gas_test');
						//qt_gas01.animation.addByPrefix('burst', 'ezgif.com-gif-makernew_gif instance ', 30, false);	
	
						//Left gas
						qt_gas01.frames = Paths.getSparrowAtlas('stage/Gas_Release', 'qt');
						qt_gas01.animation.addByPrefix('burst', 'Gas_Release', 38, false);	
						qt_gas01.animation.addByPrefix('burstALT', 'Gas_Release', 49, false);
						qt_gas01.animation.addByPrefix('burstFAST', 'Gas_Release', 76, false);	
						qt_gas01.setGraphicSize(Std.int(qt_gas01.width * 2.5));	
						qt_gas01.antialiasing = true;
						qt_gas01.scrollFactor.set();
						qt_gas01.alpha = 0.72;
						qt_gas01.setPosition(-880,-100);
						qt_gas01.angle = -31;				
	
						//Right gas
						qt_gas02 = new FlxSprite();
						//qt_gas02.frames = Paths.getSparrowAtlas('stage/gas_test');
						//qt_gas02.animation.addByPrefix('burst', 'ezgif.com-gif-makernew_gif instance ', 30, false);
	
						qt_gas02.frames = Paths.getSparrowAtlas('stage/Gas_Release', 'qt');
						qt_gas02.animation.addByPrefix('burst', 'Gas_Release', 38, false);	
						qt_gas02.animation.addByPrefix('burstALT', 'Gas_Release', 49, false);
						qt_gas02.animation.addByPrefix('burstFAST', 'Gas_Release', 76, false);	
						qt_gas02.setGraphicSize(Std.int(qt_gas02.width * 2.5));
						qt_gas02.antialiasing = true;
						qt_gas02.scrollFactor.set();
						qt_gas02.alpha = 0.72;
						qt_gas02.setPosition(920,-100);
						qt_gas02.angle = 31;
			case 'power-link':
				defaultCamZoom = 0.9;
				curStage = 'stage_2';
				var bg:FlxSprite = new FlxSprite(-400, -160).loadGraphic(Paths.image('bg_lemon'));
				bg.setGraphicSize(Std.int(bg.width * 1.5));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.95, 0.95);
				bg.active = false;
				add(bg);
					
			case 'final-destination':
				defaultCamZoom = 0.9;
							curStage = 'boxing';
							var bg:FlxSprite = new FlxSprite(-400, -220).loadGraphic(Paths.image('bg_boxn'));
							bg.antialiasing = true;
							bg.scrollFactor.set(0.8, 0.8);
							bg.active = false;
							add(bg);
				
							var bg_r:FlxSprite = new FlxSprite(-810, -380).loadGraphic(Paths.image('bg_boxr'));
							bg_r.antialiasing = true;
							bg_r.scrollFactor.set(1, 1);
							bg_r.active = false;
							add(bg_r);
				
							shadow1 = new FlxSprite(0, -20).loadGraphic(Paths.image('shadows'));
							shadow1.scrollFactor.set();
							shadow1.antialiasing = true;
							shadow1.alpha = 0;
				
							shadow2 = new FlxSprite(0, -20).loadGraphic(Paths.image('shadows'));
							shadow2.scrollFactor.set();
							shadow2.antialiasing = true;
							shadow2.alpha = 0;

							theBlackBG = new FlxSprite().loadGraphic(Paths.image('theblackthing'));
							theBlackBG.scrollFactor.set();
							theBlackBG.screenCenter(X);
							theBlackBG.active = false;
							theBlackBG.scale.set(1000, 1000);
							theBlackBG.visible = false;
							add(theBlackBG);
							
							cum = new FlxSprite().loadGraphic(Paths.image('white'));
							cum.scrollFactor.set();
							cum.screenCenter(X);
							cum.active = false;
							cum.scale.set(1000, 1000);
							cum.visible = false;
			default: //so idk
			defaultCamZoom = 0.9;
			curStage = 'boxing';
			var bg:FlxSprite = new FlxSprite(-400, -220).loadGraphic(Paths.image('bg_boxn'));
			bg.antialiasing = true;
			bg.scrollFactor.set(0.8, 0.8);
			bg.active = false;
			add(bg);

			var bg_r:FlxSprite = new FlxSprite(-810, -380).loadGraphic(Paths.image('bg_boxr'));
			bg_r.antialiasing = true;
			bg_r.scrollFactor.set(1, 1);
			bg_r.active = false;
			add(bg_r);

			shadow1 = new FlxSprite(0, -20).loadGraphic(Paths.image('shadows'));
			shadow1.scrollFactor.set();
			shadow1.antialiasing = true;
			shadow1.alpha = 0;

			shadow2 = new FlxSprite(0, -20).loadGraphic(Paths.image('shadows'));
			shadow2.scrollFactor.set();
			shadow2.antialiasing = true;
			shadow2.alpha = 0;

			theBlackBG = new FlxSprite().loadGraphic(Paths.image('theblackthing'));
			theBlackBG.scrollFactor.set();
			theBlackBG.screenCenter(X);
			theBlackBG.active = false;
			theBlackBG.scale.set(1000, 1000);
			theBlackBG.visible = false;
			add(theBlackBG);
			
			cum = new FlxSprite().loadGraphic(Paths.image('white'));
			cum.scrollFactor.set();
			cum.screenCenter(X);
			cum.active = false;
			cum.scale.set(1000, 1000);
			cum.visible = false;

		}
					
	}
		//defaults if no gf was found in chart
		var gfCheck:String = 'gf';
		
		if (SONG.gfVersion == null) {
			switch(storyWeek)
			{
				case 4: gfCheck = 'gf-car';
				case 5: gfCheck = 'gf-christmas';
				case 6: gfCheck = 'gf-pixel';
			}
		} else {gfCheck = SONG.gfVersion;}

		var curGf:String = '';
		switch (gfCheck)
		{
			case 'gf-car':
				curGf = 'gf-car';
			case 'gf-christmas':
				curGf = 'gf-christmas';
			case 'gf-pixel':
				curGf = 'gf-pixel';
			default:
				curGf = 'gf';
		}

		switch(SONG.song.toLowerCase())
		{
			case 'power-link' | 'final-destination':
				exDad = true; //this works apparently
			case 'censory-overload' | 'termination':
				do404 = true; //lets game do 404 shit
		}

		var bfVersion = SONG.player1;

		switch(curStage)
		{
			case 'nevadaSpook':
				bfVersion = 'bf-hell';
			case 'auditorHell':
				hexError.visible = false;
			case 'street': 
				terminateError.visible = false;
		}
		
		gf = new Character(400, 130, curGf);
		gf.scrollFactor.set(0.95, 0.95);

		var dadxoffset:Float = 0;
		var dadyoffset:Float = 0;
		var bfxoffset:Float = 0;
		var bfyoffset:Float = 0;

		dad = new Character(100, 100, SONG.player2, false);
		boyfriend = new Boyfriend(770, 450, SONG.player1, true);

		if (exDad)
		{
			dad2 = new Character(280, 100, "robot");
		}

		if (do404)
		{
			trace('your on a stage that uses 404 shit');
		}

		/*
		dad = new Character(100, 100, SONG.player2, false);
		dad2 = new Character(280, 100, "robot");
		*/

		var dadcharacter:String = SONG.player2;

		var bf = PlayState.boyfriend;

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player1)
		{
			case 'bfWhitty':
				bf.y -= 150;
		}

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dadyoffset += 200;
			case "monster":
				dadyoffset += 100;
			case 'monster-christmas':
				dadyoffset += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dadyoffset += 300;
			case 'parents-christmas':
				dadxoffset -= 500;
			case 'senpai':
				dadxoffset += 150;
				dadyoffset += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dadxoffset += 150;
				dadyoffset += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'trickyMask':
				camPos.x += 400;
			case 'trickyH':
				camPos.set(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y + 500);
				dad.y -= 2000;
				dad.x -= 1400;
				gf.x -= 380;
			case 'exTricky':
				dad.x -= 250;
				dad.y -= 365;
				gf.x += 345;
				gf.y -= 25;
				dad.visible = false;
			case 'hex':
				dad.y += 100;
			case 'qt-meme':
				dad.y += 260;
			case 'qt_classic':
				dad.y += 255;
			case 'robot_classic' | 'robot_classic_404':
				dad.x += 110;
			case 'robot':
				dad.y  += 100;
				dad.x += 100;
			case 'spirit':
				if (FlxG.save.data.distractions)
					{
						// trailArea.scrollFactor.set();
						if (!PlayStateChangeables.Optimize)
						{
							var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
							// evilTrail.changeValuesEnabled(false, false, false, false);
							// evilTrail.changeGraphic()
							add(evilTrail);
						}
						// evilTrail.scrollFactor.set(1.1, 1.1);
					}
				dadxoffset -= 150;
				dadyoffset += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}


		


		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'limo':
				bfyoffset -= 220;
				bfxoffset += 260;
				if(FlxG.save.data.distractions){
					resetFastCar();
					add(fastCar);
				}

			case 'mall':
				bfxoffset += 200;

			case 'mallEvil':
				bfxoffset += 320;
				dadyoffset -= 80;
			case 'school':
				bfxoffset += 200;
				bfyoffset += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				bfxoffset += 200;
				bfyoffset += 220;
				gf.x += 180;
				gf.y += 300;
			case 'stage_2':
				gf.alpha = 0;
				boyfriend.y -= 20;
			case 'boxing':
				gf.x += 70;
				boyfriend.x += 130;
		}
			dad.x += dadxoffset;
			dad.y += dadyoffset;
			boyfriend.x += bfxoffset;
			boyfriend.y += bfyoffset;

		if (!PlayStateChangeables.Optimize)
		{
			add(gf);

			// Shitty layering but whatev it works LOL
			if (curStage == 'limo')
				add(limo);

			if (exDad) 
				add(dad2);
			add(dad);
			add(boyfriend);
		}

		if(SONG.song.toLowerCase() == 'censory-overload' || SONG.song.toLowerCase() == 'termination'){
			add(gf404);
			add(boyfriend404);
			add(dad404);
		}

		if (loadRep)
		{
			FlxG.watch.addQuick('rep rpesses',repPresses);
			FlxG.watch.addQuick('rep releases',repReleases);
			// FlxG.watch.addQuick('Queued',inputsQueued);

			PlayStateChangeables.useDownscroll = rep.replay.isDownscroll;
			PlayStateChangeables.safeFrames = rep.replay.sf;
			PlayStateChangeables.botPlay = true;
			keyBotplay = true;
		}

		trace('uh ' + PlayStateChangeables.safeFrames);

		trace("SF CALC: " + Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;
		
		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		
		if (PlayStateChangeables.useDownscroll)
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		add(noteSplashes);
		playerStrums = new FlxTypedGroup<FlxSprite>();
		cpuStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		if(SONG.song.toLowerCase() == 'censory-overload' || SONG.song.toLowerCase() == 'termination') // just making sure this fucking works, and im not dumb
		{
			bfCanDodge = true;
			FlxG.log.add('you can now dodge');
		}

		if (SONG.song == null)
			trace('song is null???');
		else
			trace('song looks gucci');

		generateSong(SONG.song);

		/*for(i in unspawnNotes)
			{
				var dunceNote:Note = i;
				notes.add(dunceNote);
				if (executeModchart)
				{
					if (!dunceNote.isSustainNote)
						dunceNote.cameras = [camNotes];
					else
						dunceNote.cameras = [camSustains];
				}
				else
				{
					dunceNote.cameras = [camHUD];
				}
			}
	
			if (startTime != 0)
				{
					var toBeRemoved = [];
					for(i in 0...notes.members.length)
					{
						var dunceNote:Note = notes.members[i];
		
						if (dunceNote.strumTime - startTime <= 0)
							toBeRemoved.push(dunceNote);
						else 
						{
							if (PlayStateChangeables.useDownscroll)
							{
								if (dunceNote.mustPress)
									dunceNote.y = (playerStrums.members[Math.floor(Math.abs(dunceNote.noteData))].y
										+ 0.45 * (startTime - dunceNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) - dunceNote.noteYOff;
								else
									dunceNote.y = (strumLineNotes.members[Math.floor(Math.abs(dunceNote.noteData))].y
										+ 0.45 * (startTime - dunceNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) - dunceNote.noteYOff;
							}
							else
							{
								if (dunceNote.mustPress)
									dunceNote.y = (playerStrums.members[Math.floor(Math.abs(dunceNote.noteData))].y
										- 0.45 * (startTime - dunceNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) + dunceNote.noteYOff;
								else
									dunceNote.y = (strumLineNotes.members[Math.floor(Math.abs(dunceNote.noteData))].y
										- 0.45 * (startTime - dunceNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) + dunceNote.noteYOff;
							}
						}
					}
		
					for(i in toBeRemoved)
						notes.members.remove(i);
				}*/

		trace('generated');

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (30 / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		if (FlxG.save.data.songPosition) // I dont wanna talk about this code :(
			{
				songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
				if (PlayStateChangeables.useDownscroll)
					songPosBG.y = FlxG.height * 0.9 + 45; 
				songPosBG.screenCenter(X);
				songPosBG.scrollFactor.set();
				add(songPosBG);
				
				songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
					'songPositionBar', 0, 90000);
				songPosBar.scrollFactor.set();
				songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
				add(songPosBar);
	
				var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - (SONG.song.length * 5),songPosBG.y,0,SONG.song, 16);
				if (PlayStateChangeables.useDownscroll)
					songName.y -= 3;
				songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
				songName.scrollFactor.set();
				add(songName);
				songName.cameras = [camHUD];
			}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(Paths.image('healthBar'));
		if (PlayStateChangeables.useDownscroll)
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

				healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
				'health', 0, 2);
				healthBar.scrollFactor.set();
				healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar
		add(healthBar);

		overhealthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
		'health', 2.2, 4);
		overhealthBar.scrollFactor.set();
		overhealthBar.createFilledBar(0x00000000, 0xFFFFFF00);
		// healthBar
		add(overhealthBar);

		// Add Kade Engine watermark
		// what's your fuckin' deal???????????? -discussions
		// what discussions??? -teu
		// no 
		// ░░░░░▄▄▄▄▀▀▀▀▀▀▀▀▄▄▄▄▄▄░░░░░░░
		// ░░░░░█░░░░▒▒▒▒▒▒▒▒▒▒▒▒░░▀▀▄░░░░
		// ░░░░█░░░▒▒▒▒▒▒░░░░░░░░▒▒▒░░█░░░
		// ░░░█░░░░░░▄██▀▄▄░░░░░▄▄▄░░░░█░░
		// ░▄▀▒▄▄▄▒░█▀▀▀▀▄▄█░░░██▄▄█░░░░█░
		// █░▒█▒▄░▀▄▄▄▀░░░░░░░░█░░░▒▒▒▒▒░█
		// █░▒█░█▀▄▄░░░░░█▀░░░░▀▄░░▄▀▀▀▄▒█
		// ░█░▀▄░█▄░█▀▄▄░▀░▀▀░▄▄▀░░░░█░░█░
		// ░░█░░░▀▄▀█▄▄░█▀▀▀▄▄▄▄▀▀█▀██░█░░
		// ░░░█░░░░██░░▀█▄▄▄█▄▄█▄████░█░░░
		// ░░░░█░░░░▀▀▄░█░░░█░█▀██████░█░░
		// ░░░░░▀▄░░░░░▀▀▄▄▄█▄█▄█▄█▄▀░░█░░
		// ░░░░░░░▀▄▄░▒▒▒▒░░░░░░░░░░▒░░░█░
		// ░░░░░░░░░░▀▀▄▄░▒▒▒▒▒▒▒▒▒▒░░░░█░
		// ░░░░░░░░░░░░░░▀▄▄▄▄▄░░░░░░░░█░░
		// trolling

		// Add Kade Engine watermark
		kadeEngineWatermark = new FlxText(4,FlxG.height - 4,0,SONG.song + " " + (storyDifficulty == 2 ? "Unfair" : storyDifficulty == 1 ? "Hard" : "Easy") + " - KE " + "Hex VS Whitty Mod", 16);
		kadeEngineWatermark.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		add(kadeEngineWatermark);

		if (PlayStateChangeables.useDownscroll)
			kadeEngineWatermark.y = FlxG.height * 0.9 + 45;

		scoreTxt = new FlxText(FlxG.width / 2 - 235, healthBarBG.y + 50, 0, "", 20);

		scoreTxt.screenCenter(X);

		originalX = scoreTxt.x;


		scoreTxt.scrollFactor.set();
		
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);

		add(scoreTxt);

		replayTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (PlayStateChangeables.useDownscroll ? 100 : -100), 0, "REPLAY", 20);
		replayTxt.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		replayTxt.borderSize = 4;
		replayTxt.borderQuality = 2;
		replayTxt.scrollFactor.set();
		if (loadRep)
		{
			add(replayTxt);
		}
		// Literally copy-paste of the above, fu
		botPlayState = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 75, healthBarBG.y + (PlayStateChangeables.useDownscroll ? 100 : -100), 0, "BOTPLAY", 20);
		botPlayState.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		botPlayState.scrollFactor.set();
		botPlayState.borderSize = 4;
		botPlayState.borderQuality = 2;
		if(PlayStateChangeables.botPlay && !loadRep) add(botPlayState);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		noteSplashes.cameras = [camNotes];
//		strumLineNotes.cameras = [camNotes];
	//	notes.cameras = [camNotes];
		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		overhealthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];

		if (curStage == 'auditorHell')
			hexError.cameras = [camHUD];
		if (SONG.song == 'Terminate')
			terminateError.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;
		
		trace('starting');

		if (isStoryMode)
		{
			switch (StringTools.replace(curSong," ", "-").toLowerCase())
			{
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer)
					{
						remove(blackScreen);
						FlxG.sound.play(Paths.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer)
						{
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									startCountdown();
								}
							});
						});
					});
				case 'senpai':
					schoolIntro(doof);
				case 'roses':
					FlxG.sound.play(Paths.sound('ANGRY'));
					schoolIntro(doof);
				case 'thorns':
					schoolIntro(doof);
				case 'improbable-outset':
					camFollow.setPosition(boyfriend.getMidpoint().x + 70, boyfriend.getMidpoint().y - 50);
					if (playCutscene)
					{
						trickyCutscene();
						playCutscene = false;
					}
					else
						startCountdown();
				case 'carefree' | 'careless' | 'terminate':
					schoolIntro(doof);
				case 'censory-overload':
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		if (!loadRep)
			rep = new Replay("na");

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN,handleInput);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, releaseInput);

		super.create();
	}


	function schoolIntro(?dialogueBox:DialogueBox):Void
		{
			var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
			black.scrollFactor.set();
		//	add(black);
	
			FlxG.log.notice(qtCarelessFin);
			if(!qtCarelessFin)
			{
				add(black);
			}
			else
			{
				FlxTween.tween(FlxG.camera, {x: 0, y:0}, 1.5, {
					ease: FlxEase.quadInOut
				});
			}
	
			trace(cutsceneSkip);
			var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
			red.scrollFactor.set();
	
			var senpaiEvil:FlxSprite = new FlxSprite();
			var horrorStage:FlxSprite = new FlxSprite();
	
			if(!cutsceneSkip){
				if(SONG.song.toLowerCase() == 'censory-overload'){
					camHUD.visible = false;
					//BG
					horrorStage.frames = Paths.getSparrowAtlas('stage/horrorbg', 'qt');
					horrorStage.animation.addByPrefix('idle', 'Symbol 10 instance ', 24, false);
					horrorStage.antialiasing = true;
					horrorStage.scrollFactor.set();
					horrorStage.screenCenter();
	
					//QT sprite
					senpaiEvil.frames = Paths.getSparrowAtlas('cutscenev3', 'qt');
					senpaiEvil.animation.addByPrefix('idle', 'final_edited', 24, false);
					senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 0.875));
					senpaiEvil.scrollFactor.set();
					senpaiEvil.updateHitbox();
					senpaiEvil.screenCenter();
					senpaiEvil.x -= 140;
					senpaiEvil.y -= 55;
				}else{
					senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
					senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
					senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
					senpaiEvil.scrollFactor.set();
					senpaiEvil.updateHitbox();
					senpaiEvil.screenCenter();
				}
			}
	
			if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
			{
				remove(black);
	
				if (SONG.song.toLowerCase() == 'thorns')
				{
					add(red);
				}
			}
			else if (SONG.song.toLowerCase() == 'censory-overload' && !cutsceneSkip)
				{
					add(horrorStage);
				}
	
				new FlxTimer().start(0.3, function(tmr:FlxTimer)
					{
						black.alpha -= 0.15;
			
						if (black.alpha > 0)
						{
							tmr.reset(0.3);
						}
						else
						{
							if (dialogueBox != null)
							{
								inCutscene = true;
			
								if (SONG.song.toLowerCase() == 'censory-overload' && !cutsceneSkip)
								{
									//Background old
									//var horrorStage:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stage/horrorbg'));
									//horrorStage.antialiasing = true;
									//horrorStage.scrollFactor.set();
									//horrorStage.y-=125;
									//add(horrorStage);
									add(senpaiEvil);
									senpaiEvil.alpha = 0;
									new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
									{
										senpaiEvil.alpha += 0.15;
										if (senpaiEvil.alpha < 1)
										{
											swagTimer.reset();
										}
										else
										{
											senpaiEvil.animation.play('idle');
											horrorStage.animation.play('idle');
											FlxG.sound.play(Paths.sound('music-box-horror'), 0.9, false, null, true, function()
											{
												remove(senpaiEvil);
												remove(red);
												remove(horrorStage);
												camHUD.visible = true;
												FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
												{
													add(dialogueBox);
												}, true);
											});
											new FlxTimer().start(13, function(deadTime:FlxTimer)
											{
												FlxG.camera.fade(FlxColor.WHITE, 3, false);
											});
										}
									});
								}
								else if (SONG.song.toLowerCase() == 'thorns'  && !cutsceneSkip)
								{
									add(senpaiEvil);
									senpaiEvil.alpha = 0;
									new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
									{
										senpaiEvil.alpha += 0.15;
										if (senpaiEvil.alpha < 1)
										{
											swagTimer.reset();
										}
										else
										{
											senpaiEvil.animation.play('idle');
											FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
											{
												remove(senpaiEvil);
												remove(red);
												FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
												{
													add(dialogueBox);
												}, true);
											});
											new FlxTimer().start(3.2, function(deadTime:FlxTimer)
											{
												FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
											});
										}
									});
								}
								else
								{
									add(dialogueBox);
								}
							}
							else
								if(!qtCarelessFin)
								{
									startCountdown();
								}
								else
								{
									loadSongHazard();
								}
			
							remove(black);
						}
					});
		}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	var luaWiggles:Array<WiggleEffect> = [];

	#if windows
	public static var luaModchart:ModchartState = null;
	#end

	var keys = [false, false, false, false, false, false, false, false, false];

	var cloneOne:FlxSprite;
	var cloneTwo:FlxSprite;

	function doClone(side:Int)
	{
		switch(side)
		{
			case 0:
				if (cloneOne.alpha == 1)
					return;
				cloneOne.x = dad.x - 20;
				cloneOne.y = dad.y + 140;
				cloneOne.alpha = 1;

				cloneOne.animation.play('clone');
				cloneOne.animation.finishCallback = function(pog:String) {cloneOne.alpha = 0;}
			case 1:
				if (cloneTwo.alpha == 1)
					return;
				cloneTwo.x = dad.x + 390;
				cloneTwo.y = dad.y + 140;
				cloneTwo.alpha = 1;

				cloneTwo.animation.play('clone');
				cloneTwo.animation.finishCallback = function(pog:String) {cloneTwo.alpha = 0;}
		}

	}

	public function traceBoth(message:String = 'hello world'):Void 
	{
		trace(message);
		FlxG.log.add(message);
	}

	function startCountdown():Void
	{
		inCutscene = false;

		//testStaticArrows();
		//traceBoth('tested staic arrows.');

		//add(daSign);
		traceBoth('starting to spawn in notes.');
		generateStaticArrows(0);
		generateStaticArrows(1);
		traceBoth('finished spawning in strumline notes.');
	//	add(daSign);

		switch(mania) //moved it here because i can lol
		{
			case 0: 
				keys = [false, false, false, false];
			case 1: 
				keys = [false, false, false, false, false, false];
			case 2: 
				keys = [false, false, false, false, false, false, false, false, false];
			case 3: 
				keys = [false, false, false, false, false];
			case 4: 
				keys = [false, false, false, false, false, false, false];
			case 5: 
				keys = [false, false, false, false, false, false, false, false];
			case 6: 
				keys = [false];
			case 7: 
				keys = [false, false];
			case 8: 
				keys = [false, false, false];
		}
	
		


		#if windows
		// pre lowercasing the song name (startCountdown)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		switch (songLowercase) {
			case 'dad-battle': songLowercase = 'dadbattle';
			case 'philly-nice': songLowercase = 'philly';
		}
		if (executeModchart)
		{
			luaModchart = ModchartState.createModchartState();
			luaModchart.executeState('start',[songLowercase]);
		}
		#end
		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		var swagCounter:Int = 0;
		
		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			if (exDad) 
				dad2.dance();
			boyfriend.dance();

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel',
				'weeb/pixelUI/set-pixel',
				'weeb/pixelUI/date-pixel'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + altSuffix), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + altSuffix), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);

		if (SONG.song.toLowerCase() == 'expurgation') // start the grem time
			{
				new FlxTimer().start(25, function(tmr:FlxTimer) {
					if (curStep < 2400)
					{
						if (canPause && !paused && health >= 1.5 && !grabbed)
							doGremlin(40,3);
						trace('checka ' + health);
						tmr.reset(25);
					}
				});
			}
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;
	var grabbed = false;

	function CensoryOverload404():Void
		{
			if(qtIsBlueScreened){
				//Hide original versions
				boyfriend.alpha = 0;
				gf.alpha = 0;
				dad.alpha = 0;
	
				//New versions un-hidden.
				boyfriend404.alpha = 1;
				gf404.alpha = 1;
				dad404.alpha = 1;
			}
			else{ //Reset back to normal
	
				//Return to original sprites.
				boyfriend404.alpha = 0;
				gf404.alpha = 0;
				dad404.alpha = 0;
	
				//Hide 404 versions
				boyfriend.alpha = 1;
				gf.alpha = 1;
				dad.alpha = 1;
			}
		}


	private function getKey(charCode:Int):String
	{
		for (key => value in FlxKey.fromStringMap)
		{
			if (charCode == value)
				return key;
		}
		return null;
	}
	
	var totalDamageTaken:Float = 0;

	var shouldBeDead:Bool = false;

	var interupt = false;


	private function releaseInput(evt:KeyboardEvent):Void // handles releases
	{
		@:privateAccess
		var key = FlxKey.toStringMap.get(evt.keyCode);

		var binds:Array<String> = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind];
		var data = -1;
		switch(maniaToChange)
		{
			case 0: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys // why the fuck are arrow keys hardcoded it fucking breaks the controls with extra keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 1: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind, FlxG.save.data.L2Bind, FlxG.save.data.D1Bind, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 3;
					case 40:
						data = 4;
					case 39:
						data = 5;
				}
			case 2: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, FlxG.save.data.N4Bind, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 7;
					case 39:
						data = 8;
				}
			case 3: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.N4Bind, FlxG.save.data.upBind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 3;
					case 39:
						data = 4;
				}
			case 4: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind,FlxG.save.data.N4Bind, FlxG.save.data.L2Bind, FlxG.save.data.D1Bind, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 4;
					case 40:
						data = 5;
					case 39:
						data = 6;
				}
			case 5: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 4;
					case 40:
						data = 5;
					case 38:
						data = 6;
					case 39:
						data = 7;
				}
			case 6: 
				binds = [FlxG.save.data.N4Bind];
			case 7: 
				binds = [FlxG.save.data.leftBind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys 
				{
					case 37:
						data = 0;
					case 39:
						data = 1;
				}

			case 8: 
				binds = [FlxG.save.data.leftBind, FlxG.save.data.N4Bind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys 
				{
					case 37:
						data = 0;
					case 39:
						data = 2;
				}
			case 10: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind, null, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 11: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.D1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind, null, FlxG.save.data.L2Bind, null, null, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 1;
					case 39:
						data = 8;
				}
			case 12: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, FlxG.save.data.N4Bind, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 7;
					case 39:
						data = 8;
				}
			case 13: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind, FlxG.save.data.N4Bind, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 14: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.D1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind, FlxG.save.data.N4Bind, FlxG.save.data.L2Bind, null, null, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 1;
					case 39:
						data = 8;
				}
			case 15: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, null, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 7;
					case 39:
						data = 8;
				}
			case 16: 
				binds = [null, null, null, null, FlxG.save.data.N4Bind, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 4;
					case 39:
						data = 8;
				}
			case 17: 
				binds = [FlxG.save.data.leftBind, null, null, FlxG.save.data.rightBind, null, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 18: 
				binds = [FlxG.save.data.leftBind, null, null, FlxG.save.data.rightBind, FlxG.save.data.N4Bind, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
		}

		


		for (i in 0...binds.length) // binds
		{
			if (binds[i].toLowerCase() == key.toLowerCase())
				data = i;
		}

		if (data == -1)
			return;

		keys[data] = false;
	}

	public var closestNotes:Array<Note> = [];

	private function handleInput(evt:KeyboardEvent):Void { // this actually handles press inputs

		if (PlayStateChangeables.botPlay || loadRep || paused)
			return;

		// first convert it from openfl to a flixel key code
		// then use FlxKey to get the key's name based off of the FlxKey dictionary
		// this makes it work for special characters

		@:privateAccess
		var key = FlxKey.toStringMap.get(evt.keyCode);
		var data = -1;
		var binds:Array<String> = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind];
		switch(maniaToChange)
		{
			case 0: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys // why the fuck are arrow keys hardcoded it fucking breaks the controls with extra keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 1: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind, FlxG.save.data.L2Bind, FlxG.save.data.D1Bind, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 3;
					case 40:
						data = 4;
					case 39:
						data = 5;
				}
			case 2: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, FlxG.save.data.N4Bind, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 7;
					case 39:
						data = 8;
				}
			case 3: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.N4Bind, FlxG.save.data.upBind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 3;
					case 39:
						data = 4;
				}
			case 4: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind,FlxG.save.data.N4Bind, FlxG.save.data.L2Bind, FlxG.save.data.D1Bind, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 4;
					case 40:
						data = 5;
					case 39:
						data = 6;
				}
			case 5: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 4;
					case 40:
						data = 5;
					case 38:
						data = 6;
					case 39:
						data = 7;
				}
			case 6: 
				binds = [FlxG.save.data.N4Bind];
			case 7: 
				binds = [FlxG.save.data.leftBind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys 
				{
					case 37:
						data = 0;
					case 39:
						data = 1;
				}

			case 8: 
				binds = [FlxG.save.data.leftBind, FlxG.save.data.N4Bind, FlxG.save.data.rightBind];
				switch(evt.keyCode) // arrow keys 
				{
					case 37:
						data = 0;
					case 39:
						data = 2;
				}
			case 10: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind, null, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 11: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.D1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind, null, FlxG.save.data.L2Bind, null, null, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 1;
					case 39:
						data = 8;
				}
			case 12: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, FlxG.save.data.N4Bind, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 7;
					case 39:
						data = 8;
				}
			case 13: 
				binds = [FlxG.save.data.leftBind,FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind, FlxG.save.data.N4Bind, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 14: 
				binds = [FlxG.save.data.L1Bind, FlxG.save.data.D1Bind, FlxG.save.data.U1Bind, FlxG.save.data.R1Bind, FlxG.save.data.N4Bind, FlxG.save.data.L2Bind, null, null, FlxG.save.data.R2Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 1;
					case 39:
						data = 8;
				}
			case 15: 
				binds = [FlxG.save.data.N0Bind, FlxG.save.data.N1Bind, FlxG.save.data.N2Bind, FlxG.save.data.N3Bind, null, FlxG.save.data.N5Bind, FlxG.save.data.N6Bind, FlxG.save.data.N7Bind, FlxG.save.data.N8Bind];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 7;
					case 39:
						data = 8;
				}
			case 16: 
				binds = [null, null, null, null, FlxG.save.data.N4Bind, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 5;
					case 40:
						data = 6;
					case 38:
						data = 4;
					case 39:
						data = 8;
				}
			case 17: 
				binds = [FlxG.save.data.leftBind, null, null, FlxG.save.data.rightBind, null, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}
			case 18: 
				binds = [FlxG.save.data.leftBind, null, null, FlxG.save.data.rightBind, FlxG.save.data.N4Bind, null, null, null, null];
				switch(evt.keyCode) // arrow keys
				{
					case 37:
						data = 0;
					case 40:
						data = 1;
					case 38:
						data = 2;
					case 39:
						data = 3;
				}

		}

			for (i in 0...binds.length) // binds
				{
					if (binds[i].toLowerCase() == key.toLowerCase())
						data = i;
				}
				if (data == -1)
				{
		//			trace("couldn't find a keybind with the code " + key);
					return;
				}
				if (keys[data])
				{
		//			trace("ur already holding " + key);
					return;
				}
		
				keys[data] = true;
		
				var ana = new Ana(Conductor.songPosition, null, false, "miss", data);
		
				var dataNotes = [];
				for(i in closestNotes)
					if (i.noteData == data)
						dataNotes.push(i);

				
				if (!FlxG.save.data.gthm)
				{
					if (dataNotes.length != 0)
						{
							var coolNote = null;
				
							for (i in dataNotes)
								if (!i.isSustainNote)
								{
									coolNote = i;
									break;
								}
				
							if (coolNote == null) // Note is null, which means it's probably a sustain note. Update will handle this (HOPEFULLY???)
							{
								return;
							}
				
							if (dataNotes.length > 1) // stacked notes or really close ones
							{
								for (i in 0...dataNotes.length)
								{
									if (i == 0) // skip the first note
										continue;
				
									var note = dataNotes[i];
				
									if (!note.isSustainNote && (note.strumTime - coolNote.strumTime) < 2)
									{
										trace('found a stacked/really close note ' + (note.strumTime - coolNote.strumTime));
										// just fuckin remove it since it's a stacked note and shouldn't be there
									//	note.kill(); - adds to the challenge :D - Discussions
									//	notes.remove(note, true);
									//	note.destroy();
									}
								}
							}
				
							goodNoteHit(coolNote);
							var noteDiff:Float = -(coolNote.strumTime - Conductor.songPosition);
							ana.hit = true;
							ana.hitJudge = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));
							ana.nearestNote = [coolNote.strumTime, coolNote.noteData, coolNote.sustainLength];
						
						}
					else if (!FlxG.save.data.ghost && songStarted && !grace)
						{
							noteMiss(data, null);
							ana.hit = false;
							ana.hitJudge = "shit";
							ana.nearestNote = [];
							//health -= 0.20;
						}
				}
		
	}

	var songStarted = false;

	function startSong():Void
	{
		startingSong = false;
		songStarted = true;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		}

		if (FlxG.save.data.noteSplash)
			{
				switch (mania)
				{
					case 0: 
						NoteSplash.colors = ['purple', 'blue', 'green', 'red'];
					case 1: 
						NoteSplash.colors = ['purple', 'green', 'red', 'yellow', 'blue', 'darkblue'];	
					case 2: 
						NoteSplash.colors = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'darkred', 'darkblue'];
					case 3: 
						NoteSplash.colors = ['purple', 'blue', 'white', 'green', 'red'];
						if (FlxG.save.data.gthc)
							NoteSplash.colors = ['green', 'red', 'yellow', 'darkblue', 'orange'];
					case 4: 
						NoteSplash.colors = ['purple', 'green', 'red', 'white', 'yellow', 'blue', 'darkblue'];
					case 5: 
						NoteSplash.colors = ['purple', 'blue', 'green', 'red', 'yellow', 'violet', 'darkred', 'darkblue'];
					case 6: 
						NoteSplash.colors = ['white'];
					case 7: 
						NoteSplash.colors = ['purple', 'red'];
					case 8: 
						NoteSplash.colors = ['purple', 'white', 'red'];
				}
			}

		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (FlxG.save.data.songPosition)
		{
			remove(songPosBG);
			remove(songPosBar);
			remove(songName);

			songPosBG = new FlxSprite(0, 10).loadGraphic(Paths.image('healthBar'));
			if (PlayStateChangeables.useDownscroll)
				songPosBG.y = FlxG.height * 0.9 + 45; 
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), this,
				'songPositionBar', 0, songLength - 1000);
			songPosBar.numDivisions = 1000;
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.LIME);
			add(songPosBar);

			var songName = new FlxText(songPosBG.x + (songPosBG.width / 2) - (SONG.song.length * 5),songPosBG.y,0,SONG.song, 16);
			if (PlayStateChangeables.useDownscroll)
				songName.y -= 3;
			songName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			songName.scrollFactor.set();
			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}
		
		// Song check real quick
		switch(curSong)
		{
			case 'Bopeebo' | 'Philly Nice' | 'Blammed' | 'Cocoa' | 'Eggnog': allowedToHeadbang = true;
			default: allowedToHeadbang = false;
		}

		if (useVideo)
			GlobalVideo.get().resume();
		
		#if windows
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore +  " | why are you looking in here" + " | Misses: " + misses  , iconRPC);
		#end

	//	DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore +  " | why are you looking in here" + " | Misses: " + misses  , iconRPC);
	//	#end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		PauseSubState.avoid = true;

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		trace('loaded vocals');

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		// Per song offset check
		#if windows
			// pre lowercasing the song name (generateSong)
			var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
				switch (songLowercase) {
					case 'dad-battle': songLowercase = 'dadbattle';
					case 'philly-nice': songLowercase = 'philly';
				}

			var songPath = 'assets/data/' + songLowercase + '/';
			
			for(file in sys.FileSystem.readDirectory(songPath))
			{
				var path = haxe.io.Path.join([songPath, file]);
				if(!sys.FileSystem.isDirectory(path))
				{
					if(path.endsWith('.offset'))
					{
						trace('Found offset file: ' + path);
						songOffset = Std.parseFloat(file.substring(0, file.indexOf('.off')));
						break;
					}else {
						trace('Offset file not found. Creating one @: ' + songPath);
						sys.io.File.saveContent(songPath + songOffset + '.offset', '');
					}
				}
			}
		#end
		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		//if (FlxG.save.data.randomNotes != "Regular" && FlxG.save.data.randomNotes != "None" && FlxG.save.data.randomNotes != "Section")
			//FlxG.save.data.randomNotes = "None";
		for (section in noteData)
		{
			var mn:Int = keyAmmo[mania];
			var coolSection:Int = Std.int(section.lengthInSteps / 4);
			var dataForThisSection:Array<Int> = [];
			var randomDataForThisSection:Array<Int> = [];
			//var maxNoteData:Int = 3;
			switch (maniaToChange) //sets up the max data for each section based on mania
			{
				case 0: 
					dataForThisSection = [0,1,2,3];
				case 1: 
					dataForThisSection = [0,1,2,3,4,5];
				case 2: 
					dataForThisSection = [0,1,2,3,4,5,6,7,8];
				case 3: 
					dataForThisSection = [0,1,2,3,4];
				case 4: 
					dataForThisSection = [0,1,2,3,4,5,6];
				case 5: 
					dataForThisSection = [0,1,2,3,4,5,6,7];
				case 6: 
					dataForThisSection = [0];
				case 7: 
					dataForThisSection = [0,1];
				case 8: 
					dataForThisSection = [0,1,2];
			}

			for (songNotes in section.sectionNotes)
			{
				var isRandomNoteType:Bool = false;
				var isReplaceable:Bool = false;
				var newNoteType:Int = 0;
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offset + songOffset;
				if (daStrumTime < 0)
					daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % mn);
				var daNoteTypeData:Int = FlxG.random.int(0, mn - 1);


				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] >= mn)
				{
					gottaHitNote = !section.mustHitSection;

				}
							switch(daNoteData)
							{
								case 0: 
									daNoteData = 0;
								case 1: 
									daNoteData = 1;
								case 2: 
									daNoteData = 2;
								case 3:
									daNoteData = 3;
								case 4: 
									daNoteData = 4;
								case 5: 
									daNoteData = 5;
								case 6: 
									daNoteData = 6;
								case 7:
									daNoteData = 7;
							}
					if (daNoteData > 7) //failsafe
						daNoteData -= 4;

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var daType = songNotes[3];

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, daType);

				var fuckYouNote:Note; //note type placed next to other note

				if (daNoteTypeData == daNoteData && daNoteTypeData == 0) //so it doesnt go over the other note, even though it still happens lol
					daNoteTypeData += 1;
				else if(daNoteTypeData == daNoteData)
					daNoteTypeData -= 1;

					fuckYouNote = null; // why tho thezoroforce.
					

				

				if (!gottaHitNote && PlayStateChangeables.Optimize)
					continue;

				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				if (susLength > 0)
					swagNote.isParent = true;

				var type = 0;

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, daType);
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

						sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
					{
						sustainNote.x += FlxG.width / 2; // general offset
					}
					sustainNote.parent = swagNote;
					swagNote.children.push(sustainNote);
					sustainNote.spotInLine = type;
					type++;
				}
					swagNote.mustPress = gottaHitNote;
					if (isRandomNoteType && !isReplaceable)
						fuckYouNote.mustPress = gottaHitNote;
					


				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
					if (isRandomNoteType && !isReplaceable)
						fuckYouNote.x += FlxG.width / 2;
				}
				else
				{
				}
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function testStaticArrows():Void
		{
				var babyArrow:FlxSprite = new FlxSprite(0, 0);

				babyArrow.frames = Paths.getSparrowAtlas('noteassets/NOTE_assets');
	
				trace(babyArrow.frames);
				FlxG.log.add(babyArrow.frames);
	
				trace(babyArrow);
				FlxG.log.add(babyArrow);
		}
	

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...keyAmmo[mania])
		{
			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			//defaults if no noteStyle was found in chart
			var noteTypeCheck:String = 'normal';
		
			if (PlayStateChangeables.Optimize && player == 0)
				continue;

	//		if (SONG.noteStyle == null) {
		//		switch(storyWeek) {case 6: noteTypeCheck = 'pixel';}
		//	} else {noteTypeCheck = SONG.noteStyle;}

			traceBoth(noteTypeCheck);
			trace(noteTypeCheck);
			switch (noteTypeCheck)
			{
				case 'pixel':
					babyArrow.loadGraphic(Paths.image('noteassets/pixel/arrows-pixels'), true, 17, 17);
					babyArrow.animation.add('green', [11]);
					babyArrow.animation.add('red', [12]);
					babyArrow.animation.add('blue', [10]);
					babyArrow.animation.add('purplel', [9]);

					babyArrow.animation.add('white', [13]);
					babyArrow.animation.add('yellow', [14]);
					babyArrow.animation.add('violet', [15]);
					babyArrow.animation.add('black', [16]);
					babyArrow.animation.add('darkred', [16]);
					babyArrow.animation.add('orange', [16]);
					babyArrow.animation.add('dark', [17]);


					babyArrow.setGraphicSize(Std.int(babyArrow.width * daPixelZoom * Note.pixelnoteScale));
					babyArrow.updateHitbox();
					babyArrow.antialiasing = false;

					var numstatic:Array<Int> = [0, 1, 2, 3, 4, 5, 6, 7, 8]; //this is most tedious shit ive ever done why the fuck is this so hard
					var startpress:Array<Int> = [9, 10, 11, 12, 13, 14, 15, 16, 17];
					var endpress:Array<Int> = [18, 19, 20, 21, 22, 23, 24, 25, 26];
					var startconf:Array<Int> = [27, 28, 29, 30, 31, 32, 33, 34, 35];
					var endconf:Array<Int> = [36, 37, 38, 39, 40, 41, 42, 43, 44];
						switch (mania)
						{
							case 1:
								numstatic = [0, 2, 3, 5, 1, 8];
								startpress = [9, 11, 12, 14, 10, 17];
								endpress = [18, 20, 21, 23, 19, 26];
								startconf = [27, 29, 30, 32, 28, 35];
								endconf = [36, 38, 39, 41, 37, 44];

							case 2: 
								babyArrow.x -= Note.tooMuch;
							case 3: 
								numstatic = [0, 1, 4, 2, 3];
								startpress = [9, 10, 13, 11, 12];
								endpress = [18, 19, 22, 20, 21];
								startconf = [27, 28, 31, 29, 30];
								endconf = [36, 37, 40, 38, 39];
							case 4: 
								numstatic = [0, 2, 3, 4, 5, 1, 8];
								startpress = [9, 11, 12, 13, 14, 10, 17];
								endpress = [18, 20, 21, 22, 23, 19, 26];
								startconf = [27, 29, 30, 31, 32, 28, 35];
								endconf = [36, 38, 39, 40, 41, 37, 44];
							case 5: 
								numstatic = [0, 1, 2, 3, 5, 6, 7, 8];
								startpress = [9, 10, 11, 12, 14, 15, 16, 17];
								endpress = [18, 19, 20, 21, 23, 24, 25, 26];
								startconf = [27, 28, 29, 30, 32, 33, 34, 35];
								endconf = [36, 37, 38, 39, 41, 42, 43, 44];
							case 6: 
								numstatic = [4];
								startpress = [13];
								endpress = [22];
								startconf = [31];
								endconf = [40];
							case 7: 
								numstatic = [0, 3];
								startpress = [9, 12];
								endpress = [18, 21];
								startconf = [27, 30];
								endconf = [36, 39];
							case 8: 
								numstatic = [0, 4, 3];
								startpress = [9, 13, 12];
								endpress = [18, 22, 21];
								startconf = [27, 31, 30];
								endconf = [36, 40, 39];


						}
					babyArrow.x += Note.swagWidth * i;
					babyArrow.animation.add('static', [numstatic[i]]);
					babyArrow.animation.add('pressed', [startpress[i], endpress[i]], 12, false);
					babyArrow.animation.add('confirm', [startconf[i], endconf[i]], 24, false);

					
				
					case 'normal':
						{
							babyArrow.frames = Paths.getSparrowAtlas('noteassets/NOTE_assets');
							babyArrow.animation.addByPrefix('green', 'arrowUP');
							babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
							babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
							babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

							trace(babyArrow.frames);
							FlxG.log.add(babyArrow.frames);
		
							babyArrow.antialiasing = FlxG.save.data.antialiasing;
							babyArrow.setGraphicSize(Std.int(babyArrow.width * Note.noteScale));
	
							var nSuf:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
							var pPre:Array<String> = ['purple', 'blue', 'green', 'red'];
								switch (mania)
								{
									case 1:
										nSuf = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
										pPre = ['purple', 'green', 'red', 'yellow', 'blue', 'dark'];
	
									case 2:
										nSuf = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'SPACE', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
										pPre = ['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'darkred', 'dark'];
										babyArrow.x -= Note.tooMuch;
									case 3: 
										nSuf = ['LEFT', 'DOWN', 'SPACE', 'UP', 'RIGHT'];
										pPre = ['purple', 'blue', 'white', 'green', 'red'];
										if (FlxG.save.data.gthc)
											{
												nSuf = ['UP', 'RIGHT', 'LEFT', 'RIGHT', 'UP'];
												pPre = ['green', 'red', 'yellow', 'dark', 'orange'];
											}
									case 4: 
										nSuf = ['LEFT', 'UP', 'RIGHT', 'SPACE', 'LEFT', 'DOWN', 'RIGHT'];
										pPre = ['purple', 'green', 'red', 'white', 'yellow', 'blue', 'dark'];
									case 5: 
										nSuf = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
										pPre = ['purple', 'blue', 'green', 'red', 'yellow', 'violet', 'darkred', 'dark'];
									case 6: 
										nSuf = ['SPACE'];
										pPre = ['white'];
									case 7: 
										nSuf = ['LEFT', 'RIGHT'];
										pPre = ['purple', 'red'];
									case 8: 
										nSuf = ['LEFT', 'SPACE', 'RIGHT'];
										pPre = ['purple', 'white', 'red'];
									default:
										nSuf = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
										pPre = ['purple', 'blue', 'green', 'red'];
								}
						
						babyArrow.x += Note.swagWidth * i;
						babyArrow.animation.addByPrefix('static', 'arrow' + nSuf[i]);
						babyArrow.animation.addByPrefix('pressed', pPre[i] + ' press', 24, false);
						babyArrow.animation.addByPrefix('confirm', pPre[i] + ' confirm', 24, false);
						}						
			}

			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				
				#if cpp
				if(!(SONG.song.toLowerCase() == "termination" || SONG.song.toLowerCase() == "redacted")) {//Disables usual intro for Termination AND REDACTED
					FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
				}
				#end
			}

			babyArrow.ID = i;

			trace(babyArrow);
			FlxG.log.add(babyArrow);

			switch (player)
			{
				case 0:
					cpuStrums.add(babyArrow);
				case 1:
					playerStrums.add(babyArrow);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);
			
			if (PlayStateChangeables.Optimize)
				babyArrow.x -= 275;

			if (PlayStateChangeables.bothSide)
				babyArrow.x -= 350;
			
			cpuStrums.forEach(function(spr:FlxSprite)
			{					
				spr.centerOffsets(); //CPU arrows start out slightly off-center
			});

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			#if windows
			DiscordClient.changePresence("PAUSED on " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore +  " | why are you looking in here" + " | Misses: " + misses  , iconRPC);
			#end
			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;

			#if windows
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore +  " | why are you looking in here" + " | Misses: " + misses, iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), iconRPC);
			}
			#end
		}

		super.closeSubState();
	}
	

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if windows
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore +  " | why are you looking in here" + " | Misses: " + misses  , iconRPC);
		#end
	}

	private var paused:Bool = false;

	var canPause:Bool = true;
	var nps:Int = 0;
	var maxNPS:Int = 0;

	public static var songRate = 1.5;

	public var stopUpdate = false;
	public var removedVideo = false;



	override public function update(elapsed:Float)
	{
		#if !debug
		perfectMode = false;
		#end

		if (shakeCam)
			{
				FlxG.camera.shake(0.01, 0.01);
			}
			if (shakeCock)
			{
				FlxG.camera.shake(0.05, 0.05);
			}

		floatdad += 0.05;
		floatdad2 -= 0.05;
		
		if (godModeFloat)
		{
			dad.y += Math.sin(floatdad);
			dad2.y += Math.sin(floatdad2);
		}

		if (generatedMusic)
			{
				for(i in notes)
				{
					var diff = i.strumTime - Conductor.songPosition;
					if (diff < 2650 && diff >= -2650)
					{
						i.active = true;
						i.visible = true;
					}
					else
					{
						i.active = false;
						i.visible = false;
					}
				}
			}

		if (PlayStateChangeables.botPlay && FlxG.keys.justPressed.ONE)
			camHUD.visible = !camHUD.visible;


		if (useVideo && GlobalVideo.get() != null && !stopUpdate)
			{		
				if (GlobalVideo.get().ended && !removedVideo)
				{
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}
			}


		
		#if windows
		if (executeModchart && luaModchart != null && songStarted)
		{
			luaModchart.setVar('songPos',Conductor.songPosition);
			luaModchart.setVar('hudZoom', camHUD.zoom);
			luaModchart.setVar('cameraZoom',FlxG.camera.zoom);
			luaModchart.executeState('update', [elapsed]);

			for (i in luaWiggles)
			{
				trace('wiggle le gaming');
				i.update(elapsed);
			}

			/*for (i in 0...strumLineNotes.length) {
				var member = strumLineNotes.members[i];
				member.x = luaModchart.getVar("strum" + i + "X", "float");
				member.y = luaModchart.getVar("strum" + i + "Y", "float");
				member.angle = luaModchart.getVar("strum" + i + "Angle", "float");
			}*/

			FlxG.camera.angle = luaModchart.getVar('cameraAngle', 'float');
			camHUD.angle = luaModchart.getVar('camHudAngle','float');

			if (luaModchart.getVar("showOnlyStrums",'bool'))
			{
				healthBarBG.visible = false;
				kadeEngineWatermark.visible = false;
				healthBar.visible = false;
				overhealthBar.visible = false;
				iconP1.visible = false;
				iconP2.visible = false;
				scoreTxt.visible = false;
			}
			else
			{
				healthBarBG.visible = true;
				kadeEngineWatermark.visible = true;
				healthBar.visible = true;
				overhealthBar.visible = false;
				iconP1.visible = true;
				iconP2.visible = true;
				scoreTxt.visible = true;
			}

			var p1 = luaModchart.getVar("strumLine1Visible",'bool');
			var p2 = luaModchart.getVar("strumLine2Visible",'bool');

			for (i in 0...keyAmmo[mania])
			{
				strumLineNotes.members[i].visible = p1;
				if (i <= playerStrums.length)
					playerStrums.members[i].visible = p2;
			}

			camNotes.zoom = camHUD.zoom;
			camNotes.x = camHUD.x;
			camNotes.y = camHUD.y;
			camNotes.angle = camHUD.angle;
			camSustains.zoom = camHUD.zoom;
			camSustains.x = camHUD.x;
			camSustains.y = camHUD.y;
			camSustains.angle = camHUD.angle;
		}

		#end
		camNotes.zoom = camHUD.zoom;
		camNotes.x = camHUD.x;
		camNotes.y = camHUD.y;
		camNotes.angle = camHUD.angle;

		// reverse iterate to remove oldest notes first and not invalidate the iteration
		// stop iteration as soon as a note is not removed
		// all notes should be kept in the correct order and this is optimal, safe to do every frame/update
		{
			var balls = notesHitArray.length-1;
			while (balls >= 0)
			{
				var cock:Date = notesHitArray[balls];
				if (cock != null && cock.getTime() + 1000 < Date.now().getTime())
					notesHitArray.remove(cock);
				else
					balls = 0;
				balls--;
			}
			nps = notesHitArray.length;
			if (nps > maxNPS)
				maxNPS = nps;
		}

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving && !PlayStateChangeables.Optimize)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);

		scoreTxt.text = Ratings.CalculateRanking(songScore,songScoreDef,nps,maxNPS,accuracy);

		var lengthInPx = scoreTxt.textField.length * scoreTxt.frameHeight; // bad way but does more or less a better job

		scoreTxt.x = (originalX - (lengthInPx / 2)) + 335;

		if (controls.PAUSE && startedCountdown && canPause && !cannotDie)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				trace('GITAROO MAN EASTER EGG');
				if (SONG.song.toLowerCase() != 'terminate')
					FlxG.switchState(new GitarooPause());
			}
			else
				if (SONG.song.toLowerCase() != 'terminate')
					openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		#if desktop
		if (FlxG.keys.justPressed.F9 && songStarted)
		{
			if (useVideo)
				{
					GlobalVideo.get().stop();
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}
			cannotDie = true;
			#if windows
			DiscordClient.changePresence("being a wuss on hex vs whitty by building debug for chart editor", null, null, true);
			#end
			FlxG.switchState(new ChartingState());
			Main.editor = true;
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, releaseInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}
		#else
		if (FlxG.keys.justPressed.SEVEN && songStarted)
			{
				if (useVideo)
					{
						GlobalVideo.get().stop();
						remove(videoSprite);
						FlxG.stage.window.onFocusOut.remove(focusOut);
						FlxG.stage.window.onFocusIn.remove(focusIn);
						removedVideo = true;
					}
				cannotDie = true;
				#if windows
				DiscordClient.changePresence("being a wuss on hex vs whitty by building debug for chart editor", null, null, true);
				#end
				FlxG.switchState(new ChartingState());
				Main.editor = true;
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
				FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, releaseInput);
				#if windows
				if (luaModchart != null)
				{
					luaModchart.die();
					luaModchart = null;
				}
				#end
			}
		#end

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

			iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
			iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);	

			if (FlxG.save.data.cheatsV2) {
				if (health > 2999999999)
					health = 2999999999;
			}
			else if (!FlxG.save.data.cheatsV2) {
				if (health > 2 &&  MaxHealth == 5) { //shit way of doing it, I know. but it fucking works
					trace('a lot of health');
					health = 2;
				}
				else if (health > 1.5 && MaxHealth == 4)
					health = 1.5;
				else if (health > 1 && MaxHealth == 3)
					health = 1;
				else if (health > 0.5 && MaxHealth == 2)
					health = 0.5;
				else if (health > 0.1 && MaxHealth == 1)
					health = 0.1;
				else if (health > 0.1 && MaxHealth == 0)
					health = 0.1;
				else if (health > 0.1 && MaxHealth == -1)
					health = 0.1;
				else if (health > 0.1 && MaxHealth == -3)
					health = 0.1;
				else if (health > 0.1 && MaxHealth == -4)
					health = 0.1;
				else if (health > 0.1 && MaxHealth == -5)
					health = 0.1;
				else if (health > 0.1 && MaxHealth == -6)
					health = 0.1;
				else if (health > 0.1 && MaxHealth == -7)
					health = 0.1;
				else if (health > 0.1 && MaxHealth == -8)
					health = 0.1;
				else if (health > 0.1 && MaxHealth == -9) {
					health = 0.1;
				trace('almost gone');
				}
				else if (health > 0 && MaxHealth == -10) {
					health = 0;
					trace('your dead');
				}
			}
			else {
				health = 0;
				trace('what tf are you doing my guy?????');
			}

				if (healthBar.percent < 20)
					iconP1.animation.curAnim.curFrame = 1;
				else
					iconP1.animation.curAnim.curFrame = 0;
		
				if (healthBar.percent > 80)
					iconP2.animation.curAnim.curFrame = 1;
				else
					iconP2.animation.curAnim.curFrame = 0;

		#if debug
		if (FlxG.keys.justPressed.SIX)
		{
			if (useVideo)
				{
					GlobalVideo.get().stop();
					remove(videoSprite);
					FlxG.stage.window.onFocusOut.remove(focusOut);
					FlxG.stage.window.onFocusIn.remove(focusIn);
					removedVideo = true;
				}

			FlxG.switchState(new AnimationDebug(SONG.player2));
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, releaseInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		if (FlxG.keys.justPressed.ZERO)
		{
			FlxG.switchState(new AnimationDebug(SONG.player1));
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN,handleInput);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, releaseInput);
			#if windows
			if (luaModchart != null)
			{
				luaModchart.die();
				luaModchart = null;
			}
			#end
		}

		#end

		if (FlxG.keys.justPressed.F10)
			{
				TitleState.reTrace();
			}

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;
			/*@:privateAccess
			{
				FlxG.sound.music._channel.
			}*/
			songPositionBar = Conductor.songPosition;

			currentSection = SONG.notes[Std.int(curStep / 16)];

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && currentSection != null)
		{
			closestNotes = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
					closestNotes.push(daNote);
			}); // Collect notes that can be hit

			closestNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

			if (closestNotes.length != 0)
				FlxG.watch.addQuick("Current Note",closestNotes[0].strumTime - Conductor.songPosition);
			// Make sure Girlfriend cheers only for certain songs
			if(allowedToHeadbang)
			{
				// Don't animate GF if something else is already animating her (eg. train passing)
				if(gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle')
				{
					// Per song treatment since some songs will only have the 'Hey' at certain times
					switch(curSong)
					{
						case 'Philly Nice':
						{
							// General duration of the song
							if(curBeat < 250)
							{
								// Beats to skip or to stop GF from cheering
								if(curBeat != 184 && curBeat != 216)
								{
									if(curBeat % 16 == 8)
									{
										// Just a garantee that it'll trigger just once
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Bopeebo':
						{
							// Where it starts || where it ends
							if(curBeat > 5 && curBeat < 130)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
						case 'Blammed':
						{
							if(curBeat > 30 && curBeat < 190)
							{
								if(curBeat < 90 || curBeat > 128)
								{
									if(curBeat % 4 == 2)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Cocoa':
						{
							if(curBeat < 170)
							{
								if(curBeat < 65 || curBeat > 130 && curBeat < 145)
								{
									if(curBeat % 16 == 15)
									{
										if(!triggeredAlready)
										{
											gf.playAnim('cheer');
											triggeredAlready = true;
										}
									}else triggeredAlready = false;
								}
							}
						}
						case 'Eggnog':
						{
							if(curBeat > 10 && curBeat != 111 && curBeat < 220)
							{
								if(curBeat % 8 == 7)
								{
									if(!triggeredAlready)
									{
										gf.playAnim('cheer');
										triggeredAlready = true;
									}
								}else triggeredAlready = false;
							}
						}
					}
				}
			}
			
			#if windows
			if (luaModchart != null)
				luaModchart.setVar("mustHit",currentSection.mustHitSection);
			#end

				if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
					{
						var offsetX = 0;
						var offsetY = 0;
						#if windows
						if (luaModchart != null)
						{
							offsetX = luaModchart.getVar("followXOffset", "float");
							offsetY = luaModchart.getVar("followYOffset", "float");
						}
						#end
		
						camFollow.setPosition(dad.getMidpoint().x + 150 + offsetX, dad.getMidpoint().y - 100 + offsetY);
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoTurn', []);
						#end
						// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);
		
						switch (dad.curCharacter)
						{
							case 'mom':
								camFollow.y = dad.getMidpoint().y;
							case 'senpai':
								camFollow.y = dad.getMidpoint().y - 430;
								camFollow.x = dad.getMidpoint().x - 100;
							case 'senpai-angry':
								camFollow.y = dad.getMidpoint().y - 430;
								camFollow.x = dad.getMidpoint().x - 100;
							case 'qt' | 'qt_annoyed':
								camFollow.y = dad.getMidpoint().y + 261;
							case 'qt_classic':
								camFollow.y = dad.getMidpoint().y + 95;
							case 'robot' | 'robot_404' | 'robot_404-TERMINATION' | 'robot_classic' | 'robot_classic_404':
								camFollow.y = dad.getMidpoint().y + 25;
								camFollow.x = dad.getMidpoint().x - 18;
							case 'qt-kb':
								camFollow.y = dad.getMidpoint().y + 25;
								camFollow.x = dad.getMidpoint().x - 18;
							case 'qt-meme':
								camFollow.y = dad.getMidpoint().y + 107;
						}
		
						if (dad.curCharacter == 'mom')
							vocals.volume = 1;
					}
		
					if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
					{
						var offsetX = 0;
						var offsetY = 0;
						#if windows
						if (luaModchart != null)
						{
							offsetX = luaModchart.getVar("followXOffset", "float");
							offsetY = luaModchart.getVar("followYOffset", "float");
						}
						#end
						camFollow.setPosition(boyfriend.getMidpoint().x - 100 + offsetX, boyfriend.getMidpoint().y - 200 + offsetY);
		
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerOneTurn', []);
						#end
		
						switch (curStage)
						{
							case 'limo':
								camFollow.x = boyfriend.getMidpoint().x - 300;
							case 'mall':
								camFollow.y = boyfriend.getMidpoint().y - 200;
							case 'school':
								camFollow.x = boyfriend.getMidpoint().x - 200;
								camFollow.y = boyfriend.getMidpoint().y - 200;
							case 'schoolEvil':
								camFollow.x = boyfriend.getMidpoint().x - 200;
								camFollow.y = boyfriend.getMidpoint().y - 200;
						}
					}
			}

		if (camZooming)
		{
			if (FlxG.save.data.zoom < 0.8)
				FlxG.save.data.zoom = 0.8;
	
			if (FlxG.save.data.zoom > 1.2)
				FlxG.save.data.zoom = 1.2;
			if (!executeModchart)
				{
					FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
					camHUD.zoom = FlxMath.lerp(FlxG.save.data.zoom, camHUD.zoom, 0.95);
	
					camNotes.zoom = camHUD.zoom;
					camSustains.zoom = camHUD.zoom;
				}
				else
				{
					FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
					camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
	
					camNotes.zoom = camHUD.zoom;
					camSustains.zoom = camHUD.zoom;
				}
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (curSong.toLowerCase() == 'censory-overload')
		{
			switch (curBeat)
			{	
				case 0:
						qt_tv01.animation.play("instructions");
				case 2:
					if(!Main.qtOptimisation){
						boyfriend404.alpha = 0; 
						dad404.alpha = 0;
						gf404.alpha = 0;
					}
				/*case 4:
					//Experimental stuff
					FlxG.log.notice('Anything different?');
					qtIsBlueScreened = true;
					CensoryOverload404();*/
				case 64:
					qt_tv01.animation.play("eye");
				case 80: //First drop
					gfSpeed = 1;
					qt_tv01.animation.play("idle");
				case 208: //First drop end
					gfSpeed = 2;
				case 240: //2nd drop hype!!!
					qt_tv01.animation.play("drop");
				case 304: //2nd drop
					gfSpeed = 1;
				case 432:  //2nd drop end
					qt_tv01.animation.play("idle");
					gfSpeed = 2;
				case 558: //rawr xd
					FlxG.camera.shake(0.00425,0.6725);
					qt_tv01.animation.play("eye");
				case 560: //3rd drop
					gfSpeed = 1;
					qt_tv01.animation.play("idle");
				case 688: //3rd drop end
					gfSpeed = 2;
				case 702:
					//Change to glitch background
					if(!Main.qtOptimisation){
						streetBGerror.visible = true;
						streetBG.visible = false;
					}
					qt_tv01.animation.play("error");
					FlxG.camera.shake(0.0075,0.67);
				case 704: //404 section
					gfSpeed = 1;
					isdad404 = true;
					isbf404 = true;
					isgf404 = true;
					//Change to bluescreen background
					qt_tv01.animation.play("404");
					if(!Main.qtOptimisation){
						streetBG.visible = false;
						streetBGerror.visible = false;
						streetFrontError.visible = true;
						qtIsBlueScreened = true;
						CensoryOverload404();
					}
				case 832: //Final drop
					//Revert back to normal
					isdad404 = false; //prevents lag.
					isbf404 = false;
					isgf404 = false;
					if(!Main.qtOptimisation){
						streetBG.visible = true;
						streetFrontError.visible = false;
						qtIsBlueScreened = false;
						CensoryOverload404();
					}
					gfSpeed = 1;
				case 960: //After final drop. 
					qt_tv01.animation.play("idle");
					//gfSpeed = 2; //Commented out because I like gfSpeed being 1 rather then 2. -Haz
			}
			if (curStep == 52) {
			//	add(kb_attack_saw);
			//	add(kb_attack_alert);
			}
			/*
			if (curStep == 56){
				KBATTACK(true);
			}
			if (curStep == 912){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 916){
				KBATTACK_ALERT(false);
			}
			if (curStep == 920){
				KBATTACK(true);
			}
			if (curStep == 1072){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 1076){
				KBATTACK_ALERT(false);
			}
			if (curStep == 1080){
				KBATTACK(true);
			}
			if (curStep == 1200){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 1204){
				KBATTACK_ALERT(false);
			}
			if (curStep == 1208){
				KBATTACK(true);
			}
			if (curStep == 1968){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 1972){
				KBATTACK_ALERT(false);
			}
			if (curStep == 1976){
				KBATTACK(true);
			}
			if (curStep == 2096){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2100){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2104)
				KBATTACK(true);
			if (curStep == 2176){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2180){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2184)
				KBATTACK(true);
			if (curStep == 2208){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2212){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2216){
				KBATTACK(true);
			}
			if (curStep == 2240){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2244){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2248){
				KBATTACK(true);
			}
			if (curStep == 2256){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2260){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2264){
				KBATTACK(true);
			}
			if (curStep == 2276){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2280){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2284){
				KBATTACK(true);
			}
			if (curStep == 2288){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2292){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2296){
				KBATTACK(true);
			}
			if (curStep == 2304){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2308){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2312){
				KBATTACK(true);
			}
			if (curStep == 2320){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2324){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2328){
				KBATTACK(true);
			}
			if (curStep == 2340){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2344){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2348){
				KBATTACK(true);
			}
			if (curStep == 2352){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2356){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2360){
				KBATTACK(true);
			}
			if (curStep == 2496){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2500){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2504){
				KBATTACK(true);
			}
			if (curStep == 2512){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2516){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2520){
				KBATTACK(true);
			}
			if (curStep == 2544){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2548){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2552)
				KBATTACK(true);
			if (curStep == 2560){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2564){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2568){
				KBATTACK(true);
			}
			if (curStep == 2576){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2580){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2584){
				KBATTACK(true);
			}
			if (curStep == 2608){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2612){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2616){
				KBATTACK(true);
			}
			if (curStep == 2672){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2676){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2680){
				KBATTACK(true);
			}
			if (curStep == 2704){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2708){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2712){
				KBATTACK(true);
			}
			if (curStep == 2880){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2884){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2888){
				KBATTACK(true);
			}
			if (curStep == 2912){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2916){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2920){
				KBATTACK(true);
			}
			if (curStep == 2944){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2948){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2952){
				KBATTACK(true);
			}
			if (curStep == 2956){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2960){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2964){
				KBATTACK(true);
			}
			if (curStep == 2976){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2980){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2984){
				KBATTACK(true);
			}
			if (curStep == 2988){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 2992){
				KBATTACK_ALERT(false);
			}
			if (curStep == 2996){
				KBATTACK(true);
			}
			if (curStep == 3008){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3012){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3016){
				KBATTACK(true);
			}
			if (curStep == 3024){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3028){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3032){
				KBATTACK(true);
			}
			if (curStep == 3040){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3044){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3048){
				KBATTACK(true);
			}
			if (curStep == 3056){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3060){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3064)
				KBATTACK(true);
			if (curStep == 3168){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3172){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3176){
				KBATTACK(true);
			}
			if (curStep == 3216){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3220){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3224){
				KBATTACK(true);
			}
			if (curStep == 3248){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3252){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3256){
				KBATTACK(true);
			}
			if (curStep == 3312){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3316){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3320)
				KBATTACK(true);
			if (curStep == 3376){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3380){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3384){
				KBATTACK(true);
			}
			if (curStep == 3408){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3412){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3416){
				KBATTACK(true);
			}
			if (curStep == 3424){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3428){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3432){
				KBATTACK(true);
			}
			if (curStep == 3440){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3444)
				KBATTACK_ALERT(false);
			if (curStep == 3448){
				KBATTACK(true);
			}
			if (curStep == 3584){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3588){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3592){
				KBATTACK(true);
			}
			if (curStep == 3596){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3600){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3604){
				KBATTACK(true);
			}
			if (curStep == 3616){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3620){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3624){
				KBATTACK(true);
			}
			if (curStep == 3628){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3632){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3636){
				KBATTACK(true);
			}
			if (curStep == 3648){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3652){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3656)
				KBATTACK(true);
			if (curStep == 3664)
			{
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3668){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3672){
				KBATTACK(true);
			}
			if (curStep == 3680){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3684){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3688){
				KBATTACK(true);
			}
			if (curStep == 3692){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3696){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3700){
				KBATTACK(true);
			}
			if (curStep == 3888){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3892){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3896){
				KBATTACK(true);
			}
			if (curStep == 3952){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3956){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3960){
				KBATTACK(true);
			}
			if (curStep == 3984){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 3988){
				KBATTACK_ALERT(false);
			}
			if (curStep == 3992){
				KBATTACK(true);
			}
			if (curStep == 4016){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 4020){
				KBATTACK_ALERT(false);
			}
			if (curStep == 4024){
				KBATTACK(true);
			}
			if (curStep == 4048){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 4052){
				KBATTACK_ALERT(false);
			}
			if (curStep == 4056){
				KBATTACK(true);
			}
			if (curStep == 4080){
				KBATTACK_ALERT(false);
				KBATTACK(false);
			}
			if (curStep == 4084){
				KBATTACK_ALERT(false);
			}
			if (curStep == 4088){
				KBATTACK(true);
			}*/
		}

		if (curSong == 'Fresh')
		{
			switch (curBeat)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}

		if (curSong == 'Bopeebo')
		{
			switch (curBeat)
			{
				case 128, 129, 130:
					vocals.volume = 0;
					// FlxG.sound.music.stop();
					// FlxG.switchState(new PlayState());
			}
		}

		if (health <= 0 && !cannotDie && !practiceMode)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

			#if windows
			// Game Over doesn't get his own variable because it's only used here
			DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore +  " | DM me the word Tomato for a suprise :), as Im SHIT at this game." + " | Misses: " + misses  , iconRPC);
			#end

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}
 		if (!inCutscene && FlxG.save.data.resetButton)
		{
			if(FlxG.keys.justPressed.R)
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					FlxG.sound.music.stop();
		
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
					#if windows
					// Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore +  " | DM me the word Tomato for a suprise :), as Im SHIT at this game." + " | Misses: " + misses  , iconRPC);
					#end
		
					// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 3500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		switch(mania)
		{
			case 0: 
				sDir = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
				bfsDir = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
			case 1: 
				sDir = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
				bfsDir = ['LEFT', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'RIGHT'];
			case 2: 
				sDir = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'UP', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
				bfsDir = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'Hey', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
			case 3: 
				sDir = ['LEFT', 'DOWN', 'UP', 'UP', 'RIGHT'];
				bfsDir = ['LEFT', 'DOWN', 'Hey', 'UP', 'RIGHT'];
			case 4: 
				sDir = ['LEFT', 'UP', 'RIGHT', 'UP', 'LEFT', 'DOWN', 'RIGHT'];
				bfsDir = ['LEFT', 'UP', 'RIGHT', 'Hey', 'LEFT', 'DOWN', 'RIGHT'];
			case 5: 
				sDir = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
				bfsDir = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'LEFT', 'DOWN', 'UP', 'RIGHT'];
			case 6: 
				sDir = ['UP'];
				bfsDir = ['Hey'];
			case 7: 
				sDir = ['LEFT', 'RIGHT'];
				bfsDir = ['LEFT', 'RIGHT'];
			case 8:
				sDir = ['LEFT', 'UP', 'RIGHT'];
				bfsDir = ['LEFT', 'Hey', 'RIGHT'];
		}

		if (generatedMusic)
			{
				switch(maniaToChange)
				{
					case 0: 
						hold = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
					case 1: 
						hold = [controls.L1, controls.U1, controls.R1, controls.L2, controls.D1, controls.R2];
					case 2: 
						hold = [controls.N0, controls.N1, controls.N2, controls.N3, controls.N4, controls.N5, controls.N6, controls.N7, controls.N8];
					case 3: 
						hold = [controls.LEFT, controls.DOWN, controls.N4, controls.UP, controls.RIGHT];
					case 4: 
						hold = [controls.L1, controls.U1, controls.R1, controls.N4, controls.L2, controls.D1, controls.R2];
					case 5: 
						hold = [controls.N0, controls.N1, controls.N2, controls.N3, controls.N5, controls.N6, controls.N7, controls.N8];
					case 6: 
						hold = [controls.N4];
					case 7: 
						hold = [controls.LEFT, controls.RIGHT];
					case 8: 
						hold = [controls.LEFT, controls.N4, controls.RIGHT];

					case 10: //changing mid song (mania + 10, seemed like the best way to make it change without creating more switch statements)
						hold = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT,false,false,false,false,false];
					case 11: 
						hold = [controls.L1, controls.D1, controls.U1, controls.R1, false, controls.L2, false, false, controls.R2];
					case 12: 
						hold = [controls.N0, controls.N1, controls.N2, controls.N3, controls.N4, controls.N5, controls.N6, controls.N7, controls.N8];
					case 13: 
						hold = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT, controls.N4,false,false,false,false];
					case 14: 
						hold = [controls.L1, controls.D1, controls.U1, controls.R1, controls.N4, controls.L2, false, false, controls.R2];
					case 15:
						hold = [controls.N0, controls.N1, controls.N2, controls.N3, false, controls.N5, controls.N6, controls.N7, controls.N8];
					case 16: 
						hold = [false, false, false, false, controls.N4, false, false, false, false];
					case 17: 
						hold = [controls.LEFT, false, false, controls.RIGHT, false, false, false, false, false];
					case 18: 
						hold = [controls.LEFT, false, false, controls.RIGHT, controls.N4, false, false, false, false];
				}
				var holdArray:Array<Bool> = hold;

				
				notes.forEachAlive(function(daNote:Note)
				{	

					// instead of doing stupid y > FlxG.height
					// we be men and actually calculate the time :)
					if (daNote.tooLate)
					{
						daNote.active = false;
						daNote.visible = false;
					}
					else
					{
						daNote.visible = true;
						daNote.active = true;
					}
					
					if (!daNote.modifiedByLua)
						{
						//	traceBoth('first note is: '+playerStrums.members[0]);
						//	traceBoth('second note is: '+playerStrums.members[1]);

							if (PlayStateChangeables.useDownscroll)
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members
										[Math.floor(Math.abs
											(daNote.noteData))] //testing for which line crashes
										.y
										+ 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) - daNote.noteYOff;
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
										+ 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) - daNote.noteYOff;
								if (daNote.isSustainNote)
								{
									// Remember = minus makes notes go up, plus makes them go down
									if (daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null)
										daNote.y += daNote.prevNote.height;
									else
										daNote.y += daNote.height / 2;
		
									// If not in botplay, only clip sustain notes when properly hit, botplay gets to clip it everytime
									if (!PlayStateChangeables.botPlay)
									{
										if (keyBotplay) { //adding custom botplay shit
										if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit || holdArray[Math.floor(Math.abs(daNote.noteData))] && !daNote.tooLate)
											&& daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
											swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
												+ Note.swagWidth / 2
												- daNote.y) / daNote.scale.y;
											swagRect.y = daNote.frameHeight - swagRect.height;
		
											daNote.clipRect = swagRect;
										}
										}
									}
									else
									{
										var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
										swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
											+ Note.swagWidth / 2
											- daNote.y) / daNote.scale.y;
										swagRect.y = daNote.frameHeight - swagRect.height;
		
										daNote.clipRect = swagRect;
									}
								}
							}
							else
							{
								if (daNote.mustPress)
									daNote.y = (playerStrums.members				
										[Math.floor(Math.abs(
											daNote.noteData))] 
											.y
										- 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) + daNote.noteYOff;
								else
									daNote.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
										- 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? SONG.speed : PlayStateChangeables.scrollSpeed,
											2)) + daNote.noteYOff;
								if (daNote.isSustainNote)
								{
									daNote.y -= daNote.height / 2;
		
									if (!PlayStateChangeables.botPlay)
									{
										if (keyBotplay) {
										if ((!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit || holdArray[Math.floor(Math.abs(daNote.noteData))] && !daNote.tooLate)
											&& daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2))
										{
											// Clip to strumline
											var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
											swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
												+ Note.swagWidth / 2
												- daNote.y) / daNote.scale.y;
											swagRect.height -= swagRect.y;
		
											daNote.clipRect = swagRect;
										}
									}
									}
									else
									{
										var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
										swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y
											+ Note.swagWidth / 2
											- daNote.y) / daNote.scale.y;
										swagRect.height -= swagRect.y;
		
										daNote.clipRect = swagRect;
									}
								}
							}
						}
		
	
					if (!daNote.mustPress && daNote.wasGoodHit)
					{
						if (SONG.song != 'Tutorial')
							camZooming = true;

						var altAnim:String = "";
	
						if (currentSection != null)
						{
							if (currentSection.altAnim)
								altAnim = '-alt';
						}	
						if (daNote.alt)
							altAnim = '-alt';

						//var sDir
					//	dad.playAnim('sing' + sDir[daNote.noteData] + altAnim, true);

						if (isdad)
						{
							dad.playAnim('sing' + sDir[daNote.noteData] + altAnim, true);
							dad.holdTimer = 0;
						}
						if (isdad2)
						{
							dad2.playAnim('sing' + sDir[daNote.noteData] + altAnim, true);
							dad2.holdTimer = 0;
						}
						if (isdad404)
						{ //how im doing it
							dad404.playAnim('sing' + sDir[daNote.noteData] + altAnim, true);
							dad404.holdTimer = 0;
						}


						/*if (daNote.isSustainNote)
						{
							health -= SONG.noteValues[0] / 3;
						}
						else
							health -= SONG.noteValues[0];
						*/
						
						if (FlxG.save.data.cpuStrums)
						{
							cpuStrums.forEach(function(spr:FlxSprite)
							{
								if (Math.abs(daNote.noteData) == spr.ID)
								{
									spr.animation.play('confirm', true);
								}
								if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
								{
									spr.centerOffsets();
									switch(maniaToChange)
									{
										case 0: 
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 1: 
											spr.offset.x -= 16;
											spr.offset.y -= 16;
										case 2: 
											spr.offset.x -= 22;
											spr.offset.y -= 22;
										case 3: 
											spr.offset.x -= 15;
											spr.offset.y -= 15;
										case 4: 
											spr.offset.x -= 18;
											spr.offset.y -= 18;
										case 5: 
											spr.offset.x -= 20;
											spr.offset.y -= 20;
										case 6: 
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 7: 
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 8:
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 10: 
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 11: 
											spr.offset.x -= 16;
											spr.offset.y -= 16;
										case 12: 
											spr.offset.x -= 22;
											spr.offset.y -= 22;
										case 13: 
											spr.offset.x -= 15;
											spr.offset.y -= 15;
										case 14: 
											spr.offset.x -= 18;
											spr.offset.y -= 18;
										case 15: 
											spr.offset.x -= 20;
											spr.offset.y -= 20;
										case 16: 
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 17: 
											spr.offset.x -= 13;
											spr.offset.y -= 13;
										case 18:
											spr.offset.x -= 13;
											spr.offset.y -= 13;
									}
								}
								else
									spr.centerOffsets();
							});
						}
	
						#if windows
						if (luaModchart != null)
							luaModchart.executeState('playerTwoSing', [Math.abs(daNote.noteData), Conductor.songPosition]);
						#end

						dad.holdTimer = 0;
	
						if (SONG.needsVoices)
							vocals.volume = 1;
	
						daNote.active = false;


						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}

					if (daNote.mustPress && !daNote.modifiedByLua)
						{
							daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
							daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
							if (!daNote.isSustainNote)
								daNote.modAngle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
							if (daNote.sustainActive)
							{
								if (executeModchart)
									daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
							}
							daNote.modAngle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						}
						else if (!daNote.wasGoodHit && !daNote.modifiedByLua)
						{
							daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
							daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
							if (!daNote.isSustainNote)
								daNote.modAngle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
							if (daNote.sustainActive)
							{
								if (executeModchart)
									daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
							}
							daNote.modAngle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						}
		
						if (daNote.isSustainNote)
						{
							daNote.x += daNote.width / 2 + 20;
							if (SONG.noteStyle == 'pixel')
								daNote.x -= 11;
						}
					

					//trace(daNote.y);
					// WIP interpolation shit? Need to fix the pause issue
					// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
	
					if (daNote.isSustainNote && daNote.wasGoodHit && Conductor.songPosition >= daNote.strumTime)
						{
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
					else if ((daNote.mustPress && daNote.tooLate && !PlayStateChangeables.useDownscroll || daNote.mustPress && daNote.tooLate && PlayStateChangeables.useDownscroll) 
					&& daNote.mustPress)
					{

							switch (daNote.noteType)
							{
						
								case 0: //normal
								{
									if (daNote.isSustainNote && daNote.wasGoodHit)
										{
											daNote.kill();
											notes.remove(daNote, true);
										}
										else
										{
											if (loadRep && daNote.isSustainNote)
											{
												// im tired and lazy this sucks I know i'm dumb
												if (findByTime(daNote.strumTime) != null)
													totalNotesHit += 1;
												else
												{
													vocals.volume = 0;
													if (theFunne && !daNote.isSustainNote)
													{
														noteMiss(daNote.noteData, daNote);
													}
													if (daNote.isParent)
													{
														health -= 0.15; // give a health punishment for failing a LN
														trace("hold fell over at the start");
														for (i in daNote.children)
														{
															i.alpha = 0.3;
															i.sustainActive = false;
														}
													}
													else
													{
														if (!daNote.wasGoodHit
															&& daNote.isSustainNote
															&& daNote.sustainActive
															&& daNote.spotInLine != daNote.parent.children.length)
														{
															health -= 0.2; // give a health punishment for failing a LN
															trace("hold fell over at " + daNote.spotInLine);
															for (i in daNote.parent.children)
															{
																i.alpha = 0.3;
																i.sustainActive = false;
															}
															if (daNote.parent.wasGoodHit)
																misses++;
															if (!practiceMode)
															updateAccuracy();
														}
														else if (!daNote.wasGoodHit
															&& !daNote.isSustainNote)
														{
															health -= 0.15;
														}
													}
												}
											}
											else
											{
												vocals.volume = 0;
												if (theFunne && !daNote.isSustainNote)
												{
													if (PlayStateChangeables.botPlay)
													{
														if (keyBotplay) {
														daNote.rating = "bad";
														goodNoteHit(daNote);
														}
													}
													else
														noteMiss(daNote.noteData, daNote);
												}
				
												if (daNote.isParent)
												{
													health -= 0.15; // give a health punishment for failing a LN
													trace("hold fell over at the start");
													for (i in daNote.children)
													{
														i.alpha = 0.3;
														i.sustainActive = false;
														trace(i.alpha);
													}
												}
												else
												{
													if (!daNote.wasGoodHit
														&& daNote.isSustainNote
														&& daNote.sustainActive
														&& daNote.spotInLine != daNote.parent.children.length)
													{
														health -= 0.25; // give a health punishment for failing a LN
														trace("hold fell over at " + daNote.spotInLine);
														for (i in daNote.parent.children)
														{
															i.alpha = 0.3;
															i.sustainActive = false;
															trace(i.alpha);
														}
														if (daNote.parent.wasGoodHit)
															misses++;
														if (!practiceMode)
														updateAccuracy();
													}
													else if (!daNote.wasGoodHit
														&& !daNote.isSustainNote)
													{
														health -= 0.15;
													}
												}
											}
										}
				
										daNote.visible = false;
										daNote.kill();
										notes.remove(daNote, true);
								}
								case 1: //fire notes - makes missing them not count as one -- YOUR WELCOME PEOPLE FOR THE KILL NOTES FUNCTION -discussions | killNotes(daNote);
								{
									killNotes(daNote);
								}
								case 2: //halo notes, same as fire
								{
									killNotes(daNote);
								}
								case 3:  //warning notes, removes half health and) removed so it doesn't repeatedly deal damage
								{
									health -= 1;
									vocals.volume = 0;
									badNoteHit();
									killNotes(daNote);
								}
								case 4: //angel notes
								{
									killNotes(daNote);
								}
								case 6:  //bob notes
								{
									killNotes(daNote);
								}
								case 7: //gltich notes
								{
									HealthDrain();
									killNotes(daNote);
								}
								case 8: //warning new notes
								{
									health = 0; //sorry just nature
									vocals.volume = 0;
									badNoteHit();
									killNotes(daNote);
								}
								case 9: //snow notes
								{
									killNotes(daNote);
								}
								case 10: //deathNew notes
								{
									killNotes(daNote);
								}
								case 11: //fire notes
								{
									killNotes(daNote);
								}
							}
						}
						if(PlayStateChangeables.useDownscroll && daNote.y > strumLine.y ||
							!PlayStateChangeables.useDownscroll && daNote.y < strumLine.y)
							{
									// Force good note hit regardless if it's too late to hit it or not as a fail safe
									if(PlayStateChangeables.botPlay && daNote.canBeHit && daNote.mustPress ||
									PlayStateChangeables.botPlay && daNote.tooLate && daNote.mustPress)
									{
										if (keyBotplay) {
										if(loadRep)
										{
											//trace('ReplayNote ' + tmpRepNote.strumtime + ' | ' + tmpRepNote.direction);
											var n = findByTime(daNote.strumTime);
											trace(n);
											if(n != null)
											{
												goodNoteHit(daNote);
												boyfriend.holdTimer = daNote.sustainLength;
											}
										}
										}else {
											if (!daNote.burning && !daNote.death && !daNote.bob)
												{
													goodNoteHit(daNote);
													boyfriend.holdTimer = daNote.sustainLength;
													playerStrums.forEach(function(spr:FlxSprite)
													{
														if (Math.abs(daNote.noteData) == spr.ID)
														{
															spr.animation.play('confirm', true);
														}
														if (spr.animation.curAnim.name == 'confirm' && SONG.noteStyle != 'pixel')
														{
															spr.centerOffsets();
															switch(maniaToChange)
															{
																case 0: 
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 1: 
																	spr.offset.x -= 16;
																	spr.offset.y -= 16;
																case 2: 
																	spr.offset.x -= 22;
																	spr.offset.y -= 22;
																case 3: 
																	spr.offset.x -= 15;
																	spr.offset.y -= 15;
																case 4: 
																	spr.offset.x -= 18;
																	spr.offset.y -= 18;
																case 5: 
																	spr.offset.x -= 20;
																	spr.offset.y -= 20;
																case 6: 
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 7: 
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 8:
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 10: 
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 11: 
																	spr.offset.x -= 16;
																	spr.offset.y -= 16;
																case 12: 
																	spr.offset.x -= 22;
																	spr.offset.y -= 22;
																case 13: 
																	spr.offset.x -= 15;
																	spr.offset.y -= 15;
																case 14: 
																	spr.offset.x -= 18;
																	spr.offset.y -= 18;
																case 15: 
																	spr.offset.x -= 20;
																	spr.offset.y -= 20;
																case 16: 
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 17: 
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
																case 18:
																	spr.offset.x -= 13;
																	spr.offset.y -= 13;
															}
														}
														else
															spr.centerOffsets();
													});
												}
											}
											
									}
							}
								
					
				});
				
			}

		if (FlxG.save.data.cpuStrums)
		{
			cpuStrums.forEach(function(spr:FlxSprite)
			{
				if (spr.animation.finished)
				{
					spr.animation.play('static');
					spr.centerOffsets();
				}
			});
			if (PlayStateChangeables.botPlay)
				{
					playerStrums.forEach(function(spr:FlxSprite)
						{
							if (spr.animation.finished)
							{
								spr.animation.play('static');
								spr.centerOffsets();
							}
						});
				}
		}

		var botplayPress = FlxG.keys.justPressed.TWO;
		var fullscreenPress = FlxG.keys.justPressed.THREE; //not even used

		if (!inCutscene && songStarted)
			keyShit();


	//	#if debug
	if (FlxG.keys.justPressed.F1) //YESSSSSS
		{
				endSong();
		}

		if (FlxG.keys.justPressed.F2) 
		{
			if (!PlayStateChangeables.botPlay) {
				PlayStateChangeables.botPlay = true;
				keyBotplay = true;
			}
			else {
				PlayStateChangeables.botPlay = false;
				keyBotplay = false;
			}
		}

		if (FlxG.keys.justPressed.F3)
		{
			if (!FlxG.fullscreen)
				FlxG.fullscreen = true;
			else
				FlxG.fullscreen = false;
		}
	//	#end
	}

	var endingSong:Bool = false;

	var hits:Array<Float> = [];
	var offsetTest:Float = 0;

	var timeShown = 0;
	var currentTimingShown:FlxText = null;

	private function popUpScore(daNote:Note = null):Void
		{
			var noteDiff:Float = -(daNote.strumTime - Conductor.songPosition);
			var wife:Float = EtternaFunctions.wife3(-noteDiff, Conductor.timeScale);
			// boyfriend.playAnim('hey');
			vocals.volume = 1;
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
			coolText.y -= 350;
			coolText.cameras = [camHUD];
			//
	
			var rating:FlxSprite = new FlxSprite();
			var score:Float = 350;

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit += wife;

			var daRating = daNote.rating;

			switch(daRating)
			{
				case 'shit':
					if (daNote.noteType == 9) //snow notes
						{
							MaxHealth -= 1;
							FlxG.sound.play(Paths.sound('thunder_2'));
						}
					else if (daNote.noteType == 10) //halo notes
						{
							health -= 2;
							FlxG.sound.play(Paths.sound('death', 'clown'));
						}
					else if (daNote.noteType == 8) //warning note
						{
			//				FlxG.sound.play(Paths.sound('shooters', 'shared'), 0.6);
						}
					else if (daNote.noteType == 11) //fire note
						{
							health = 0.1; // now this will get some peeps.
							FlxG.sound.play(Paths.sound('thunder_2'));
						}
					score = -300;
					combo = 0;
					misses++;
					if (!FlxG.save.data.gthm)
						health -= 0.2;
					ss = false;
					if (!practiceMode)
						shits++;
					if (FlxG.save.data.accuracyMod == 0 && !practiceMode)
						totalNotesHit -= 1;
				case 'bad':
					if (daNote.noteType == 9) //snow notes
						{
							MaxHealth -= 1;
							FlxG.sound.play(Paths.sound('thunder_2'));
						}
					else if (daNote.noteType == 10) //halo notes
						{
							health -= 2;
							FlxG.sound.play(Paths.sound('death', 'clown'));
						}
					else if (daNote.noteType == 8) //warning note
						{
				//			FlxG.sound.play(Paths.sound('shooters', 'shared'), 0.6);
						}
					else if (daNote.noteType == 11) //fire note
						{
							health = 0.1; // now this will get some peeps.
							FlxG.sound.play(Paths.sound('thunder_2'));
						}
					daRating = 'bad';
					score = 0;
					if (!FlxG.save.data.gthm)
						health -= 0.06;
					ss = false;
					if (!practiceMode)
						bads++;
					if (FlxG.save.data.accuracyMod == 0 && !practiceMode)
						totalNotesHit += 0.50;
				case 'good':
					if (daNote.noteType == 9) //snow notes
						{
							MaxHealth -= 1;
							FlxG.sound.play(Paths.sound('thunder_2'));
						}
					else if (daNote.noteType == 10) //halo notes
						{
							health -= 2;
							FlxG.sound.play(Paths.sound('death', 'clown'));
						}
					else if (daNote.noteType == 8) //warning note
						{
			//				FlxG.sound.play(Paths.sound('shooters', 'shared'), 0.6);
						}
					else if (daNote.noteType == 11) //fire note
						{
							health = 0.1; // now this will get some peeps.
							FlxG.sound.play(Paths.sound('thunder_2'));
						}
					daRating = 'good';
					score = 200;
					ss = false;
					if (!practiceMode)
						goods++;
					if (health < 2)
						health += 0.04;
					if (FlxG.save.data.accuracyMod == 0 && !practiceMode)
						totalNotesHit += 0.75;
				case 'sick':
					if (daNote.noteType == 9) //snow notes
						{
							MaxHealth -= 1;
							FlxG.sound.play(Paths.sound('thunder_2'));
						}
					else if (daNote.noteType == 10) //halo notes
						{
							health -= 2;
							FlxG.sound.play(Paths.sound('death', 'clown'));
						}
					else if (daNote.noteType == 8) //warning note
						{
				//			FlxG.sound.play(Paths.sound('shooters', 'shared'), 0.6);
						}
					else if (daNote.noteType == 11) //fire note
						{
							health = 0.1; // now this will get some peeps.
							FlxG.sound.play(Paths.sound('thunder_2'));
						}
					if (health < 2)
						health += 0.1;
					if (FlxG.save.data.accuracyMod == 0 && !practiceMode)
						totalNotesHit += 1;
					if (!practiceMode)
						sicks++;
			}

			// trace('Wife accuracy loss: ' + wife + ' | Rating: ' + daRating + ' | Score: ' + score + ' | Weight: ' + (1 - wife));

			if (daRating != 'shit' || daRating != 'bad')
				{
	
		if (!practiceMode) {
			songScore += Math.round(score);
			songScoreDef += Math.round(ConvertScore.convertScore(noteDiff));
		}
	
			/* if (combo > 60)
					daRating = 'sick';
				else if (combo > 12)
					daRating = 'good'
				else if (combo > 4)
					daRating = 'bad';
			 */
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
			rating.screenCenter();
			rating.y -= 50;
			rating.x = coolText.x - 125;
			
			if (FlxG.save.data.changedHit)
			{
				rating.x = FlxG.save.data.changedHitX;
				rating.y = FlxG.save.data.changedHitY;
			}
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
			
			var msTiming = HelperFunctions.truncateFloat(noteDiff, 3);
			if(PlayStateChangeables.botPlay && !loadRep) msTiming = 0;		
			
			if (loadRep)
				msTiming = HelperFunctions.truncateFloat(findByTime(daNote.strumTime)[3], 3);

			if (currentTimingShown != null)
				remove(currentTimingShown);

			currentTimingShown = new FlxText(0,0,0,"0ms");
			timeShown = 0;
			switch(daRating)
			{
				case 'shit' | 'bad':
					currentTimingShown.color = FlxColor.RED;
				case 'good':
					currentTimingShown.color = FlxColor.GREEN;
				case 'sick':
					currentTimingShown.color = FlxColor.CYAN;
			}
			currentTimingShown.borderStyle = OUTLINE;
			currentTimingShown.borderSize = 1;
			currentTimingShown.borderColor = FlxColor.BLACK;
			currentTimingShown.text = msTiming + "ms";
			currentTimingShown.size = 20;

			if (msTiming >= 0.03 && offsetTesting)
			{
				//Remove Outliers
				hits.shift();
				hits.shift();
				hits.shift();
				hits.pop();
				hits.pop();
				hits.pop();
				hits.push(msTiming);

				var total = 0.0;

				for(i in hits)
					total += i;
				

				
				offsetTest = HelperFunctions.truncateFloat(total / hits.length,2);
			}

			if (currentTimingShown.alpha != 1)
				currentTimingShown.alpha = 1;

			if(!PlayStateChangeables.botPlay || loadRep) add(currentTimingShown);
			
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
			comboSpr.screenCenter();
			comboSpr.x = rating.x;
			comboSpr.y = rating.y + 100;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			currentTimingShown.screenCenter();
			currentTimingShown.x = comboSpr.x + 100;
			currentTimingShown.y = rating.y + 100;
			currentTimingShown.acceleration.y = 600;
			currentTimingShown.velocity.y -= 150;
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			currentTimingShown.velocity.x += comboSpr.velocity.x;
			if(!PlayStateChangeables.botPlay || loadRep) add(rating);
	
			if (!curStage.startsWith('school'))
			{
				rating.setGraphicSize(Std.int(rating.width * 0.7));
				rating.antialiasing = FlxG.save.data.antialiasing;
				comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
				comboSpr.antialiasing = FlxG.save.data.antialiasing;
			}
			else
			{
				rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
				comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
			}
	
			currentTimingShown.updateHitbox();
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			currentTimingShown.cameras = [camHUD];
			comboSpr.cameras = [camHUD];
			rating.cameras = [camHUD];

			var seperatedScore:Array<Int> = [];
	
			var comboSplit:Array<String> = (combo + "").split('');

			if (combo > highestCombo)
				highestCombo = combo;

			// make sure we have 3 digits to display (looks weird otherwise lol)
			if (comboSplit.length == 1)
			{
				seperatedScore.push(0);
				seperatedScore.push(0);
			}
			else if (comboSplit.length == 2)
				seperatedScore.push(0);

			for(i in 0...comboSplit.length)
			{
				var str:String = comboSplit[i];
				seperatedScore.push(Std.parseInt(str));
			}
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
				numScore.screenCenter();
				numScore.x = rating.x + (43 * daLoop) - 50;
				numScore.y = rating.y + 100;
				numScore.cameras = [camHUD];

				if (!curStage.startsWith('school'))
				{
					numScore.antialiasing = FlxG.save.data.antialiasing;
					numScore.setGraphicSize(Std.int(numScore.width * 0.5));
				}
				else
				{
					numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
				}
				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				add(numScore);

				visibleCombos.push(numScore);

				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						visibleCombos.remove(numScore);
						numScore.destroy();
					},
					onUpdate: function (tween:FlxTween)
					{
						if (!visibleCombos.contains(numScore))
						{
							tween.cancel();
							numScore.destroy();
						}
					},
					startDelay: Conductor.crochet * 0.002
				});

				if (visibleCombos.length > seperatedScore.length + 20)
				{
					for(i in 0...seperatedScore.length - 1)
					{
						visibleCombos.remove(visibleCombos[visibleCombos.length - 1]);
					}
				}
	
				daLoop++;
			}
			/* 
				trace(combo);
				trace(seperatedScore);
			 */
	
			coolText.text = Std.string(seperatedScore);
			// add(coolText);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001,
				onUpdate: function(tween:FlxTween)
				{
					if (currentTimingShown != null)
						currentTimingShown.alpha -= 0.02;
					timeShown++;
				}
			});

			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
					if (currentTimingShown != null && timeShown >= 20)
					{
						remove(currentTimingShown);
						currentTimingShown = null;
					}
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
			}
		}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
		{
			return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
		}

		var upHold:Bool = false;
		var downHold:Bool = false;
		var rightHold:Bool = false;
		var leftHold:Bool = false;
		var l1Hold:Bool = false;
		var uHold:Bool = false;
		var r1Hold:Bool = false;
		var l2Hold:Bool = false;
		var dHold:Bool = false;
		var r2Hold:Bool = false;
	
		var n0Hold:Bool = false;
		var n1Hold:Bool = false;
		var n2Hold:Bool = false;
		var n3Hold:Bool = false;
		var n4Hold:Bool = false;
		var n5Hold:Bool = false;
		var n6Hold:Bool = false;
		var n7Hold:Bool = false;
		var n8Hold:Bool = false;
		// THIS FUNCTION JUST FUCKS WIT HELD NOTES AND BOTPLAY/REPLAY (also gamepad shit)

		private function keyShit():Void // I've invested in emma stocks
			{
				// control arrays, order L D R U
				switch(maniaToChange)
				{
					case 0: 
						//hold = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
						press = [
							controls.LEFT_P,
							controls.DOWN_P,
							controls.UP_P,
							controls.RIGHT_P
						];
						release = [
							controls.LEFT_R,
							controls.DOWN_R,
							controls.UP_R,
							controls.RIGHT_R
						];
					case 1: 
						//hold = [controls.L1, controls.U1, controls.R1, controls.L2, controls.D1, controls.R2];
						press = [
							controls.L1_P,
							controls.U1_P,
							controls.R1_P,
							controls.L2_P,
							controls.D1_P,
							controls.R2_P
						];
						release = [
							controls.L1_R,
							controls.U1_R,
							controls.R1_R,
							controls.L2_R,
							controls.D1_R,
							controls.R2_R
						];
					case 2: 
						//hold = [controls.N0, controls.N1, controls.N2, controls.N3, controls.N4, controls.N5, controls.N6, controls.N7, controls.N8];
						press = [
							controls.N0_P,
							controls.N1_P,
							controls.N2_P,
							controls.N3_P,
							controls.N4_P,
							controls.N5_P,
							controls.N6_P,
							controls.N7_P,
							controls.N8_P
						];
						release = [
							controls.N0_R,
							controls.N1_R,
							controls.N2_R,
							controls.N3_R,
							controls.N4_R,
							controls.N5_R,
							controls.N6_R,
							controls.N7_R,
							controls.N8_R
						];
					case 3: 
						//hold = [controls.LEFT, controls.DOWN, controls.N4, controls.UP, controls.RIGHT];
						press = [
							controls.LEFT_P,
							controls.DOWN_P,
							controls.N4_P,
							controls.UP_P,
							controls.RIGHT_P
						];
						release = [
							controls.LEFT_R,
							controls.DOWN_R,
							controls.N4_R,
							controls.UP_R,
							controls.RIGHT_R
						];
					case 4: 
						//hold = [controls.L1, controls.U1, controls.R1, controls.N4, controls.L2, controls.D1, controls.R2];
						press = [
							controls.L1_P,
							controls.U1_P,
							controls.R1_P,
							controls.N4_P,
							controls.L2_P,
							controls.D1_P,
							controls.R2_P
						];
						release = [
							controls.L1_R,
							controls.U1_R,
							controls.R1_R,
							controls.N4_R,
							controls.L2_R,
							controls.D1_R,
							controls.R2_R
						];
					case 5: 
						//hold = [controls.N0, controls.N1, controls.N2, controls.N3, controls.N5, controls.N6, controls.N7, controls.N8];
						press = [
							controls.N0_P,
							controls.N1_P,
							controls.N2_P,
							controls.N3_P,
							controls.N5_P,
							controls.N6_P,
							controls.N7_P,
							controls.N8_P
						];
						release = [
							controls.N0_R,
							controls.N1_R,
							controls.N2_R,
							controls.N3_R,
							controls.N5_R,
							controls.N6_R,
							controls.N7_R,
							controls.N8_R
						];
					case 6: 
						//hold = [controls.N4];
						press = [
							controls.N4_P
						];
						release = [
							controls.N4_R
						];
					case 7: 
					//	hold = [controls.LEFT, controls.RIGHT];
						press = [
							controls.LEFT_P,
							controls.RIGHT_P
						];
						release = [
							controls.LEFT_R,
							controls.RIGHT_R
						];
					case 8: 
						//hold = [controls.LEFT, controls.N4, controls.RIGHT];
						press = [
							controls.LEFT_P,
							controls.N4_P,
							controls.RIGHT_P
						];
						release = [
							controls.LEFT_R,
							controls.N4_R,
							controls.RIGHT_R
						];
					case 10: //changing mid song (mania + 10, seemed like the best way to make it change without creating more switch statements)
						press = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P,false,false,false,false,false];
						release = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R,false,false,false,false,false];
					case 11: 
						press = [controls.L1_P, controls.D1_P, controls.U1_P, controls.R1_P, false, controls.L2_P, false, false, controls.R2_P];
						release = [controls.L1_R, controls.D1_R, controls.U1_R, controls.R1_R, false, controls.L2_R, false, false, controls.R2_R];
					case 12: 
						press = [controls.N0_P, controls.N1_P, controls.N2_P, controls.N3_P, controls.N4_P, controls.N5_P, controls.N6_P, controls.N7_P, controls.N8_P];
						release = [controls.N0_R, controls.N1_R, controls.N2_R, controls.N3_R, controls.N4_R, controls.N5_R, controls.N6_R, controls.N7_R, controls.N8_R];
					case 13: 
						press = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P, controls.N4_P,false,false,false,false];
						release = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R, controls.N4_R,false,false,false,false];
					case 14: 
						press = [controls.L1_P, controls.D1_P, controls.U1_P, controls.R1_P, controls.N4_P, controls.L2_P, false, false, controls.R2_P];
						release = [controls.L1_R, controls.D1_R, controls.U1_R, controls.R1_R, controls.N4_R, controls.L2_R, false, false, controls.R2_R];
					case 15:
						press = [controls.N0_P, controls.N1_P, controls.N2_P, controls.N3_P, false, controls.N5_P, controls.N6_P, controls.N7_P, controls.N8_P];
						release = [controls.N0_R, controls.N1_R, controls.N2_R, controls.N3_R, false, controls.N5_R, controls.N6_R, controls.N7_R, controls.N8_R];
					case 16: 
						press = [false, false, false, false, controls.N4_P, false, false, false, false];
						release = [false, false, false, false, controls.N4, false, false, false, false];
					case 17: 
						press = [controls.LEFT_P, false, false, controls.RIGHT_P, false, false, false, false, false];
						release = [controls.LEFT_R, false, false, controls.RIGHT_R, false, false, false, false, false];
					case 18: 
						press = [controls.LEFT_P, false, false, controls.RIGHT_P, controls.N4_P, false, false, false, false];
						release = [controls.LEFT_R, false, false, controls.RIGHT_R, controls.N4_R, false, false, false, false];
				}
				var holdArray:Array<Bool> = hold;
				var pressArray:Array<Bool> = press;
				var releaseArray:Array<Bool> = release;
				
				#if windows
				if (luaModchart != null)
				{
					for (i in 0...pressArray.length) {
						if (pressArray[i] == true) {
						luaModchart.executeState('keyPressed', [sDir[i].toLowerCase()]);
						}
					};
					
					for (i in 0...releaseArray.length) {
						if (releaseArray[i] == true) {
						luaModchart.executeState('keyReleased', [sDir[i].toLowerCase()]);
						}
					};
					
				};
				#end
				
		 
				
				// Prevent player input if botplay is on
				if(PlayStateChangeables.botPlay)
				{
					if (keyBotplay) {
					holdArray = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
					pressArray = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
					releaseArray = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];
					}
				} 

				var anas:Array<Ana> = [null,null,null,null];
				switch(mania)
				{
					case 0: 
						anas = [null,null,null,null];
					case 1: 
						anas = [null,null,null,null,null,null];
					case 2: 
						anas = [null,null,null,null,null,null,null,null,null];
					case 3: 
						anas = [null,null,null,null,null];
					case 4: 
						anas = [null,null,null,null,null,null,null];
					case 5: 
						anas = [null,null,null,null,null,null,null,null];
					case 6: 
						anas = [null];
					case 7: 
						anas = [null,null];
					case 8: 
						anas = [null,null,null];
				}

				for (i in 0...pressArray.length)// {
					if (pressArray[i])
						anas[i] = new Ana(Conductor.songPosition, null, false, "miss", i);
				//}

				// HOLDS, check for sustain notes
				if (holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData])
							goodNoteHit(daNote);
					});
				} //gt hero input shit, using old code because i can
				if (controls.GTSTRUM)
				{
					if (pressArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic && FlxG.save.data.gthm || holdArray.contains(true) && /*!boyfriend.stunned && */ generatedMusic && FlxG.save.data.gthm)
						{
							var possibleNotes:Array<Note> = [];

							var ignoreList:Array<Int> = [];
				
							notes.forEachAlive(function(daNote:Note)
							{
								if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote)
								{
									possibleNotes.push(daNote);
									possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
				
									ignoreList.push(daNote.noteData);
								}
				
							});
				
							if (possibleNotes.length > 0)
							{
								var daNote = possibleNotes[0];
				
								// Jump notes
								if (possibleNotes.length >= 2)
								{
									if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
									{
										for (coolNote in possibleNotes)
										{
											if (pressArray[coolNote.noteData] || holdArray[coolNote.noteData])
												goodNoteHit(coolNote);
											else
											{
												var inIgnoreList:Bool = false;
												for (shit in 0...ignoreList.length)
												{
													if (holdArray[ignoreList[shit]] || pressArray[ignoreList[shit]])
														inIgnoreList = true;
												}
												if (!inIgnoreList && !FlxG.save.data.ghost)
													noteMiss(1, null);
											}
										}
									}
									else if (possibleNotes[0].noteData == possibleNotes[1].noteData)
									{
										if (pressArray[daNote.noteData] || holdArray[daNote.noteData])
											goodNoteHit(daNote);
									}
									else
									{
										for (coolNote in possibleNotes)
										{
											if (pressArray[coolNote.noteData] || holdArray[coolNote.noteData])
												goodNoteHit(coolNote);
										}
									}
								}
								else // regular notes?
								{
									if (pressArray[daNote.noteData] || holdArray[daNote.noteData])
										goodNoteHit(daNote);
								}
							}
						}

					}
		 
				if (KeyBinds.gamepad && !FlxG.keys.justPressed.ANY)
				{
					// PRESSES, check for note hits
					if (pressArray.contains(true) && generatedMusic)
					{
						boyfriend.holdTimer = 0;
			
						var possibleNotes:Array<Note> = []; // notes that can be hit
						var directionList:Array<Int> = []; // directions that can be hit
						var dumbNotes:Array<Note> = []; // notes to kill later
						var directionsAccounted:Array<Bool> = [false,false,false,false]; // we don't want to do judgments for more than one presses
						
						switch(mania)
						{
							case 0: 
								directionsAccounted = [false, false, false, false];
							case 1: 
								directionsAccounted = [false, false, false, false, false, false];
							case 2: 
								directionsAccounted = [false, false, false, false, false, false, false, false, false];
							case 3: 
								directionsAccounted = [false, false, false, false, false];
							case 4: 
								directionsAccounted = [false, false, false, false, false, false, false];
							case 5: 
								directionsAccounted = [false, false, false, false, false, false, false, false];
							case 6: 
								directionsAccounted = [false];
							case 7: 
								directionsAccounted = [false, false];
							case 8: 
								directionsAccounted = [false, false, false];
						}
						

						notes.forEachAlive(function(daNote:Note)
							{
								if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !directionsAccounted[daNote.noteData])
								{
									if (directionList.contains(daNote.noteData))
										{
											directionsAccounted[daNote.noteData] = true;
											for (coolNote in possibleNotes)
											{
												if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
												{ // if it's the same note twice at < 10ms distance, just delete it
													// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
													dumbNotes.push(daNote);
													break;
												}
												else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime)
												{ // if daNote is earlier than existing note (coolNote), replace
													possibleNotes.remove(coolNote);
													possibleNotes.push(daNote);
													break;
												}
											}
										}
										else
										{
											directionsAccounted[daNote.noteData] = true;
											possibleNotes.push(daNote);
											directionList.push(daNote.noteData);
										}
								}
						});

						for (note in dumbNotes)
						{
							FlxG.log.add("killing dumb ass note at " + note.strumTime);
							note.kill();
							notes.remove(note, true);
							note.destroy();
						}
			
						possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
						var hit = [false,false,false,false,false,false,false,false,false];
						switch(mania)
						{
							case 0: 
								hit = [false, false, false, false];
							case 1: 
								hit = [false, false, false, false, false, false];
							case 2: 
								hit = [false, false, false, false, false, false, false, false, false];
							case 3: 
								hit = [false, false, false, false, false];
							case 4: 
								hit = [false, false, false, false, false, false, false];
							case 5: 
								hit = [false, false, false, false, false, false, false, false];
							case 6: 
								hit = [false];
							case 7: 
								hit = [false, false];
							case 8: 
								hit = [false, false, false];
						}
						if (perfectMode)
							goodNoteHit(possibleNotes[0]);
						else if (possibleNotes.length > 0)
						{
							if (!FlxG.save.data.ghost)
								{
									for (i in 0...pressArray.length)
										{ // if a direction is hit that shouldn't be
											if (pressArray[i] && !directionList.contains(i))
												noteMiss(i, null);
										}
								}
							if (FlxG.save.data.gthm)
							{
	
							}
							else
							{
								for (coolNote in possibleNotes)
									{
										if (pressArray[coolNote.noteData] && !hit[coolNote.noteData])
										{
											if (mashViolations != 0)
												mashViolations--;
											hit[coolNote.noteData] = true;
											scoreTxt.color = FlxColor.WHITE;
											var noteDiff:Float = -(coolNote.strumTime - Conductor.songPosition);
											anas[coolNote.noteData].hit = true;
											anas[coolNote.noteData].hitJudge = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));
											anas[coolNote.noteData].nearestNote = [coolNote.strumTime,coolNote.noteData,coolNote.sustainLength];
											goodNoteHit(coolNote);
										}
									}
							}
							
						};
						if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || PlayStateChangeables.botPlay))
							{
							//	if (keyBotplay)
								if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss') && (boyfriend.animation.curAnim.curFrame >= 10 || boyfriend.animation.curAnim.finished))
									boyfriend.dance();
							}
						else if (!FlxG.save.data.ghost)
							{
								for (shit in 0...keyAmmo[mania])
									if (pressArray[shit])
										noteMiss(shit, null);
							}
					}

					if (!loadRep)
						for (i in anas)
							if (i != null)
								replayAna.anaArray.push(i); // put em all there
				}
					
				
				if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && (!holdArray.contains(true) || PlayStateChangeables.botPlay))
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
						boyfriend.dance();
				}
		 
				if (!PlayStateChangeables.botPlay)
				{
				//	if ()
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (keys[spr.ID] && spr.animation.curAnim.name != 'confirm' && spr.animation.curAnim.name != 'pressed')
							spr.animation.play('pressed', false);
						if (!keys[spr.ID])
							spr.animation.play('static', false);
			
						if (spr.animation.curAnim.name == 'confirm' && !curStage.startsWith('school'))
						{
							spr.centerOffsets();
							switch(maniaToChange)
							{
								case 0: 
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 1: 
									spr.offset.x -= 16;
									spr.offset.y -= 16;
								case 2: 
									spr.offset.x -= 22;
									spr.offset.y -= 22;
								case 3: 
									spr.offset.x -= 15;
									spr.offset.y -= 15;
								case 4: 
									spr.offset.x -= 18;
									spr.offset.y -= 18;
								case 5: 
									spr.offset.x -= 20;
									spr.offset.y -= 20;
								case 6: 
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 7: 
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 8:
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 10: 
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 11: 
									spr.offset.x -= 16;
									spr.offset.y -= 16;
								case 12: 
									spr.offset.x -= 22;
									spr.offset.y -= 22;
								case 13: 
									spr.offset.x -= 15;
									spr.offset.y -= 15;
								case 14: 
									spr.offset.x -= 18;
									spr.offset.y -= 18;
								case 15: 
									spr.offset.x -= 20;
									spr.offset.y -= 20;
								case 16: 
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 17: 
									spr.offset.x -= 13;
									spr.offset.y -= 13;
								case 18:
									spr.offset.x -= 13;
									spr.offset.y -= 13;
							}
						}
						else
							spr.centerOffsets();
					});
				}

				//Dodge code only works on termination and Tutorial -Haz
			if(SONG.song.toLowerCase()=='termination' || SONG.song.toLowerCase()=='tutorial'|| SONG.song.toLowerCase()=='censory-overload')
			{
				//Dodge code, yes it's bad but oh well. -Haz
				//var dodgeButton = controls.ACCEPT; //I have no idea how to add custom controls so fuck it. -Haz
	
			if (SONG.song.toLowerCase()=='censory-overload')
			{
				if(FlxG.keys.justPressed.SPACE)
					trace('buttton pressed');
	
				if(FlxG.keys.justPressed.SPACE && !bfDodging && bfCanDodge && !FlxG.save.data.botplay){
					trace('DODGE START!');
					bfDodging = true;
					bfCanDodge = false;
					trace('you spaced, so imma dodge');
	
					if(qtIsBlueScreened)
						boyfriend404.playAnim('dodge');
					else
						boyfriend.playAnim('dodge');
	
					FlxG.sound.play(Paths.sound('dodge01', 'qt'));
	
					//Wait,) set bfDodging back to false. -Haz
					//V1.2 - Timer lasts a bit longer (by 0.00225)
				//	new FlxTimer().start(0.22625, function(tmr:FlxTimer) 		//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
					//new FlxTimer().start(0.15, function(tmr:FlxTimer)			//UNCOMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
					new FlxTimer().start(bfDodgeTiming, function(tmr:FlxTimer) 	//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
					{
						bfDodging = false;
						boyfriend.dance(); //V1.3 = This forces the animation to end when you are no longer safe as the animation keeps misleading people.
						trace('DODGE END!');
						//Cooldown timer so you can't keep spamming it.
						//V1.3 = Incremented this by a little (0.005)
						//new FlxTimer().start(0.1135, function(tmr:FlxTimer) 	//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
						//new FlxTimer().start(0.1, function(tmr:FlxTimer) 		//UNCOMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
						new FlxTimer().start(bfDodgeCooldown, function(tmr:FlxTimer) 	//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
						{
							bfCanDodge=true;
							trace('DODGE RECHARGED!');
						});
					});
			}
			else
			{
						if(FlxG.keys.justPressed.SPACE)
							trace('butttonpressed');
			
						if(FlxG.keys.justPressed.SPACE && !bfDodging && bfCanDodge)
						{
							trace('DODGE START!');
							bfDodging = true;
							bfCanDodge = false;
			
							if(qtIsBlueScreened)
								boyfriend404.playAnim('dodge');
							else
								boyfriend.playAnim('dodge');
			
							FlxG.sound.play(Paths.sound('dodge01'));
			
							//Wait, then set bfDodging back to false. -Haz
							//V1.2 - Timer lasts a bit longer (by 0.00225)
							//new FlxTimer().start(0.22625, function(tmr:FlxTimer) 		//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
							new FlxTimer().start(0.15, function(tmr:FlxTimer)			//UNCOMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
							{
								bfDodging=false;
								boyfriend.dance(); //V1.3 = This forces the animation to end when you are no longer safe as the animation keeps misleading people.
								trace('DODGE END!');
								new FlxTimer().start(0.1, function(tmr:FlxTimer) 		//UNCOMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
								{
									bfCanDodge=true;
									trace('DODGE RECHARGED!');
								});
							});
						}
					}
				}
			}
		}

			function BotBfDodge(random:Bool = false):Void //it errors if no paramter?
			//function BOT_KBATTACK(state:Bool = false, soundToPlay:String = 'attack'):Void
			{
					trace('BOT DODGE START!');
					bfDodging = true;
					bfCanDodge = false;
					trace('you spaced, so imma dodge');
	
					if(qtIsBlueScreened)
						boyfriend404.playAnim('dodge');
					else
						boyfriend.playAnim('dodge');
	
					FlxG.sound.play(Paths.sound('dodge01', 'qt'));

					trace(random);
	
					//Wait, then set bfDodging back to false. -Haz
					//V1.2 - Timer lasts a bit longer (by 0.00225)
					new FlxTimer().start(0.22625, function(tmr:FlxTimer) 		//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
					//new FlxTimer().start(0.15, function(tmr:FlxTimer)			//UNCOMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
			//		new FlxTimer().start(bfDodgeTiming, function(tmr:FlxTimer) 	//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
					{
						bfDodging = false;
						boyfriend.dance(); //V1.3 = This forces the animation to end when you are no longer safe as the animation keeps misleading people.
						trace('DODGE END!');
						//Cooldown timer so you can't keep spamming it.
						//V1.3 = Incremented this by a little (0.005)
						//new FlxTimer().start(0.1135, function(tmr:FlxTimer) 	//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
						//new FlxTimer().start(0.1, function(tmr:FlxTimer) 		//UNCOMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
						new FlxTimer().start(bfDodgeCooldown, function(tmr:FlxTimer) 	//COMMENT THIS IF YOU WANT TO USE DOUBLE SAW VARIATIONS!
						{
							bfCanDodge=true;
							trace('DODGE RECHARGED!');
						});
					});
			}

		//	 BotBfDodge();

			public function findByTime(time:Float):Array<Dynamic>
				{
					for (i in rep.replay.songNotes)
					{
						//trace('checking ' + Math.round(i[0]) + ' against ' + Math.round(time));
						if (i[0] == time)
							return i;
					}
					return null;
				}

			public function findByTimeIndex(time:Float):Int
				{
					for (i in 0...rep.replay.songNotes.length)
					{
						//trace('checking ' + Math.round(i[0]) + ' against ' + Math.round(time));
						if (rep.replay.songNotes[i][0] == time)
							return i;
					}
					return -1;
				}

			public var fuckingVolume:Float = 1;
			public var useVideo = false;

			public static var webmHandler:WebmHandler;

			public var playingDathing = false;

			public var videoSprite:FlxSprite;

			public function focusOut() {
				if (paused)
					return;
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;
		
					if (FlxG.sound.music != null)
					{
						FlxG.sound.music.pause();
						vocals.pause();
					}
		
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			}
			public function focusIn() 
			{ 
				// nada 
			}


			public function backgroundVideo(source:String) // for background videos
				{
					#if cpp
					useVideo = true;
			
					FlxG.stage.window.onFocusOut.add(focusOut);
					FlxG.stage.window.onFocusIn.add(focusIn);

					var ourSource:String = "assets/videos/daWeirdVid/dontDelete.webm";
					//WebmPlayer.SKIP_STEP_LIMIT = 90;
					var str1:String = "WEBM SHIT"; 
					webmHandler = new WebmHandler();
					webmHandler.source(ourSource);
					webmHandler.makePlayer();
					webmHandler.webm.name = str1;
			
					GlobalVideo.setWebm(webmHandler);

					GlobalVideo.get().source(source);
					GlobalVideo.get().clearPause();
					if (GlobalVideo.isWebm)
					{
						GlobalVideo.get().updatePlayer();
					}
					GlobalVideo.get().show();
			
					if (GlobalVideo.isWebm)
					{
						GlobalVideo.get().restart();
					} else {
						GlobalVideo.get().play();
					}
					
					var data = webmHandler.webm.bitmapData;
			
					videoSprite = new FlxSprite(-470,-30).loadGraphic(data);
			
					videoSprite.setGraphicSize(Std.int(videoSprite.width * 1.2));
			
					remove(gf);
					remove(boyfriend);
					remove(dad);
					add(videoSprite);
					add(gf);
					add(boyfriend);
					add(dad);
			
					trace('poggers');
			
					if (!songStarted)
						webmHandler.pause();
					else
						webmHandler.resume();
					#end
				}

				var songNameLow = PlayState.SONG.song.toLowerCase();

	function noteMiss(direction:Int = 1, daNote:Note):Void
	{
		if (!boyfriend.stunned)
		{
			if (songNameLow=='terminate' || songNameLow=='cessation' || songNameLow=='censory-overload'){
				//health -= 0.0625;
				health -= 0.0675;
			}
			else if(songNameLow=="power-link"){
				health -= 0.65; //THAT'S ALOTA DAMAGE²
			}else if(songNameLow=='termination'){
				health -= 0.16725; //THAT'S ALOTA DAMAGE
			}else if(songNameLow=='final-destination'){
				health -= 0.23952; //HAVE EVEN MORE FUN??
			}else{
				health -= 0.05;
			}
			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			misses++;

			if (daNote != null)
			{
				if (!loadRep)
				{
					saveNotes.push([daNote.strumTime,0,direction,166 * Math.floor((PlayState.rep.replay.sf / 60) * 1000) / 166]);
					saveJudge.push("miss");
				}
			}
			else
				if (!loadRep)
				{
					saveNotes.push([Conductor.songPosition,0,direction,166 * Math.floor((PlayState.rep.replay.sf / 60) * 1000) / 166]);
					saveJudge.push("miss");
				}

			//var noteDiff:Float = Math.abs(daNote.strumTime - Conductor.songPosition);
			//var wife:Float = EtternaFunctions.wife3(noteDiff, FlxG.save.data.etternaMode ? 1 : 1.7);

			if (FlxG.save.data.accuracyMod == 1)
				totalNotesHit -= 1;

			songScore -= 10;

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');
			if (isbf)
				boyfriend.playAnim('sing' + missDir[direction], true);

			#if windows
			if (luaModchart != null)
				luaModchart.executeState('playerOneMiss', [direction, Conductor.songPosition]);
			#end

			if (!practiceMode)
				updateAccuracy();
		}
	}

	/*function badNoteCheck()
		{
			// just double pasting this shit cuz fuk u
			// REDO THIS SYSTEM!
			var upP = controls.UP_P;
			var rightP = controls.RIGHT_P;
			var downP = controls.DOWN_P;
			var leftP = controls.LEFT_P;
	
			if (leftP)
				noteMiss(0);
			if (upP)
				noteMiss(2);
			if (rightP)
				noteMiss(3);
			if (downP)
				noteMiss(1);
			updateAccuracy();
		}
	*/
	function updateAccuracy() 
		{
			totalPlayed += 1;
			accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
			accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		}


	function getKeyPresses(note:Note):Int
	{
		var possibleNotes:Array<Note> = []; // copypasted but you already know that

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress)
			{
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1)
			return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	
	var mashing:Int = 0;
	var mashViolations:Int = 0;

	var etternaModeScore:Int = 0;

	function noteCheck(controlArray:Array<Bool>, note:Note):Void // sorry lol
		{
			var noteDiff:Float = -(note.strumTime - Conductor.songPosition);

			note.rating = Ratings.CalculateRating(noteDiff, Math.floor((PlayStateChangeables.safeFrames / 60) * 1000));

			/* if (loadRep)
			{
				if (controlArray[note.noteData])
					goodNoteHit(note, false);
				else if (rep.replay.keyPresses.length > repPresses && !controlArray[note.noteData])
				{
					if (NearlyEquals(note.strumTime,rep.replay.keyPresses[repPresses].time, 4))
					{
						goodNoteHit(note, false);
					}
				}
			} */
			
			if (controlArray[note.noteData])
			{
				goodNoteHit(note, (mashing > getKeyPresses(note)));
				
				/*if (mashing > getKeyPresses(note) && mashViolations <= 2)
				{
					mashViolations++;

					goodNoteHit(note, (mashing > getKeyPresses(note)));
				}
				else if (mashViolations > 2)
				{
					// this is bad but fuck you
					playerStrums.members[0].animation.play('static');
					playerStrums.members[1].animation.play('static');
					playerStrums.members[2].animation.play('static');
					playerStrums.members[3].animation.play('static');
					health -= 0.4;
					trace('mash ' + mashing);
					if (mashing != 0)
						mashing = 0;
				}
				else
					goodNoteHit(note, false);*/

			}
		}

		function goodNoteHit(note:Note, resetMashViolation = true):Void
			{

				if (mashing != 0)
					mashing = 0;

				var noteDiff:Float = -(note.strumTime - Conductor.songPosition);

				if(loadRep)
				{
					noteDiff = findByTime(note.strumTime)[3];
					note.rating = rep.replay.songJudgements[findByTimeIndex(note.strumTime)];
				}
				else
					note.rating = Ratings.CalculateRating(noteDiff);

				if (note.rating == "miss")
					return;	


				// add newest note to front of notesHitArray
				// the oldest notes are at the end and are removed first
				if (!note.isSustainNote)
					notesHitArray.unshift(Date.now());

				if (!resetMashViolation && mashViolations >= 1)
					mashViolations--;

				if (mashViolations < 0)
					mashViolations = 0;

				if (!note.wasGoodHit)
				{
					if (!note.isSustainNote)
					{
						popUpScore(note);
						combo += 1;
					}
					else
						totalNotesHit += 1;
	
					var altAnim:String = "";

					if (currentSection != null)
						{
							if (currentSection.altAnim)
								altAnim = '-alt';
						}	
					if (note.alt)
						altAnim = '-alt';

					if (!PlayStateChangeables.bothSide)
					{
						if (isbf)
						{
							if (boyfriend.curCharacter == 'bfWhitty')
								boyfriend.playAnim('sing' + bfsDir[note.noteData] + altAnim, true);
							else
								boyfriend.playAnim('sing' + sDir[note.noteData] + altAnim, true);
							boyfriend.holdTimer = 0;
						}
						if (isbf404)
						{
							boyfriend404.playAnim('sing' + sDir[note.noteData] + altAnim, true);
							boyfriend404.holdTimer = 0;
						}
					}
					else if (note.noteData <= 3)
					{
						if (isbf)
						{
							boyfriend.playAnim('sing' + sDir[note.noteData] + altAnim, true);
							boyfriend.holdTimer = 0;
						}
						if (isbf404)
						{
							boyfriend404.playAnim('sing' + sDir[note.noteData] + altAnim, true);
							boyfriend404.holdTimer = 0;
						}
					}
					else
					{
						if (isdad) 
						{
							dad.playAnim('sing' + sDir[note.noteData] + altAnim, true);
							dad.holdTimer = 0;
						}
					}



		
					#if windows
					if (luaModchart != null)
						luaModchart.executeState('playerOneSing', [note.noteData, Conductor.songPosition]);
					#end

					if (note.burning) //fire note
						{
							badNoteHit();
							health -= 0.45;
						}

					else if (note.death) //halo note
						{
							badNoteHit();
							health -= 2.2;
						}
					else if (note.angel) //angel note
						{
							switch(note.rating)
							{
								case "shit": 
									badNoteHit();
									health -= 2;
								case "bad": 
									badNoteHit();
									health -= 0.5;
								case "good": 
									health += 0.5;
								case "sick": 
									health += 1;

							}
						}
					else if (note.bob) //bob note
						{
							HealthDrain();
						}


					if(!loadRep && note.mustPress)
					{
						var array = [note.strumTime,note.sustainLength,note.noteData,noteDiff];
						if (note.isSustainNote)
							array[1] = -1;
						saveNotes.push(array);
						saveJudge.push(note.rating);
					}
					
					playerStrums.forEach(function(spr:FlxSprite)
					{
						if (Math.abs(note.noteData) == spr.ID)
						{
							spr.animation.play('confirm', true);
						}
					});
					
		
					if (!note.isSustainNote)
						{
							if (note.rating == "sick")
								doNoteSplash(note.x, note.y, note.noteData);

							note.kill();
							notes.remove(note, true);
							note.destroy();

						}
						else
						{
							note.wasGoodHit = true;
						}
					if (!practiceMode)
					updateAccuracy();

					if (FlxG.save.data.gracetmr)
						{
							grace = true;
							new FlxTimer().start(0.15, function(tmr:FlxTimer)
							{
								grace = false;
							});
						}
					
				}
			}
		

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if(FlxG.save.data.distractions){
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if(FlxG.save.data.distractions){
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

			fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}

	function doNoteSplash(noteX:Float, noteY:Float, nData:Int)
		{
			var recycledNote = noteSplashes.recycle(NoteSplash);
			recycledNote.makeSplash(playerStrums.members[nData].x, playerStrums.members[nData].y, nData);
			noteSplashes.add(recycledNote);
			
		}

	function HealthDrain():Void //code from vs bob
		{
			badNoteHit();
			new FlxTimer().start(0.01, function(tmr:FlxTimer)
			{
				health -= 0.005;
			}, 300);
		}

	function badNoteHit():Void
		{
			boyfriend.playAnim('hit', true);
			FlxG.sound.play(Paths.soundRandom('badnoise', 1, 3), FlxG.random.float(0.7, 1));
		}

	var justChangedMania:Bool = false;

	public function switchMania(newMania:Int) //i know this is pretty big, but how else am i gonna do this shit
	{
		if (mania == 2) //so it doesnt break the fucking game
		{
			maniaToChange = newMania;
			justChangedMania = true;
			new FlxTimer().start(10, function(tmr:FlxTimer)
				{
					justChangedMania = false; //cooldown timer
				});
			switch(newMania)
			{
				case 10: 
					Note.newNoteScale = 0.7; //fix the note scales pog
				case 11: 
					Note.newNoteScale = 0.6;
				case 12: 
					Note.newNoteScale = 0.5;
				case 13: 
					Note.newNoteScale = 0.65;
				case 14: 
					Note.newNoteScale = 0.58;
				case 15: 
					Note.newNoteScale = 0.55;
				case 16: 
					Note.newNoteScale = 0.7;
				case 17: 
					Note.newNoteScale = 0.7;
				case 18: 
					Note.newNoteScale = 0.7;
			}
	
			strumLineNotes.forEach(function(spr:FlxSprite)
				{
					FlxTween.tween(spr, {alpha: 0}, 0.5, {
						onComplete: function(tween:FlxTween)
						{
							spr.animation.play('static'); //changes to static because it can break the scaling of the static arrows if they are doing the confirm animation
							spr.setGraphicSize(Std.int((spr.width / Note.prevNoteScale) * Note.newNoteScale));
							spr.centerOffsets();
							Note.scaleSwitch = false;
						}
					});
				});
	
			new FlxTimer().start(0.6, function(tmr:FlxTimer)
				{
					cpuStrums.forEach(function(spr:FlxSprite)
						{
							moveKeyPositions(spr, newMania, 0);
						});
					playerStrums.forEach(function(spr:FlxSprite)
						{
							moveKeyPositions(spr, newMania, 1);
						});
				});
	
		}
	}

	public function moveKeyPositions(spr:FlxSprite, newMania:Int, player:Int):Void //some complex calculations and shit here
	{
		spr.x = 0;
		spr.alpha = 1;
		switch(newMania) //messy piece of shit, i wish there was an easier way to do this, but it has to be done i guess
		{
			case 10: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (160 * 0.7) * 0;
					case 1: 
						spr.x += (160 * 0.7) * 1;
					case 2: 
						spr.x += (160 * 0.7) * 2;
					case 3: 
						spr.x += (160 * 0.7) * 3;
					case 4: 
						spr.alpha = 0;
					case 5: 
						spr.alpha = 0;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.alpha = 0;
				}
			case 11: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (120 * 0.7) * 0;
					case 1: 
						spr.x += (120 * 0.7) * 4;
					case 2: 
						spr.x += (120 * 0.7) * 1;
					case 3: 
						spr.x += (120 * 0.7) * 2;
					case 4: 
						spr.alpha = 0;
					case 5: 
						spr.x += (120 * 0.7) * 3;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.x += (120 * 0.7) * 5;
				}
			case 12: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (95 * 0.7) * 0;
					case 1: 
						spr.x += (95 * 0.7) * 1;
					case 2: 
						spr.x += (95 * 0.7) * 2;
					case 3: 
						spr.x += (95 * 0.7) * 3;
					case 4: 
						spr.x += (95 * 0.7) * 4;
					case 5: 
						spr.x += (95 * 0.7) * 5;
					case 6: 
						spr.x += (95 * 0.7) * 6;
					case 7: 
						spr.x += (95 * 0.7) * 7;
					case 8:
						spr.x += (95 * 0.7) * 8;
				}
				spr.x -= Note.tooMuch;
			case 13: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (130 * 0.7) * 0;
					case 1: 
						spr.x += (130 * 0.7) * 1;
					case 2: 
						spr.x += (130 * 0.7) * 3;
					case 3: 
						spr.x += (130 * 0.7) * 4;
					case 4: 
						spr.x += (130 * 0.7) * 2;
					case 5: 
						spr.alpha = 0;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.alpha = 0;
				}
			case 14: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (110 * 0.7) * 0;
					case 1: 
						spr.x += (110 * 0.7) * 5;
					case 2: 
						spr.x += (110 * 0.7) * 1;
					case 3: 
						spr.x += (110 * 0.7) * 2;
					case 4: 
						spr.x += (110 * 0.7) * 3;
					case 5: 
						spr.x += (110 * 0.7) * 4;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.x += (110 * 0.7) * 6;
				}
			case 15: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (100 * 0.7) * 0;
					case 1: 
						spr.x += (100 * 0.7) * 1;
					case 2: 
						spr.x += (100 * 0.7) * 2;
					case 3: 
						spr.x += (100 * 0.7) * 3;
					case 4: 
						spr.alpha = 0;
					case 5: 
						spr.x += (100 * 0.7) * 4;
					case 6: 
						spr.x += (100 * 0.7) * 5;
					case 7: 
						spr.x += (100 * 0.7) * 6;
					case 8:
						spr.x += (100 * 0.7) * 7;
				}
			case 16: 
				switch(spr.ID)
				{
					case 0: 
						spr.alpha = 0;
					case 1: 
						spr.alpha = 0;
					case 2: 
						spr.alpha = 0;
					case 3: 
						spr.alpha = 0;
					case 4: 
						spr.x += (160 * 0.7) * 0;
					case 5: 
						spr.alpha = 0;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.alpha = 0;
				}
			case 17: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (160 * 0.7) * 0;
					case 1: 
						spr.alpha = 0;
					case 2: 
						spr.alpha = 0;
					case 3: 
						spr.x += (160 * 0.7) * 1;
					case 4: 
						spr.alpha = 0;
					case 5: 
						spr.alpha = 0;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.alpha = 0;
				}
			case 18: 
				switch(spr.ID)
				{
					case 0: 
						spr.x += (160 * 0.7) * 0;
					case 1: 
						spr.alpha = 0;
					case 2: 
						spr.alpha = 0;
					case 3: 
						spr.x += (160 * 0.7) * 2;
					case 4: 
						spr.x += (160 * 0.7) * 1;
					case 5: 
						spr.alpha = 0;
					case 6: 
						spr.alpha = 0;
					case 7: 
						spr.alpha = 0;
					case 8:
						spr.alpha = 0;
				}
		}
		spr.x += 50;
		spr.x += ((FlxG.width / 2) * player);
	}
	

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		if(FlxG.save.data.distractions){
			trainMoving = true;
			if (!trainSound.playing)
				trainSound.play(true);
		}
	}

	function terminateBlueScreen():Void
	{
		canPause = false; //useless cause it just is
		strumLineNotes.visible = false;
		notes.visible = false;
		healthBar.visible = false;
		healthBarBG.visible = false;
		iconP1.visible = false;
		iconP2.visible = false;
		scoreTxt.visible = false;
		replayTxt.visible = false;
		songPosBG.visible = false;
		songPosBar.visible = false;
	//	doof.visible = false;
		noteSplashes.visible = false;
		overhealthBar.visible = false; //this took too goddamn long
		terminateError.visible = true;
	}

	/*
	noteSplashes.cameras = [camNotes];
		overhealthBar.cameras = [camHUD];
		doof.cameras = [camHUD];
		if (FlxG.save.data.songPosition)
		{
			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
		}
		kadeEngineWatermark.cameras = [camHUD];
		if (loadRep)
			replayTxt.cameras = [camHUD];
			terminateError.cameras = [camHUD];
	*/

	function hexErrorSwitch(before:Bool = true):Void // a better way of doing it
	{
		if(before)
		{
			hexError.visible = true;
			canPause = false; //useless cause it just is
			strumLineNotes.visible = false;
			notes.visible = false;
			healthBar.visible = false;
			healthBarBG.visible = false;
			iconP1.visible = false;
			iconP2.visible = false;
			scoreTxt.visible = false;
			replayTxt.visible = false;
			songPosBG.visible = false;
			songPosBar.visible = false;
			//doof.visible = false;
			noteSplashes.visible = false;
			overhealthBar.visible = false; //this took too goddamn long

			kadeEngineWatermark.visible = false;
		}
		else {
		hexError.visible = false;
		canPause = true; // you can now pause
		strumLineNotes.visible = true;
		notes.visible = true;
		healthBar.visible = true;
		healthBarBG.visible = true;
		iconP1.visible = true;
		iconP2.visible = true;
		scoreTxt.visible = true;
		replayTxt.visible = true;
		songPosBG.visible = true;
		songPosBar.visible = true;
	//	doof.visible = true;
		noteSplashes.visible = true;
		overhealthBar.visible = true; //this took too goddamn long
		kadeEngineWatermark.visible = true;
		}
	}

	public function dodgeTimingOverride(newValue:Float = 0.22625):Void
		{
			bfDodgeTiming = newValue;
		}
	
		public  function dodgeCooldownOverride(newValue:Float = 0.1135):Void
		{
			bfDodgeCooldown = newValue;
		}	
	
		public function KBATTACK_TOGGLE(shouldAdd:Bool = true):Void
		{
			if(shouldAdd)
				add(kb_attack_saw);
			else
				remove(kb_attack_saw);
		}
	
		public function KBALERT_TOGGLE(shouldAdd:Bool = true):Void
		{
			if(shouldAdd)
				add(kb_attack_alert);
			else
				remove(kb_attack_alert);
		}
	
		//False state = Prime!
		//True state = Attack!
		function KBATTACK_FAKE(state:Bool = false, soundToPlay:String = 'attack'):Void
			{
				if(!(SONG.song.toLowerCase() == "termination" || SONG.song.toLowerCase() == "final-destination" || SONG.song.toLowerCase() == "terminate" || SONG.song.toLowerCase() == "censory-overload")){
					trace("Sawblade Attack Error, cannot use Termination functions outside Termination or Tutorial.");
				}
			if (!FlxG.save.data.cheatsV2) {
				trace("HE ATACC!");
				if(state){
					FlxG.sound.play(Paths.sound(soundToPlay,'qt'),0.75);
					//Play saw attack animation
					kb_attack_saw.animation.play('fire');
					kb_attack_saw.offset.set(1600,0);
		
					/*kb_attack_saw.animation.finishCallback = function(pog:String){
						if(state) //I don't get it.
							remove(kb_attack_saw);
					}*/
		
					//Slight delay for animation. Yeah I know I should be doing this using curStep and curBeat and what not, but I'm lazy -Haz
					new FlxTimer().start(0.09, function(tmr:FlxTimer)
					{
						if(!bfDodging){
							//MURDER THE BITCH!
							deathBySawBlade = true;
							health -= 0;
						}
					});
				}else{
					kb_attack_saw.animation.play('prepare');
					kb_attack_saw.offset.set(-333,0);
				}
			}
				else {
					trace('god mode saved you, disable it for a real experience');
					if(state){
						FlxG.sound.play(Paths.sound(soundToPlay,'qt'),0.75);
						//Play saw attack animation
						kb_attack_saw.animation.play('fire');
						kb_attack_saw.offset.set(1600,0);
			
						/*kb_attack_saw.animation.finishCallback = function(pog:String){
							if(state) //I don't get it.
								remove(kb_attack_saw);
						}*/
			
						//Slight delay for animation. Yeah I know I should be doing this using curStep and curBeat and what not, but I'm lazy -Haz
						new FlxTimer().start(0.09, function(tmr:FlxTimer)
						{
							if(!bfDodging){
								//MURDER THE BITCH!
								deathBySawBlade = false;
								health -= 0;
							}
						});
					}else{
						kb_attack_saw.animation.play('prepare');
						kb_attack_saw.offset.set(-333,0);
					}
					trace('still showed the blade tho, heh heh');
				}
			}
	
		public function KBATTACK(state:Bool = false, soundToPlay:String = 'attack'):Void
		{
				if (!FlxG.save.data.noSaw) {
			if(!(SONG.song.toLowerCase() == "termination" || SONG.song.toLowerCase() == "final-destination" || SONG.song.toLowerCase() == "censory-overload")){
				trace("Sawblade Attack Error, cannot use Termination functions outside Termination or Tutorial.");
			}
			trace("HE ATACC!");
			if(state){
				FlxG.sound.play(Paths.sound(soundToPlay,'qt'),0.75);
				//Play saw attack animation
				kb_attack_saw.animation.play('fire');
				kb_attack_saw.offset.set(1600,0);
	
				/*kb_attack_saw.animation.finishCallback = function(pog:String){
					if(state) //I don't get it.
						remove(kb_attack_saw);
				}*/
	
				//Slight delay for animation. Yeah I know I should be doing this using curStep and curBeat and what not, but I'm lazy -Haz
				new FlxTimer().start(0.09, function(tmr:FlxTimer)
				{
					if(!bfDodging){
						//MURDER THE BITCH!
						deathBySawBlade = true;
						health -= 404;
					}
				});
			}else{
				kb_attack_saw.animation.play('prepare');
				kb_attack_saw.offset.set(-333,0);
			}
			}
		}

		/* //copy and paste shit
			if (FlxG.save.data.botplay) {
				BotBfDodge();
				BOT_KBATTACK();
			}
			else
				KBATTACK();

		*/

		function BOT_KBATTACK(state:Bool = false, soundToPlay:String = 'attack'):Void
			{
				trace("HE ATACC!");
				if(state){
					FlxG.sound.play(Paths.sound(soundToPlay,'qt'),0.75);
					//Play saw attack animation
					kb_attack_saw.animation.play('fire');
					kb_attack_saw.offset.set(1600,0);
		
					/*kb_attack_saw.animation.finishCallback = function(pog:String){
						if(state) //I don't get it.
							remove(kb_attack_saw);
					}*/
		
					//Slight delay for animation. Yeah I know I should be doing this using curStep and curBeat and what not, but I'm lazy -Haz
					new FlxTimer().start(0.09, function(tmr:FlxTimer)
					{
						if(!bfDodging){
							//MURDER THE BITCH!
						//	deathBySawBlade = true;
						//	health -= 404;
						}
					});
				}else{
					kb_attack_saw.animation.play('prepare');
					kb_attack_saw.offset.set(-333,0);
				}
		//	}
	/*			else {
					trace('god mode saved you, disable it for a real experience');
					if(state){
						FlxG.sound.play(Paths.sound(soundToPlay,'qt'),0.75);
						//Play saw attack animation
						kb_attack_saw.animation.play('fire');
						kb_attack_saw.offset.set(1600,0);
			
						/*kb_attack_saw.animation.finishCallback = function(pog:String){
							if(state) //I don't get it.
								remove(kb_attack_saw);
						}
			
						//Slight delay for animation. Yeah I know I should be doing this using curStep and curBeat and what not, but I'm lazy -Haz
						new FlxTimer().start(0.09, function(tmr:FlxTimer)
						{
							if(!bfDodging){
								//MURDER THE BITCH!
								deathBySawBlade = true;
								health -= 0;
							}
						});
					}else{
						kb_attack_saw.animation.play('prepare');
						kb_attack_saw.offset.set(-333,0);
					}
					trace('still showed the blade tho, heh heh');
				}*/
			}

		public function KBATTACK_ALERT(pointless:Bool = false):Void //For some reason, modchart doesn't like functions with no parameter? why? dunno.
		{
			if (!FlxG.save.data.noSaw) {
			if(!(SONG.song == 'Termination' || SONG.song.toLowerCase() == "tutorial" || SONG.song.toLowerCase() == "terminate" || SONG.song.toLowerCase() == "censory-overload")){
				trace("Sawblade Alert Error, cannot use Termination functions outside Termination or Tutorial.");
			}
			trace("DANGER!");
			kb_attack_alert.animation.play('alert');
			FlxG.sound.play(Paths.sound('alert','qt'), 1);
		}
		}
	
		//OLD ATTACK DOUBLE VARIATION
		public function KBATTACK_ALERTDOUBLE(pointless:Bool = false):Void
		{
			if (!FlxG.save.data.noSaw) {
			if(!(SONG.song == 'Termination' || SONG.song.toLowerCase() == "tutorial" || SONG.song.toLowerCase() == "terminate" || SONG.song.toLowerCase() == "censory-overload")){
				trace("Sawblade AlertDOUBLE Error, cannot use Termination functions outside Termination or Tutorial.");
			}
			trace("DANGER DOUBLE INCOMING!!");
			kb_attack_alert.animation.play('alertDOUBLE');
			FlxG.sound.play(Paths.sound('old/alertALT','qt'), 1);
			}
		}
	
		//Pincer logic, used by the modchart but can be hardcoded like saws if you want.
		public function KBPINCER_PREPARE(laneID:Int,goAway:Bool):Void
		{
			if(!(SONG.song.toLowerCase() == "termination" || SONG.song.toLowerCase() == "tutorial" || SONG.song.toLowerCase() == "censory-overload")){
				trace("Pincer Error, cannot use Termination functions outside Termination or Tutorial.");
			}
			else{
				//1 = BF far left, 4 = BF far right. This only works for BF!
				//Update! 5 now refers to the far left lane. Mainly used for the shaking section or whatever.
				pincer1.cameras = [camHUD];
				pincer2.cameras = [camHUD];
				pincer3.cameras = [camHUD];
				pincer4.cameras = [camHUD];
	
				//This is probably the most disgusting code I've ever written in my life.
				//All because I can't be bothered to learn arrays and shit.
				//Would've converted this to a switch case but I'm too scared to change it so deal with it.
				if(laneID==1){
					pincer1.loadGraphic(Paths.image('bonus/pincer-open','qt'), false);
					if(FlxG.save.data.downscroll){
						if(!goAway){
							pincer1.setPosition(strumLineNotes.members[4].x,strumLineNotes.members[4].y+500);
							add(pincer1);
							FlxTween.tween(pincer1, {y : strumLineNotes.members[4].y}, 0.3, {ease: FlxEase.elasticOut});
						}else{
							FlxTween.tween(pincer1, {y : strumLineNotes.members[4].y+500}, 0.4, {ease: FlxEase.bounceIn, onComplete: function(twn:FlxTween){remove(pincer1);}});
						}
					}else{
						if(!goAway){
							pincer1.setPosition(strumLineNotes.members[4].x,strumLineNotes.members[4].y-500);
							add(pincer1);
							FlxTween.tween(pincer1, {y : strumLineNotes.members[4].y}, 0.3, {ease: FlxEase.elasticOut});
						}else{
							FlxTween.tween(pincer1, {y : strumLineNotes.members[4].y-500}, 0.4, {ease: FlxEase.bounceIn, onComplete: function(twn:FlxTween){remove(pincer1);}});
						}
					}
				}
				else if(laneID==5){ //Targets far left note for Dad (KB). Used for the screenshake thing
					pincer1.loadGraphic(Paths.image('bonus/pincer-open','qt'), false);
					if(FlxG.save.data.downscroll){
						if(!goAway){
							pincer1.setPosition(strumLineNotes.members[0].x,strumLineNotes.members[0].y+500);
							add(pincer1);
							FlxTween.tween(pincer1, {y : strumLineNotes.members[0].y}, 0.3, {ease: FlxEase.elasticOut});
						}else{
							FlxTween.tween(pincer1, {y : strumLineNotes.members[0].y+500}, 0.4, {ease: FlxEase.bounceIn, onComplete: function(twn:FlxTween){remove(pincer1);}});
						}
					}else{
						if(!goAway){
							pincer1.setPosition(strumLineNotes.members[0].x,strumLineNotes.members[5].y-500);
							add(pincer1);
							FlxTween.tween(pincer1, {y : strumLineNotes.members[0].y}, 0.3, {ease: FlxEase.elasticOut});
						}else{
							FlxTween.tween(pincer1, {y : strumLineNotes.members[0].y-500}, 0.4, {ease: FlxEase.bounceIn, onComplete: function(twn:FlxTween){remove(pincer1);}});
						}
					}
				}
				else if(laneID==2){
					pincer2.loadGraphic(Paths.image('bonus/pincer-open','qt'), false);
					if(FlxG.save.data.downscroll){
						if(!goAway){
							pincer2.setPosition(strumLineNotes.members[5].x,strumLineNotes.members[5].y+500);
							add(pincer2);
							FlxTween.tween(pincer2, {y : strumLineNotes.members[5].y}, 0.3, {ease: FlxEase.elasticOut});
						}else{
							FlxTween.tween(pincer2, {y : strumLineNotes.members[5].y+500}, 0.4, {ease: FlxEase.bounceIn, onComplete: function(twn:FlxTween){remove(pincer2);}});
						}
					}else{
						if(!goAway){
							pincer2.setPosition(strumLineNotes.members[5].x,strumLineNotes.members[5].y-500);
							add(pincer2);
							FlxTween.tween(pincer2, {y : strumLineNotes.members[5].y}, 0.3, {ease: FlxEase.elasticOut});
						}else{
							FlxTween.tween(pincer2, {y : strumLineNotes.members[5].y-500}, 0.4, {ease: FlxEase.bounceIn, onComplete: function(twn:FlxTween){remove(pincer2);}});
						}
					}
				}
				else if(laneID==3){
					pincer3.loadGraphic(Paths.image('bonus/pincer-open','qt'), false);
					if(FlxG.save.data.downscroll){
						if(!goAway){
							pincer3.setPosition(strumLineNotes.members[6].x,strumLineNotes.members[6].y+500);
							add(pincer3);
							FlxTween.tween(pincer3, {y : strumLineNotes.members[6].y}, 0.3, {ease: FlxEase.elasticOut});
						}else{
							FlxTween.tween(pincer3, {y : strumLineNotes.members[6].y+500}, 0.4, {ease: FlxEase.bounceIn, onComplete: function(twn:FlxTween){remove(pincer3);}});
						}
					}else{
						if(!goAway){
							pincer3.setPosition(strumLineNotes.members[6].x,strumLineNotes.members[6].y-500);
							add(pincer3);
							FlxTween.tween(pincer3, {y : strumLineNotes.members[6].y}, 0.3, {ease: FlxEase.elasticOut});
						}else{
							FlxTween.tween(pincer3, {y : strumLineNotes.members[6].y-500}, 0.4, {ease: FlxEase.bounceIn, onComplete: function(twn:FlxTween){remove(pincer3);}});
						}
					}
				}
				else if(laneID==4){
					pincer4.loadGraphic(Paths.image('bonus/pincer-open','qt'), false);
					if(FlxG.save.data.downscroll){
						if(!goAway){
							pincer4.setPosition(strumLineNotes.members[7].x,strumLineNotes.members[7].y+500);
							add(pincer4);
							FlxTween.tween(pincer4, {y : strumLineNotes.members[7].y}, 0.3, {ease: FlxEase.elasticOut});
						}else{
							FlxTween.tween(pincer4, {y : strumLineNotes.members[7].y+500}, 0.4, {ease: FlxEase.bounceIn, onComplete: function(twn:FlxTween){remove(pincer4);}});
						}
					}else{
						if(!goAway){
							pincer4.setPosition(strumLineNotes.members[7].x,strumLineNotes.members[7].y-500);
							add(pincer4);
							FlxTween.tween(pincer4, {y : strumLineNotes.members[7].y}, 0.3, {ease: FlxEase.elasticOut});
						}else{
							FlxTween.tween(pincer4, {y : strumLineNotes.members[7].y-500}, 0.4, {ease: FlxEase.bounceIn, onComplete: function(twn:FlxTween){remove(pincer4);}});
						}
					}
				}else
					trace("Invalid LaneID for pincer");
			}
		}
		public function KBPINCER_GRAB(laneID:Int):Void
		{
			if(!(SONG.song == 'Termination' || SONG.song.toLowerCase() == "tutorial")){
				trace("PincerGRAB Error, cannot use Termination functions outside Termination or Tutorial.");
			}
			else{
				switch(laneID)
				{
					case 1 | 5:
						pincer1.loadGraphic(Paths.image('bonus/pincer-close','qt'), false);
					case 2:
						pincer2.loadGraphic(Paths.image('bonus/pincer-close','qt'), false);
					case 3:
						pincer3.loadGraphic(Paths.image('bonus/pincer-close','qt'), false);
					case 4:
						pincer4.loadGraphic(Paths.image('bonus/pincer-close','qt'), false);
					default:
						trace("Invalid LaneID for pincerGRAB");
				}
			}
		}

	
		function endScreenHazard():Void //For displaying the "thank you for playing" screen on Cessation
		{
			var black:FlxSprite = new FlxSprite(-300, -100).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
			black.scrollFactor.set();
	
			var screen:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('bonus/FinalScreen'));
			screen.setGraphicSize(Std.int(screen.width * 0.625));
			screen.antialiasing = true;
			screen.scrollFactor.set();
			screen.screenCenter();
	
			var hasTriggeredAlready:Bool = false;
	
			screen.alpha = 0;
			black.alpha = 0;
			
			add(black);
			add(screen);
	
			//Fade in code stolen from schoolIntro() >:3
			new FlxTimer().start(0.15, function(swagTimer:FlxTimer)
			{
				black.alpha += 0.075;
				if (black.alpha < 1)
				{
					swagTimer.reset();
				}
				else
				{
					screen.alpha += 0.075;
					if (screen.alpha < 1)
					{
						swagTimer.reset();
					}
	
					canSkipEndScreen = true;
					//Wait 12 seconds, then do shit -Haz
					new FlxTimer().start(12, function(tmr:FlxTimer)
					{
						if(!hasTriggeredAlready){
							hasTriggeredAlready = true;
							loadSongHazard();
						}
					});
				}
			});		
		}

		var spookyText:FlxText;
		var spookyRendered:Bool = false;
		var spookySteps:Int = 0;

		function loadSongHazard():Void //Used for Careless, Termination, and Cessation when they end -Haz
			{
				canSkipEndScreen = false;
		
				//Very disgusting but it works... kinda
				if (SONG.song.toLowerCase() == 'cessation')
				{
					trace('Switching to MainMenu. Thanks for playing.');
					FlxG.sound.playMusic(Paths.music('thanks'));
					FlxG.switchState(new MainMenuState());
					Conductor.changeBPM(102); //lmao, this code doesn't even do anything useful! (aaaaaaaaaaaaaaaaaaaaaa)
				}	
				else if (SONG.song.toLowerCase() == 'terminate')
				{
					FlxG.log.notice("Back to the menu you go!!!");
		
					FlxG.sound.playMusic(Paths.music("nexus_qt","qt"), 0);
		
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
		
					FlxG.switchState(new MainMenuState());
		
					StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;
		
					if (SONG.validScore)
					{
						NGio.unlockMedal(60961);
						Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
					}
		
					if(storyDifficulty == 2) //You can only unlock Termination after beating story week on hard.
						FlxG.save.data.terminationUnlocked = true; //Congratulations, you unlocked hell! Have fun! ~♥
		
		
					FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;	
					FlxG.save.flush();
				}
				else
				{
				var difficulty:String = "";
				if (storyDifficulty == 0)
					difficulty = '-easy';
		
				if (storyDifficulty == 1)
					difficulty = '-hard';
		
				if (storyDifficulty == 2)
					difficulty = '-unfair';	
				
				trace('LOADING NEXT SONG');
				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);
				FlxG.log.notice(PlayState.storyPlaylist[0].toLowerCase() + difficulty);
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;
		
				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
				
				LoadingState.loadAndSwitchState(new PlayState());
				}
			}

		function terminationEndEarly():Void //Yep, terminate was originally called termination while termination was going to have a different name. Can't be bothered to update some names though like this so sorry for any confusion -Haz
			{
				if(!qtCarelessFinCalled){
					qt_tv01.animation.play("error");
					canPause = false;
					inCutscene = true;
					paused = true;
					camZooming = false;
					qtCarelessFin = true;
					qtCarelessFinCalled = true; //Variable to prevent constantly repeating this code.
					FlxG.save.data.terminateWon = true;
					//Slight delay... -Haz
					new FlxTimer().start(3, function(tmr:FlxTimer)
					{
						camHUD.visible = false;
						//FlxG.sound.music.pause();
						//vocals.pause();
						var doof = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('terminate/terminateDialogueEND')));
						doof.scrollFactor.set();
						doof.finishThing = loadSongHazard;
						schoolIntro(doof);
					});
				}
			}

		function createSpookyText(text:String, x:Float = -1111111111111, y:Float = -1111111111111):Void
			{
				spookySteps = curStep;
				spookyRendered = true;
				tstatic.alpha = 0.5;
				FlxG.sound.play(Paths.sound('staticSound','clown'));
				spookyText = new FlxText((x == -1111111111111 ? FlxG.random.float(dad.x + 40,dad.x + 120) : x), (y == -1111111111111 ? FlxG.random.float(dad.y + 200, dad.y + 300) : y));
				spookyText.setFormat("Impact", 128, FlxColor.RED);
				if (curStage == 'nevedaSpook')
				{
					spookyText.size = 200;
					spookyText.x += 250;
				}
				spookyText.bold = true;
				spookyText.text = text;
				add(spookyText);
			}

			var resetSpookyText:Bool = true;

	function resetSpookyTextManual():Void
	{
		trace('reset spooky');
		spookySteps = curStep;
		spookyRendered = true;
		tstatic.alpha = 0.5;
		FlxG.sound.play(Paths.sound('staticSound','clown'));
		resetSpookyText = true;
	}

	function manuallymanuallyresetspookytextmanual()
	{
		remove(spookyText);
		spookyRendered = false;
		tstatic.alpha = 0;
	}

		function killNotes(daNote:Note):Void //dumbest/easiet function ever
		{
			daNote.kill();
			notes.remove(daNote, true);
			daNote.destroy();
		}

		// killNotes();

		function trickySecondCutscene():Void // why is this a second method? idk cry about it loL!!!!
			{
				var done:Bool = false;
	
				trace('starting cutscene');
	
				var black:FlxSprite = new FlxSprite(-300, -120).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.WHITE);
				black.scrollFactor.set();
				black.alpha = 0;
				
				var animation:FlxSprite = new FlxSprite(200,300); // create the fuckin thing
	
				animation.frames = Paths.getSparrowAtlas('trickman','clown'); // add animation from sparrow
				animation.antialiasing = true;
				animation.animation.addByPrefix('cut1','Cutscene 1', 24, false);
				animation.animation.addByPrefix('cut2','Cutscene 2', 24, false);
				animation.animation.addByPrefix('cut3','Cutscene 3', 24, false);
				animation.animation.addByPrefix('cut4','Cutscene 4', 24, false);
				animation.animation.addByPrefix('pillar','Pillar Beam Tricky', 24, false);
				
				animation.setGraphicSize(Std.int(animation.width * 1.5));
	
				animation.alpha = 0;
	
				camFollow.setPosition(dad.getMidpoint().x + 300, boyfriend.getMidpoint().y - 200);
	
				inCutscene = true;
				startedCountdown = false;
				generatedMusic = false;
				canPause = false;
	
				FlxG.sound.music.volume = 0;
				vocals.volume = 0;
	
				var sounders:FlxSound = new FlxSound().loadEmbedded(Paths.sound('honkers','clown'));
				var energy:FlxSound = new FlxSound().loadEmbedded(Paths.sound('energy shot','clown'));
				var roar:FlxSound = new FlxSound().loadEmbedded(Paths.sound('sound_clown_roar','clown'));
				var pillar:FlxSound = new FlxSound().loadEmbedded(Paths.sound('firepillar','clown'));
	
				var fade:FlxSprite = new FlxSprite(-300, -120).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.fromRGB(19, 0, 0));
				fade.scrollFactor.set();
				fade.alpha = 0;
	
				var textFadeOut:FlxText = new FlxText(300,FlxG.height * 0.5,0,"TO BE CONTINUED");
				textFadeOut.setFormat("Impact", 128, FlxColor.RED);
	
				textFadeOut.alpha = 0;
	
				add(animation);
	
				add(black);
	
				add(textFadeOut);
	
				add(fade);
	
				var startFading:Bool = false;
				var varNumbaTwo:Bool = false;
				var fadeDone:Bool = false;
	
				sounders.fadeIn(30);
	
				new FlxTimer().start(0.01, function(tmr:FlxTimer)
					{
						if (fade.alpha != 1 && !varNumbaTwo)
						{
							camHUD.alpha -= 0.1;
							fade.alpha += 0.1;
							if (fade.alpha == 1)
							{
								// THIS IS WHERE WE LOAD SHIT UN-NOTICED
								varNumbaTwo = true;
	
								animation.alpha = 1;
								
								dad.alpha = 0;
							}
							tmr.reset(0.1);
						}
						else
						{
							fade.alpha -= 0.1;
							if (fade.alpha <= 0.5)
								fadeDone = true;
							tmr.reset(0.1);
						}
					});
	
				var roarPlayed:Bool = false;
	
				new FlxTimer().start(0.01, function(tmr:FlxTimer)
				{
					if (!fadeDone)
						tmr.reset(0.1)
					else
					{
						if (animation.animation == null || animation.animation.name == null)
						{
							trace('playin cut cuz its funny lol!!!');
							animation.animation.play("cut1");
							resetSpookyText = false;
							createSpookyText(cutsceneText[1], 260, FlxG.height * 0.9);
						}
	
						if (!animation.animation.finished)
						{
							tmr.reset(0.1);
							trace(animation.animation.name + ' - FI ' + animation.animation.frameIndex);
	
							switch(animation.animation.frameIndex)
							{
								case 104:
									if (animation.animation.name == 'cut1')
										resetSpookyTextManual();
							}
	
							if (animation.animation.name == 'pillar')
							{
								if (animation.animation.frameIndex >= 85) // why is this not in the switch case above? idk cry about it
									startFading = true;
								FlxG.camera.shake(0.05);
							}
						}
						else
						{
							trace('completed ' + animation.animation.name);
							resetSpookyTextManual();
							switch(animation.animation.name)
							{
								case 'cut1':
									animation.animation.play('cut2');
								case 'cut2':
									animation.animation.play('cut3');
									energy.play();
								case 'cut3':
									animation.animation.play('cut4');
									resetSpookyText = false;
									createSpookyText(cutsceneText[2], 260, FlxG.height * 0.9);
									animation.x -= 100;
								case 'cut4':
									resetSpookyTextManual();
									sounders.fadeOut();
									pillar.fadeIn(4);
									animation.animation.play('pillar');
									animation.y -= 670;
									animation.x -= 100;
							}
							tmr.reset(0.1);
						}
	
						if (startFading)
						{
							sounders.fadeOut();
							trace('do the fade out and the text');
							if (black.alpha != 1)
							{
								tmr.reset(0.1);
								black.alpha += 0.02;
	
								if (black.alpha >= 0.7 && !roarPlayed)
								{
									roar.play();
									roarPlayed = true;
								}
							}
							else if (done)
							{
								endSong();
								FlxG.camera.stopFX();
							}
							else
							{
								done = true;
								tmr.reset(5);
							}
						}
					}
				});
			}
	
			var bfScared:Bool = false;
	
			public static var playCutscene:Bool = true;
	
			function trickyCutscene():Void // god this function is terrible
			{
				trace('starting cutscene');
	
				var playonce:Bool = false;
	
				
				trans = new FlxSprite(-400,-760);
				trans.frames = Paths.getSparrowAtlas('Jaws','clown');
				trans.antialiasing = true;
	
				trans.animation.addByPrefix("Close","Jaws smol", 24, false);
				
				trace(trans.animation.frames);
	
				trans.setGraphicSize(Std.int(trans.width * 1.6));
	
				trans.scrollFactor.set();
	
				trace('added trancacscas ' + trans);
	
		
	
				var faded:Bool = false;
				var wat:Bool = false;
				var black:FlxSprite = new FlxSprite(-300, -120).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.fromRGB(19, 0, 0));
				black.scrollFactor.set();
				black.alpha = 0;
				var black3:FlxSprite = new FlxSprite(-300, -120).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.fromRGB(19, 0, 0));
				black3.scrollFactor.set();
				black3.alpha = 0;
				var red:FlxSprite = new FlxSprite(-300, -120).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.fromRGB(19, 0, 0));
				red.scrollFactor.set();
				red.alpha = 1;
				inCutscene = true;
				//camFollow.setPosition(bf.getMidpoint().x + 80, bf.getMidpoint().y + 200);
				dad.alpha = 0;
				gf.alpha = 0;
				remove(boyfriend);
				var nevada:FlxSprite = new FlxSprite(260,FlxG.height * 0.7);
				nevada.frames = Paths.getSparrowAtlas('somewhere','clown'); // add animation from sparrow
				nevada.antialiasing = true;
				nevada.animation.addByPrefix('nevada', 'somewhere idfk', 24, false);
				var animation:FlxSprite = new FlxSprite(-50,200); // create the fuckin thing
				animation.frames = Paths.getSparrowAtlas('intro','clown'); // add animation from sparrow
				animation.antialiasing = true;
				animation.animation.addByPrefix('fuckyou','Symbol', 24, false);
				animation.setGraphicSize(Std.int(animation.width * 1.2));
				nevada.setGraphicSize(Std.int(nevada.width * 0.5));
				add(animation); // add it to the scene
				
				// sounds
	
				var ground:FlxSound = new FlxSound().loadEmbedded(Paths.sound('ground','clown'));
				var wind:FlxSound = new FlxSound().loadEmbedded(Paths.sound('wind','clown'));
				var cloth:FlxSound = new FlxSound().loadEmbedded(Paths.sound('cloth','clown'));
				var metal:FlxSound = new FlxSound().loadEmbedded(Paths.sound('metal','clown'));
				var buildUp:FlxSound = new FlxSound().loadEmbedded(Paths.sound('trickyIsTriggered','clown'));
	
				camHUD.visible = false;
				
				add(boyfriend);
	
				add(red);
				add(black);
				add(black3);
	
				add(nevada);
	
				add(trans);
	
				trans.animation.play("Close",false,false,18);
				trans.animation.pause();
	
				new FlxTimer().start(0.01, function(tmr:FlxTimer)
					{
					if (!wat)
						{
							tmr.reset(1.5);
							wat = true;
						}
						else
						{
						if (wat && trans.animation.frameIndex == 18)
						{
							trans.animation.resume();
							trace('playing animation...');
						}
					if (trans.animation.finished)
					{
					trace('animation done lol');
					new FlxTimer().start(0.01, function(tmr:FlxTimer)
					{
	
							if (boyfriend.animation.finished && !bfScared)
								boyfriend.animation.play('idle');
							else if (boyfriend.animation.finished)
								boyfriend.animation.play('scared');
							if (nevada.animation.curAnim == null)
							{
								trace('NEVADA | ' + nevada);
								nevada.animation.play('nevada');
							}
							if (!nevada.animation.finished && nevada.animation.curAnim.name == 'nevada')
							{
								if (nevada.animation.frameIndex >= 41 && red.alpha != 0)
								{
									trace(red.alpha);
									red.alpha -= 0.1;
								}
								if (nevada.animation.frameIndex == 34)
									wind.fadeIn();
								tmr.reset(0.1);
							}
							if (animation.animation.curAnim == null && red.alpha == 0)
							{
								remove(red);
								trace('play tricky');
								animation.animation.play('fuckyou', false, false, 40);
							}
							if (!animation.animation.finished && animation.animation.curAnim.name == 'fuckyou' && red.alpha == 0 && !faded)
							{
								trace("animation loop");
								tmr.reset(0.01);
	
								// animation code is bad I hate this
								// :(
	
								
								switch(animation.animation.frameIndex) // THESE ARE THE SOUNDS NOT THE ACTUAL CAMERA MOVEMENT!!!!
								{
									case 73:
										ground.play();
									case 84:
										metal.play();
									case 170:
										if (!playonce)
										{
											resetSpookyText = false;
											createSpookyText(cutsceneText[0], 260, FlxG.height * 0.9);
											playonce = true;
										}
										cloth.play();
									case 192:
										resetSpookyTextManual();
										if (tstatic.alpha != 0)
											manuallymanuallyresetspookytextmanual();
										buildUp.fadeIn();
									case 219:
										trace('reset thingy');
										buildUp.fadeOut();
								}
	
							
								// im sorry for making this code.
								// TODO: CLEAN THIS FUCKING UP (switch case it or smth)
	
								if (animation.animation.frameIndex == 190)
									bfScared = true;
	
								if (animation.animation.frameIndex >= 115 && animation.animation.frameIndex < 200)
								{
									camFollow.setPosition(dad.getMidpoint().x + 150, boyfriend.getMidpoint().y + 50);
									if (FlxG.camera.zoom < 1.1)
										FlxG.camera.zoom += 0.01;
									else
										FlxG.camera.zoom = 1.1;
								}
								else if (animation.animation.frameIndex > 200 && FlxG.camera.zoom != defaultCamZoom)
								{
									FlxG.camera.shake(0.01, 3);
									if (FlxG.camera.zoom < defaultCamZoom || camFollow.y < boyfriend.getMidpoint().y - 50)
										{
											FlxG.camera.zoom = defaultCamZoom;
											camFollow.y = boyfriend.getMidpoint().y - 50;
										}
									else
										{
											FlxG.camera.zoom -= 0.008;
											camFollow.y = dad.getMidpoint().y -= 1;
										}
								}
								if (animation.animation.frameIndex >= 235)
									faded = true;
							}
							else if (red.alpha == 0 && faded)
							{
								trace('red gay');
								// animation finished, start a dialog or start the countdown (should also probably fade into this, aka black fade in when the animation gets done and black fade out. Or just make the last frame tranisiton into the idle animation)
								if (black.alpha != 1)
								{
									if (tstatic.alpha != 0)
										manuallymanuallyresetspookytextmanual();
									black.alpha += 0.4;
									tmr.reset(0.1);
									trace('increase blackness lmao!!!');
								}
								else
								{
									if (black.alpha == 1 && black.visible)
									{
										black.visible = false;
										black3.alpha = 1;
										trace('transision ' + black.visible + ' ' + black3.alpha);
										remove(animation);
										dad.alpha = 1;
										// why did I write this comment? I'm so confused
										// shitty layering but ninja muffin can suck my dick like mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
										remove(red);
										remove(black);
										remove(black3);
										dad.alpha = 1;
										gf.alpha = 1;
										add(black);
										add(black3);
										remove(tstatic);
										add(tstatic);
										tmr.reset(0.3);
										FlxG.camera.stopFX();
										camHUD.visible = true;
									}
									else if (black3.alpha != 0)
									{
										black3.alpha -= 0.1;
										tmr.reset(0.3);
										trace('decrease blackness lmao!!!');
									}
									else 
									{
										wind.fadeOut();
										startCountdown();
									}
								}
						}
					});
					}
					else
					{
						trace(trans.animation.frameIndex);
						if (trans.animation.frameIndex == 30)
							trans.alpha = 0;
						tmr.reset(0.1);
					}
					}
				});
			}	
	

		public function endSong():Void
			{
				if(FlxG.save.data.botplay) //no botplay shit
				{
					boyfriend.stunned = true;

					persistentUpdate = false;
					persistentDraw = false;
					paused = true;
		
					vocals.stop();
					FlxG.sound.music.stop();
		
					openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		
					#if windows
					// Game Over doesn't get his own variable because it's only used here
					DiscordClient.changePresence("GAME OVER -- " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore +  " | DM me the word Tomato for a suprise :), as Im SHIT at this game." + " | Misses: " + misses  , iconRPC);
					#end
				}
		
				canPause = false;
				FlxG.sound.music.volume = 0;
				vocals.volume = 0;
				if (SONG.validScore)
				{
					#if !switch
					Highscore.saveScore(SONG.song, Math.round(songScore), storyDifficulty);
					#end
				}
		
				if(PauseSubState.avoid) {
				if(SONG.song.toLowerCase() == "termination" && storyDifficulty == 2 && !FlxG.save.data.botplay){
					FlxG.save.data.terminationBeaten = true; //Congratulations, you won!
					FlxG.save.flush();
				}

				if(SONG.song.toLowerCase() == "expurgation" && storyDifficulty == 2 && !FlxG.save.data.botplay){
					FlxG.save.data.terminateWon = true;
					FlxG.save.data.isEligible = true;
					FlxG.save.data.didError == true;
					FlxG.save.data.diffStory = true;
					FlxG.save.flush();
				}

				if(SONG.song.toLowerCase() == "power-link" && storyDifficulty == 2 && !FlxG.save.data.botplay) {
					FlxG.save.data.powerWon = true;
					FlxG.save.flush();
				}

				if(SONG.song.toLowerCase() == "censory-overload" && storyDifficulty == 2 && !FlxG.save.data.botplay) {
					FlxG.save.data.didCensory = true;
					FlxG.save.flush();
				}
			}
		
				if (offsetTesting)
				{
		//			trace('dont do shit. k?');
				}
				else
				{
					if (SONG.song.toLowerCase() == 'cessation') //if placed at top cuz this should execute regardless of story mode. -Haz
					{
						camZooming = false;
						paused = true;
						qtCarelessFin = true;
						FlxG.sound.music.pause();
						vocals.pause();
						//Conductor.songPosition = 0;
						var doof = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('cessation/finalDialogue')));
						doof.scrollFactor.set();
						doof.finishThing = endScreenHazard;
						camHUD.visible = false;
						schoolIntro(doof);
					}
					else if (isStoryMode)
					{
						campaignScore += Math.round(songScore);
		
						storyPlaylist.remove(storyPlaylist[0]);
		
						if(!(SONG.song.toLowerCase() == 'terminate')){
		
							if (storyPlaylist.length <= 0)
							{
								FlxG.sound.playMusic(Paths.music("nexus_qt","qt"), 0);
		
								transIn = FlxTransitionableState.defaultTransIn;
								transOut = FlxTransitionableState.defaultTransOut;
		
								FlxG.switchState(new StoryMenuState());
		
								// if ()
								StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;
		
								if (SONG.validScore)
								{
									NGio.unlockMedal(60961);
									Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
								}
		
								FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
								FlxG.save.flush();
							}
							else
							{
								var difficulty:String = "";
		
								if (storyDifficulty == 0)
									difficulty = '-easy';

								if (storyDifficulty == 1)
									difficulty = '-hard';
		
								if (storyDifficulty == 2)
									difficulty = '-unfair';		
		
								//For whatever reason, this stuff never gets called or something??? wtf Kade Engine?
								//UPDATE: Apparently this shit works, but the loading instantly stops anything from happening.
								if (SONG.song.toLowerCase() == 'eggnog')
								{
									var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
										-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
									blackShit.scrollFactor.set();
									add(blackShit);
									camHUD.visible = false;
		
									FlxG.sound.play(Paths.sound('Lights_Shut_off'));
		
									//Slight delay to allow sound to play. -Haz
									new FlxTimer().start(2, function(tmr:FlxTimer)
									{
										trace('LOADING NEXT SONG');
										trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);
										FlxTransitionableState.skipNextTransIn = true;
										FlxTransitionableState.skipNextTransOut = true;
										prevCamFollow = camFollow;
		
										PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
										FlxG.sound.music.stop();
										
		
										LoadingState.loadAndSwitchState(new PlayState());
									});
								}
								else if (SONG.song.toLowerCase() == 'careless')
								{
									camZooming = false;
									paused = true;
									qtCarelessFin = true;
									FlxG.sound.music.pause();
									vocals.pause();
									//Conductor.songPosition = 0;
									var doof = new DialogueBox(false, CoolUtil.coolTextFile(Paths.txt('careless/carelessDialogue2')));
									doof.scrollFactor.set();
									doof.finishThing = loadSongHazard;
									camHUD.visible = false;
									schoolIntro(doof);
								}else
								{
									trace('LOADING NEXT SONG');
									trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);
									FlxTransitionableState.skipNextTransIn = true;
									FlxTransitionableState.skipNextTransOut = true;
									prevCamFollow = camFollow;
				
									PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
									FlxG.sound.music.stop();
									
				
									LoadingState.loadAndSwitchState(new PlayState());
								}					
							}
						}
					}
					else
					{
						trace('WENT BACK TO FREEPLAY??');
						FlxG.switchState(new FreeplayState());
					}
				}
			}

	function doStopSign(sign:Int = 0, fuck:Bool = false)
		{
			trace('sign ' + sign);
			var daSign:FlxSprite = new FlxSprite(0,0);
			// CachedFrames.cachedInstance.get('sign')
	
			daSign.frames = Paths.getSparrowAtlas('fourth/mech/Sign_Post_Mechanic', 'clown');
	
			daSign.setGraphicSize(Std.int(daSign.width * 0.67));
	
			daSign.cameras = [camNotes];
	
			switch(sign)
			{
				case 0:
					daSign.animation.addByPrefix('sign','Signature Stop Sign 1',24, false);
					daSign.x = FlxG.width - 650;
					daSign.angle = -90;
					daSign.y = -300;
				case 1:
					/*daSign.animation.addByPrefix('sign','Signature Stop Sign 2',20, false);
					daSign.x = FlxG.width - 670;
					daSign.angle = -90;*/ // this one just doesn't work???
				case 2:
					daSign.animation.addByPrefix('sign','Signature Stop Sign 3',24, false);
					daSign.x = FlxG.width - 780;
					daSign.angle = -90;
					if (FlxG.save.data.downscroll)
						daSign.y = -395;
					else
						daSign.y = -980;
				case 3:
					daSign.animation.addByPrefix('sign','Signature Stop Sign 4',24, false);
					daSign.x = FlxG.width - 1070;
					daSign.angle = -90;
					daSign.y = -145;
			}
			add(daSign);
			daSign.flipX = fuck;
			daSign.animation.play('sign');
			daSign.animation.finishCallback = function(pog:String)
				{
					trace('ended sign');
					remove(daSign);
				}
		}

		function doGremlin(hpToTake:Int, duration:Int,persist:Bool = false)
			{
				interupt = false;
		
				grabbed = true;
				
				totalDamageTaken = 0;
		
				var gramlan:FlxSprite = new FlxSprite(0,0);
		
				gramlan.frames = Paths.getSparrowAtlas('fourth/mech/HP GREMLIN', 'clown');
		
				gramlan.setGraphicSize(Std.int(gramlan.width * 0.76));
		
				gramlan.cameras = [camHUD];
		
				gramlan.x = iconP1.x;
				gramlan.y = healthBarBG.y - 325;
		
				gramlan.animation.addByIndices('come','HP Gremlin ANIMATION',[0,1], "", 24, false);
				gramlan.animation.addByIndices('grab','HP Gremlin ANIMATION',[2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24], "", 24, false);
				gramlan.animation.addByIndices('hold','HP Gremlin ANIMATION',[25,26,27,28],"",24);
				gramlan.animation.addByIndices('release','HP Gremlin ANIMATION',[29,30,31,32,33],"",24,false);
		
				gramlan.antialiasing = true;
		
				add(gramlan);
		
				if(FlxG.save.data.downscroll){
					gramlan.flipY = true;
					gramlan.y -= 150;
				}
				
				// over use of flxtween :)
		
				var startHealth = health;
				var toHealth = (hpToTake / 100) * startHealth; // simple math, convert it to a percentage then get the percentage of the health
		
				var perct = toHealth / 2 * 100;
		
				trace('start: $startHealth\nto: $toHealth\nwhich is prect: $perct');
		
				var onc:Bool = false;
		
				FlxG.sound.play(Paths.sound('fourth/GremlinWoosh','clown'));
		
				gramlan.animation.play('come');
				new FlxTimer().start(0.14, function(tmr:FlxTimer) {
					gramlan.animation.play('grab');
					FlxTween.tween(gramlan,{x: iconP1.x - 140},1,{ease: FlxEase.elasticIn, onComplete: function(tween:FlxTween) {
						trace('I got em');
						gramlan.animation.play('hold');
						FlxTween.tween(gramlan,{
							x: (healthBar.x + 
							(healthBar.width * (FlxMath.remapToRange(perct, 0, 100, 100, 0) * 0.01) 
							- 26)) - 75}, duration,
						{
							onUpdate: function(tween:FlxTween) { 
								// lerp the health so it looks pog
								if (interupt && !onc && !persist)
								{
									onc = true;
									trace('oh shit');
									gramlan.animation.play('release');
									gramlan.animation.finishCallback = function(pog:String) { gramlan.alpha = 0;}
								}
								else if (!interupt || persist)
								{
									var pp = FlxMath.lerp(startHealth,toHealth, tween.percent);
									if (pp <= 0)
										pp = 0.1;
									health = pp;
								}
		
								if (shouldBeDead)
									health = 0;
							},
							onComplete: function(tween:FlxTween)
							{
								if (interupt && !persist)
								{
									remove(gramlan);
									grabbed = false;
								}
								else
								{
									trace('oh shit');
									gramlan.animation.play('release');
									if (persist && totalDamageTaken >= 0.7)
										health -= totalDamageTaken; // just a simple if you take a lot of damage wtih this, you'll loose probably.
									gramlan.animation.finishCallback = function(pog:String) { remove(gramlan);}
									grabbed = false;
								}
							}
						});
					}});
				});
			}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if(FlxG.save.data.distractions){
			if (trainSound.time >= 4700)
				{
					startedMoving = true;
					gf.playAnim('hairBlow');
				}
		
				if (startedMoving)
				{
					phillyTrain.x -= 400;
		
					if (phillyTrain.x < -2000 && !trainFinishing)
					{
						phillyTrain.x = -1150;
						trainCars -= 1;
		
						if (trainCars <= 0)
							trainFinishing = true;
					}
		
					if (phillyTrain.x < -4000 && trainFinishing)
						trainReset();
				}
		}

	}

	function trainReset():Void
	{
		if(FlxG.save.data.distractions){
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}
	
	function switchCharacters(charName:String = ''):Void 
	{
		switch(charName)
		{
			case 'bf':
				isbf = true;
			case 'dad':
				isdad = true;
			case 'dad2': 
				isdad2 = true;
			case 'hex':
				isdad = true;
			case 'robot': 
				isdad2 = true;
			default: //default switch name
				isdad = true;
		}
	}

	function betterSwitch():Void
	{
		if (isdad) { //im lazy ok?
			isdad2 = true;
			isdad = false;
		}
		else {
			isdad = true;
			isdad2 = false;
		}
	}

	function singAllDad():Void
	{
		isdad = true;
		isdad2 = true;
	}
	
	function resetAll():Void
	{
		isbf = false;	
		isdad = false;	
		isdad2 = false;	
	}

	function resetBf():Void
	{
		isbf = false;	
	}

	function resetDad():Void
	{
		isdad = false;	
		isdad2 = false;	
	}

	var danced:Bool = false;

	var stepOfLast = 0;

	override function stepHit()
	{
		super.stepHit();
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
		{
			resyncVocals();
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curStep',curStep);
			luaModchart.executeState('stepHit',[curStep]);
		}
		#end

		// resetDad();
		// betterSwitchs('hex');

		if (curSong.toLowerCase() == 'censory-overload'){
			//Making GF scared for error section
			if(curBeat>=704 && curBeat<832 && curStep % 2 == 0)
			{
				gf.playAnim('scared', true);
				if(!Main.qtOptimisation)
					gf404.playAnim('scared', true);
			}
		}

		if (SONG.song.toLowerCase() == "power-link")
		{
			switch(curStep)
			{
				case 319:
					resetDad();
					isdad = true; //resets vars for no trouble
				case 447:
					betterSwitch(); //if hex sing is true, set robot sing to true and hex to false. and vice versa
				case 576:
					betterSwitch();
				case 703:
					betterSwitch();
				case 831:
					betterSwitch();
				case 959:
					betterSwitch();
				case 1150:
					betterSwitch();
				case 1343:
					betterSwitch();
				case 1471:
					betterSwitch();
				case 1598:
					betterSwitch();
				case 1721:
					resetDad(); //resets both dad's singing ability
					singAllDad(); //grants it back for all dads	
			}
		}

		// resetDad();
		// betterSwitchs('hex');

		if (SONG.song.toLowerCase() == 'final-destination' && curStep != stepOfLast)
			{
				Main.god = true;
				switch(curStep)
				{
					case 1:
						resetDad();
						isdad = true;
					if (Main.god)
					{
						dadTrail = new FlxTrail(dad2, null, 5, 10, 0.1, 0.01);
						dad2Trail = new FlxTrail(dad, null, 5, 10, 0.1, 0.01);
					}
					case 128:
						betterSwitch();
					case 256:
						betterSwitch();
					case 384:
						betterSwitch();
					case 512:
						betterSwitch();
					case 640:
						betterSwitch();
					case 768:
						betterSwitch();
					case 896:
						betterSwitch();
					case 1024:
						
						betterSwitch();
					case 1152:
						resetDad();
						singAllDad();
						FlxTween.tween(FlxG.camera, {zoom: 0.65}, 3.2, {
				ease: FlxEase.expoOut
					});
					shakeCam = true;
					if (Main.god)
					{
						camHUD.alpha = 0.5;
						add(dadTrail);
						add(dad2Trail);
						theBlackBG.visible = true;
						godModeFloat = true;
						cum.visible = true;
						FlxTween.tween(cum, {alpha: 0}, 1, {ease: FlxEase.expoOut});
					}
	
						//shakeCam = false;
					
					case 1408:
						shakeCam = false;
	
	
						FlxTween.tween(FlxG.camera, {zoom: 0.65}, 1.6, {
							ease: FlxEase.expoOut
								});
	
					if (Main.god)
					{
						remove(dadTrail);
						remove(dad2Trail);
						camHUD.alpha = 1;
						theBlackBG.visible = false;
						godModeFloat = false;
						cum.visible = false;
						dad.x = 100;
						dad.y = 125;
						dad2.x = 280;
						dad2.y = 75;
						/*
							dad = new Character(100, 100, SONG.player2, false);
							dad2 = new Character(280, 100, "robot");
						*/
					}

					case 1416:
						resetDad();
						isdad = true; //1
					case 1536:
						
						betterSwitch(); //1
					case 1600:
						
						betterSwitch(); //1
					case 1664:
						
						betterSwitch(); //1
					case 1792:
						
						betterSwitch(); //2
					case 1856:
						
						betterSwitch(); //2
					case 1984:
						
						betterSwitch(); //1
					case 2112:
						
						betterSwitch(); //2
					case 2240:
						
						betterSwitch(); //2
					case 2368:
						
						betterSwitch(); //2
					case 2496:
						
						betterSwitch(); //2
					case 2624:
						resetDad();
						singAllDad();
						FlxTween.tween(FlxG.camera, {zoom: 0.65}, 3.2, {
				ease: FlxEase.expoOut
					});
					shakeCam = true;
					if (Main.god)
					{
						add(dadTrail);
						add(dad2Trail);
						camHUD.alpha = 0.1;
						theBlackBG.visible = true;
						godModeFloat = true;
						cum.visible = true;
						FlxTween.tween(cum, {alpha: 0}, 1, {ease: FlxEase.expoOut});
					}
					case 2688:
						shakeCam = false;
						resetDad();
					case 2752:
						FlxTween.tween(FlxG.camera, {zoom: 0.65}, 3.2, {
							   ease: FlxEase.expoOut
							});
	
							resetDad();
						singAllDad();
					shakeCam = true;
					case 2816:
						shakeCam = false;
						resetDad();
						betterSwitch();
					case 2880:
						remove(dadTrail);
						remove(dad2Trail);
						camHUD.alpha = 1;
						resetDad();
						isdad = true;
					FlxTween.tween(FlxG.camera, {zoom: 0.65}, 1.6, {
				ease: FlxEase.expoOut
					});
					case 2944:
						betterSwitch();
					case 3008:
						betterSwitch();
					case 3072:
						betterSwitch();
				}
				stepOfLast = curStep;
			}
		
		if (SONG.song.toLowerCase() == "tutorial" && curStep != stepOfLast && storyDifficulty == 2) //song events
			{
				switch(curStep) //guide for anyone looking at this, switching mid song needs to be mania + 10
				{
					case 56: //switched it to modcharts! (can still be hardcoded though)
						//2 key
						//switchMania(17);
					case 125: 
						//4 key
						//switchMania(10);
					case 189: 
						//6 key
						//switchMania(11);
					case 252: 
						//8 key
						//switchMania(15);
					case 323: 
						//9 key
						//switchMania(12);
					case 390: 
						//4 key
						//switchMania(10);
					case 410: 
						//9 key
						//switchMania(12);
				}
			}

		if (curSong.toLowerCase() == 'termination'){
			
			//For animating KB during the 404 section since he animates every half beat, not every beat.
			if(qtIsBlueScreened)
			{
				//Termination KB animates every 2 curstep instead of 4 (aka, every half beat, not every beat!)
				if (SONG.notes[Math.floor(curStep / 16)].mustHitSection && !dad404.animation.curAnim.name.startsWith("sing") && curStep % 2 == 0)
				{
					dad404.dance();
				}
			}

			//Making GF scared for error section
			if(curStep>=2816 && curStep<3328 && curStep % 2 == 0)
			{
				gf.playAnim('scared', true);
				if(!Main.qtOptimisation)
					gf404.playAnim('scared', true);
			}


			switch (curStep)
			{
				//Commented out stuff are for the double sawblade variations.
				//It is recommended to not uncomment them unless you know what you're doing. They are also not polished at all so don't complain about them if you do uncomment them.
				
				
				//CONVERTED THE CUSTOM INTRO FROM MODCHART INTO HARDCODE OR WHATEVER! NO MORE INVISIBLE NOTES DUE TO NO MODCHART SUPPORT!
				case 1:
					qt_tv01.animation.play("instructions");
					FlxTween.tween(cpuStrums.members[0], {y: cpuStrums.members[0].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
					FlxTween.tween(playerStrums.members[5], {y: playerStrums.members[5].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
					if(!Main.qtOptimisation){
						boyfriend404.alpha = 0; 
						dad404.alpha = 0;
						gf404.alpha = 0;
					}
				case 32:
					FlxTween.tween(cpuStrums.members[1], {y: cpuStrums.members[1].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
					FlxTween.tween(playerStrums.members[4], {y: playerStrums.members[4].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
				case 48:
					if(!FlxG.save.data.noSaw) {
					add(kb_attack_saw);
					add(kb_attack_alert);
					}
					KBATTACK_ALERT();
					KBATTACK();
				case 52:
					KBATTACK_ALERT();
				case 56:
					if (FlxG.save.data.botplay) {
						BotBfDodge();
						BOT_KBATTACK(true);
					}
					else
						KBATTACK(true);
				case 96:
					FlxTween.tween(cpuStrums.members[2], {y: cpuStrums.members[2].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
					FlxTween.tween(playerStrums.members[3], {y: playerStrums.members[3].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
				case 64:
					qt_tv01.animation.play("gl");
					FlxTween.tween(cpuStrums.members[3], {y: cpuStrums.members[3].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
					FlxTween.tween(playerStrums.members[2], {y: playerStrums.members[2].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
				case 112:
					KBATTACK_ALERT();
					KBATTACK();
				case 116:
					KBATTACK_ALERTDOUBLE();
					FlxTween.tween(cpuStrums.members[4], {y: cpuStrums.members[4].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
					FlxTween.tween(playerStrums.members[1], {y: playerStrums.members[1].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
				case 120:
					if (FlxG.save.data.botplay) {
						BotBfDodge();
						BOT_KBATTACK(true, "old/attack_alt01");
					}
					else
						KBATTACK(true, "old/attack_alt01");
					qt_tv01.animation.play("idle");
					for (boi in strumLineNotes.members) { //FAIL SAFE TO ENSURE THAT ALL THE NOTES ARE VISIBLE WHEN PLAYING!!!!!
						boi.alpha = 1;
					}
				case 123:
					KBATTACK();
				case 124:
					FlxTween.tween(cpuStrums.members[5], {y: cpuStrums.members[5].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
					FlxTween.tween(playerStrums.members[0], {y: playerStrums.members[0].y + 10, alpha: 1}, 1.2, {ease: FlxEase.cubeOut});
					if (FlxG.save.data.botplay) {
						BotBfDodge();
						BOT_KBATTACK(true, "old/attack_alt01");
					}
					else
						KBATTACK(true, "old/attack_alt01");
				case 1280:
					qt_tv01.animation.play("idle");
				case 480:
					qt_tv01.animation.play("watch");
				case 516:
					qt_tv01.animation.play("idle");

				case 272 | 304 | 404 | 416 | 504 | 544 | 560 | 612 | 664 | 696 | 752 | 816 | 868 | 880 | 1088 | 1204 | 1344 | 1400 | 1428 | 1440 | 1472 | 1520 | 1584 | 1648 | 1680 | 1712 | 1744:
					KBATTACK_ALERT();
					KBATTACK();
				case 276 | 308 | 408 | 420 | 508 | 548 | 564 | 616 | 668 | 700 | 756 | 820 | 872 | 884 | 1092 | 1208 | 1348 | 1404 | 1432 | 1444 | 1476 | 1524 | 1588 | 1652 | 1684 | 1716 | 1748: 
					KBATTACK_ALERT();
				case 280 | 312 | 412 | 424 | 512 | 552 | 568 | 620 | 672 | 704 | 760 | 824 | 876 | 888 | 1096 | 1212 | 1352 | 1408 | 1436 | 1448 | 1480 | 1528 | 1592 | 1656 | 1688 | 1720 | 1752:
					if (FlxG.save.data.botplay) {
						BotBfDodge();
						BOT_KBATTACK(true);
					}
					else
						KBATTACK(true);

				case 1776 | 1904 | 2576 | 2596 | 2624 | 2640 | 2660 | 2704 | 2736 | 3072 | 3104 | 3136 | 3152 | 3168 | 3184 | 3216 | 3248 | 3312:
					KBATTACK_ALERT();
					KBATTACK();
				case 1780 | 1908 | 2580 | 2600 | 2628 | 2644 | 2664 | 2708 | 2740 | 3076 | 3108 | 3140 | 3156 | 3172 | 3188 | 3220 | 3252 | 3316:
					KBATTACK_ALERT();
				case 1784 | 1912 | 2584 | 2604 | 2632 | 2648 | 2668 | 2712 | 2744 | 3080 | 3112 | 3144 | 3160 | 3176 | 3192 | 3224 | 3256 | 3320:
					if (FlxG.save.data.botplay) {
						BotBfDodge();
						BOT_KBATTACK(true);
					}
					else
						KBATTACK(true);

				case 1808 | 1840 | 1872 | 1952 | 2000 | 2112 | 2148 | 2176 | 2192 | 2228 | 2240 | 2272 | 2768 | 2788 | 2800 | 2864 | 2916 | 2928 | 3024 | 3264 | 3280 | 3300:
					KBATTACK_ALERT();
					KBATTACK();
				case 1812 | 1844 | 1876 | 1956 | 2004 | 2116 | 2152 | 2180 | 2196 | 2232 | 2244 | 2276 | 2772 | 2792 | 2804 | 2868 | 2920 | 2932 | 3028 | 3268 | 3284 | 3304:
					KBATTACK_ALERT();
				case 1816 | 1848 | 1880 | 1960 | 2008 | 2120 | 2156 | 2184 | 2200 | 2236 | 2248 | 2280 | 2776 | 2796 | 2808 | 2872 | 2924 | 2936 | 3032 | 3272 | 3288 | 3308:
					if (FlxG.save.data.botplay) {
						BotBfDodge();
						BOT_KBATTACK(true);
					}
					else
						KBATTACK(true);

                case 624 | 1136 | 2032 | 2608 | 2672 | 3084 | 3116 | 4140 | 4204 | 4464:
					KBATTACK_ALERT();
					KBATTACK();
				case 628 | 1140 | 2036 | 2612 | 2676 | 3088 | 3120 | 4144 | 4208 | 4468:
					KBATTACK_ALERTDOUBLE();
				case 632 | 1144 | 2040 | 2616 | 2680 | 3092 | 3124 | 4148 | 4212 | 4472:
					if (FlxG.save.data.botplay) {
						BotBfDodge();
						BOT_KBATTACK(true, "old/attack_alt01");
					}
					else
						KBATTACK(true, "old/attack_alt02");
				case 635 | 1147 | 2043 | 2619 | 2683 | 3095 | 3127 | 4151 | 4215 | 4475:
					KBATTACK();
				case 636 | 1148 | 2044 | 2620 | 2684 | 3096 | 3128 | 4152 | 4216 | 4476:
					if (FlxG.save.data.botplay) {
						BotBfDodge();
						BOT_KBATTACK(true, "old/attack_alt01");
					}
					else
						KBATTACK(true, "old/attack_alt02");
				//Sawblades before bluescreen thing
				//These were seperated for double sawblade experimentation if you're wondering.
				//My god this organisation is so bad. Too bad!
				//Yes, this is too bad! -DrkFon376
				case 2304 | 2320 | 2340 | 2368 | 2384 | 2404 | 2496 | 2528:
					KBATTACK_ALERT();
					KBATTACK();
				case 2308 | 2324 | 2344 | 2372 | 2388 | 2408 | 2500 | 2532:
					KBATTACK_ALERT();
				case 2312 | 2328 | 2348 | 2376 | 2392 | 2412 | 2504 | 2536:
					if (FlxG.save.data.botplay) {
						BotBfDodge();
						BOT_KBATTACK(true);
					}
					else
						KBATTACK(true);

				case 2352 | 2416:
					KBATTACK_ALERT();
					KBATTACK();
				case 2356 | 2420:
					KBATTACK_ALERTDOUBLE();
				case 2360 | 2424:
					if (FlxG.save.data.botplay) {
						BotBfDodge();
						BOT_KBATTACK(true, "old/attack_alt01");
					}
					else
						KBATTACK(true, "old/attack_alt02");
				case 2363 | 2427:
					KBATTACK();
				case 2364 | 2428:
					if (FlxG.save.data.botplay) {
						BotBfDodge();
						BOT_KBATTACK(true, "old/attack_alt01");
					}
					else
						KBATTACK(true, "old/attack_alt02");

				case 2560:
					KBATTACK_ALERT();
					KBATTACK();
					qt_tv01.animation.play("eye");
				case 2564:
					KBATTACK_ALERT();
				case 2568:
					if (FlxG.save.data.botplay) {
						BotBfDodge();
						BOT_KBATTACK(true);
					}
					else
						KBATTACK(true);
				
				case 2808:
					//Change to glitch background
					if(!Main.qtOptimisation){
						streetBGerror.visible = true;
						streetBG.visible = false;
					}
					FlxG.camera.shake(0.0075,0.675);
					qt_tv01.animation.play("error");

				case 2816: //404 section
					qt_tv01.animation.play("404");
					gfSpeed = 1;
					//Change to bluescreen background
					if(!Main.qtOptimisation){
						streetBG.visible = false;
						streetBGerror.visible = false;
						streetFrontError.visible = true;
						qtIsBlueScreened = true;
						CensoryOverload404();
					}
				case 3328: //Final drop
					qt_tv01.animation.play("alert");
					gfSpeed = 1;
					//Revert back to normal
					if(!Main.qtOptimisation){
						streetBG.visible = true;
						streetFrontError.visible = false;
						qtIsBlueScreened = false;
						CensoryOverload404();
					}

				case 3360 | 3376 | 3396 | 3408 | 3424 | 3440 | 3504 | 3552 | 3576 | 3616 | 3636 | 3648 | 3664 | 3680 | 3696 | 3776 | 3808 | 3888 | 3824 | 3872 | 3924 | 3936 | 3952 | 3984:
					KBATTACK_ALERT();
					KBATTACK();
				case 3364 | 3380 | 3400 | 3412 | 3428 | 3444 | 3508 | 3556 | 3580 | 3620 | 3640 | 3652 | 3668 | 3684 | 3700 | 3780 | 3812 | 3892 | 3828 | 3876 | 3928 | 3940 | 3956 | 3988:
					KBATTACK_ALERT();
				case 3368 | 3384 | 3404 | 3416 | 3432 | 3448 | 3512 | 3560 | 3584 | 3624 | 3644 | 3656 | 3672 | 3688 | 3704 | 3784 | 3816 | 3896 | 3832 | 3880 | 3932 | 3944 | 3960 | 3992:
					if (FlxG.save.data.botplay) {
						BotBfDodge();
						BOT_KBATTACK(true);
					}
					else
						KBATTACK(true);

				case 4020 | 4032 | 4064 | 4080 | 4096 | 4108 | 4128 | 4160 | 4176 | 4192 | 4224 | 4256 | 4268 | 4288 | 4324 | 4336 | 4368 | 4400 | 4432 | 4496 | 4528 | 4560 | 4592 /*someone thought b4 me*/| 4656:
					KBATTACK_ALERT();
					KBATTACK();
				case 4024 | 4036 | 4068 | 4084 | 4100 | 4112 | 4132 | 4164 | 4180 | 4196 | 4228 | 4260 | 4272 | 4292 | 4328 | 4340 | 4372 | 4404 | 4436 | 4500 | 4532 | 4564 | 4596 | 4660:
					KBATTACK_ALERT();
				case 4028 | 4040 | 4072 | 4088 | 4104 | 4116 | 4136 | 4168 | 4184 | 4200 | 4232 | 4264 | 4276 | 4296 | 4332 | 4344 | 4376 | 4408 | 4440 | 4504 | 4536 | 4568 | 4600 | 4664://<----LMAO this is the last sawblade placed on the penultimate beat of the level. Funny, right? 
				if (FlxG.save.data.botplay) {
					BotBfDodge();
					BOT_KBATTACK(true);
				}
				else
					KBATTACK(true);
								
				case 4352: //Custom outro hardcoded instead of being part of the modchart! 
					qt_tv01.animation.play("idle");
					FlxTween.tween(strumLineNotes.members[2], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
				case 4384:
					FlxTween.tween(strumLineNotes.members[3], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
				case 4416:
					FlxTween.tween(strumLineNotes.members[0], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
				case 4448:
					FlxTween.tween(strumLineNotes.members[1], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});

				case 4480:
					FlxTween.tween(strumLineNotes.members[6], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
				case 4512:
					FlxTween.tween(strumLineNotes.members[7], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
				case 4544:
					FlxTween.tween(strumLineNotes.members[4], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
				case 4576:
					FlxTween.tween(strumLineNotes.members[5], {alpha: 0}, 1.1, {ease: FlxEase.sineInOut});
				case 4592:
					KBATTACK_ALERT(); //sure to get some peeps
				case 4596:
					KBATTACK_ALERT();
				case 4600:
					if (FlxG.save.data.botplay) {
						BotBfDodge();
						BOT_KBATTACK(true);
					}
					else
						KBATTACK(true);
					/*
					if (FlxG.save.data.botplay) {
						BotBfDodge();
						BOT_KBATTACK(true);
					}
					else
						KBATTACK(true);
					*/
			}
		}

		if (SONG.song.toLowerCase() == 'terminate' && !FlxG.save.data.botplay)
		{
			FlxG.save.data.didError == true;
			FlxG.save.data.diffStory = true;
			FlxG.save.flush();
		}

		if (curStage == 'auditorHell' && curStep != stepOfLast)
		{
			switch(curStep)
			{
				case 384:
					doStopSign(0);
				case 511:
					doStopSign(2);
					doStopSign(0);
				case 610:
					doStopSign(3);
				case 720:
					doStopSign(2);
				case 991:
					doStopSign(3);
				case 1184:
					doStopSign(2);
				case 1218:
					doStopSign(0);
				case 1235:
					doStopSign(0, true);
				case 1200:
					doStopSign(3);
				case 1328:
					doStopSign(0, true);
					doStopSign(2);
				case 1439:
					doStopSign(3, true);
				case 1567:
					doStopSign(0);
				case 1584:
					doStopSign(0, true);
				case 1600:
					doStopSign(2);
				case 1706:
					doStopSign(3);
				case 1917:
					doStopSign(0);
				case 1923:
					doStopSign(0, true);
				case 1927:
					doStopSign(0);
				case 1932:
					doStopSign(0, true);
				case 2032:
					doStopSign(2);
					doStopSign(0);
				case 2036:
					doStopSign(0, true);
				case 2128:
					hexErrorSwitch();
				case 2144:
					hexErrorSwitch(false);
				case 2162:
					doStopSign(2);
					doStopSign(3);
				case 2193:
					doStopSign(0);
				case 2202:
					doStopSign(0,true);
				case 2239:
					doStopSign(2,true);
				case 2258:
					doStopSign(0, true);
				case 2304:
					doStopSign(0, true);
					doStopSign(0);	
				case 2326:
					doStopSign(0, true);
				case 2336:
					doStopSign(3);
				case 2447:
					doStopSign(2);
					doStopSign(0, true);
					doStopSign(0);	
				case 2480:
					doStopSign(0, true);
					doStopSign(0);	
				case 2512:
					doStopSign(2);
					doStopSign(0, true);
					doStopSign(0);
				case 2544:
					doStopSign(0, true);
					doStopSign(0);	
				case 2575:
					doStopSign(2);
					doStopSign(0, true);
					doStopSign(0);
				case 2608:
					doStopSign(0, true);
					doStopSign(0);	
				case 2604:
					doStopSign(0, true);
				case 2655:
					doGremlin(20,13,true);
			}
			stepOfLast = curStep;
		}

		if (SONG.song == 'Termination')
			{
				switch(curStep)
				{
					case 384:
						doStopSign(0);
					case 511:
						doStopSign(2);
						doStopSign(0);
					case 610:
						doStopSign(3);
					case 720:
						doStopSign(2);
					case 991:
						doStopSign(3);
					case 1184:
						doStopSign(2);
					case 1218:
						doStopSign(0);
					case 1235:
						doStopSign(0, true);
					case 1200:
						doStopSign(3);
					case 1328:
						doStopSign(0, true);
						doStopSign(2);
					case 1439:
						doStopSign(3, true);
					case 1567:
						doStopSign(0);
					case 1584:
						doStopSign(0, true);
					case 1600:
						doStopSign(2);
					case 1706:
						doStopSign(3);
					case 1917:
						doStopSign(0);
					case 1923:
						doStopSign(0, true);
					case 1927:
						doStopSign(0);
					case 1932:
						doStopSign(0, true);
					case 2032:
						doStopSign(2);
						doStopSign(0);
					case 2036:
						doStopSign(0, true);
					case 2162:
						doStopSign(2);
						doStopSign(3);
					case 2193:
						doStopSign(0);
					case 2202:
						doStopSign(0,true);
					case 2239:
						doStopSign(2,true);
					case 2258:
						doStopSign(0, true);
					case 2304:
						doStopSign(0, true);
						doStopSign(0);	
					case 2326:
						doStopSign(0, true);
					case 2336:
						doStopSign(3);
					case 2447:
						doStopSign(2);
						doStopSign(0, true);
						doStopSign(0);	
					case 2480:
						doStopSign(0, true);
						doStopSign(0);	
					case 2512:
						doStopSign(2);
						doStopSign(0, true);
						doStopSign(0);
					case 2544:
						doStopSign(0, true);
						doStopSign(0);	
					case 2575:
						doStopSign(2);
						doStopSign(0, true);
						doStopSign(0);
					case 2608:
						doStopSign(0, true);
						doStopSign(0);	
					case 2604:
						doStopSign(0, true);
					case 2655:
				//		doGremlin(20,13,true);
					case 2800:
						FlxG.save.data.terminationUnlocked = true;
				}
				stepOfLast = curStep;
			}
			
			if (SONG.song == 'Terminate' && storyDifficulty == 2)
			{
				switch (curStep)
				{
					case 127:
						FlxG.save.data.isEligible = true;
				}
			}
		
			if (SONG.song == 'Terminate')
				{ //For finishing the song early or whatever.
			//		var makeItCRASH:FlxSprite;	
					switch (curStep)
					{
						case 120: 
							add(kb_attack_alert);
							KBATTACK_ALERT();
							KBATTACK_FAKE();
						case 124:
							//KBATTACK_ALERTDOUBLE();
							KBATTACK_ALERT();
						case 127:
							terminateBlueScreen();

							FlxG.save.data.terminateWon = true;

							var realShit:String = 'File "renpy/common/00action_file.rpy, line 427, in __call__ renpy.load(fn)"\nRestartTopContext: Oh jeez...I didnt break anything, did I? Hold on a sec, I can probably fix this...I think...\nActually, you know what? This would probably be a lot easier if I just deleted him. Hes the one whos making this so difficult. \nAhaha! Well, heres goes nothing. crap. sirry};';

							var user/*:String*/ = realShit;
							var content:String = haxe.Json.stringify(user);
							#if desktop
							sys.io.File.saveContent('traceback.txt',content);	
							#end

							var location = "traceback.txt";
							var path = new haxe.io.Path(location);
							trace(path.dir); // path/to
							trace(path.file); // file
							trace(path.ext); // txt
						case 128:
							KBATTACK_FAKE(true);
							dad.playAnim('singLEFT', true);

						//	terminateBlueScreen();

							FlxG.save.data.didError = true;

							FlxG.save.flush();

							add(makeItCRASH); // makes the game fucking crash cause why not
							makeItCRASH.animation.play('alert'); // backup :)
						
							if(!qtCarelessFinCalled)
								terminationEndEarly();
					}
				}

		if(SONG.song.toLowerCase() == "termination"){
			if(curBeat >= 192 && curBeat <= 320) //1st drop
			{
				if(camZooming && FlxG.camera.zoom < 1.35)
				{
					FlxG.camera.zoom += 0.0075;
					camHUD.zoom += 0.015;
				}
				if(!(curBeat == 320)) //To prevent alert flashing when I don't want it too.
					qt_tv01.animation.play("alert");
			}
			else if(curBeat >= 512 && curBeat <= 640) //1st drop
			{
				if(camZooming && FlxG.camera.zoom < 1.35)
				{
					FlxG.camera.zoom += 0.0075;
					camHUD.zoom += 0.015;
				}
				if(!(curBeat == 640)) //To prevent alert flashing when I don't want it too.
					qt_tv01.animation.play("alert");
			}
			else if(curBeat >= 832 && curBeat <= 1088) //last drop
				{
					if(camZooming && FlxG.camera.zoom < 1.35)
					{
						FlxG.camera.zoom += 0.0075;
						camHUD.zoom += 0.015;
					}
					if(!(curBeat == 1088)) //To prevent alert flashing when I don't want it too.
						qt_tv01.animation.play("alert");
				}
		}

	/*if (FlxG.save.data.characters)
	{
		// This mode is just purely concept, you are allowed to fix it up if you want, but this is being put off for now.
		if (curSong == 'Expurgation') //THIS MOD WAS ORIGNALLY GOING TO BE A PLAYABLE VER OF EXPURGATION BETADCIU BY VITOR, BUT I WAS TOO LAZY
		{
			/*dad = new Character(100, 100, 'dad');
			mom = new Character(0, 100, 'mom');
			senpai = new Character(100, 100, 'senpai');
			hankchar = new Character(0, 100, 'hankchar');
			spooky = new Character(100, 100, 'spooky');
			pico = new Character(100, 0, 'pico');
			tricky = new Character(100, 100, 'tricky');
			whitty = new Character(100, 0, 'whitty');
		 
			switch (curStep)
			{
			case 0:
				dad.visible = false;
				mom.visible = false;
				senpai.visible = false;
				hankchar.visible = false;
				spooky.visible = false;
				tricky.visible = false;
			case 126:
				dad.visible = true;
				dad.visible = false;
			case 159:
				mom.visible = true;
			case 190:
				dad.visible = false;
				senpai.visible = true;
			case 220:
				mom.visible = false;
				hankchar.visible = true;
			case 250:
				senpai.visible = false;
				spooky.visible = true;
			case 280:
				hankchar.visible = false;
				pico.visible = true;
			case 320:
				spooky.visible = false;
				whitty.visible = false;
			case 384:
				pico.visible = false;
				boyfriend.visible = true;
			case 445:
				whitty.visible = false;
				dad.visible = true;
			}
		}
	}*/

	/*if (!FlxG.save.data.characters)
		{
	
			if (curSong == 'Expurgation')
			{
			 
				switch (curStep)
				{
	
				case 126:
					changeDadCharacter('dad');
				case 159:
					changeBoyfriendCharacter('mom');
				case 190:
					changeDadCharacter('senpai');
				case 220:
					changeBoyfriendCharacter('hankchar');
				case 250:
					changeDadCharacter('spooky');
				case 280:
					changeBoyfriendCharacter('pico');
				case 320:
					changeDadCharacter('whitty');
				case 384:
					changeBoyfriendCharacter('hex');
				case 445:
					changeDadCharacter('hankchar');
				case 2128: 
					changeDadCharacter('exTricky');
				case 2144: 
					changeDadCharacter('dad');
					changeDad1Character('mom');
					changeDad2Character('gf');
				case 2176: 
					changeBoyfriendCharacter('bf');
					changeBoyfriend1Character('senpai');
					changeBoyfriend2Character('whitty');
				}
			}
		}*/


		// yes this updates every step.
		// yes this is bad
		// but i'm doing it to update misses and accuracy
		#if windows
		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText + " " + SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy), "Acc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + songScore + "stop looking k? also I like you a lot." + " | Misses: " + misses  , iconRPC,true,  songLength - Conductor.songPosition);
		#end

	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;
	var beatOfFuck:Int = 0;


	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, (PlayStateChangeables.useDownscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		}

		#if windows
		if (executeModchart && luaModchart != null)
		{
			luaModchart.setVar('curBeat',curBeat);
			luaModchart.executeState('beatHit',[curBeat]);
		}
		#end

		if (curSong == 'Tutorial' && dad.curCharacter == 'gf') {
			if (curBeat % 2 == 1 && dad.animOffsets.exists('danceLeft'))
				dad.playAnim('danceLeft');
			if (curBeat % 2 == 0 && dad.animOffsets.exists('danceRight'))
				dad.playAnim('danceRight');
		}





		if (currentSection != null)
		{
			if (!currentSection.mustHitSection)
			{
				//just do nothing
			//	trace('dont do shit k?');
			}
			if (currentSection.changeBPM)
			{
				Conductor.changeBPM(currentSection.bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (currentSection.mustHitSection && dad.curCharacter != 'gf')
				{
						dad.dance();
						if (exDad) 
							dad2.dance();
				}
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		wiggleShit.update(Conductor.crochet);

		if (FlxG.save.data.camzoom)
		{
			// HARDCODING FOR MILF ZOOMS!
			if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
	
			if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
	
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));
			
		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
		{
			boyfriend.dance();
		}
		

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
			{
				boyfriend.playAnim('hey', true);
				dad.playAnim('cheer', true);
			}

		switch (curStage)
		{
			case 'school':
				if(FlxG.save.data.distractions){
					bgGirls.dance();
				}

			case 'mall':
				if(FlxG.save.data.distractions){
					upperBoppers.animation.play('bop', true);
					bottomBoppers.animation.play('bop', true);
					santa.animation.play('idle', true);
				}

			case 'limo':
				if(FlxG.save.data.distractions){
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
						{
							dancer.dance();
						});
		
						if (FlxG.random.bool(10) && fastCarCanDrive)
							fastCarDrive();
				}
			case "philly":
				if(FlxG.save.data.distractions){
					if (!trainMoving)
						trainCooldown += 1;
	
					if (curBeat % 4 == 0)
					{
						phillyCityLights.forEach(function(light:FlxSprite)
						{
							light.visible = false;
						});
	
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
	
						phillyCityLights.members[curLight].visible = true;
						// phillyCityLights.members[curLight].alpha = 1;
				}

				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					if(FlxG.save.data.distractions){
						trainCooldown = FlxG.random.int(-4, 0);
						trainStart();
					}
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			if(FlxG.save.data.distractions){
				lightningStrikeShit();
			}
		}
	}

	var curLight:Int = 0;
}
