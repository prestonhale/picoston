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
    if can_move then
        self.x+=1
    end
    if not can_move and not self.poop then
        new_poop(self.x,self.lane_index)
        self.poop=true     
    end
    
    self.y=.5*(sin(self.x/40))+get_lane_y(self.lane_index)+8
    self.timer+=1
    self.collider:update()
    remove_if_out_of_bounds(self)
end

function add_monkey_in_lane(lane_index)
    local monkey = monkey:new()
    monkey.collider=collider:new()
    monkey.y=get_lane_y(lane_index)
    monkey.x=5
    monkey.lane_index=lane_index
    monkey.collider = collider:new()
    add(objects,monkey)
    

end

poop={}
function poop:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function poop:draw()
    rectfill(self.x+1,self.y+1,self.x+5,self.y+5,8)    
end

function poop:update()
   self.x+=1
end

function new_poop(new_x,lane_index)
    local poop = poop:new()
    poop.collider=collider:new()
    poop.y=get_lane_y(lane_index)
    poop.x=new_x
    poop.lane_index=lane_index
    poop.collider = collider:new()
    add(objects,poop)
end