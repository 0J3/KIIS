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

local KIIS = require(6822873135)

return {

	ParameterGenerator = function()
		-- This function is called before running your function (outside the timer)
		-- and the return(s) are passed into your function arguments (after the Profiler). This sample
		-- will pass the function a random number, but you can make it pass
		-- arrays, Vector3s, or anything else you want to test your function on.
		return 1000;
	end;

	Functions = {
		["Vanilla Events"] = function(Profiler, a) -- You can change "Sample A" to a descriptive name for your function

			-- The first argument passed is always our Profiler tool, so you can put
			-- Profiler.Begin("UNIQUE_LABEL_NAME") ... Profiler.End() around portions of your code
			-- to break your function into labels that are viewable under the results
			-- histogram graph to see what parts of your function take the most time.


			Profiler.Begin("Create Event");
			local e = Instance.new("BindableEvent");
			Profiler.End();

			local v = table.create(a)
			
			Profiler.Begin("Connect to Event "..a.." Times");
			for i=1,a,1 do
				v[i]=e.Event:Connect(function()
					return;
				end);
			end;
			Profiler.End();
			
			Profiler.Begin("Fire Event");
			e:Fire();
			Profiler.End();
			
			Profiler.Begin("Disconnect "..a.." Connections");
			for i=1,a,1 do
				v[i]:Disconnect();
			end;
			Profiler.End();
			
		end;

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

		end;
		
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
			
		end;
		
		
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
			
		end;
		
		["KIIS"] = function(Profiler, a)

			Profiler.Begin("Create Event");
			local e = KIIS.new();
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
			(e.FireSync or e.Fire)(e);
			Profiler.End();

			Profiler.Begin("Disconnect "..a.." Connections");
			for i=1,a,1 do
				v[i]:Disconnect();
			end;
			Profiler.End();
			
			Profiler.Begin("Garbage Collect");
			e:GarbageCollect();
			Profiler.End();

		end;
		
		["KIIS Locked"] = function(Profiler, a)

			Profiler.Begin("Create Event");
			local e = KIIS.newLocked();
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
			e:Fire();
			Profiler.End();

			Profiler.Begin("Disconnect "..a.." Connections");
			for i=1,a,1 do
				v[i]:Disconnect();
			end;
			Profiler.End();

			Profiler.Begin("Garbage Collect");
			e:GarbageCollect();
			Profiler.End();
			
		end;
	};

}