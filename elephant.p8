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

    if self.health < self.max_health and not self.show_health then
        self.show_health = true
        add_health_bar(self,3,-4,9,1,3)
    end

    if self.health <=0 then
        self.show_health = false
        del(objects, self)
    end

    self.collider:update()
    remove_if_out_of_bounds(self)
end