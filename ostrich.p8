pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

ostrich_type = {
    is_collideable = true,
    is_friendly=true,

    collide = function(self, other)
        self.colliding[other] = 1
    end,

    draw = function(self)
        spr(self.sprite,self.x,self.y,2,2)
        if self.timer==18 then 
            if self.sprite==96 then
               self.sprite=64
            elseif self.sprite==64 then
                self.sprite=96        
            end
            self.timer=0 
        end
    end,
    update = function(self)
        local can_move = true
        for k,v in pairs(self.colliding) do
            self.do_damage(self, k)
            if not k.type.is_friendly then 
                can_move = false
            end
            if k.type.is_friendly and k.x>self.x then
                can_move = false
            end
        end    
        if can_move then 
            self.x+=1   
            self.y=.5*(sin(self.x/40))+get_lane_y(self.lane_index)+3
            
        end
        self.timer+=1
        self.colliding = {}
        remove_if_out_of_bounds(self)
    end
}



function init_tyler(objects)
    
end

function add_ostrich_at(new_x,new_y,new_lane_index)
    ostrich={ 
        x=new_x,
        y=new_y,
        lane_index = new_lane_index,
        sprite=64,
        type=ostrich_type,
        health=100,
        colliding = {},
        timer=0,
        do_damage=function(self, coll)
            if coll.type.is_friendly then return end
            coll.health -= 5
            end
    }
    
end



function add_ostrich_in_lane(lane_index)
    new_y=get_lane_y(lane_index)
    new_x=5
    add_ostrich_at(new_x,new_y,lane_index)
    add(objects,ostrich)
end