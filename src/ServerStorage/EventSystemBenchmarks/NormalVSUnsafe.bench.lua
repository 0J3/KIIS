--[[

|WARNING| THESE TESTS RUN IN YOUR REAL ENVIRONMENT. |WARNING|

If your tests alter a DataStore, it will actually alter your DataStore.

This is useful in allowing your tests to move Parts around in the workspace or something,
but with great power comes great responsibility. Don't mess up your stuff!

---------------------------------------------------------------------

Documentation and Change Log:
https://devforum.roblox.com/t/benchmarker-plugin-compare-function-speeds-with-graphs-percentiles-and-more/829912/1

--------------------------------------------------------------------]]

local eventTest = require(6822278371)
local eventTestUntyped = eventTest.getUntypedEdition()
local eventTestUnsafe = eventTest.getUnsafeEdition()

return {

	ParameterGenerator = function()
		-- This function is called before running your function (outside the timer)
		-- and the return(s) are passed into your function arguments (after the Profiler). This sample
		-- will pass the function a random number, but you can make it pass
		-- arrays, Vector3s, or anything else you want to test your function on.
		return 1000;
	end;

	Functions = {
--------------------------------------------------------------------------
		["Custom Events"] = function(Profiler, a)

			Profiler.Begin("Create Event");
			local e = eventTest.makeEvent("Benchmark");
			Profiler.End();

			local v = table.create(a)

			Profiler.Begin("Connect to Event "..a.." Times");
			for i=1,a,1 do
				v[i]=e:Connect(function()
					return;
				end);
			end;
			Profiler.End();

			Profiler.Begin("Fire Event");
			e();
			Profiler.End();

			Profiler.Begin("Disconnect "..a.." Connections");
			for i=1,a,1 do
				v[i]:Disconnect();
			end;
			Profiler.End();
			
			Profiler.Begin("Reconnect "..a.." Connections");
			for i=1,a,1 do
				v[i]:Reconnect();
			end;
			Profiler.End();

			Profiler.Begin("Loop over connections");
			for _,o in pairs(e:GetConnections()) do end;
			Profiler.End();

			Profiler.Begin("Change Callbacks");
			for _,o in pairs(e:GetConnections()) do
				o:SetCb(function()	end)	
			end;
			Profiler.End();
			
		end;
--------------------------------------------------------------------------
		["Custom Events Untyped"] = function(Profiler, a)

			Profiler.Begin("Create Event");
			local e = eventTestUntyped.makeEvent("Benchmark");
			Profiler.End();

			local v = table.create(a)

			Profiler.Begin("Connect to Event "..a.." Times");
			for i=1,a,1 do
				v[i]=e:Connect(function()
					return;
				end);
			end;
			Profiler.End();

			Profiler.Begin("Fire Event");
			e();
			Profiler.End();

			Profiler.Begin("Disconnect "..a.." Connections");
			for i=1,a,1 do
				v[i]:Disconnect();
			end;
			Profiler.End();

			Profiler.Begin("Reconnect "..a.." Connections");
			for i=1,a,1 do
				v[i]:Reconnect();
			end;
			Profiler.End();

			Profiler.Begin("Loop over connections");
			for _,o in pairs(e:GetConnections()) do end;
			Profiler.End();

			Profiler.Begin("Change Callbacks");
			for _,o in pairs(e:GetConnections()) do
				o:SetCb(function()	end)	
			end;
			Profiler.End();

		end;
--------------------------------------------------------------------------
		["Custom Events Unsafe"] = function(Profiler, a)

			Profiler.Begin("Create Event");
			local e = eventTestUnsafe.makeEvent("Benchmark");
			Profiler.End();

			local v = table.create(a)

			Profiler.Begin("Connect to Event "..a.." Times");
			for i=1,a,1 do
				v[i]=e:Connect(function()
					return;
				end);
			end;
			Profiler.End();

			Profiler.Begin("Fire Event");
			e();
			Profiler.End();

			Profiler.Begin("Disconnect "..a.." Connections");
			for i=1,a,1 do
				v[i]:Disconnect();
			end;
			Profiler.End();

			Profiler.Begin("Reconnect "..a.." Connections");
			for i=1,a,1 do
				v[i]:Reconnect();
			end;
			Profiler.End();

			Profiler.Begin("Loop over connections");
			for _,o in pairs(e:GetConnections()) do end;
			Profiler.End();

			Profiler.Begin("Change Callbacks");
			for _,o in pairs(e:GetConnections()) do
				o:SetCb(function()	end)	
			end;
			Profiler.End();
			
		end;
	};

}