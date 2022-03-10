package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class MenuCharacter extends FlxSprite
{
	public var character:String;

	public function new(x:Float, character:String = 'bf')
	{
		super(x);

		this.character = character;

		var tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		frames = tex;

		animation.addByPrefix('bf', "BF Idle dance white", 24);
		animation.addByPrefix('bfConfirm', 'BF HEY!!', 24, false);
		animation.addByPrefix('gf', "GF Dancing Beat white", 24);
		animation.addByPrefix('cyril', "Cyril Idle dance blackline", 24);

		animation.play(character);
		updateHitbox();
	}
}
