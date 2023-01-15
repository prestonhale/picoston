pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

function init_tyler(objects)
end

monkey=animal:new{ 
    x=new_x,
    y=new_y,
    sprite=98,
    timer=0,
    is_friendly=true,
    pwidth=9,
    cost=1,
    poop=false,
    poopagain_t=0,
    poopagain_t_max=30,
    dmg=0,
    health=30,
    max_health=30
}

function monkey:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function monkey:draw()
    sspr(((self.sprite% 16)*8), (flr(self.sprite/16)*8),16,16,self.x,self.y,8,8)
    if self.timer==18 then 
        if self.sprite==98 then
            self.sprite=100
        elseif self.sprite==100 then
            self.sprite=98        
        end
        self.timer=0 
    end
end

function monkey:update()
    local can_move = self.collider:can_move(self)
    self.poopagain_t+=1
    if can_move then
        self.x+=0.5
    end
    if not can_move and not self.poop then
        new_poop(self.x,self.lane_index)
        self.poop=true 
        self.poopagain_t=0    
    end
    
    if self.poopagain_t>=self.poopagain_t_max then
        self.poop=false
    end

    self.y=.5*(sin(self.x/40))+get_lane_y(self.lane_index)+8
    self.timer+=1

    if self.health < self.max_health and not self.show_health then
        self.show_health = true
        add_health_bar(self,-1,-4,9,1,3)
    end

    if self.health <=0 then
        self.show_health = false
        del(objects, self)
    end

    self.collider:update()
    remove_if_out_of_bounds(self)
end

poop={
    is_friendly_projectile=true,
    pwidth=5,  
    dmg=10,
    grav=0.1,
    angle=0.90
}

function poop:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function poop:draw()
    ovalfill(self.x+3,get_lane_y(self.lane_index)+13,self.x+6,get_lane_y(self.lane_index)+16,5)
    spr(70,self.x,self.y)   
end

function poop:update()
    
    --self.x+=2
    self.x+=self.x_speed
    self.y+=self.y_speed
    self.y_speed+=self.grav

    for k,v in pairs(self.collider.colliding_with) do
        if not k.is_friendly and not k.is_friendly_projectile then 
            self.do_damage(self,k)
            del(objects,self)
        end
    end
    self.collider:update()
    remove_if_out_of_bounds(self)
end

function poop:do_damage(coll)
    if coll.is_friendly or coll.is_friendly_projectile then return end
    coll.health -= self.dmg
end

function new_poop(new_x,lane_index)
    local poop = poop:new()
    poop.y=get_lane_y(lane_index)
    poop.x=new_x
    poop.lane_index=lane_index
    poop.collider = collider:new()
    poop.x_final = get_closest_enemy_x(poop.x,lane_index)

    -- if an enemy was found
    if poop.x_final != -1 then

        distance = poop.x_final - poop.x
        velocity = sqrt( (distance*poop.grav*4) / 2*sin(poop.angle)*cos(poop.angle) )
        debug=2*sin(poop.angle)*cos(poop.angle)

        poop.x_speed = cos(poop.angle) * velocity
        poop.y_speed = sin(poop.angle) * velocity * -1

        add(objects,poop)
    end
end

------------------------------------------------

blue_whale=animal:new{ 
    x=new_x,
    y=new_y,
    sprite=102,
    timer=0,
    is_friendly=true, --might need to change this back to true 
    pwidth=115,
    cost=0,
    dmg=999,
    speed=1,
    health=1000000,
    max_health=1000000,
    high_y=0,
    lane_index=lane_index

}

function blue_whale:_init()
    local lane_y = get_lane_y(self.lane_index)
    self.high_y=lane_y-12-120
    self.collider=nil
end


function blue_whale:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self  
    return obj
end


function blue_whale:draw()
    sspr(((self.sprite% 16)*8), (flr(self.sprite/16)*8),48,16,self.x-5,self.high_y,140,32)
    -- if self.timer==18 then 
    --     if self.sprite==102 then
    --         self.sprite=102
    --     elseif self.sprite==102 then
    --         self.sprite=102        
    --     end
    -- end
end


function blue_whale:update()
    if self.high_y < get_lane_y(self.lane_index)-12 then 
        self.high_y+=self.speed*8
    end    

    if self.high_y>=get_lane_y(self.lane_index)-12 then
        self.timer+=1
        if not self.collider then self.collider=collider:new() end
        can_move, coll = self.collider:can_move(self)
        if coll then
            blue_whale:do_damage(coll)
        end
    end

    if self.timer>=5 then 
        self.x+=self.speed*4
    end
    
    if self.collider then self.collider:update() end
    remove_if_out_of_bounds(self)
end

------------------------------------------------------------------------
enemy_fat = {
    -- static --
    sprite_1 = 73,
    sprite_2 = 75,

    is_friendly=false,

    is_collideable = true,
    damage = 1,

    -- not static ---
    sprite = 73,
    health=150,
    max_health=150,
    x=127,
    y=0,
    sprite_timer=0,
    lane_index=lane_index,
    dmg=2
}


function enemy_fat:new(e)
    e = e or {}
    setmetatable(e, self)
    self.__index = self
    e.colliding = {}
    return e
end

function enemy_fat:do_damage(coll)
    if not coll.is_friendly or win then return end
    coll.health -= self.dmg
end

function enemy_fat:update()
    local can_move = true
    for k,v in pairs(self.collider.colliding_with) do
        self.do_damage(self, k)
        if k.is_friendly then 
            can_move = false
        end
        if not k.is_friendly and k.x<self.x and not k.is_gate then
            can_move = false
        end
    end

    if can_move then
        self.x -= 0.125
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

    if self.health < self.max_health and not self.show_health then
        self.show_health = true
        add_health_bar(self,5,-4,9,1,8)
    end
    
    if self.health <=0 then
        self.show_health = false
        del(objects, self)
    end

    self.collider:update()
    remove_if_out_of_bounds(self)
end

function enemy_fat:draw()
    spr(self.sprite, self.x,self.y, 2, 2)
end

enemy_fat_spawner = {
    -- config
    chance_to_spawn = 0.02,
    enemy_sprite = 128,
    spawn_speed = 20,

    -- state
    time_since_spawn = 0,
    update = function(self)
        self.time_since_spawn +=1

        if self.time_since_spawn < self.spawn_speed then -- don't spawn too fast
            return
        end 

        if rnd(1) < self.chance_to_spawn then
            self.spawn_enemy_fat(self)
            self.time_since_spawn = 0
        end
    end,
    draw = function(self)
    end,
    spawn_enemy_fat = function(self)
        e = enemy_fat:new()
        e.collider = collider:new()
        e.lane_index = flr(rnd(5)+1)
        add(objects, e)
    end
}

function before_game()
    cls()
    print("press x to start game", 5, 20)
end
