pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
ostrich_type = {
    draw = function(self)
        spr(self.sprite,self.x,self.y)
        end,
    update = function(self)
        self.x+=2    
        end
    }

ostrich={
        x = 0,
        y = 0,
        lane_x = 0,
        lane_y = 57,
        sprite=1,
        type=ostrich_type
        }    
function init_tyler(objects)
    
end

function add_ostrich_at(new_x,new_y)
    ostrich={ 
        x=new_x,
        y=new_y,
        lane_x = 0,
        lane_y = 57,
        sprite=65,
        type=ostrich_type
    }

    add(objects,ostrich)
    
end