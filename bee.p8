pico-8 cartridge // http://www.pico-8.com
version 38
__lua__


bee_giant=animal:new{ 
    x=0,
    y=0,
    is_friendly=true,
    health = 100,
    sprite=66,
    timer=0,
    cost=1,
    pwidth=10
}

function bee_giant:draw()
    sspr(((self.sprite% 16)*8), (flr(self.sprite/16)*8),16,16,self.x,self.y,8,8)
    if self.timer==2 then 
        self.sprite=68 
        self.timer=0 
    else 
        self.sprite=66
    end
end


function bee_giant:update()
    local can_move = true
    for k,v in pairs(self.collider.colliding_with) do
        if not k.is_friendly then 
            can_move = false
        end
        self.do_damage(self,k)
    end

    -- bee always buzzes up and down even if it can't move forward
    self.y=(2*(sin(self.timer/60))+get_lane_y(self.lane_index)+3)+5
    if can_move then 
        self.y=(2*(sin(self.x/30))+get_lane_y(self.lane_index)+3)+1
    end

    if not can_move then 
        self.x+=1
    else
        self.x+=3
    end    


    self.timer+=1

    self.collider:update()

    if self.health <=0 then
        del(objects, self)
    end

    remove_if_out_of_bounds(self)
end