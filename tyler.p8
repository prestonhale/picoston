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
    poopagain_t_max=25,
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
    dmg=25
}

function poop:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function poop:draw()
   spr(70,self.x,self.y)   
end

function poop:update()
    
    self.x+=2
       for k,v in pairs(self.collider.colliding_with) do
        if not k.is_friendly then 
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
    add(objects,poop)
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
        self.collider:can_move(self)
    end

    if self.timer>=5 then 
        self.x+=self.speed*4
    end
    
    if self.collider then self.collider:update() end
    remove_if_out_of_bounds(self)
end