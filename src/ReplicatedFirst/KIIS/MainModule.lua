--!nocheck
-- KIIS: Keep It Insanely Simple, A lightweight even system by 0J3 that just works.

local table = table;

local QuickRemove = function(Tab, Index)
	local Size = #Tab;
	Tab[Index] = Tab[Size];
	Tab[Size] = nil;
end;

local KIIS = {}

KIIS.new = function()
	local KIISBindable = {};
	local Connections={};
	KIISBindable.Event={};
	function KIISBindable:Connect(cb)
		local connection = {}
		local Disconnect = function()
			connection.Disabled = true;
			connection.Disconnect = function()end;
			connection.disconnect = function()end;
			connection.CB = function()end;
		end
		connection = {
			Disabled=false;
			Disconnect=Disconnect;
			disconnect=Disconnect;
			Parent=KIISBindable;
			CB=cb;
		}
		Connections[#Connections+1]=connection;
		return connection;
	end;
	function KIISBindable:Disconnect(i)
		QuickRemove(Connections,i)
	end;
	function KIISBindable:GarbageCollect()
		for i,o in pairs(Connections) do
			if o.Disabled == true then
				QuickRemove(Connections,i);
			end;
		end;
	end;
	function KIISBindable:Fire(...)
		for _,o in pairs(Connections) do
			o.CB(...);
		end;
	end;
	function KIISBindable:FireAsync(...)
		local b = table.pack(...)
		for _,c in pairs(Connections) do
			coroutine.resume(coroutine.create(function()
				c(table.unpack(b));
			end));
		end;
	end;
	return KIISBindable;
end;
KIIS.newLocked = function() -- Safer .new()
	local bind = KIIS.new();
	return setmetatable({},{
		__index=function(_,k)
			return rawget(bind,k);
		end,
		__newindex=function(_)
			return error("Cannot extend read-only table")
		end,
		__metatable="This object's metatable is locked"
	});
end;

return KIIS;
