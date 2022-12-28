pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

ostrich_type = {
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
        self.x+=1   
        self.y=.5*(sin(self.x/40))+get_lane_y(self.lane_index)+3
        self.timer+=1
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
        timer=0
    }
end

function add_ostrich_in_lane(lane_index)
    new_y=get_lane_y(lane_index)
    new_x=5
    add_ostrich_at(new_x,new_y,lane_index)
    add(objects,ostrich)
end