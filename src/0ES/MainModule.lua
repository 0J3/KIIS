--!nonstrict
-- 0J3's Event System
-- @author 0J3_3
-- Example:
--[[
local a = require(eventSystem).makeEvent("a");
local b = a:Connect(function()
  print("ef");
  wait(0.2); -- replace this in actual code with a wait() alternative
end);
for i=0,10,1 do
  a:Connect(function(...)
  	print(...);
  end);
end;
print(a:Stats());
--> Calls: 0
--> Last Call At: never
print(a:Stats().calls, a:Stats().lastCallAt);
--> 0,-1
b:Disconnect();
a:FireSync("ab"); -- returns after aproximately 2 seconds
--> ab (x11)
b:Reconnect();
a:Fire("cd"); -- returns more-or-less immediately
--> cd (x11)
--> ef
a:GetConnections(); -- gives a list of Callbacks, with `nil` for disabled callbacks

b:SetCb(function()print("ij");end) 
a("gh"); -- equal to :Fire()
--> gh (x11)
--> ij

print(a:Stats().calls, a:Stats().lastCallAt);
--> 7 1621130452

print(a:GetName());
--> "a"
--]]

export type Bindable = {
	GetConnections: ()->{(...any)->nil},
	Fire: (Bindable,...any) -> nil,
	FireSync: (Bindable,...any) -> nil,
	Connect: (Bindable,...any)->Connection,
	Stats: (Bindable)->{
		lastCallAt:number,
		calls: number,
	},
	ClassName: string
}

export type Connection = {
	Disconnect: ()->nil,
	Reconnect: ()->nil,
	SetCb: ()->nil,
	connectionTo: Bindable,
	Parent: Bindable,
	Active: boolean,
	Callback: (...any)->any,
	ClassName: string
}

local isEvent:(any)->boolean = function(v:any)
	return typeof(v)=="table" and v.ClassName=="Event"
end
local isConnection:(any)->boolean = function(v:any)
	return typeof(v)=="table" and v.ClassName=="Connection"
end

local createConnection = function(event,connectionID:number,disconnect:(number)->nil,reconnect:(number,any)->nil)
	assert(event,"No Event");assert(connectionID,"No ConnectionID");assert(disconnect,"No Disconnect Function");assert(reconnect,"No Reconnect Function");

	local connection;
	local it = {
		id = connectionID;
		connectionTo = event;
		Parent = event;
		Active = true;
		Callback = function()end;
		ClassName = "Connection";
	}

	function it:Disconnect()
		if self.Active == true then
			disconnect(self.id);
			self.Active=false;
		else 
			error("Cannot disconnect already-disconnected event");
		end
	end;
	function it:Reconnect()
		reconnect(self.id,connection);
		self.Active=true;
	end;
	function it:SetCb(callback)
		if typeof(callback) ~= "function" then
			if typeof(callback) == "nil" then
				error("Called SetCb with argument of type nil or undefined. Exected function.\nIf you are trying to disable this connection, call :Disconnect(), and :Reconnect() to re-enable");
			else
				error("First argument to SetCB must be of type Function");
			end;
		end;
		self.Callback=callback;
	end;

	connection=setmetatable({},{
		__index = function(t,m)
			local r = rawget(t,m) or rawget(it,m);
			if r == nil then return error("Propriety "..m.." does not exist on type Connection")end
			return r
		end,
		__tostring = function(t)
			return (t.Active and "" or "Inactive ").."Connection (with ID "..t.id..") to "..tostring(t.connectionTo:GetName());
		end,
	});

	return connection;
end

local createEvent: (string)->Bindable = function(t:string)
	local bindable;

	local calls = 0;
	local lastCallAt = -1;

	local connections = {};
	local internalEvent = {
		ClassName="Event"
	};
	local actualLength = 0;

	function internalEvent:Connect(callback)
		if not callback then error("NO CB SPECIFIED") end
		if typeof(callback) ~= "function" then
			if typeof(callback) == "nil" then
				error("Called SetCb with argument of type nil or undefined. Exected function.\nIf you are trying to disable this connection, call :Disconnect(), and :Reconnect() to re-enable");
			else
				error("First argument to SetCB must be of type Function");
			end;
		end;
		local connectionID = actualLength;
		actualLength=actualLength+1;

		local connection = createConnection(self,connectionID,function(id)
			internalEvent:UnbindConnection(id);
		end,function(id,connection)
			internalEvent:SetConnectionID(id,connection)
		end);

		connection:SetCb(callback);

		connections[connectionID]=connection;
		return connection;
	end

	function internalEvent:UnbindConnection(id)
		if not id then error("NO ID SPECIFIED") end;
		if not (typeof(id)=="number") then error("FIRST ARGUMENT MUST BE OF TYPE NUMBER") end;
		connections[id]=nil;
	end;

	function internalEvent:SetConnectionID(id,c)
		if not id then error("NO ID SPECIFIED") end;
		if not (typeof(id)=="number") then error("FIRST ARGUMENT MUST BE OF TYPE NUMBER") end;
		if not c then error("NO CONNECTION SPECIFIED") end;
		if not isConnection(c) then error("SECOND ARGUMENT MUST BE OF TYPE CONNECTION") end;
		connections[id]=c;
	end

	function internalEvent:Fire(...)
		lastCallAt=os.time();
		local b = table.pack(...)
		for _,c in pairs(connections) do
			if (c) then
				coroutine.resume(coroutine.create(function()
					c.Callback(table.unpack(b));
				end));
			end
		end;
		calls=calls+1;
	end;
	internalEvent.FireSync=internalEvent.Fire;
	function internalEvent:FireAsync(...) -- Sync version of Fire()
		lastCallAt=os.time();
		for _,c in pairs(connections) do
			if c then
				c.Callback(...);
			end
		end;
		calls=calls+1;
		return bindable;
	end;

	local metatable = {
		__call = function(t,...)
			return t:Fire(...);
		end,
		__tostring = function(tab)
			return "Event "..tab:GetName();
		end,
		__index = function(tab,index)
			if index == "GetName" then
				return function()
					return t or "UNSPECIFIED";
				end
			elseif index == "Event" then -- compatability with vanilla events
				local eventthing = {}
				function eventthing:Connect(cb)
					return tab:Connect(cb)
				end
				return setmetatable({},{
					__index=eventthing,
					__call=function(t,...)
						t:Connect(...);
					end,
				})
			elseif index == "Stats" then
				return function()
					return setmetatable({
						calls = calls;
						lastCallAt = lastCallAt;
					},{
						__tostring = function(t)
							return "Calls: "..t.calls.."\nLast Call At: "..(t.lastCallAt==-1 and "never" or t.lastCallAt);
						end,
					});
				end
			elseif index == "GetConnections" then
				return function() return connections end
			else
				return rawget(tab,index) or rawget(internalEvent,index) or nil;
			end;
		end,
		__metatable = "Event Meta";
	}

	bindable = setmetatable({},metatable);


	return bindable;
end;

return setmetatable({},{
	__metatable="This metatable is locked!";
	__newindex=function(a,b) return error("Cannot extend read-only table!",2)end,
	__index={
		makeEvent = createEvent;
		ClassName = "J3EventSystem";
		isEvent=isEvent;
		isConnection=isConnection;
		-- Allows me to only load this module in the benchmark, then use .getUnsafeEdition() and .getUntypedEdition()
		getSafeEdition = function()
			return require(6822278371);
		end;
		getUntypedEdition = function()
			return require(6822723121);
		end;
		getUnsafeEdition = function()
			return require(6822434092);
		end;
	};
	__tostring=function()
		return "Module https://www.roblox.com/library/6822278371/J3-Event-System"
	end,
});
