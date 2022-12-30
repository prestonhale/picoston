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
    health=100,
    max_health=100,
    x=127,
    y=0,
    sprite_timer=0,
    lane_index=lane_index,
    dmg=2
}

function enemy:new(e)
    e = e or {}
    setmetatable(e, self)
    self.__index = self
    e.colliding = {}
    return e
end

function enemy:do_damage(coll)
    if not coll.is_friendly then return end
    coll.health -= self.dmg
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
        self.x -= 0.5
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
        rect(self.x+4,self.y-5,self.x+15,self.y-3,7)
        length = convert(self.health,0,self.max_health,0,10)
        if length < 0 then
            length=0
        end
        line(self.x+5,self.y-4,self.x+14,self.y-4,6)
        line(self.x+5,self.y-4,self.x+5+length,self.y-4,8)
    end
    spr(self.sprite, self.x,self.y, 2, 2)
end

enemy_spawner = {
    -- config
    chance_to_spawn = 0.02,
    enemy_sprite = 128,

    -- state
    time_since_spawn = 0,
    update = function(self)
        self.time_since_spawn +=1

        if self.time_since_spawn < 20 then -- don't spawn too fast
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
        e = enemy:new()
        e.collider = collider:new()
        e.lane_index = flr(rnd(5)+1)
        add(objects, e)
    end
}