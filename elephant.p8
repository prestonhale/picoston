pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

elephant=animal:new{
    x=0,
    y=0,
    sprite=3,
    width=2,
    height=2,
    stomp_t=15,
    curr_stomp_t=0,
    stomp_t_increase=true,
    anim_t=5,
    curr_anim_t=0,
    shadow=nil,
    is_friendly=true,
    cost=3,
    pwidth=16,
    dmg=0.1,
    health=800,
    max_health=800
}

function elephant:draw()
    if self.health<self.max_health then
        rect(self.x+2,self.y-5,self.x+13,self.y-3,7)
        length = convert(self.health,0,self.max_health,0,10)
        if length < 0 then
            length=0
        end
        line(self.x+3,self.y-4,self.x+12,self.y-4,6)
        line(self.x+3,self.y-4,self.x+3+length,self.y-4,3)
    end
    spr(self.sprite,self.x,self.y,self.width,self.height)
end

function elephant:update()
    local can_move = self.collider:can_move(self)

    if self.stomp_t_increase then
        self.curr_stomp_t+=1
        self.curr_anim_t+=1
        if can_move then
            self.x+=0.5
        end
        if self.curr_stomp_t>=self.stomp_t then
            self.curr_stomp_t=self.stomp_t
            self.stomp_t_increase=false
        end
        if self.curr_anim_t>=self.anim_t then
            if self.sprite==3 then
                self.sprite=35
                self.y-=1
            else
                self.sprite=3
                self.y+=1
            end
            self.curr_anim_t=0
        end
    else
        self.curr_stomp_t-=1
        if self.curr_stomp_t<=0 then
            self.curr_stomp_t=0
            self.stomp_t_increase=true
        end
    end

    if self.health <=0 then
        del(objects, self)
    end

    self.collider:update()
    remove_if_out_of_bounds(self)
end