pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

bee_giant_type = {
    collideable = true,
    collide = function(self, other)
        self.colliding = true
    end,
    draw = function(self)
        spr(self.sprite,self.x,self.y,2,2)
        if self.timer==2 then 
            self.sprite=68 
            self.timer=0 
        else 
            self.sprite=66
        end
    end,
    update = function(self)
        if not self.colliding then
            self.y=(2*(sin(self.x/30))+get_lane_y(self.lane_index)+3)
            self.x+=3 
        end
        self.timer+=1
        end
    }

function add_bee_giant_in_lane(lane_index)
    new_y=get_lane_y(lane_index)
    new_x=5
    add_bee_giant_at(new_x,new_y,lane_index)
end


function add_bee_giant_at(new_x,new_y,new_lane_index)
    bee_giant={ 
        x=new_x,
        y=new_y,
        lane_index = new_lane_index,
        sprite=66,
        type=bee_giant_type,
        timer=0
    }

    add(objects,bee_giant)
    
end