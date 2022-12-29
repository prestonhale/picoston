pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

------------------
--- shadow code ---
------------------

function add_shadow(obj,x_offset,y_offset,w,h,col)
    shadow_obj={
        x=obj.x+x_offset,
        y=obj.y+y_offset,
        xoff=x_offset,
        yoff=y_offset,
        width=w,
        height=h,
        color=col
    }
    obj.shadow=shadow_obj
end

function draw_shadow(obj)
    if obj.shadow!=nil then
        ovalfill(obj.shadow.x,obj.shadow.y,obj.shadow.x+obj.shadow.width,obj.shadow.y+obj.shadow.height,obj.shadow.color)
    end
end

function move_shadow(obj)
    if obj.shadow!=nil then
        obj.shadow.x=obj.x
        obj.shadow.x=obj.x+obj.shadow.xoff
    end
end


-----------------
--- grass obj ---
-----------------

grass={
    objs={},
    update=function(self)end,
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
    update=function(self)end
}

bg.draw = function(self)
    cls(0)
    rectfill(0,0,127,20,12)
    line(0,19,127,19,10)
    circfill(80,19,10,10)

    swap=-1
    x_val=22
    y_val=13
    x_offset=-1
    y_offset=20

    for i=0,4 do
        for j=0,6 do
            if swap==-1 then
                rectfill(
                    (j*x_val)+x_offset,
                    (i*y_val)+y_offset-i,
                    (j*x_val)+x_val-1+x_offset,
                    (i*y_val)+y_val+y_offset-1,
                    11
                )
            else
                rectfill(
                    (j*x_val)+x_offset,
                    (i*y_val)+y_offset-i,
                    (j*x_val)+x_val-1+x_offset,
                    (i*y_val)+y_val+y_offset-1,
                    3
                )
            end
            swap*=-1
        end
        y_val+=1
    end
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

function wind:new()
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

------------------------
--- wind_generator obj ---
------------------------

wind_generator={
    spawn_t=60,
    c_spawn_t=0,
    draw=function(self)end
}

function wind_generator:update()
    self.c_spawn_t+=1
    if self.c_spawn_t>=self.spawn_t then

        self.c_spawn_t=0
        self.spawn_t=rnd(rnd(50))+70
        
        wind_randx=flr(rnd(80))-10
        wind_randy=flr(rnd(70))+20

        wind = wind:new()
        wind.x = wind_randx
        wind.y = wind_randy
        wind.last_x=wind_randx
        wind.check_x=wind_randx
        wind.last_y=wind_randy
        wind.check_y=wind_randy
        wind.initial_y=wind_randy

        add(objects,wind)
    end
end

----------------
--- gate obj ---
----------------
gate={
    lane_x=0,
    lane_y=0,
    sprite=13,
    width=2,
    height=2,
    bounce_t=20,
    c_bounce_t=0,
}

function gate:new()
    obj = obj or {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end


function gate:update()
    self.c_bounce_t+=1
    if self.c_bounce_t>=self.bounce_t then
        self.c_bounce_t=0
        if self.y==self.initial_y then
            self.y+=1
        else
            self.y-=1
        end
    end
end

function gate:draw()
    spr(45,self.x,self.initial_y+16,2,1)
    spr(self.sprite,self.x,self.y,self.width,self.height)
end

gates={}
for i=0,4 do
    g = gate:new()
    g.x=100+(i*4)
    g.y=-3+(i*21)
    g.initial_y=-3+(i*21)
    if i%2==0 then
        g.y+=1
    end
    add(gates,g)
end
-----------------
--- init func ---
-----------------

function init_michael(objects)
    add(objects,bg)
    add(objects,grass)
    add(objects,flowers)
    -- for gate in all(gates) do
    --     add(objects,gate)
    -- end
    -- add(objects,wind_generator)
end