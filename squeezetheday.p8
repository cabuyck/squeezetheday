DEFAULT_RECT_COLOR = 8
ACTIVE_RECT_COLOR = 9
DIR_LEFT = 0
DIR_RIGHT = 1
DIR_UP = 2
DIR_DOWN = 3
STATE_TITLE = 0
STATE_GAME = 1
STATE_CUTSCENE = 2
STATE_ENDING = 3
LEVEL_NEIGHBORHOOD = 0
LEVEL_PARK = 1
LEVEL_CITY = 2
PICKUP_STRATEGY_SINGLE = 0
PICKUP_STRATEGY_INFINITE = 1
JUICER_LEVEL = 0
MAX_JUICER_LEVEL = 4
PITCHER_STATE = {
    water = false,
    lemon = false,
    sugar = false,
    lemonade_count = 0
}
DISPLAY = ""
SERVE = 10
screen_width = 128
screen_height = 128
pedestrians = {}
next_spawn_time = 0
current_time = 0
pedestrian_stopped = false
STOP_DURATION = 2
customer = nil

gamestate = {
    level = LEVEL_NEIGHBORHOOD,
    state = STATE_TITLE,
    loaded = false
}

player = {
    r = 7,
    c = 4,
    x = 64,
    y = 96,
    direction = DIR_RIGHT,
    item = nil
}
rects = {}
items = {
    [0] = {
        name = "lemons",
        spriteId = 43,
        pickupStrategy = PICKUP_STRATEGY_INFINITE,
        gives = 3
    },
    [1] = {
        name = "sugar",
        spriteId = 41,
        pickupStrategy = PICKUP_STRATEGY_INFINITE,
        gives = 6
    },
    [2] = {
        name = "water",
        spriteId = 67,
        pickupStrategy = PICKUP_STRATEGY_INFINITE,
        gives = 2
    },
    [3] = {
        name = "lemon",
        spriteId = 13,
        pickupStrategy = PICKUP_STRATEGY_SINGLE,
        gives = 3
    },
    [4] = {
        name = "juicer",
        spriteId = 99,
        pickupStrategy = PICKUP_STRATEGY_SINGLE,
        gives = 4
    },
    [5] = {
        name = "pitcher",
        spriteId = 109,
        pickupStrategy = PICKUP_STRATEGY_SINGLE,
        gives = 5,
        sprites = {
            ["lemon"] = 129,
            ["water"] = 131,
            ["sugar"] = 161,
            ["lemon_water"] = 133,
            ["lemon_sugar"] = 169,
            ["water_sugar"] = 167,
            ["lemonade_full"] = 133,
            ["lemonade_mid"] = 165,
            ["lemonade_low"] = 163,
        }
    },
    [6] = {
        name = "sugar",
        spriteId = 135,
        pickupStrategy = PICKUP_STRATEGY_SINGLE,
        gives = 6
    },
    [7] = {
        name = "cups",
        spriteId = 137,
        pickupStrategy = PICKUP_STRATEGY_INFINITE,
        gives = 8
    },
    [8] = {
        name = "cup",
        spriteId = 139,
        pickupStrategy = PICKUP_STRATEGY_SINGLE,
        gives = 8
    },
    [9] = {
        name = "trashcan",
        spriteId = 11,
    },
    [10] = {
        name = "filled_cup",
        spriteId = 65,
        pickupStrategy = PICKUP_STRATEGY_SINGLE,
        gives = 10
    }
}
juicer_sprites = {
    [0] = {
        spriteId = 99
    },
    [1] = {
        spriteId = 101
    },
    [2] = {
        spriteId = 103
    },
    [3] = {
        spriteId = 105
    },
    [4] = {
        spriteId = 107
    },
}
interactions = {
    ["lemon_lemons"] = {
        consume_item = true,
        product = function()
          sfx(4)
        end
    },
    ["lemon_juicer"] = {
        consume_item = true,
        product = function()
          sfx(1)
          fill_juicer()
        end
    },
    ["juicer_pitcher"] = {
        consume_item = false,
        product = function()
          sfx(2)
          fill_pitcher("lemon")
        end
    },
    ["water_pitcher"] = {
        consume_item = true,
        product = function()
          sfx(2)
          fill_pitcher("water")
        end
    },
    ["sugar_pitcher"] = {
        consume_item = true,
        product = function()
          sfx(3)
          fill_pitcher("sugar")
        end
    },
    ["pitcher_cup"] = {
        consume_item = false,
        product = function()
          sfx(2)
          fill_cup()
        end
    },
    ["cup_cups"] = {
        consume_item = true,
        product = function()
          sfx(4)
        end
    },
    ["trash"] = {
        consume_item = true,
        product = function()
        end
    },
    ["water_water"] = {
        consume_item = true,
        product = function()
          sfx(4)
        end
    }
}
pedestrians = {}

function _init()
  palt(11, true)
  palt(0, false)
  current_time = 0
end

function load_level(level)
  JUICER_LEVEL = 0
  PITCHER_STATE = {
    water = false,
    lemon = false,
    sugar = false
  }
  if level == LEVEL_NEIGHBORHOOD then
    rects = {
      {
        x0 = 2,
        y0 = 66,
        x1 = 22,
        y1 = 86,
        active = false,
        interaction_progress = 0,
        item = 0,
        serving_platter = false
      },
      {
        x0 = 25,
        y0 = 66,
        x1 = 45,
        y1 = 86,
        active = false,
        interaction_progress = 0,
        item = 1,
        serving_platter = false
      },
      {
        x0 = 2,
        y0 = 104,
        x1 = 22,
        y1 = 124,
        active = false,
        interaction_progress = 0,
        item = 4,
        serving_platter = false
      },
      {
        x0 = 25,
        y0 = 104,
        x1 = 45,
        y1 = 124,
        active = false,
        interaction_progress = 0,
        item = 5,
        serving_platter = false
      },
      {
        x0 = 106,
        y0 = 66,
        x1 = 126,
        y1 = 86,
        active = false,
        interaction_progress = 0,
        item = 2,
        serving_platter = false
      },
      {
        x0 = 84,
        y0 = 66,
        x1 = 104,
        y1 = 86,
        active = false,
        interaction_progress = 0,
        item = nil,
        serving_platter = false
      },
      {
        x0 = 106,
        y0 = 104,
        x1 = 126,
        y1 = 124,
        active = false,
        interaction_progress = 0,
        item = 7,
        serving_platter = false
      },
      {
        x0 = 84,
        y0 = 104,
        x1 = 104,
        y1 = 124,
        active = false,
        interaction_progress = 0,
        item = nil,
        serving_platter = false
      },
      {
        x0 = 54,
        y0 = 66,
        x1 = 74,
        y1 = 86,
        active = false,
        interaction_progress = 0,
        item = nil,
        serving_platter = true
      },
    }
  end
end

function circle_rect_collision(cx, cy, r, rx1, ry1, rx2, ry2)
  -- find the closest x and y coordinates on the rectangle to the circle's center
  local dx = cx
  if cx < rx1 then
    dx = rx1
  elseif cx > rx2 then
    dx = rx2
  end
  
  local dy = cy
  if cy < ry1 then
    dy = ry1
  elseif cy > ry2 then
    dy = ry2
  end
  
  local dist_x = cx - dx
  local dist_y = cy - dy

  -- collision happens if this distance is less than the circle's radius
  return dist_x*dist_x + dist_y*dist_y <= r*r
end

function _update()
  if gamestate.state == STATE_TITLE then
    check_start_game()
  end
  if gamestate.state == STATE_GAME then
    handle_game_logic()
  end
end

function check_start_game()
  if btnp(4) or btnp(5) then
    gamestate.state = STATE_GAME
  end
end

function handle_game_logic()
    if not gamestate.loaded then
      load_level(gamestate.level)
      gamestate.loaded = true
    end
    handle_player_interaction()
    handle_player_movement()
    check_collision_with_rects(player.x, player.y)
    deactivate_non_interacting_rects()
    handle_pedestrians()
    handle_win_condition()
end

function handle_pedestrians()
current_time += (1/30)
  
  if should_spawn_pedestrian() then
    local p = init_pedestrian()
    if not pedestrian_stopped then
      p.stop_in_middle = true
      pedestrian_stopped = true
    end
    add(pedestrians, p)
  end
  
  for p in all(pedestrians) do
    if p.stop_in_middle and p.x > screen_width / 2 and p.speed > 0 then
      p.speed = 0
      local took_lemonade = try_take_lemonade()
      if took_lemonade then
        customer = {
            type = flr(rnd(2)),
            happy = true
        }
      end
      if not took_lemonade then
        customer = {
            type = flr(rnd(2)),
            happy = false
        }
      end
    end

    -- Check if pedestrian has been paused for longer than STOP_DURATION
    if p.stop_in_middle and p.speed == 0 then
      p.paused_time += (1/30)
      if p.paused_time >= STOP_DURATION then
        p.speed = p.original_speed
        p.stop_in_middle = false
        pedestrian_stopped = false
        customer = nil
      end
    else
      p.x += p.speed
    end

    if p.x > screen_width + 9 then
      del(pedestrians, p)
    end
  end
end

function try_take_lemonade(p)
  if rects[9].item == 10 then -- filled lemonade
    rects[9].item = nil
    SERVE -= 1
    return true
  end
  return false
end


function init_pedestrian()
  local color = rnd(15)
  if color == 11 then color = 10 end
  if color == 6 then color = 13 end
  local speed = rnd(0.5) + 1
  return {
    x = -9,                  
    y = rnd(16) + 45,  
    speed = speed,
    original_speed = speed,
    c = color,
    stop_in_middle = false,
    paused_time = 0
  }
end

function should_spawn_pedestrian()
  if current_time >= next_spawn_time then
    next_spawn_time = current_time + flr(rnd(3) + 0)
    return true
  end
  return false
end

function handle_win_condition()
  if SERVE == 0 then
    gamestate.state = state_ending
  end
end

function handle_player_interaction()
  if(btnp(4) or btnp(5)) then
    local rect = get_active_rect()
    if rect == nil then return end

    if player.item != nil and rect.item == nil then
      putdown_item(rect, player.item)
      return
    end

    if player.item != nil and rect.item != nil then
      perform_item_interaction(player.item, rect)
      return
    end

    if player.item == nil and rect.item != nil then
      pickup_item(rect, rect.item)
      sfx(0)
      return
    end
  end
end

function get_active_rect()
  for _, rect in pairs(rects) do
    if rect.active then
      return rect
    end
  end
  return nil
end

function putdown_item(rect, itemId)
  if rect.item == nil then
    rect.item = itemId
    player.item = nil
    sfx(4)
  end
end

function pickup_item(rect, itemId)
  local item = items[itemId]
  if item.name == "juicer" and JUICER_LEVEL < MAX_JUICER_LEVEL then return end
  if item.pickupStrategy == PICKUP_STRATEGY_SINGLE then
    player.item = item.gives
    rect.item = nil
  end
  if item.pickupStrategy == PICKUP_STRATEGY_INFINITE then
    player.item = item.gives
  end
end

function perform_item_interaction(playerItem, rect)
  local item1 = items[playerItem]
  local item2 = items[rect.item]
  if item2.name == "trashcan" then
    interaction["trashcan"].product()
    return
  end
  local interactionKey = item1.name.."_"..item2.name
  local interaction = interactions[interactionKey]
  if interaction != nil then
    if (interaction.consume_item) then
      player.item = nil
    end
    interaction.product()
  end
end

function fill_juicer()
  if JUICER_LEVEL < MAX_JUICER_LEVEL then 
    JUICER_LEVEL += 1
  end
end

function fill_pitcher(fillerItem)
  if fillerItem == "lemon" then
    JUICER_LEVEL = 0
    PITCHER_STATE.lemon = true
  end
  if fillerItem == "water" then
    PITCHER_STATE.water = true
  end
  if fillerItem == "sugar" then
    PITCHER_STATE.sugar = true
  end
  if PITCHER_STATE.lemon and PITCHER_STATE.water and PITCHER_STATE.sugar then
    PITCHER_STATE.lemonade_count = 3
  end
end

function fill_cup()
  if PITCHER_STATE.lemon and PITCHER_STATE.water and PITCHER_STATE.sugar and PITCHER_STATE.lemonade_count > 0 then
    PITCHER_STATE.lemonade_count -= 1
    if PITCHER_STATE.lemonade_count == 0 then
      PITCHER_STATE.lemon = false
      PITCHER_STATE.water = false
      PITCHER_STATE.sugar = false
    end
    local rect = get_active_rect()
    rect.item = 10
  end
end

function trash_item()
  player.item = nil
end

function handle_player_movement()
    local new_x = player.x
    local new_y = player.y
    if (btn(DIR_LEFT)) then new_x = new_x-1; player.direction = DIR_LEFT end
    if (btn(DIR_RIGHT)) then new_x = new_x+1; player.direction = DIR_RIGHT end
    if (btn(DIR_UP)) then new_y = new_y-1; player.direction = DIR_UP end
    if (btn(DIR_DOWN)) then new_y = new_y+1; player.direction = DIR_DOWN end
    if not check_collision_with_rects(new_x, player.y) then player.x = new_x end
    if not check_collision_with_rects(player.x, new_y) then player.y = new_y end
end

function check_collision_with_rects(x, y)
    for _, rect in pairs(rects) do
        if circle_rect_collision(x, y, player.r, rect.x0, rect.y0, rect.x1, rect.y1) then
            deactivate_rects()
            rect.active = true
            return true
        end
    end
    return false
end

function deactivate_non_interacting_rects()
    for _, rect in pairs(rects) do
        if rect.active and not player_still_interacting_with_rect(rect) then
            rect.active = false
        end
    end
end

function player_still_interacting_with_rect(rect)
  local bounding_box_perimeter = 20
  local bounding_box = {
    x0 = rect.x0 - bounding_box_perimeter,
    y0 = rect.y0 - bounding_box_perimeter,
    x1 = rect.x1 + bounding_box_perimeter,
    y1 = rect.y1 + bounding_box_perimeter
  }
  return player.x >= bounding_box.x0 and player.x <= bounding_box.x1 and player.y >= bounding_box.y0 and player.y <= bounding_box.y1
end

function deactivate_rects()
  for _, rect in pairs(rects) do
    rect.active = false
  end
end

function _draw()
  cls()
  if (gamestate.state == STATE_TITLE) then
   print("squeeze the day!", 30, 60, 10)
   print("press z or x to start", 21, 70, 7)
  end
  if (gamestate.state == STATE_ENDING) then
    print("you win!", 40, 60, 7)
    print("thanks for playing!",20, 70, 7)
    print("for my brothers - matt and ethan", 0, 121, 7)
    draw_gui()
  end
  if (gamestate.state == STATE_GAME) then
    draw_ground()
  
    -- Direction indicator (a smaller circle on the main circle)
    local indicator_dist = 10
    local dx = 0
    local dy = 0
  
    if player.direction == DIR_LEFT then dx = -indicator_dist end  -- left
    if player.direction == DIR_RIGHT then dx = indicator_dist end   -- right
    if player.direction == DIR_UP then dy = -indicator_dist end  -- up
    if player.direction == DIR_DOWN then dy = indicator_dist end   -- down
  
    circfill(player.x+dx, player.y+dy, 2, 8) -- Small circle to indicate direction
    circfill(player.x, player.y, player.r, player.c) -- Main circle

    for p in all(pedestrians) do
      circfill(p.x, p.y, 9, p.c)
    end
  
    for _, rect in pairs(rects) do
      if rect.active then
        rectfill(rect.x0, rect.y0, rect.x1, rect.y1, ACTIVE_RECT_COLOR)
      else
        rectfill(rect.x0, rect.y0, rect.x1, rect.y1, DEFAULT_RECT_COLOR)
      end
      draw_serving_plate()
      if rect.item != nil then
        draw_item_on_rect(rect, items[rect.item])
      end
      if rect.interaction_progress > 0 then
        draw_progress_bar(rect)
      end
    end

    draw_gui()
  end
end

function draw_serving_plate()
  spr(171, 56, 68)
  spr(172, 64, 68)
  spr(187, 56, 76)
  spr(188, 64, 76)
end

function draw_ground()
  if gamestate.level == LEVEL_NEIGHBORHOOD then
    rectfill(0, 0, 31, 127, 3) -- left lawn grass
    rectfill(32, 0, 95, 127, 6) -- driveway
    rectfill(96, 0, 127, 127, 3) -- right lawn grass
    rectfill(0, 0, 127, 42, 5) -- road
    rectfill(0, 43, 127, 63, 6) -- sidewalk
  end
  if gamestate.level == LEVEL_PARK then
    rectfill(0, 0, 127, 127, 3)
  end
  if gamestate.level == LEVEL_CITY then
    rectfill(0, 0, 127, 127, 6)
  end
end

function draw_item_on_rect(rect, item)
  if item.name == "juicer" then
    local sprite = juicer_sprites[JUICER_LEVEL]
    spr(sprite.spriteId, rect.x0 + 2, rect.y0 + 2)
    spr(sprite.spriteId + 1, rect.x0 + 10, rect.y0 + 2)
    spr(sprite.spriteId + 16, rect.x0 + 2, rect.y0 + 10)
    spr(sprite.spriteId + 17, rect.x0 + 10, rect.y0 + 10)
    return
  end

  if item.name == "pitcher" then
    local pitcherSprite = get_pitcher_sprite()
    spr(pitcherSprite, rect.x0 + 2, rect.y0 + 2)
    spr(pitcherSprite + 1, rect.x0 + 10, rect.y0 + 2)
    spr(pitcherSprite + 16, rect.x0 + 2, rect.y0 + 10)
    spr(pitcherSprite + 17, rect.x0 + 10, rect.y0 + 10)
    return
  end

  spr(item.spriteId, rect.x0 + 2, rect.y0 + 2)
  spr(item.spriteId + 1, rect.x0 + 10, rect.y0 + 2)
  spr(item.spriteId + 16, rect.x0 + 2, rect.y0 + 10)
  spr(item.spriteId + 17, rect.x0 + 10, rect.y0 + 10)
end

function draw_item_in_hands(item)
  if item.name == "juicer" then
    local sprite = juicer_sprites[JUICER_LEVEL]
    spr(sprite.spriteId, 40, 2)
    spr(sprite.spriteId + 1, 48, 2)
    spr(sprite.spriteId + 16, 40, 10)
    spr(sprite.spriteId + 17, 48, 10)
    return
  end

  if item.name == "pitcher" then
    local pitcherSprite = get_pitcher_sprite()
    spr(pitcherSprite, 40, 2)
    spr(pitcherSprite + 1, 48, 2)
    spr(pitcherSprite + 16, 40, 10)
    spr(pitcherSprite + 17, 48, 10)
    return
  end
  

  spr(item.spriteId, 40, 2)
  spr(item.spriteId + 1, 48, 2)
  spr(item.spriteId + 16, 40, 10)
  spr(item.spriteId + 17, 48, 10)
end


function draw_gui()
  rectfill(0, 0, 127, 19, 0) -- Status bar
  spr(1, 2, 2) -- player portrait
  spr(2, 10, 2)
  spr(17, 2, 10)
  spr(18, 10, 10)
  print("hands", 19, 2, 7)
  spr(9, 39, 1) -- item frame
  spr(10, 49, 1)
  spr(25, 39, 11)
  spr(26, 49, 11)
  if player.item != nil then
    draw_item_in_hands(items[player.item])
  end
  print("serve " ..SERVE, 60, 2, 7)
  if customer != nil then
    if customer.happy then
      print("thank you!", 60, 10, 7)
      if customer.type == 0 then
        spr(33, 111, 2)
        spr(34, 119, 2)
        spr(49, 111, 10)
        spr(50, 119, 10)
      end
      if customer.type == 1 then
        spr(37, 111, 2)
        spr(38, 119, 2)
        spr(53, 111, 10)
        spr(54, 119, 10)
      end
    end
    if not customer.happy then
      print("no lemonade?", 60, 10, 7)
      if customer.type == 0 then
        spr(35, 111, 2)
        spr(36, 119, 2)
        spr(51, 111, 10)
        spr(52, 119, 10)
      end
      if customer.type == 1 then
        spr(39, 111, 2)
        spr(40, 119, 2)
        spr(55, 111, 10)
        spr(56, 119, 10)
      end
    end
  end
  if gamestate.state == STATE_ENDING then
    spr(193, 2, 2) -- player portrait
    spr(194, 10, 2)
    spr(209, 2, 10)
    spr(210, 10, 10)
  end
end

function draw_progress_bar(rect)
  rectfill(rect.x, rect.y - 5, rect.x + 16, rect.y - 2, 8)
  local fill_width = rect.interaction_progress / 100 * 16
  rectfill(rect.x, rect.y - 5, rect.x + 16, rect.y - 2, 9)
end

function get_pitcher_sprite()
  if PITCHER_STATE.lemon and not PITCHER_STATE.water and not PITCHER_STATE.sugar then return items[5].sprites["lemon"] end
  if not PITCHER_STATE.lemon and PITCHER_STATE.water and not PITCHER_STATE.sugar then return items[5].sprites["water"] end
  if not PITCHER_STATE.lemon and not PITCHER_STATE.water and PITCHER_STATE.sugar then return items[5].sprites["sugar"] end
  
  if PITCHER_STATE.lemon and PITCHER_STATE.water and not PITCHER_STATE.sugar then return items[5].sprites["lemon_water"] end
  if PITCHER_STATE.lemon and not PITCHER_STATE.water and PITCHER_STATE.sugar then return items[5].sprites["lemon_sugar"] end
  if not PITCHER_STATE.lemon and PITCHER_STATE.water and PITCHER_STATE.sugar then return items[5].sprites["water_sugar"] end

  if PITCHER_STATE.lemon and PITCHER_STATE.water and PITCHER_STATE.sugar then
    if PITCHER_STATE.lemonade_count == 3 then return items[5].sprites["lemonade_full"] end
    if PITCHER_STATE.lemonade_count == 2 then return items[5].sprites["lemonade_mid"] end
    if PITCHER_STATE.lemonade_count == 1 then return items[5].sprites["lemonade_low"] end
  end

  return items[5].spriteId
end