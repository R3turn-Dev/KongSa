proc(_random_teleport, @player, @tp) {
    if(ponline(@player)) {
        @x = round(rand()*1000000) % 3000
        @z = round(rand()*1000000) % 3000
        @y = get_highest_block_at(@x, @z, ploc(@player)['world'])['y']

        if(@tp) {
            set_ploc(
                @player, @x, @y, @z
            )
        } else {
            return(array(0: @x, 1: @y, 2: @z, 3: ploc(@player)['world'], 4: 0.0, 5: 0.0, pitch: 0.0, x: @x, y: @y, z: @z, world: ploc(@player)['world'], yaw:0.0))
        }
    } else {
        @x = round(rand()*1000000) % 3000
        @z = round(rand()*1000000) % 3000
        @y = get_highest_block_at(@x, @z, 'world')['y']

        return(array(0: @x, 1: @y, 2: @z, 3: 'world', 4: 0.0, 5: 0.0, pitch: 0.0, x: @x, y: @y, z: @z, world: 'world', yaw:0.0))
    }
}