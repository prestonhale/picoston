pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

ostrich={ 
    x=new_x,
    y=new_y,
    sprite=64,
    timer=0,
    is_friendly=true,
    pwidth=10
}

function ostrich:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function ostrich:draw()
    sspr(((self.sprite% 16)*8), (flr(self.sprite/16)*8),16,16,self.x,self.y,15,15)
    if self.timer==18 then 
        if self.sprite==96 then
            self.sprite=64
        elseif self.sprite==64 then
            self.sprite=96        
        end
        self.timer=0 
    end
end

function ostrich:update()
    local can_move = self.collider:can_move(self)
    if can_move then
        self.x+=1
    end
    self.y=.5*(sin(self.x/40))+get_lane_y(self.lane_index)+1
    self.timer+=1
    self.collider:update()
    remove_if_out_of_bounds(self)
end

function add_ostrich_in_lane(lane_index)
    local ostrich = ostrich:new()
    ostrich.collider=collider:new()
    ostrich.y=get_lane_y(lane_index)
    ostrich.x=5
    ostrich.lane_index=lane_index
    ostrich.collider = collider:new()
    add(objects,ostrich)
    

end