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
    if self.health<self.max_health then
        rect(self.x-5,self.y-5,self.x+6,self.y-3,7)
        length = convert(self.health,0,self.max_health,0,10)
        line(self.x-4,self.y-4,self.x+5,self.y-4,6)
        line(self.x-4,self.y-4,self.x-4+length,self.y-4,3)
    end
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
        self.x+=1
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

    if self.health <=0 then
        del(objects, self)
    end

    self.collider:update()
    remove_if_out_of_bounds(self)
end

poop={
    is_projectile=true,
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
    if coll.is_friendly or coll.is_projectile then return end
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
    is_friendly=true,
    pwidth=128,
    cost=0,
    dmg=999,
    speed=1,
    health=1000000,
    max_health=1000000
}

function blue_whale:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function blue_whale:draw()
    sspr(((self.sprite% 16)*8), (flr(self.sprite/16)*8),48,16,self.x,self.y-12,140,32)
    if self.timer==18 then 
        if self.sprite==102 then
            self.sprite=102
        elseif self.sprite==102 then
            self.sprite=102        
        end
        self.speed+=3
        self.timer=0 
        self.x+=self.speed
    end
end

function blue_whale:update()
    local can_move = self.collider:can_move(self)
    
    if can_move then
        
    end
    
   

    self.y=.5*(sin(self.x/40))+get_lane_y(self.lane_index)+8
    self.timer+=1
    self.collider:update()
    
end