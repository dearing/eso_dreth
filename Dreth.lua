Dreth = {}
Dreth.name = "Dreth"

function Dreth:Initialize()
  -- ...but we don't have anything to initialize yet. We'll come back to this.
end

function Dreth.OnAddOnLoaded(event, addonName)
  if addonName == Dreth.name then
    Dreth:Initialize()
  end
end

EVENT_MANAGER:RegisterForEvent(Dreth.name, EVENT_ADD_ON_LOADED, Dreth.OnAddOnLoaded)

function Dreth.OnPlayerCombatState(event, inCombat)
  if inCombat ~= Dreth.inCombat then
    Dreth.inCombat = inCombat
    if inCombat then
      d("Entering combat.")
    else
      d("Exiting combat.")
    end
  end
end

function Dreth.OnLootReceived(
  _,
  receivedBy,
  itemName,
  quantity,
  _,
  lootType,
  isPlayer,
  isPickpocketLoot,
  _,
  itemId,
  isStolen)
  local itemType, specializedItemType = GetItemLinkItemType(itemName)
  local type = GetString("SI_ITEMTYPE", itemType)

  if isStolen then
    d(zo_strformat("You stole <<2>> <<1>> (<<3>>).", itemName, quantity, type))
  elseif isPickpocketLoot then
    d(zo_strformat("You picked <<2>> <<1>> (<<3>>).", itemName, quantity, type))
  else
    d(zo_strformat("You looted <<2>> <<1>> (<<3>>).", itemName, quantity, type))
  end
end

function Dreth.OnOpenStore()
  SellAllJunk()
  local cost = GetRepairAllCost()

  if cost == 0 then
    return
  end

  if CanStoreRepair() then
    RepairAll()
    d(zo_strformat("Repairs cost you <<1>>.", cost))
  else
    d(zo_strformat("Can't afford repair cost of <<1>>.", cost))
  end
end

function Dreth:Initialize()
  --self.inCombat = IsUnitInCombat("player")
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_OPEN_STORE, self.OnOpenStore)
  --EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_COMBAT_STATE, self.OnPlayerCombatState)
  -- * EVENT_LOOT_RECEIVED (*string* _receivedBy_, *string* _itemName_, *integer* _quantity_, *[ItemUISoundCategory|#ItemUISoundCategory]* _soundCategory_, *[LootItemType|#LootItemType]* _lootType_, *bool* _self_, *bool* _isPickpocketLoot_, *string* _questItemIcon_, *integer* _itemId_, *bool* _isStolen_)
  EVENT_MANAGER:RegisterForEvent(self.name, EVENT_LOOT_RECEIVED, self.OnLootReceived)
end
