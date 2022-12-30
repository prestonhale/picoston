pico-8 cartridge // http://www.pico-8.com
version 38
__lua__


bee_giant=animal:new{ 
    x=0,
    y=0,
    is_friendly=true,
    is_collideable=true,
    health = 100,
    colliding = {},
    sprite=66,
    timer=0,
    cost=1,
    pwidth=10,
    x_speed=2
}

function bee_giant:draw()
    if self.x_speed==2 then
        ovalfill(self.x,self.y+10,self.x+5,self.y+13,5)
    else
        ovalfill(self.x+1,self.y+8,self.x+5,self.y+10,5)
    end
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
    self.x_speed=2
    for k,v in pairs(self.collider.colliding_with) do
        if not k.is_friendly and not k.is_projectile then 
            can_move = false
            self.x_speed=1
        end
        self.do_damage(self,k)
    end

    -- bee always buzzes up and down even if it can't move forward
    self.y=(2*(sin(self.timer/60))+get_lane_y(self.lane_index)+3)+5
    if can_move then 
        self.y=(2*(sin(self.x/30))+get_lane_y(self.lane_index)+3)+1
    end

    self.x+=self.x_speed

    self.timer+=1

    self.collider:update()

    remove_if_out_of_bounds(self)
end