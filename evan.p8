pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

scoreboard = {    
    counter=0,
    update = function(self)
        if flr(time()) > self.counter then
            self.counter+=1
            points+=1
        end
    end,
    draw = function(self)
        spr(192, 0, 105, 2, 2)
        print(points, 4, 108, 7)
    end
}

function init_evan(objects)
    points = 1
    add(objects, scoreboard)
end

animal = {
    x=0,
    y=0,
    sprite=0,
    width=2,
    height=2,
    anim_t=5,
    curr_anim_t=0,
    shadow=nil,
    is_friendly=true,
    cost=0,
    pwidth=0
}

function animal:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function animal:draw()
    spr(self.sprite,self.x,self.y,self.width,self.height)
end


function add_in_lane(animal_type, lane_index)
    if animal_type.cost <= points then
        new_y=get_lane_y(lane_index)
        new_x=5
        add_at(animal_type,new_x,new_y,lane_index)
        points -= animal_type.cost
        return 0
    else
        return animal_type.cost
    end
end

function add_at(animal_type,new_x,new_y,new_lane_index)
   
    local new_animal = animal_type:new()
    new_animal.x = new_x
    new_animal.y = new_y
    new_animal.lane_index = new_lane_index
    new_animal.collider = collider:new()
    add_shadow(new_animal,3,14,10,3,5)
    add(objects,new_animal)
end

