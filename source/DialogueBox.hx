package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var curSound:FlxSound; // thanks GWebDev

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	// DIALOGUE MUSIC
	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		if (PlayState.isStoryMode)
		{
			switch (PlayState.SONG.song.toLowerCase())
			{
				case 'rise':
					FlxG.sound.playMusic(Paths.music('lateSpringBreeze'), 0);
					FlxG.sound.music.fadeIn(1, 0, 0.5);
				case 'pissed':
					FlxG.sound.playMusic(Paths.music('lateSpringBreeze'), 0);
					FlxG.sound.music.fadeIn(1, 0, 0.5);
				case 'rebel':
					FlxG.sound.playMusic(Paths.music('burst'), 0);
					FlxG.sound.music.fadeIn(1, 0, 0.5);
			}
		}

		// bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), 0xFFB3DFd8);
		// bgFade.scrollFactor.set();
		// bgFade.alpha = 0;
		// add(bgFade);

		// new FlxTimer().start(0.83, function(tmr:FlxTimer)
		// {
		//	bgFade.alpha += (1 / 5) * 0.7;
		//	if (bgFade.alpha > 0.7)
		//		bgFade.alpha = 0.7;
		// }, 5);

		box = new FlxSprite(-20, 370);

		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'rise':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, false);

			case 'pissed':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24, false);

			case 'rebel':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking');
				box.animation.addByPrefix('normalOpen', 'speech bubble loud open', 24, false);
				box.animation.addByPrefix('normal', 'AHH speech bubble', 24, false);
		}

		this.dialogueList = dialogueList;

		if (!hasDialog)
			return;

		portraitLeft = new FlxSprite(-20, 40);
		portraitLeft.frames = Paths.getSparrowAtlas('dialog/left_side');
		portraitLeft.animation.addByPrefix('salty', 'CYRIL_salty ', 24, false);
		portraitLeft.animation.addByPrefix('scorn', 'CYRIL_scorn ', 24, false);
		portraitLeft.animation.addByPrefix('grudge', 'CYRIL_grudge ', 24, false);
		portraitLeft.animation.addByPrefix('shock', 'CYRIL_shock ', 24, false);
		portraitLeft.animation.addByPrefix('SHAME', 'CYRIL_SHAME ', 24, false);
		portraitLeft.animation.addByPrefix('grudge(sigh)', 'CYRIL_grudge(sigh) ', 24, false);
		portraitLeft.animation.addByPrefix('ANGER', 'CYRIL_ANGER ', 24, false);
		portraitLeft.animation.addByPrefix('baffled(mic)', 'CYRIL_baffled(mic) ', 24, false);
		portraitLeft.animation.addByPrefix('hubris', 'CYRIL_hubris ', 24, false);
		portraitLeft.animation.addByPrefix('fierce', 'CYRIL_fierce ', 24, false);
		portraitLeft.animation.addByPrefix('CRAZED', 'CYRIL_CRAZED ', 24, false);
		portraitLeft.animation.addByPrefix('CRAZED(gun)', 'CYRIL_CRAZED(gun) ', 24, false);
		portraitLeft.animation.addByPrefix('CRAZED_fierce', 'CYRIL_CRAZED_fierce ', 24, false);

		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(750, 40);
		portraitRight.frames = Paths.getSparrowAtlas('dialog/right_side');
		portraitRight.animation.addByPrefix('CASS_EXTRA_SMUG', 'CASS_EXTRA_SMUG', 24, false); // offset -150
		portraitRight.animation.addByPrefix('approves', 'PICO_approves', 24, false);
		portraitRight.animation.addByPrefix('determined', 'PICO_determined', 24, false);
		portraitRight.animation.addByPrefix('friends', 'PICO_friends', 24, false);
		portraitRight.animation.addByPrefix('greet', 'PICO_greet', 24, false);
		portraitRight.animation.addByPrefix('hand_pistols', 'PICO_hand_pistols', 24, false);
		portraitRight.animation.addByPrefix('mic_throw', 'PICO_mic_throw', 24, false);
		portraitRight.animation.addByPrefix('panicking', 'PICO_panicking', 24, false);
		portraitRight.animation.addByPrefix('worried', 'PICO_worried', 24, false);

		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		add(portraitRight);
		portraitRight.visible = false;

		box.animation.play('normalOpen');
		// box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9)); // pixel zoom
		box.updateHitbox();
		add(box);

		if (PlayState.SONG.song.toLowerCase() == 'rebel')
		{
			box.setPosition(0, 330);
		}
		else
		{
			box.setPosition(0, 390);
		}

		// box.setPosition(0, 390);
		// box.screenCenter(X);
		// portraitLeft.screenCenter(X);

		if (!talkingRight)
		{
			box.flipX = true;
		}

		swagDialogue = new FlxTypeText(90, 498, Std.int(FlxG.width * 0.8), "", 52);
		swagDialogue.font = 'PhantomMuff 1.5';
		swagDialogue.color = FlxColor.BLACK;
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		dialogue.x = 90;
		add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			// dropText.color = FlxColor.BLACK;
		}

		// dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}
                #if mobile
		var justTouched:Bool = false;

		for (touch in FlxG.touches.list)
		{
			justTouched = false;
			
			if (touch.justReleased){
				justTouched = true;
			}
		}
		
		if (FlxG.keys.justPressed.ANY #if mobile || justTouched #end && dialogueStarted == true)
		{
			remove(dialogue);

			var random1t5 = FlxG.random.int(1, 5);

			switch (random1t5)
			{
				case 1:
					FlxG.sound.play(Paths.sound('clickText1'), 0.3);
				case 2:
					FlxG.sound.play(Paths.sound('clickText2'), 0.3);
				case 3:
					FlxG.sound.play(Paths.sound('clickText3'), 0.3);
				case 4:
					FlxG.sound.play(Paths.sound('clickText4'), 0.3);
				case 5:
					FlxG.sound.play(Paths.sound('clickText5'), 0.3);
			}

			// fix
			portraitLeft.visible = false;
			portraitRight.visible = false;

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					// stop voice acting
					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}

					// if (PlayState.SONG.song.toLowerCase() == 'rise' || PlayState.SONG.song.toLowerCase() == 'pissed')
					// FlxG.sound.music.fadeOut(2.2, 0);

					FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						// bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;

						swagDialogue.alpha -= 1 / 5;
						// dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		// THIS IS IT
		switch (curCharacter)
		{
			// DIALOG CODE
			case '1d1':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.offset.set(-30);
					portraitLeft.visible = true;
					box.flipX = true;
					portraitLeft.animation.play('scorn', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '1d2':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.offset.set(0, -50);
					portraitRight.visible = true;
					box.flipX = false;
					portraitRight.animation.play('greet', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '1d3':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.offset.set(180, -50);
					portraitRight.visible = true;
					box.flipX = false;
					portraitRight.animation.play('friends', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '1d4':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.offset.set(-30, 70);
					portraitLeft.visible = true;
					box.flipX = true;
					portraitLeft.animation.play('grudge', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '1d5':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.offset.set(-10, 20);
					portraitLeft.visible = true;
					box.flipX = true;
					portraitLeft.animation.play('shock', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '1d6':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.offset.set(170);
					portraitRight.visible = true;
					box.flipX = false;
					portraitRight.animation.play('CASS_EXTRA_SMUG', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '1d7':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.offset.set(-50, 70);
					portraitLeft.visible = true;
					box.flipX = true;
					portraitLeft.animation.play('SHAME', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '1d8':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.offset.set(-50, 0);
					portraitLeft.visible = true;
					box.flipX = true;
					portraitLeft.animation.play('grudge(sigh)', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '1d9':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					// portraitLeft.offset.set(0, 0);
					portraitLeft.visible = true;
					box.flipX = true;
					portraitLeft.animation.play('ANGER', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '1d10':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.offset.set(-100, -50);
					portraitRight.visible = true;
					box.flipX = false;
					portraitRight.animation.play('worried', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '1d11':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.offset.set(50, -50);
					portraitRight.visible = true;
					box.flipX = false;
					portraitRight.animation.play('mic_throw', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '1d12':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					// portraitLeft.offset.set(0, 0);
					portraitLeft.visible = true;
					box.flipX = true;
					portraitLeft.animation.play('baffled(mic)', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '1d13':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.offset.set(0, 100);
					portraitLeft.visible = true;
					box.flipX = true;
					portraitLeft.animation.play('hubris', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '1d14':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.offset.set(-20, -50);
					portraitRight.visible = true;
					box.flipX = false;
					portraitRight.animation.play('hand_pistols', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '2d1':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					// portraitLeft.offset.set(0, 0);
					portraitLeft.visible = true;
					box.flipX = true;
					portraitLeft.animation.play('baffled(mic)', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '2d2':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.offset.set(-70, 50);
					portraitLeft.visible = true;
					box.flipX = true;
					portraitLeft.animation.play('salty', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '2d3':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.offset.set(-100, -50);
					portraitRight.visible = true;
					box.flipX = false;
					portraitRight.animation.play('approves', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '2d4':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.offset.set(30);
					portraitLeft.visible = true;
					box.flipX = true;
					portraitLeft.animation.play('fierce', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '3d0':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.offset.set(-50);
					portraitLeft.visible = true;
					box.flipX = false;
					portraitLeft.animation.play('CRAZED', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '3d1':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.offset.set(-50);
					portraitLeft.visible = true;
					box.flipX = false;
					portraitLeft.animation.play('CRAZED', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '3d2':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					FlxG.sound.play(Paths.sound('gunOut'), 1.1);
					portraitLeft.offset.set(-50);
					portraitLeft.visible = true;
					box.flipX = false;
					portraitLeft.animation.play('CRAZED(gun)', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '3d3':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.offset.set(-20, -50);
					portraitRight.visible = true;
					box.flipX = true;
					portraitRight.animation.play('panicking', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '3d4':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.offset.set(-100, -50);
					portraitRight.visible = true;
					box.flipX = true;
					portraitRight.animation.play('worried', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '3d5':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.offset.set(-50);
					portraitLeft.visible = true;
					box.flipX = false;
					portraitLeft.animation.play('CRAZED_fierce', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
			case '3d6':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.offset.set(-100, -50);
					portraitRight.visible = true;
					box.flipX = true;
					portraitRight.animation.play('determined', true);

					if (curSound != null && curSound.playing)
					{
						curSound.stop();
					}
					curSound = new FlxSound().loadEmbedded(Paths.sound(curCharacter));
					// curSound.volume = 1;
					curSound.play();
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
