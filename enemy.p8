pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

enemy_type = {
    sprite_1 = 128,
    sprite_2 = 130,

    is_friendly=false,

    is_collideable = true,
    damage = 1,

    collide = function(self, other)
        self.colliding[other] = 1
    end,

    update = function(self)
        local can_move=true
        for k,v in pairs(self.colliding) do
            self.do_damage(self, k)
            if k.type.is_friendly then 
                can_move = false
            end
            if not k.type.is_friendly and k.x<self.x then
                can_move = false
            end
        end

        if can_move then
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
        
        self.colliding = {}
        
        if self.health <=0 then
            del(objects, self)
        end
        remove_if_out_of_bounds(self)
        
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

            if self.time_since_spawn < 8 then -- don't spawn too fast
                return
            end 

            if rnd(1) < self.chance_to_spawn then
                self.spawn_enemy(self)
                self.time_since_spawn = 0
            end
        end,
        draw = function(self)
        end
    },
    spawn_enemy = function(self)
        lane_index = flr(rnd(6))
        enemy = {
            sprite = enemy_type.sprite_1,
            colliding = {},
            health=100,
            x=100,
            y=0,
            sprite_timer=0,
            lane_index=lane_index,
            type=enemy_type
        }

        function enemy:do_damage(coll) 

        end 

        add(objects, enemy)
    end, 
}