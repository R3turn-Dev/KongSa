######################
# Global Variable
######################

store_value("interval.tpa", 15)
store_value("chat.prefix", json_encode(array(true:'  &c&lOP  ', false:' &aUSER &f')))
if(!has_value("commandfeedback.list")){ store_value("commandfeedback.list", json_encode(array())) }
tmsg(~console, "[ ProtectWorld ] Debugging: ".has_value(GLOBAL.DEBUGGING))


######################
# Monitors
######################

bind(player_command, array(priority: monitor), null, @e) {
    @feedback = json_decode(get_value("commandfeedback.list"))
    foreach(@user in @feedback) {
        if(ponline(@user)) {
            tmsg(@user, colorize('&a  [ CommandFeedBack ] &f'.@e['player'].' &c> &f'.@e['command']))
            play_sound(ploc(@user), array(sound:"ITEM_PICKUP", volume:100, pitch:1), @user)
        }
    }
}


######################
# Chat Management
######################

bind(player_chat, null, null, @e) {
    @pl = @e['player']
    @op = pisop(@pl)
    @prefix = json_decode(get_value('chat.prefix'))[@op]

    array_push(@e['recipients'], '~console')
    foreach(@user in @e['recipients']) {
        try(
            tmsg(@user, colorize(sprintf(@prefix.' %1$s > &f%2$s', @pl, replace(@e['message'], "&", "&&") ) ) )
        , @e, null)
    }
    cancel()
}


######################
# Tpa Delay
######################

bind(player_command, null, null, @e) { if(@e['prefix'] == '/tpa' || @e['prefix'] == '/tpahere' || @e['prefix'] == '/tpaall') {
	@pl = @e['player']
	@pl_d = to_lower(@pl)

	@available_interval = get_value("interval.tpa")

	if(!has_value(sprintf('%s.last_tpa', @pl_d))) {
		store_value( sprintf('%s.last_tpa', @pl_d) , 0)
	}

	@last = get_value(sprintf('%s.last_tpa', @pl_d))
	@now = time()
	@elapsed = (@now - @last) / 1000

	if(@elapsed < @available_interval) {
		cancel()
		tmsg(@pl, colorize(' [ &cTPA Interval&f ] &a'.sprintf('%.2f', @available_interval-@elapsed).'초&f 후에 다시 사용가능합니다.'))
	} else {
		store_value(sprintf('%s.last_tpa', @pl_d), @now)
	}
}}


######################
# Amusing when death
######################

bind(player_death, null, null, @e) {
	sudo('/title '.@e['player'].' times 10 40 10')
	sudo('/title '.@e['player'].' title {"text":"","extra":[{"text":"죽다니 "},{"text":"한심","color":"red","bold":"true"},{"text":"하군요. :D"}]}')
}


####################
#  Anti Explosion  #
####################

# Disabled all the explosion
bind(entity_explode, array(priority: HIGHEST), null, @event,
	if(@event['location']['world'] == 'world') {
		cancel()
		if(has_value(GLOBAL.DEBUGGING)){tmsg(~console, "[ ProtectWorld ] Entity exploded at X".@event['location']['x']." Y".@event['location']['y']." Z".@event['location']['z'])}
	}
)

# Canceled entity damage on explosion
bind(entity_damage, array(priority: HIGHEST), null, @event,
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
bind(block_ignite, array(priority: HIGHEST), null, @event,
	if(@event['location']['world'] == 'world') {
		if(has_value(GLOBAL.DEBUGGING)){tmsg(~console, "[ ProtectWorld ] Block ignited at X".@event['location']['x']." Y".@event['location']['y']." Z".@event['location']['z'])}
	}
)

# No spawning explosive entity
bind(creature_spawn, array(priority: HIGHEST), null, @event,
	if(@event['location']['world'] == 'world') {
		if(@event['type'] == 'WITHER') {
			cancel()
			if(has_value(GLOBAL.DEBUGGING)){tmsg(~console, "[ ProtectWorld ] Created WitherBoss at X".@event['location']['x']." Y".@event['location']['y']." Z".@event['location']['z'])}
		}
	}
)



####################
# Entrance Message #
####################

bind(player_join, null, null, @e) {
    if(has_value("broadcast")) {
        @msg = json_decode(get_value("broadcast"))

        sudo('/title '.@e['player'].' times 10 50 10')
        if(@msg['title']) {
            sudo('/title '.@e['player'].' title '.@msg['title'])
            if(@msg['subtitle']) {
                sudo('/title '.@e['player'].' subtitle '.@msg['subtitle'])
            }
        }
    }
}