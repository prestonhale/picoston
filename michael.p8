pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

--- elephant obj ---

elephant_type={
	update=function(self)end,
	draw=function(self)end
}

function add_elephant_in_lane(lane_index)
	new_y=get_lane_y(lane_index)+1
	new_x=5
	add_elephant_at(new_x,new_y,lane_index)
end

function add_elephant_at(new_x,new_y,new_lane_index)
	elephant={
		x=new_x,
		y=new_y,
		lane_index=new_lane_index,
		sprite=3,
		width=2,
		height=2,
		type=elephant_type,
		stomp_t=15,
		curr_stomp_t=0,
		stomp_t_increase=true,
		anim_t=5,
		curr_anim_t=0
	}
	add(objects,elephant)
end

elephant_type.update=function(self)
	if self.stomp_t_increase then
		self.curr_stomp_t+=1
		self.curr_anim_t+=1
		self.x+=1
		if self.curr_stomp_t>=self.stomp_t then
			self.curr_stomp_t=self.stomp_t
			self.stomp_t_increase=false
		end
		if self.curr_anim_t>=self.anim_t then
			if self.sprite==3 then
				self.sprite=35
				self.y-=1
			else
				self.sprite=3
				self.y+=1
			end
			self.curr_anim_t=0
		end
	else
		self.curr_stomp_t-=1
		if self.curr_stomp_t<=0 then
			self.curr_stomp_t=0
			self.stomp_t_increase=true
		end
	end
	remove_if_out_of_bounds(self)
end

elephant_type.draw=function(self)
	spr(self.sprite,self.x,self.y,self.width,self.height)
end

--- grass obj ---

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

--- flower obj ---

flower_type = {
	update=function(self)end,
	draw=function(self)end
}

flowers={
	objs={},
	type=flower_type
}

for i=0,20 do
	rand_x=flr(rnd(108))+10
	rand_y=flr(rnd(85))+10
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
		sprite=flwr_sprite
	}
	add(flowers.objs,flower)
end

flower_type.draw = function(self)
	for flower in all(flowers.objs) do
		spr(flower.sprite,flower.x,flower.y)
	end
end

--- bakground obj ---

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

--- gate obj ---

gate_type={
	update=function(self)end,
	draw=function(self)end
}

gates={}
for i=0,4 do
	gate={
		x=100+(i*4),
		y=-3+(i*21),
		lane_x=0,
		lane_y=0,
		sprite=13,
		width=2,
		height=3,
		type=gate_type
	}
	add(gates,gate)
end

gate_type.draw = function(self)
	spr(self.sprite,self.x,self.y,self.width,self.height)
end

--- init func ---

function init_michael(objects)
	add(objects,bg)
	add(objects,grass)
	add(objects,flowers)
	for gate in all(gates) do
		add(objects,gate)
	end
end