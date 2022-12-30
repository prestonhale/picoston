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
    pwidth=6,
    dmg=2,
    health=90,
    max_health=90
}

function ostrich:draw()
    if self.health<self.max_health then
        rect(self.x-5,self.y-5,self.x+6,self.y-3,7)
        length = convert(self.health,0,self.max_health,0,10)
        line(self.x-4,self.y-4,self.x+5,self.y-4,6)
        line(self.x-4,self.y-4,self.x-4+length,self.y-4,3)
    end
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

    if self.health <=0 then
        del(objects, self)
    end

    self.collider:update()
    remove_if_out_of_bounds(self)
end
