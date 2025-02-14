--- STEAMODDED HEADER
--- MOD_NAME: Vicsmod
--- MOD_ID: vicsmod
--- MOD_AUTHOR: [vicentun]
--- MOD_DESCRIPTION: A simple mod that adds 1 rare joker
--- PREFIX: xmpl
----------------------------------------------
------------MOD CODE -------------------------


SMODS.Atlas{
    key = 'Jokers', --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95, -- height of one card
}
SMODS.Joker{
    key = 'Jackofalltrades', --joker key
    loc_txt = { -- local text
        name = 'Jack of all trades',
        text = {
          'When Blind is selected Gain {C:money}3${}',
          '{X:mult,C:white}X#1#{} Mult',
          'Gain add a random joker at end of round',
          'Gain a random tarot when playing a straight'    --blind selected, end of round, score, held in hand, joker
        },
        --[[unlock = {
            'Be {C:legendary}cool{}',
        }]]
    },
    atlas = 'Jokers', --atlas' key
    rarity = 3, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 10, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = false, --can it be eternal
    perishable_compat = false, --can it be perishable
    pos = {x = 0, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
    config = { 
      extra = {
        Xmult = 2, --configurable value
        dollars = 3
      }
    },
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.Xmult}} --#1# is replaced with card.ability.extra.Xmult
    end,
    check_for_unlock = function(self, args)
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                card = card,
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X' .. card.ability.extra.Xmult,
                colour = G.C.MULT
            }
        end
        if context.before and next(context.poker_hands['Straight'])
        then
            G.E_MANAGER:add_event(Event({
				func = function()
						local card = SMODS.create_card({set='Tarot',area=G.consumeables})
						card:add_to_deck()
						G.consumeables:emplace(card)
					return true
				end,
			}))
        end
        if context.setting_blind then
            return{
            card = card,
            dollars = card.ability.extra.dollars,
            }
        end
        if
			context.end_of_round
			and not context.individual
			and not context.repetition
			and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit
			and not context.retrigger_joker
		then
			local roundcreatejoker = math.min(1, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
			G.GAME.joker_buffer = G.GAME.joker_buffer + roundcreatejoker
			G.E_MANAGER:add_event(Event({
				func = function()
					if roundcreatejoker > 0 then
						local card = SMODS.create_card({set='Joker',area=G.jokers,rarity=0})
						card:add_to_deck()
						G.jokers:emplace(card)
						card:start_materialize()
						G.GAME.joker_buffer = 0
                        roundcreatejoker = 0

					end
					return true
				end,
			}))
		end
    end,
}







--SMODS.ConsumableType{
--    key = 'DerekConsumableType', --consumable type key
--
--    collection_rows = {4,5}, --amount of cards in one page
--    primary_colour = G.C.PURPLE, --first color
--    secondary_colour = G.C.DARK_EDITION, --second color
--    loc_txt = {
--        collection = 'Derek Cards', --name displayed in collection
--        name = 'Derek', --name displayed in badge
--        undiscovered = {
--            name = 'Hidden Derek', --undiscovered name
--            text = {'Derek is', 'not here'} --undiscovered text
--        }
--    },
--    shop_rate = 1, --rate in shop out of 100
--}
--
--
--SMODS.UndiscoveredSprite{
--    key = 'DerekConsumableType', --must be the same key as the consumabletype
--    atlas = 'Jokers',
--    pos = {x = 0, y = 0}
--}
--
--
--SMODS.Consumable{
--    key = 'Derek', --key
--    set = 'DerekConsumableType', --the set of the card: corresponds to a consumable type
--    atlas = 'Jokers', --atlas
--    pos = {x = 0, y = 0}, --position in atlas
--    loc_txt = {
--        name = 'Derek Consumable', --name of card
--        text = { --text of card
--            'Add Negative to up to #1# selected cards',
--            'and create a Derek consumable'
--        }
--    },
--    config = {
--        extra = {
--            cards = 5, --configurable value
--        }
--    },
--    loc_vars = function(self,info_queue, center)
--        return {vars = {center.ability.extra.cards}} --displays configurable value: the #1# in the description is replaced with the configurable value
--    end,
--    can_use = function(self,card)
--        if G and G.hand then
--            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= card.ability.extra.cards then --if cards in hand highlighted are above 0 but below the configurable value then
--                return true
--            end
--        end
--        return false
--    end,
--    use = function(self,card,area,copier)
--        for i = 1, #G.hand.highlighted do 
--            --for every card in hand highlighted
--
--            G.hand.highlighted[i]:set_edition({negative = true},true)
--            --set their edition to negative
--        end
--
--        local newcard = create_card('DerekConsumableType', G.consumeables) --create a derek consumable
--        newcard:add_to_deck() --add it to deck
--        G.consumeables:emplace(newcard) --place it into G.consumeables
--
--    end,
--}
--
--
--  
------------------------------------------------
--------------MOD CODE END----------------------
--    
--