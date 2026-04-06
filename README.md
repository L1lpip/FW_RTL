# FW_RTL


Version: 2.1
Date: 6/4/2026
Update: Fix the Tvalid match timming with data comming out from Tdata, User IP is validated then output data and tvalid, if not only flush data from fifo and tvalid assert low.

Next_version: Add IP block to calculate data rate, need to output full packet for calculating data rate.

Suggestion: Need to choose time window like: 1ms, 10ms, 1s,... the system will base on that window to calculate.
- Counting incoming bytes of the FireWall IP block.
- Avoid division in system.
