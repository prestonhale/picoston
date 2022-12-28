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
        sprite=64,
        type=ostrich_type
    }

    add(objects,ostrich)
    
end
--------------------------------------------------
bee_giant_type = {
    draw = function(self)
        spr(self.sprite,self.x,self.y,2,2)
        if self.timer==4 
        then self.sprite=68 
        self.timer=0 else self.sprite=66
        end
        end,
    update = function(self)
        self.y=2*(sin(self.x/30))
        self.x+=3 
        self.timer+=1
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
        sprite=66,
        type=bee_giant_type,
        timer=0
    }

    add(objects,bee_giant)
    
end