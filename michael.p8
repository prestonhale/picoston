pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

------------------
--- health bar ---
------------------

health_bar={
    foreground=false
}

function add_health_bar(obj,x_offset,y_offset,length,height,color)
    local bar = health_bar:new()
    bar.parent = obj
    bar.x_offset = x_offset
    bar.y_offset = y_offset
    bar.length = length
    bar.curr_length = length
    bar.height = height
    bar.color = color
    add(objects,bar)
end

function health_bar:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function health_bar:update()
    if not self.parent.show_health then
        del(objects, self)
    end
    self.curr_length = convert_range(self.parent.health,0,self.parent.max_health,1,self.length)
end

function health_bar:draw()
    -- white border
    rect(self.parent.x + self.x_offset - 1,
        self.parent.y + self.y_offset - 1,
        self.parent.x + self.x_offset + self.length,
        self.parent.y + self.y_offset + self.height,
        7
    )
    -- gray background
    rectfill(self.parent.x + self.x_offset,
        self.parent.y + self.y_offset,
        self.parent.x + self.x_offset + self.length - 1,
        self.parent.y + self.y_offset + self.height - 1,
        6
    )
    -- health bar
    rectfill(self.parent.x + self.x_offset,
        self.parent.y + self.y_offset,
        self.parent.x + self.x_offset + self.curr_length - 1,
        self.parent.y + self.y_offset + self.height - 1,
        self.color
    )
end

-----------------
--- grass obj ---
-----------------

grass={
    objs={},
    update=function(self)end
}

top_grass={
    objs={},    
    update=function(self)end
}

for i=0,30 do
    rand_x=flr(rnd(114))+8
    rand_y=flr(rnd(77))+25
    g={
        x=rand_x,
        y=rand_y
    }
    add(grass.objs,g)
end

for i=0,10 do
    rand_x=flr(rnd(114))+8
    g={
        x=rand_x,
        y=19
    }
    add(top_grass.objs,g)
end

function draw_pixel(x,y)
    if (pget(x,y)==11) then
        pset(x,y,3)
    else
        pset(x,y,11)
    end
end

function grass:draw()
    for g in all(grass.objs) do
        draw_pixel(g.x+2,g.y)
        draw_pixel(g.x+4,g.y)
        draw_pixel(g.x+3,g.y+1)

        draw_pixel(g.x,g.y-2)
        draw_pixel(g.x+1,g.y-3)
        draw_pixel(g.x-1,g.y-3)

        draw_pixel(g.x-3,g.y+1)
        draw_pixel(g.x-4,g.y+2)
        draw_pixel(g.x-5,g.y+1)
    end

    for g in all(top_grass.objs) do
        pset(g.x,g.y,11)
        pset(g.x,g.y+1,11)

        pset(g.x+2,g.y-1,11)
        pset(g.x+2,g.y,11)
        pset(g.x+2,g.y+1,11)
    end
end

------------------
--- flower obj ---
------------------

flowers={
    objs={},
}

for i=0,20 do
    rand_x=flr(rnd(114))+8
    rand_y=flr(rnd(77))+25
    flwr_rand=flr(rnd(10))+1
    flwr_sprite=0
        if (flwr_rand%2==0) then
            flwr_sprite=5
        else
            flwr_sprite=21
        end
    flower={
        x=rand_x,
        y=rand_y,
        bounce_t=flr(rnd(3))+9,
        c_bounce_t=0,
        bounce_dir="right",
        pos="left",
        sprite=flwr_sprite
    }
    add(flowers.objs,flower)
end

function flowers:update()
    for flower in all(flowers.objs) do
        flower.c_bounce_t+=1
        if flower.c_bounce_t>=flower.bounce_t then
            flower.c_bounce_t=0
            if (flower.bounce_dir=="right") then
                if (flower.pos=="left") then
                    flower.pos="middle"
                elseif (flower.pos=="middle") then
                    flower.pos="right"
                else
                    flower.pos="middle"
                    flower.bounce_dir="left"
                end
            else
                if (flower.pos=="right") then
                    flower.pos="middle"
                elseif (flower.pos=="middle") then
                    flower.pos="left"
                else
                    flower.pos="middle"
                    flower.bounce_dir="right"
                end
            end
        end
    end
end


function flowers:draw()
    for flower in all(flowers.objs) do
        if (flower.pos=="left") then
            spr(flower.sprite,flower.x-1,flower.y-1)
        elseif (flower.pos=="middle") then
            spr(flower.sprite,flower.x,flower.y)
        else
            spr(flower.sprite,flower.x+1,flower.y-1)
        end
    end
end

---------------------
--- bakground obj ---
---------------------

bg={
    cloud_sprite=6,
    cloud_width=8,
    cloud_height=4,
    cloud_x=-30,
    cloud_y=-18
}

function bg:update()
    self.cloud_x+=0.1
    if self.cloud_x>130 then
        self.cloud_x = -70
    end
end

function bg:draw()

    cls(0)

    -- sky and sun
    rectfill(0,0,127,19,12)
    circfill(85,18,10,10)

    -- cloud
    spr(self.cloud_sprite,self.cloud_x,self.cloud_y,self.cloud_width,self.cloud_height)

    -- lanes
    y_offset=20
    local lane_spr = 132
    local sx, sy = get_sprite_coords(lane_spr)
    sx, sy = (lane_spr % 16) * 8, flr(lane_spr \ 16) * 8
    for i=0,4 do
        for j=0,7 do
            sspr(
                sx, sy,
                16, 16,
                j*16, lane_y_starts(i+1),
                16, lane_height
            )
        end
    end
end

--------------------------
--- wind_generator obj ---
--------------------------

wind_generator={
    spawn_t=60,
    c_spawn_t=0
}

function wind_generator:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function wind_generator:update()
    self.c_spawn_t+=1
    if self.c_spawn_t>=self.spawn_t then

        self.c_spawn_t=0
        self.spawn_t=rnd(rnd(50))+70
        
        wind_randx=flr(rnd(80))-10
        wind_randy=flr(rnd(70))+20

        w=wind:new()
        w.x=wind_randx
        w.y=wind_randy
        w.initial_y=wind_randy
        w.last_x=wind_randx
        w.check_x=wind_randx
        w.last_y=wind_randy
        w.check_y=wind_randy
        add(objects,w)
    end
end
function wind_generator:draw()end

function add_wind_generator()
    wind_generator=wind_generator:new()
    add(objects,wind_generator)
end

----------------
--- wind obj ---
----------------

wind={
    loop_t=10,
    c_loop_t=0,
    looping=false,
    looping_check=false,
    origin_x=0,
    origin_y=0,
    radius=7,
    angle=0.75,
    hori_speed=5,
    angle_speed=0.08,
    ending=false,
    last_angle=0.75,
    check_angle=0.75,
    air_particles={},
    done_moving=false
}

function wind:new(obj)
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function wind:update()
    if not self.looping then
        if (self.done_moving==false) then
            self.x+=self.hori_speed
        end
        self.c_loop_t+=1
        if self.c_loop_t>=self.loop_t then
            if not self.ending then
                self.c_loop_t=0
                self.looping=true
                self.origin_x=self.x
                self.origin_y=self.y-self.radius
            else
                self.done_moving=true
            end
        end
    else
        self.x=self.origin_x+cos(self.angle)*self.radius
        self.y=self.origin_y+sin(self.angle)*self.radius
        self.angle+=self.angle_speed
        if self.angle>=1.75 then
            self.looping=false
            self.angle=0.75
            self.ending=true
            self.y=self.initial_y
        end
    end

    self.check_x=self.x
    self.check_y=self.y
    self.check_angle=self.angle

    if not self.looping_check then
        while self.check_x>self.last_x do
            self.check_x-=1
            air={
                x=self.check_x,
                y=self.check_y,
                death_t=10
            }
            add(self.air_particles,air)
        end
    else
        while self.check_angle>self.last_angle do
            self.check_angle-=0.01
            -- needed to remove annoying pixel sticking out
            -- on right side during loop
            if self.check_angle<0.99 or self.check_angle>1 then
                air={
                    x=self.origin_x+cos(self.check_angle)*self.radius,
                    y=self.origin_y+sin(self.check_angle)*self.radius,
                    death_t=10
                }
                add(self.air_particles,air)
            end
        end
    end

    self.last_x=self.x
    self.last_y=self.y
    self.last_angle=self.angle

    -- needed at bottom to ensure the while loop adds previous
    -- air objs even on step where looping is changed
    if (self.looping) then
        self.looping_check=true
    else
        self.looping_check=false
    end

    for particle in all (self.air_particles) do
        particle.death_t-=1
        if particle.death_t<=0 then
            del(self.air_particles,particle)
        end
    end

    if #self.air_particles==0 then
        del(objects,self)
    end
end

function wind:draw()
    for particle in all(self.air_particles) do
        pset(particle.x,particle.y,7)
    end
end

-----------------
--- init func ---
-----------------

function init_michael(objects)
    add(objects,bg)
    add(objects,grass)
    add(objects,flowers)
    add_wind_generator()
end