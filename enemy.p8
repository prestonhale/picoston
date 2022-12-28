pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

enemy_type = {
    sprite_1 = 128,
    sprite_2 = 130,

    collide = function(self)
        for i=1,#objects do
            other = objects[i]
            if other != self 
                and other.type.collideable
                and self.x < other.x + 16 
                and self.x + 16 > other.x
                and self.y < other.y + 16
                and self.y + 16 > other.y
            then
                -- del(objects, self)
                self.colliding = true
                other.type.collide(other, self)
                return
            end
        end
    end,

    update = function(self)
        if not self.colliding then
            self.x -= 1
        end
        self.y = get_lane_y(self.lane_index)+3
        self.sprite_timer += 1
        if self.sprite_timer > 10 then
            if self.sprite == self.type.sprite_1 then
                self.sprite = self.type.sprite_2
            elseif self.sprite == self.type.sprite_2 then
                self.sprite = self.type.sprite_1 
            end
            self.sprite_timer = 0
        end
        self.type.collide(self)
    end,

    draw = function(self)
        spr(self.sprite, self.x, get_lane_y(self.lane_index)+3, 2, 2)
    end
}

enemy_spawner = {
    -- config
    chance_to_spawn = 0.03,
    enemy_sprite = 128,

    -- state
    time_since_spawn = 0,
    type = {
        update = function(self)
            self.time_since_spawn +=1

            -- if self.time_since_spawn < 8 then -- don't spawn too fast
            --     return
            -- end 

            if rnd(1) < self.chance_to_spawn then
                self.spawn_enemy(self)
                time_since_spawn = 0
            end
        end,
        draw = function(self)
        end
    },
    spawn_enemy = function(self)
        lane_index = flr(rnd(6))
        enemy = {
            sprite = enemy_type.sprite_1,
            colliding = false,
            x=100,
            y=0,
            sprite_timer=0,
            lane_index=lane_index,
            type=enemy_type
        }
        add(objects, enemy)
    end, 
}