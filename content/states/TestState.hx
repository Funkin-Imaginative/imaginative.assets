import imaginative.states.TitleScreen;

var p1:Character;
var p2:Character;

function render(?event):Void {
	conductor.reset();
	var song:String = 'Eggnog';
	var variant:String = 'erect';
	conductor.loadSong(song, variant, (_:FlxSound) -> {
		conductor.addVocalTrack(song, '', variant);
		conductor.addVocalTrack(song, 'Enemy', variant);
		conductor.addVocalTrack(song, 'Player', variant);
		conductor.play();

	});
}

function create():Void {
	render();
	conductor._onComplete = render;
	add(p1 = new Character(0, 0, 'boyfriend', true));
	p1.screenCenter();
	p1.x += 300;
	add(p2 = new Character(0, 0, 'boyfriend'));
	p2.screenCenter();
	p2.x -= 300;
}

var anims:Array<String> = ['left', 'down', 'up', 'right'];

var binds:Int->Bool = (dir:Int, is2:Bool) -> {
	var controls:Controls = (is2 ?? false) ? Controls.p2 : Controls.p1;
	return [controls.noteLeft, controls.noteDown, controls.noteUp, controls.noteRight][dir];
}
var bindsHeld:Int->Bool = (dir:Int, is2:Bool) -> {
	var controls:Controls = (is2 ?? false) ? Controls.p2 : Controls.p1;
	return [controls.noteLeftHeld, controls.noteDownHeld, controls.noteUpHeld, controls.noteRightHeld][dir];
}

function update(elapsed:Float):Void {
	for (char in [p1, p2]) {
		for (i => name in anims) {
			if (binds(i, char == p2)) {
				char.playAnim('sing' + name.toUpperCase(), true, 'IsSinging');
				char.lastHit = conductor.time;
			}
			if (bindsHeld(i, char == p2)) {
				char.lastHit = conductor.time;
				if (char.getAnimName() != ('sing' + name.toUpperCase())) {
					char.playAnim('sing' + name.toUpperCase(), true, 'IsSinging');
				}
			}
			if (FlxG.keys.justPressed.SPACE)
				char.playAnim('hey', true, 'NoSinging');
		}
	}

	if (Controls.back)
		BeatState.switchState(() -> new TitleScreen());
}