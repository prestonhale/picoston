pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

ostrich=animal:new{ 
    x=new_x,
    y=new_y,
    sprite=64,
    timer=0,
    is_friendly=true,
    cost=2,
    pwidth=6,
    dmg=1,
    health=150,
    max_health=150
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
    local can_move, coll = self.collider:can_move(self)
    if can_move then
        self.x+=0.5
    end
    if coll then
        ostrich:do_damage(coll)
    end
    self.y=.5*(sin(self.x/40))+get_lane_y(self.lane_index)+8
    self.timer+=1

    if self.health < self.max_health and not self.show_health then
        self.show_health = true
        add_health_bar(self,-2,-4,9,1,3)
    end

    if self.health <=0 then
        self.show_health = false
        del(objects, self)
    end

    self.collider:update()
    remove_if_out_of_bounds(self)
end
