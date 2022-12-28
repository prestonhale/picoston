pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

 

ostrich_type = {
    draw = function(self)
        rectfill(self.x,self.y,self.x+7,self.y+7,3)
        end,
    update = function(self)
        self.x+=1    
        end
    }

ostrich={
        x = 0,
        y = 0,
        lane_x = 0,
        lane_y = 0,
        type=ostrich_type
        }    
function init_tyler(objects)
    add(objects,ostrich)
end
