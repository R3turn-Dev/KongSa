####################
#      Global      #
####################

store_value("interval.tpa", 15)
store_value("chat.prefix", json_encode(array(true:'  &c&lOP  ', false:' &aUSER &f')))
tmsg(~console, "[ ProtectWorld ] Debugging: ".has_value(GLOBAL.DEBUGGING))


####################
#  Anti Explosion  #
####################

# Disabled all the explosion
bind(entity_explode, null, null, @event,
	if(@event['location']['world'] == 'world') {
		cancel()
		if(has_value(GLOBAL.DEBUGGING)){tmsg(~console, "[ ProtectWorld ] Entity exploded at X".@event['location']['x']." Y".@event['location']['y']." Z".@event['location']['z'])}
	}
)

# Canceled entity damage on explosion
bind(entity_damage, null, null, @event,
	if(@event['location']['world'] == 'world') {
		if(@event['cause'] == 'BLOCK_EXPLOSION') {
			if(has_value(GLOBAL.DEBUGGING)){tmsg(~console, "[ ProtectWorld ] Player Damaged by block explosion at X".@event['location']['x']." Y".@event['location']['y']." Z".@event['location']['z'])}
			cancel()
		}
		if(@event['cause'] == 'ENTITY_EXPLOSION') {
			if(has_value(GLOBAL.DEBUGGING)){tmsg(~console, "[ ProtectWorld ] Player Damaged by entity explosion at X".@event['location']['x']." Y".@event['location']['y']." Z".@event['location']['z'])}
			cancel()
		}
	}
)

# No ignite
bind(block_ignite, null, null, @event,
	if(@event['location']['world'] == 'world') {
		if(has_value(GLOBAL.DEBUGGING)){tmsg(~console, "[ ProtectWorld ] Block ignited at X".@event['location']['x']." Y".@event['location']['y']." Z".@event['location']['z'])}
	}
)

# No spawning explosive entity
bind(creature_spawn, null, null, @event,
	if(@event['location']['world'] == 'world') {
		if(@event['type'] == 'WITHER') {
			cancel()
			if(has_value(GLOBAL.DEBUGGING)){tmsg(~console, "[ ProtectWorld ] Created WitherBoss at X".@event['location']['x']." Y".@event['location']['y']." Z".@event['location']['z'])}
		}
	}
)

####################
#      Utility     #
####################

#bind(player_toggle_flight, null, null, @e,
	# broadcast(@e)
#)





####################
#     AdvLogger    #
####################
/*
bind(player_interact, null, array(item: 288), @e,
	@pl = @e['player']
	if(pisop(@pl)) {
		if(@e['action'] == 'right_click_block' || @e['action'] == 'right_click_air') {
			if(has_value(@pl.block_inspect)) {
				clear_value(@pl.block_inspect)
				tmsg(@pl, colorize(' [ Block Inspect ] 블록 보기 모드가 &c해제&f되었습니다.'))
			} else {
				store_value(@pl.block_inspect, 1)
				tmsg(@pl, colorize(' [ Block Inspect ] 블록 보기 모드가 &b설정&f되었습니다.'))
			}
		}
	}
)

bind(player_interact, null, null, @e) {
	@pl = @e['player']
	if(@e['item'] != "288:0" && has_value(@pl.block_inspect)) {
		@loc = array (
			w: @e['location']['world'],
			x: @e['location']['x'],
			y: @e['location']['y'],
			z: @e['location']['z']
		)
		if(import(@loc)) {
			tmsg(@pl, import(@loc))
		} else {
			tmsg(@pl, "None")
		}
	}
}

bind(block_break, null, null, @e,
	@loc = array(
		w: @e['location']['world'],
		x: @e['location']['x'],
		y: @e['location']['y'],
		z: @e['location']['z']
	)
	@info = array(
		block: @e['block']['type'],
		player: @e['player'],
		time: time(),
		ntime: nano_time()
	)
	@info_s  = 'EVENT:BLOCK_BREAK'
	@info_s .= ', block:'.@info['block']
	@info_s .= ', player:'.@info['player']
	@info_s .= ', block:'.@info['block']
	@info_s .= ', time:'.@info['time']
	@info_s .= ', ntime:'.@info['ntime']
	
	try(
		@legacy = import(@loc)
		broadcast(@legacy)
		array_push(@legacy, @info)
		export(@loc, @legacy)
	, @ex,
		tmsg(@pl, @ex)
	)
)

bind(block_place, null, null, @e,
	@loc = array(
		w: @e['location']['world'],
		x: @e['location']['x'],
		y: @e['location']['y'],
		z: @e['location']['z']
	)
	@info = array(
		block: @e['type'],
		player: @e['player'],
		time: time(),
		ntime: nano_time()
	)
	@info_s  = 'EVENT:BLOCK_PLACE'
	@info_s .= ', block:'.@info['block']
	@info_s .= ', player:'.@info['player']
	@info_s .= ', block:'.@info['block']
	@info_s .= ', time:'.@info['time']
	@info_s .= ', ntime:'.@info['ntime']
	
	try(
		@legacy = import(@loc)
		broadcast(@legacy)
		array_push(@legacy, @info)
		export(@loc, @legacy)
	, @ex,
		tmsg(@pl, @ex)
	)
)
*/


####################
#      Jailing     #
####################


/* bind(player_chat, null, null, @e,
	@pl = @e['player']
	@pl_d = to_lower(@pl)
	
	if(has_value(@pl_d.mute)) {
		@duration = get_value(@pl_d.mute.duration)
		@started = get_value(@pl_d.mute.time)
		@remaining = @duration - (nano_time() - @started)/1000000000
		
		if(@remaining > 0) {
			cancel()
			@reason = get_value(@pl_d.mute.reason)
			
			tmsg(@pl, colorize('&c[ MUTED ] &f당신은 &c뮤트&f처리되었습니다.'))
			tmsg(@pl, colorize('  - 남은 시간: '.@remaining))
			tmsg(@pl, colorize('  - 이유: '.@reason))
		} else {
			clear_value(@pl_d.mute)
			clear_value(@pl_d.mute.duration)
			clear_value(@pl_d.mute.time)
			clear_value(@pl_d.mute.operator)
			clear_value(@pl_d.mute.reason)
		}
	}
) */


####################
#      Utility     #
####################


bind(player_command, null, null, @e) { if(@e['prefix'] == '/tpa' || @e['prefix'] == '/tpahere' || @e['prefix'] == '/tpaall') {

	@pl = @e['player']
	@pl_d = to_lower(@pl)
	
	@available_interval = get_value("interval.tpa")
	
	if(!has_value(@pl_d.last_tpa)) {
		store_value(@pl_d.last_tpa, 0)
	}
	
	@last = get_value(@pl_d.last_tpa)
	@now = time()
	@elapsed = (@now - @last) / 1000
	
	if(@elapsed < @available_interval) {
		cancel()
		tmsg(@pl, colorize(' [ &cTPA Interval&f ] &a'.(@available_interval-@elapsed).'초&f 후에 다시 사용가능합니다.'))
	} else {
		store_value(@pl_d.last_tpa, @now)
	}
}}

bind(player_death, null, null, @e) {
	sudo('/title '.@e['player'].' time 10 40 10')
	sudo('/title '.@e['player'].' title {"text":"","extra":[{"text":"죽다니 "},{"text":"한심","color":"red","bold":"true"},{"text":"하군요. :D"}]}')
}

bind(async_player_chat, null, null, @e) {
	cancel()

	@index = pisop(@e['player'])
	@msg = json_decode(get_value('chat.prefix'))[@index].@e['player'].'&f > '.@e['message']
	foreach(@user in @e['recipients']) {
		tmsg(@user, colorize(@msg))
	}
}

bind(player_command, null, null, @e) {
    @feedback = json_decode(get_value("commandfeedback.list"))
    foreach(@user in @feedback) {
        if(ponline(@user)) {
            tmsg(@user, colorize('&a  [ CommandFeedBack ] &f'.@e['player'].' &c> &f'.@e['command']))
            play_sound(ploc(@user), array(sound:"ITEM_PICKUP", volume:100, pitch:1), @user)
        }
    }
}