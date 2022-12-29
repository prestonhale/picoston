pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

ostrich=animal:new{ 
    x=new_x,
    y=new_y,
    sprite=64,
    timer=0,
    is_friendly=true,
    cost=1,
    pwidth=6
}

function ostrich:draw()
    sspr(((self.sprite% 16)*8), (flr(self.sprite/16)*8),16,16,self.x,self.y,8,8)
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
    self.y=.5*(sin(self.x/40))+get_lane_y(self.lane_index)+8
    self.timer+=1
    self.collider:update()
    remove_if_out_of_bounds(self)
end
