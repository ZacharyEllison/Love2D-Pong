function love.load()

    love.window.setMode(640, 448)
    window_width = 640
    window_height = 448
    -- start with a table for all objects
    objects = {}
    -- then we'll start with a paddle
    objects.right_paddle = {}
    objects.right_paddle.x = 7 * window_width/8
    objects.right_paddle.y = window_height/2
    objects.right_paddle.w = 20
    objects.right_paddle.h = 100
    objects.right_paddle.yvel = 0
    objects.right_paddle.score = 0

    -- left paddle
    objects.left_paddle = {}
    objects.left_paddle.x = window_width/8
    objects.left_paddle.y = window_height/2
    objects.left_paddle.w = 20
    objects.left_paddle.h = 100
    objects.right_paddle.yvel = 0
    objects.left_paddle.score = 0

    -- pong
    objects.pong = {}
    objects.pong.x = window_width/2
    objects.pong.y = window_height/2
    objects.pong.r = 8
    objects.pong.xvel = 2
    objects.pong.yvel = 2

    -- wins tracker
    game_over = ""
    
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    -- from love2d wiki
    return x1 < x2+w2 and
		x2 < x1+w1 and
		y1 < y2+h2 and
		y2 < y1+h1
end

function pong_out(x,y)
    -- check if the pong is out of frame
    if x < -10 or x > 650 then
        love.timer.sleep(0.5)
        objects.pong.xvel = 0
        objects.pong.yvel = 0
        objects.pong.x = window_width / 2
        objects.pong.y = window_height / 2
        love.timer.sleep(0.25)
        -- this random will go either left or right
        objects.pong.xvel = love.math.random(-1,1) * 3
        if objects.pong.xvel == 0 then
            objects.pong.xvel = 2
        end 
        -- this random would change the angle on spawn
        objects.pong.yvel = love.math.random(-1,1) * love.math.random(-3,3)
    end
end

function love.update(dt)
    -- Right up,down
    if love.keyboard.isDown("down") then
        objects.right_paddle.yvel = 5
    elseif love.keyboard.isDown("up") then
        objects.right_paddle.yvel = - 5
    else 
        objects.right_paddle.yvel = 0
    end
    -- Left up,down
    if love.keyboard.isDown("s") then
        objects.left_paddle.yvel = 5
    elseif love.keyboard.isDown("w") then
        objects.left_paddle.yvel = - 5
    else 
        objects.left_paddle.yvel = 0
    end
    objects.right_paddle.y = objects.right_paddle.y + objects.right_paddle.yvel
    objects.left_paddle.y = objects.left_paddle.y + objects.left_paddle.yvel
    
    -- pong spawn
    pong_out(objects.pong.x, objects.pong.y)
    -- paddles collision check
    if CheckCollision(objects.pong.x - 8, objects.pong.y - 8, 16, 16, objects.right_paddle.x, objects.right_paddle.y, objects.right_paddle.w, objects.right_paddle.h) then
        objects.pong.xvel = - objects.pong.xvel
        objects.pong.yvel = objects.pong.yvel + objects.right_paddle.yvel / 2
    elseif CheckCollision(objects.pong.x - 8, objects.pong.y - 8, 16, 16, objects.right_paddle.x, objects.right_paddle.y, objects.right_paddle.w, objects.right_paddle.h) then
        objects.pong.xvel = - objects.pong.xvel
        objects.pong.yvel = objects.pong.yvel + objects.right_paddle.yvel / 2
    elseif CheckCollision(objects.pong.x - 8, objects.pong.y - 8, 16, 16, objects.left_paddle.x, objects.left_paddle.y, objects.left_paddle.w, objects.left_paddle.h) then
        objects.pong.xvel = - objects.pong.xvel
        objects.pong.yvel = objects.pong.yvel + objects.left_paddle.yvel / 2
    elseif CheckCollision(objects.pong.x - 8, objects.pong.y - 8, 16, 16, objects.left_paddle.x, objects.left_paddle.y, objects.left_paddle.w, objects.left_paddle.h) then
        objects.pong.xvel = - objects.pong.xvel
        objects.pong.yvel = objects.pong.yvel + objects.left_paddle.yvel / 2
    -- Top and bottom collision
    elseif CheckCollision(objects.pong.x - 8, objects.pong.y - 8, 16, 16, 0, 0, window_width, 0) then
        objects.pong.yvel = - objects.pong.yvel
    elseif CheckCollision(objects.pong.x - 8, objects.pong.y - 8, 16, 16, 0, window_height, window_width, 0) then
        objects.pong.yvel = - objects.pong.yvel
    end
    objects.pong.x = objects.pong.x + objects.pong.xvel
    objects.pong.y = objects.pong.y + objects.pong.yvel

    -- scoring
    if objects.pong.x == -5 then
        objects.left_paddle.score = objects.left_paddle.score + 1
    elseif objects.pong.x == window_width + 5 then
        objects.right_paddle.score = objects.right_paddle.score + 1
    end
    
    -- set game_over
    if objects.left_paddle.score == 0 then
        game_over = "RIGHT"
    elseif objects.right_paddle.score == 0 then
        game_over = "LEFT"
    end
    
end

function love.draw()
    -- body
    if objects.left_paddle.score < 3 or objects.right_paddle.score < 3 then
        love.graphics.rectangle("fill", objects.right_paddle.x, objects.right_paddle.y, objects.right_paddle.w, objects.right_paddle.h)
        love.graphics.rectangle("fill", objects.left_paddle.x, objects.left_paddle.y, objects.left_paddle.w, objects.left_paddle.h)
        love.graphics.circle("fill", objects.pong.x, objects.pong.y, objects.pong.r)
        for i=-1,1 do
            love.graphics.circle("line", objects.right_paddle.x + objects.pong.r * 5/2*i, 424, objects.pong.r)
        end
        for i=-1,1 do
            love.graphics.circle("line", objects.left_paddle.x + objects.pong.r * 5/2*i, 424, objects.pong.r)
        end
    else
        love.graphics.print(game_over .. "WINS", window_width/2, window_height/2, 0, 10)
    end
end