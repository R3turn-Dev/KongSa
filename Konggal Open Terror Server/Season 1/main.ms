tmsg(~console, "[ ProtectWorld ] Debugging: ".has_value(GLOBAL.DEBUGGING))

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