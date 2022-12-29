pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

bee_giant={ 
    x=0,
    y=0,
    is_friendly=true,
    is_collideable=true,
    health = 100,
    colliding = {},
    sprite=66,
    timer=0
}


function bee_giant:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


function bee_giant:collide(obj)
    self.colliding[other] = 1
end


function bee_giant:draw()
    spr(self.sprite,self.x,self.y,2,2)
    if self.timer==2 then 
        self.sprite=68 
        self.timer=0 
    else 
        self.sprite=66
    end
end


function bee_giant:update()
    local can_move = true
    for k,v in pairs(self.colliding) do
        self:do_damage(k)
        if not k.is_friendly then 
            can_move = false
        end
        if k.is_friendly and k.x>self.x then
            can_move = false
        end
    end

    -- bee always buzzes up and down even if it can't move forward
    self.y=(2*(sin(self.timer/60))+get_lane_y(self.lane_index)+3)
    if can_move then 

        self.y=(2*(sin(self.x/30))+get_lane_y(self.lane_index)+3)-5

        self.x+=3 
    end

    self.timer+=1

    self.colliding = {}

    if self.health <=0 then
        del(objects, self)
    end
end
    
function bee_giant:do_damage(coll)
    debug=coll
    if coll.is_friendly then return end
    coll.health -= 5
end


function add_bee_giant_in_lane(lane_index)
    if bee_giant_type.cost <= points then
        new_y=get_lane_y(lane_index)
        new_x=5
        add_bee_giant_at(new_x,new_y,lane_index)
        return 0
    else
        return bee_giant_type.cost
    end
end


function add_bee_giant_at(new_x,new_y,new_lane_index)
    bee_giant = bee_giant:new()
    bee_giant.x = new_x
    bee_giant.y = new_y
    bee_giant.lane_index = new_lane_index
    add_shadow(bee_giant,3,14,10,3,5)
    add(objects,bee_giant)
end