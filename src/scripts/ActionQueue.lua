-- The Action Queue
ActionQueue = {}

function ActionQueue.doAction()
  if ActionQueue.pending ~= nil then
    ActionQueue.pending()
    ActionQueue.pending = nil
  end
end

function ActionQueue.addAction(callback)
  if ActionQueue.pending == nil then
    ActionQueue.pending = callback
  end
  seek_target = nil
end


-- END Action Queue