pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
elephant={
    x=new_x,
    y=new_y,
    lane_index=new_lane_index,
    sprite=3,
    width=2,
    height=2,
    stomp_t=15,
    curr_stomp_t=0,
    stomp_t_increase=true,
    anim_t=5,
    curr_anim_t=0,
    shadow=nil
}

function elephant:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function elephant:update()
    if self.stomp_t_increase then
        self.curr_stomp_t+=1
        self.curr_anim_t+=1
        self.x+=1
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
    remove_if_out_of_bounds(self)
    move_shadow(self)
end

function elephant:draw()
    draw_shadow(self)
    spr(self.sprite,self.x,self.y,self.width,self.height)
end

function add_elephant_in_lane(lane_index)
    new_y=get_lane_y(lane_index)
    new_x=5
    add_elephant_at(new_x,new_y,lane_index)
end

function add_elephant_at(new_x,new_y,new_lane_index)
    elephant = elephant:new()
    elephant.x = new_x
    elephant.y = new_y
    elephant.lane_index=new_lane_index
    elephant.collider = collider:new()
    add_shadow(elephant,1,13,13,4,5)
    add(objects,elephant)
end

