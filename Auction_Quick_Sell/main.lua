AucQS = {};

local AucQS_settings_live;
local ah_faction = 0.75;
local runtime = 1;
local grey = 0;
local white = 1;
local green = 2;
local blue = 3;
local purple = 4;
local orange = 5;
local name, texture, count, quality, canUse, vendor, pricePerUnit, stackCount, totalCount -- stores info from fetchs
local bid
local bo
local LE_Button

local frame, events = CreateFrame("Frame"), {};


local LE_Button_Name = ("Test1"); --Place Button name you would like to use.
local LE_Button_Width = (100); --Place the width you would like to use.
local LE_Button_Height = (50); --Place the Height you would like to use.
local LE_Button_Inherit = ("UIPanelButtonTemplate"); --Place here any inherits you would like to use.
local LE_Button_Anchor = ("TOP"); --LEFT, TOPLEFT, TOP, TOPRIGHT, RIGHT, CENTER, BOTTOMRIGHT, BOTTOM, BOTTOMLEFT
local LE_Button_Anchor1 = ("TOP"); --LEFT, TOPLEFT, TOP, TOPRIGHT, RIGHT, CENTER, BOTTOMRIGHT, BOTTOM, BOTTOMLEFT
local LE_Button_X = (0); --Alignment on the x axis
local LE_Button_Y = (0); --Alignment on the y axis
local LE_Button_Parent = (UIParent); -- Frame in which you would like to make parent

-- Do not edit this section.
function LE_Button_New()
	LE_Button = CreateFrame("Button",LE_Button_Name,LE_Button_Parent,LE_Button_Inherit);
	LE_Button:SetWidth(LE_Button_Width);
	LE_Button:SetHeight(LE_Button_Height);
	LE_Button:SetPoint(LE_Button_Anchor, LE_Button_Parent, LE_Button_Anchor1, LE_Button_X, LE_Button_Y);
    LE_Button:SetText("Sell");
	-- Register handlers.
	LE_Button:SetScript("OnClick", LE_Button_OnClick);
	LE_Button:SetScript("PostClick", LE_Button_PostClick);
	LE_Button:SetScript("PreClick", LE_Button_PreClick);
	-- End of Register handlers.
end


-- Button Functions


function LE_Button_PostClick()
	--Place your PostClick code here.
end

function LE_Button_PreClick()
	-- Place your PreClick code here.
end
-- End of Button Functions


function Prep_item()
    if quality == grey then
        bid = math.floor(vendor * AucQS_settings_live.grey_salt * AucQS_settings_live.down_scale_bid)
        bo = math.floor(vendor * AucQS_settings_live.grey_salt * AucQS_settings_live.down_scale_BO)
        return
    end
    if quality == green then 
        bid = math.floor(vendor * AucQS_settings_live.green_salt * AucQS_settings_live.down_scale_bid)
        bo = math.floor(vendor * AucQS_settings_live.green_salt * AucQS_settings_live.down_scale_BO)
        return
    end
    if quality == white then
        bid = math.floor(vendor * AucQS_settings_live.white_salt * AucQS_settings_live.down_scale_bid)
        bo = math.floor(vendor * AucQS_settings_live.white_salt * AucQS_settings_live.down_scale_BO)
        return
    end
    if quality == blue then 
        bid = math.floor(vendor * AucQS_settings_live.blue_salt * AucQS_settings_live.down_scale_bid)
        bo = math.floor(vendor * AucQS_settings_live.blue_salt * AucQS_settings_live.down_scale_BO)
        return
    end
    if quality == purple then
        bid = math.floor(vendor * AucQS_settings_live.purple_salt * AucQS_settings_live.down_scale_bid)
        bo = math.floor(vendor * AucQS_settings_live.purple_salt * AucQS_settings_live.down_scale_BO)
        return
    end
    if quality == orange then 
        bid = math.floor(vendor * AucQS_settings_live.orange_salt * AucQS_settings_live.down_scale_bid)
        bo = math.floor(vendor * AucQS_settings_live.orange_salt * AucQS_settings_live.down_scale_BO)
        return
    end

    return
end


local function auctionMaker5000()
    local money = GetMoney()
    local Deposit_Cost = 0
    if bid == bo then return end
    if AucQS_settings_live.sell_all == false then
        Deposit_Cost = math.floor(vendor * ah_faction * 1 * 1) * runtime
        if money < Deposit_Cost then
            print("Sorry not enough money for the deposit")
            bid = 1
            bo = 1
            return
        end
        StartAuction(bid,bo,runtime,1,1);
    elseif AucQS_settings_live.sell_all == true and stackCount == 1 then
        Deposit_Cost = math.floor(vendor * ah_faction * 1 * totalCount) * runtime
        if money < Deposit_Cost then
            print("Sorry not enough money for the deposit")
            bid = 1
            bo = 1
            return
        end
        StartAuction(bid,bo,runtime,1,totalCount);
    elseif AucQS_settings_live.sell_all == true and stackCount ~= 1 and totalCount < stackCount then
        Deposit_Cost = math.floor(vendor * ah_faction * totalCount * 1) * runtime
        if money < Deposit_Cost then
            print("Sorry not enough money for the deposit")
            bid = 1
            bo = 1
            return
        end
        StartAuction(bid,bo,runtime,totalCount,1);
    elseif AucQS_settings_live.sell_all == true and stackCount ~= 1 then
        local total_stacks = math.floor(totalCount/stackCount)
        Deposit_Cost = math.floor(vendor * ah_faction * totalCount * total_stacks) * runtime
        if money < Deposit_Cost then
            print("Sorry not enough money for the deposit")
            bid = 1
            bo = 1
            return
        end
        StartAuction(bid,bo,runtime,stackCount,total_stacks);
    end
    bid = 1
    bo = 1
end

function LE_Button_OnClick()
    if name == nil then return end
    Prep_item()
    auctionMaker5000()
end


 function events: NEW_AUCTION_UPDATE(self, event, ...)
    name, texture, count, quality, canUse, vendor, pricePerUnit, stackCount, totalCount = GetAuctionSellItemInfo();
    if name == nil then return end
    if AucQS_settings_live.is_auto == true then
        Prep_item();
        auctionMaker5000()
        end
    end
function events: AUCTION_HOUSE_SHOW(...)
    if AucQS_settings_live.is_auto == false then LE_Button_New();
    end
end
function events: AUCTION_HOUSE_CLOSED(...)
    if LE_Button == nil then return end
    LE_Button:Hide();
 end

function events: ADDON_LOADED(arg1,...)
    if AucQS_settings == nil and arg1 == "Auction_Quick_Sell" then  -- for first time loader
        AucQS_settings_live = {
            is_auto = false,
            sell_all = false,
            down_scale_bid = 0.98,
            down_scale_BO = 0.99,
            grey_salt = 1,
            white_salt = 5,
            green_salt = 20,
            blue_salt = 30,
            purple_salt = 40,
            orange_salt = 50,
        }
    elseif arg1 == "Auction_Quick_Sell" and AucQS_settings ~= nil then
        AucQS_settings_live = AucQS_settings
    end
end
function events: PLAYER_ENTERING_WORLD(...)

end

function events: PLAYER_LEAVING_WORLD(...)
    AucQS_settings = AucQS_settings_live
end

frame:SetScript("OnEvent", function(self, event, ...)
    events[event](self, ...); -- call one of the functions above
   end);


for k, v in pairs(events) do
    frame:RegisterEvent(k);
end
SLASH_SETAUTO1 = "/changeauto"
SLASH_GETAUTO1 = "/autostate"
SLASH_SETSELLALL1 = "/stacksell"
SLASH_GETSELLALL1 = "/stackstate"

SLASH_AQS1 = "/AucQS"
SLASH_AQS2 = "/aucqs"
SLASH_AQS3 = "/AUCQS"
SLASH_AQSgrey1 = "/AucQSGrey"
SLASH_AQSgrey2 = "/aucqsGrey"
SLASH_AQSgrey3 = "/AUCQSGrey"

function SlashCmdList.AQS(msg)
    msg = string.upper(msg)
    local args = {}
    local count = 0;
    for word in msg:gmatch("%w+") do table.insert(args, word); count = count + 1; end
    if count == 0 then
        print("Try adding HELP to find out what you can do")
        return
    end
    if args[1] == "HELP" then
        print("list of commands")
        print("Autochange")
        print("This changes the autosell mode")
        print("Autostate")
        print("This returns the current state of autosell")
        print("Stackchange")
        print("This enables or disables the selling of all avaiable items of that id")
        print("Stackstate")
        print("This lets you know if the stacksell feature is enabled")
        print("Grey/White/Green/Blue/Purple/Orange on it's own to find out the current multiplier or follow it with a number to change that value")
        print("Bidunder/Buyoutunder returns the % under the maximum theoretical price follow this with a whole number to set a new percent")
    elseif args[1] == "BIDUNDER" then
        if count > 1 then
            local new_down_under_scale_bid = tonumber(args[2])
            local current_buyout_value = AucQS_settings_live.down_scale_BO
            if new_down_under_scale_bid > 100 then
                print("Bid percentage needs to be under 100")
            elseif new_down_under_scale_bid/100 >= current_buyout_value then
                print("Bid percentage needs to be under the current buyout value which is")
                print(current_buyout_value*100,"%")
            else AucQS_settings_live.down_scale_bid = new_down_under_scale_bid /100
            end
        end
        print("Bid undercut", AucQS_settings_live.down_scale_bid*100, "%")
    elseif args[1] == "BUYOUTUNDER" then
        if count > 1 then
            local new_down_under_scale_bo = tonumber(args[2])
            local current_bid_value = AucQS_settings_live.down_scale_bid
            if new_down_under_scale_bo > 100 then
                print("Buyout percentage needs to be under 100")
            elseif new_down_under_scale_bo/100 <= current_bid_value then
                print("Buyout percentage needs to be greater than the current bid value which is")
                print(current_bid_value*100,"%")
            else AucQS_settings_live.down_scale_BO = new_down_under_scale_bo /100
            end
        end
        print("Buyout undercut", AucQS_settings_live.down_scale_BO*100, "%")
    elseif args[1] == "GREY" then
        if count  > 1 then
            local new_salt = tonumber(args[2])
            if new_salt == nil then
                print("Sorry only allowed numbers for the multipliers")
            elseif new_salt < 1 then 
                print("Sorry the multiplier needs to stay above one")
            else
                AucQS_settings_live.grey_salt = new_salt
            end
        end
        print("Grey multiplier")
        print(AucQS_settings_live.grey_salt)
    elseif args[1] == "WHITE" then
        if count  > 1 then
            local new_salt = tonumber(args[2])
            if new_salt == nil then
                print("Sorry only allowed numbers for the multipliers")
            elseif new_salt < 1 then 
                print("Sorry the multiplier needs to stay above one")
            else
                AucQS_settings_live.white_salt = new_salt
            end
        end
        print("White multiplier")
        print(AucQS_settings_live.white_salt)
    elseif args[1] == "GREEN" then
        if count  > 1 then
            local new_salt = tonumber(args[2])
            if new_salt == nil then
                print("Sorry only allowed numbers for the multipliers")
            elseif new_salt < 1 then 
                print("Sorry the multiplier needs to stay above one")
            else
                AucQS_settings_live.green_salt = new_salt
            end
        end
        print("Green multiplier")
        print(AucQS_settings_live.green_salt)
    elseif args[1] == "BLUE" then
        if count  > 1 then
            local new_salt = tonumber(args[2])
            if new_salt == nil then
                print("Sorry only allowed numbers for the multipliers")
            elseif new_salt < 1 then 
                print("Sorry the multiplier needs to stay above one")
            else
                AucQS_settings_live.blue_salt = new_salt
            end
        end
        print("Blue multiplier")
        print(AucQS_settings_live.blue_salt)
    elseif args[1] == "PURPLE" then
        if count  > 1 then
            local new_salt = tonumber(args[2])
            if new_salt == nil then
                print("Sorry only allowed numbers for the multipliers")
            elseif new_salt < 1 then 
                print("Sorry the multiplier needs to stay above one")
            else
                AucQS_settings_live.purple_salt = new_salt
            end
        end
        print("Purple multiplier")
        print(AucQS_settings_live.purple_salt)
    elseif args[1] == "ORANGE" then
        if count  > 1 then
            local new_salt = tonumber(args[2])
            if new_salt == nil then
                print("Sorry only allowed numbers for the multipliers")
            elseif new_salt < 1 then 
                print("Sorry the multiplier needs to stay above one")
            else
                AucQS_settings_live.orange_salt = new_salt
            end
        end
        print("orange multiplier")
        print(AucQS_settings_live.orange_salt)
    elseif args[1] == "AUTOCHANGE" then
        AucQS_settings_live.is_auto = not AucQS_settings_live.is_auto
        print("Changed auto status")
        print("Auto auction mode now")
        print (AucQS_settings_live.is_auto)
    elseif args[1] == "AUTOSTATE" then
        print("Current auto state")
        print(AucQS_settings_live.is_auto)
    elseif args[1] == "STACKCHANGE" then
        AucQS_settings_live.sell_all = not AucQS_settings_live.sell_all
        print("Changed stack sell status")
        print("stack sell mode now")
        print (AucQS_settings_live.sell_all)
    elseif args[1] == "STACKSTATE" then
        print("Current auto state")
        print(AucQS_settings_live.is_auto)
    else
        print("Sorry invalid command")
    end
end

function SlashCmdList.SETSELLALL(msg)
    AucQS_settings_live.sell_all = not AucQS_settings_live.sell_all
    print("Changed stack sell status")
    print("stack sell mode now")
    print (AucQS_settings_live.sell_all)
end
function SlashCmdList.GETSELLALL(msg)
    print("Current auto state")
    print(AucQS_settings_live.sell_all)
end

function SlashCmdList.SETAUTO(msg)
    AucQS_settings_live.is_auto = not AucQS_settings_live.is_auto
    print("Changed auto status")
    print("Auto auction mode now")
    print (AucQS_settings_live.is_auto)
end
function SlashCmdList.GETAUTO(msg)
    print("Current auto state")
    print(AucQS_settings_live.is_auto)
end

