pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

enemy = {
    -- static --
    sprite_1 = 128,
    sprite_2 = 130,

    is_friendly=false,

    is_collideable = true,
    damage = 1,

    -- not static ---
    sprite = 128,
    colliding = {},
    health=100,
    x=127,
    y=0,
    sprite_timer=0,
    lane_index=lane_index
}

function enemy:new(e)
    e = e or {}
    setmetatable(e, self)
    self.__index = self
    return e
end

function enemy:do_damage(coll)
end

function enemy:update()
    local can_move = true
    for k,v in pairs(self.collider.colliding_with) do
        self.do_damage(self, k)
        if k.is_friendly then 
            can_move = false
        end
        if not k.is_friendly and k.x<self.x then
            can_move = false
        end
    end

    if can_move then
        self.x -= 1
    end

    self.y = get_lane_y(self.lane_index)+3
    self.sprite_timer += 1
    if self.sprite_timer > 10 then
        if self.sprite == self.sprite_1 then
            self.sprite = self.sprite_2
        elseif self.sprite == self.sprite_2 then
            self.sprite = self.sprite_1 
        end
        self.sprite_timer = 0
    end

    self.collider:update()
    
    if self.health <=0 then
        del(objects, self)
    end

    remove_if_out_of_bounds(self)
end

function convert(val,s1,e1,s2,e2)
	prop=(val-s1)/(e1-s1)
	return prop*(e2-s2)+s2
end

function enemy:draw()
    if self.health<100 then
        rect(self.x+1,self.y-5,self.x+16,self.y-3,7)
        length = convert(self.health,0,100,0,13)
        line(self.x+2,self.y-4,self.x+2+length,self.y-4,8)
    end
    spr(self.sprite, self.x,self.y, 2, 2)
end

enemy_spawner = {
    -- config
    chance_to_spawn = 0.03,
    enemy_sprite = 128,

    -- state
    time_since_spawn = 0,
    update = function(self)
        self.time_since_spawn +=1

        if self.time_since_spawn < 10 then -- don't spawn too fast
            return
        end 

        if rnd(1) < self.chance_to_spawn then
            self.spawn_enemy(self)
            self.time_since_spawn = 0
        end
    end,
    draw = function(self)
    end,
    spawn_enemy = function(self)
        local e = {lane_index = flr(rnd(5))+1}
        e = enemy:new(e)
        e.collider = collider:new()
        add(objects, e)
    end
}