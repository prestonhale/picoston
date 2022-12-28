pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

-- grass obj

grass_type={
	update=function(self)end,
	draw=function(self)end
}

grass={
	objs={},
	type=grass_type
}

for i=0,30 do
	rand_x=flr(rnd(108))+10
	rand_y=flr(rnd(85))+10
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

grass_type.draw = function(self)
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

-- bakground obj

bg_type={
	update=function(self)end,
	draw=function(self)end
}

bg={
	type=bg_type
}

bg_type.draw = function(self)
	cls(0)

    swap=-1
    y_offset=0
    bg_sq_val=23
    x_offset=23

    for i=0,4 do
        for j=0,6 do
            if swap==-1 then
                for k=0,4 do
                    rectfill(j*bg_sq_val+k+y_offset-x_offset,i*21,j*bg_sq_val+bg_sq_val+k+y_offset-x_offset,i*21+(k*5),11)
                end
            else
                for k=0,4 do
                    rectfill(j*bg_sq_val+k+y_offset-x_offset,i*21,j*bg_sq_val+bg_sq_val+k+y_offset-x_offset,i*21+(k*5),3)
                end
            end
            swap*=-1
        end
        y_offset+=4
    end
end

-- gator obj

gator_type={
	update=function(self)end,
	draw=function(self)end
}

gator={
	x=60,
	y=60,
	lane_x=0,
	lane_y=0,
	sprite=3,
	width=3,
	height=2,
	type=gator_type
}

gator_type.draw = function(self)
	spr(self.sprite,self.x,self.y,self.width,self.height)
end

-- gate obj

gate_type={
	update=function(self)end,
	draw=function(self)end
}

gate={
	x=100,
	y=-3,
	lane_x=0,
	lane_y=0,
	sprite=13,
	width=2,
	height=3,
	type=gate_type
}

gate2={
	x=104,
	y=18,
	lane_x=0,
	lane_y=0,
	sprite=13,
	width=2,
	height=3,
	type=gate_type
}

gate3={
	x=108,
	y=39,
	lane_x=0,
	lane_y=0,
	sprite=13,
	width=2,
	height=3,
	type=gate_type
}

gate4={
	x=112,
	y=60,
	lane_x=0,
	lane_y=0,
	sprite=13,
	width=2,
	height=3,
	type=gate_type
}

gate5={
	x=116,
	y=81,
	lane_x=0,
	lane_y=0,
	sprite=13,
	width=2,
	height=3,
	type=gate_type
}

gate_type.draw = function(self)
	spr(self.sprite,self.x,self.y,self.width,self.height)
end

-- init func

function init_michael(objects)
	add(objects,bg)
	add(objects,grass)
	add(objects,gate)
	add(objects,gate2)
	add(objects,gate3)
	add(objects,gate4)
	add(objects,gate5)
end
