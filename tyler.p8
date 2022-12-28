pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
ostrich_type = {
    draw = function(self)
        spr(self.sprite,self.x,self.y,2,2)
        end,
    update = function(self)
        self.x+=2    
        end
    }


function init_tyler(objects)
    
end

function add_ostrich_at(new_x,new_y)
    ostrich={ 
        x=new_x,
        y=new_y,
        lane_x = 0,
        lane_y = 0,
        sprite=66,
        type=ostrich_type
    }

    add(objects,ostrich)
    
end
--------------------------------------------------
bee_giant_type = {
    draw = function(self)
        spr(self.sprite,self.x,self.y,2,2)
        end,
    update = function(self)
        self.x=sin()    
        end
    }


function init_tyler(objects)
    
end

function add_bee_giant_at(new_x,new_y)
    bee_giant={ 
        x=new_x,
        y=new_y,
        lane_x = 0,
        lane_y = 0,
        sprite=64,
        type=bee_giant_type
    }

    add(objects,bee_giant)
    
end