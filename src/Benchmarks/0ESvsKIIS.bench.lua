-- same thing as other benchmark, just runs faster
--[[

|WARNING| THESE TESTS RUN IN YOUR REAL ENVIRONMENT. |WARNING|

If your tests alter a DataStore, it will actually alter your DataStore.

This is useful in allowing your tests to move Parts around in the workspace or something,
but with great power comes great responsibility. Don't mess up your stuff!

---------------------------------------------------------------------

Documentation and Change Log:
https://devforum.roblox.com/t/benchmarker-plugin-compare-function-speeds-with-graphs-percentiles-and-more/829912/1

--------------------------------------------------------------------]]

local a = 1000;

local eventTest = require(game:GetService("ReplicatedFirst"):FindFirstChild("0ES")) or require(6822278371);

local KIIS = require(game:GetService("ReplicatedFirst"):FindFirstChild("KIIS")) or require(6822873135);

return {

	ParameterGenerator = function()end;

	Functions = {

		["0ES"] = function(Profiler)

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
		
		["KIIS"] = function(Profiler)

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
			e:Fire(e);
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
		
		["KIIS Locked"] = function(Profiler)

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