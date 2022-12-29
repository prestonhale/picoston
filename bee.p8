pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

bee_giant_type = {
    is_collideable = true,
    is_friendly=true,

    collide = function(self, other)
        self.colliding[other] = 1
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
        can_move = true
        for k,v in pairs(self.colliding) do
            self.do_damage(self, k)
            if not k.type.is_friendly then 
                can_move = false
            end
            if k.type.is_friendly and k.x>self.x then
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
        health = 100,
        colliding = {},
        lane_index = new_lane_index,
        sprite=66,
        type=bee_giant_type,
        timer=0
    }

    function bee_giant:do_damage(coll)
        debug=coll
        if coll.type.is_friendly then return end
        coll.health -= 5
    end
    add_shadow(bee_giant,3,14,10,3,5)
    add(objects,bee_giant)
    
end